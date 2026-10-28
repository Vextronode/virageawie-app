# syntax=docker/dockerfile:1
# Build context: repository root.
#   docker build -f infra/app/Dockerfile -t virageawie-app:local .

ARG PHP_VERSION=8.4
ARG FRANKENPHP_VERSION=1
ARG NODE_VERSION=24

FROM node:${NODE_VERSION}-slim AS node

FROM dunglas/frankenphp:${FRANKENPHP_VERSION}-php${PHP_VERSION} AS base
RUN install-php-extensions pdo_pgsql intl bcmath zip pcntl opcache
WORKDIR /app

# Stage 1: PHP dependencies (no dev packages, optimized autoloader).
FROM base AS vendor
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY src/composer.json src/composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist --no-interaction --no-progress
COPY src/ ./
RUN composer dump-autoload --no-dev --optimize --classmap-authoritative --no-interaction

# Stage 2: frontend assets with Node.js 24.
# PHP stays available because the Wayfinder Vite plugin runs artisan during the build.
FROM vendor AS assets
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx
RUN npm ci --no-audit --no-fund && npm run build

# Final runtime image.
FROM base AS runtime
ARG APP_USER=app
ARG APP_UID=1000

ENV APP_ENV=production \
    APP_DEBUG=false \
    LOG_CHANNEL=stderr \
    SERVER_NAME=:8000 \
    TZ=Asia/Jakarta

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && useradd --uid "${APP_UID}" --create-home --shell /usr/sbin/nologin "${APP_USER}"

COPY --from=vendor --chown=${APP_UID}:${APP_UID} /app /app
COPY --from=assets --chown=${APP_UID}:${APP_UID} /app/public/build /app/public/build

RUN rm -rf /app/tests /app/node_modules /app/.env \
    && chown -R "${APP_UID}:${APP_UID}" /data/caddy /config/caddy /app/storage /app/bootstrap/cache

USER ${APP_USER}

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD ["php", "-r", "exit(@file_get_contents('http://127.0.0.1:8000/up') === false ? 1 : 0);"]
