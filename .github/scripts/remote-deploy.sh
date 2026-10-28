#!/usr/bin/env bash
# Runs on the server over SSH:
#   ssh host "bash -s -- <staging|prod> <deploy_path> <image> <tag>" < remote-deploy.sh
# Expects <deploy_path>/infra/.env (based on infra/.env.example) to exist on the server
# and the server to be logged in to ghcr.io with a token that can read packages.
set -euo pipefail

stack="$1"
deploy_path="$2"
export APP_IMAGE="$3"
export APP_IMAGE_TAG="$4"

case "$stack" in
    staging) file=compose.staging.yaml app=app-stg worker=worker-stg db=postgres-stg ;;
    prod) file=compose.prod.yaml app=app worker=worker db=postgres ;;
    *) echo "unknown stack: $stack" >&2; exit 2 ;;
esac

cd "$deploy_path/infra"

compose() { docker compose --env-file .env -f "$file" "$@"; }

echo "==> Edge proxy"
docker compose --env-file .env -f compose.edge.yaml up -d
docker compose --env-file .env -f compose.edge.yaml exec -T caddy caddy reload --config /etc/caddy/Caddyfile

echo "==> Database"
compose up -d --wait "$db"

if [ "$stack" = prod ]; then
    echo "==> Backup before deploy"
    compose build backup
    compose run --rm backup run
fi

echo "==> Pull ${APP_IMAGE}:${APP_IMAGE_TAG}"
compose pull "$app" "$worker"

echo "==> Migrate"
compose run --rm --no-deps "$app" php artisan migrate --force --no-interaction

echo "==> Restart app and worker"
compose up -d --wait "$app"
compose up -d "$worker"
if [ "$stack" = prod ]; then
    compose up -d backup
fi

echo "$APP_IMAGE_TAG" > ".deployed-$stack"
echo "==> Deployed ${APP_IMAGE}:${APP_IMAGE_TAG} to $stack"
