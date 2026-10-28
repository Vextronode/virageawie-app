# PostgreSQL 18 client tools (pg_dump must match the server major version),
# age for encryption, rclone for Cloudflare R2 (S3-compatible).
FROM postgres:18-alpine

RUN apk add --no-cache age rclone tzdata

COPY --chmod=0755 backup.sh /usr/local/bin/backup.sh

ENV TZ=Asia/Jakarta

ENTRYPOINT ["/usr/local/bin/backup.sh"]
CMD ["schedule"]
