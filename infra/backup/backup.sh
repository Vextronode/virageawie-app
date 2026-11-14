#!/usr/bin/env bash
# Usage:
#   backup.sh run       dump, encrypt, upload to R2, remove old backups
#   backup.sh schedule  run "backup.sh run" on BACKUP_SCHEDULE (cron syntax) with crond
#   backup.sh restore-test [object|file]
#                       decrypt a backup, restore it into a temporary database, check it,
#                       then drop that database. Default: the newest backup in R2. A path to
#                       a local .dump.age file may be given instead.
#
# All settings come from the environment:
#   PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
#   BACKUP_AGE_RECIPIENT   age public key (backups can only be read with the matching private key)
#   BACKUP_RETENTION_DAYS  days to keep (default 14)
#   BACKUP_SCHEDULE        cron expression for "schedule" (default "0 2 * * *")
#   BACKUP_AGE_IDENTITY_FILE  age private key file, needed only for "restore-test"
#   R2_ACCOUNT_ID, R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_BUCKET, R2_PREFIX
set -euo pipefail

require() {
    local name
    for name in "$@"; do
        if [ -z "${!name:-}" ]; then
            echo "backup: missing environment variable ${name}" >&2
            exit 1
        fi
    done
}

configure_rclone() {
    export RCLONE_CONFIG_R2_TYPE=s3
    export RCLONE_CONFIG_R2_PROVIDER=Cloudflare
    export RCLONE_CONFIG_R2_ACCESS_KEY_ID="${R2_ACCESS_KEY_ID}"
    export RCLONE_CONFIG_R2_SECRET_ACCESS_KEY="${R2_SECRET_ACCESS_KEY}"
    export RCLONE_CONFIG_R2_ENDPOINT="https://${R2_ACCOUNT_ID}.r2.cloudflarestorage.com"
    export RCLONE_CONFIG_R2_NO_CHECK_BUCKET=true
}

run_backup() {
    require PGHOST PGDATABASE PGUSER PGPASSWORD BACKUP_AGE_RECIPIENT \
        R2_ACCOUNT_ID R2_ACCESS_KEY_ID R2_SECRET_ACCESS_KEY R2_BUCKET
    configure_rclone

    local prefix="${R2_PREFIX:-postgres}"
    local retention="${BACKUP_RETENTION_DAYS:-14}"
    local stamp file
    stamp="$(date -u +%Y%m%dT%H%M%SZ)"
    file="/tmp/${PGDATABASE}-${stamp}.dump.age"

    trap 'rm -f "${file}"' EXIT

    echo "backup: dumping ${PGDATABASE} on ${PGHOST}"
    pg_dump --format=custom --no-owner --no-privileges \
        | age --encrypt --recipient "${BACKUP_AGE_RECIPIENT}" --output "${file}"

    echo "backup: uploading $(basename "${file}") to r2:${R2_BUCKET}/${prefix}/"
    rclone copyto "${file}" "r2:${R2_BUCKET}/${prefix}/$(basename "${file}")"

    echo "backup: removing backups older than ${retention} days"
    rclone delete --min-age "${retention}d" "r2:${R2_BUCKET}/${prefix}/"

    echo "backup: done"
}

schedule_backup() {
    local schedule="${BACKUP_SCHEDULE:-0 2 * * *}"
    # crond starts jobs with an empty environment, so pass the current one through a file.
    export -p > /etc/backup.env
    chmod 0600 /etc/backup.env
    echo "${schedule} . /etc/backup.env && /usr/local/bin/backup.sh run > /proc/1/fd/1 2> /proc/1/fd/2" \
        > /etc/crontabs/root
    echo "backup: scheduled with '${schedule}'"
    exec crond -f -l 6
}

cleanup_restore_test() {
    rm -rf "${RESTORE_WORKDIR}"
    psql -d postgres -qc "DROP DATABASE IF EXISTS \"${RESTORE_TARGET}\"" > /dev/null 2>&1 || true
}

restore_test() {
    require PGHOST PGDATABASE PGUSER PGPASSWORD BACKUP_AGE_IDENTITY_FILE

    local source="${1:-}"
    local target="${PGDATABASE}_restore_test"
    local file
    RESTORE_WORKDIR="$(mktemp -d)"
    RESTORE_TARGET="${target}"
    # The temporary database and the decrypted dump never outlive the test, also on failure.
    trap cleanup_restore_test EXIT
    local workdir="${RESTORE_WORKDIR}"

    if [ -n "${source}" ] && [ -f "${source}" ]; then
        file="${source}"
    else
        require R2_ACCOUNT_ID R2_ACCESS_KEY_ID R2_SECRET_ACCESS_KEY R2_BUCKET
        configure_rclone
        local prefix="${R2_PREFIX:-postgres}"
        if [ -z "${source}" ]; then
            source="$(rclone lsf --files-only "r2:${R2_BUCKET}/${prefix}/" | sort | tail -n 1)"
            if [ -z "${source}" ]; then
                echo "restore-test: no backups found in r2:${R2_BUCKET}/${prefix}/" >&2
                exit 1
            fi
        fi
        file="${workdir}/${source}"
        echo "restore-test: downloading ${source}"
        rclone copyto "r2:${R2_BUCKET}/${prefix}/${source}" "${file}"
    fi

    echo "restore-test: decrypting $(basename "${file}")"
    age --decrypt --identity "${BACKUP_AGE_IDENTITY_FILE}" --output "${workdir}/backup.dump" "${file}"

    echo "restore-test: restoring into temporary database ${target}"
    psql -d postgres -v ON_ERROR_STOP=1 -q \
        -c "SET client_min_messages = warning" \
        -c "DROP DATABASE IF EXISTS \"${target}\"" \
        -c "CREATE DATABASE \"${target}\""
    pg_restore --no-owner --no-privileges --exit-on-error -d "${target}" "${workdir}/backup.dump"

    local tables migrations
    tables="$(psql -d "${target}" -tAc "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'")"
    migrations="$(psql -d "${target}" -tAc "SELECT count(*) FROM migrations")"
    echo "restore-test: ${tables} tables, ${migrations} migrations restored"
    if [ "${migrations}" -eq 0 ]; then
        echo "restore-test: FAILED, the migrations table is empty" >&2
        exit 1
    fi

    echo "restore-test: OK"
}

case "${1:-run}" in
    run) run_backup ;;
    schedule) schedule_backup ;;
    restore-test) restore_test "${2:-}" ;;
    *)
        echo "usage: backup.sh [run|schedule|restore-test [object|file]]" >&2
        exit 2
        ;;
esac
