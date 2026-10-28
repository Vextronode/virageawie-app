# Development tools image: PHP 8.4 CLI with the project extensions, Composer 2, and Node.js 24.
# For running composer, artisan, and npm when the host PHP is not 8.4. Not used in production.
#
#   docker build -t virageawie-tools:local infra/dev
#   docker run --rm -it --network host --user "$(id -u):$(id -g)" \
#     -v "$PWD":/repo -w /repo/src virageawie-tools:local composer install
#
# See "Menjalankan tanpa PHP 8.4 di host" in README.md.
FROM php:8.4-cli

COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/
RUN apt-get update && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/* \
    && install-php-extensions pdo_pgsql intl bcmath zip pcntl

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=node:24-slim /usr/local/bin/node /usr/local/bin/node
COPY --from=node:24-slim /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && git config --system --add safe.directory '*'

# Writable home and caches for any --user uid.
ENV HOME=/tmp COMPOSER_HOME=/tmp/composer npm_config_cache=/tmp/npm
WORKDIR /repo/src
