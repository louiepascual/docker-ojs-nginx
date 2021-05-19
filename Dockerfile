FROM php:7.4-fpm-alpine
LABEL maintainer="louieepascual@gmail.com"

ENV OJS_VERSION=3_3_0-3

WORKDIR /var/www/html

# Install PHP Extension installer to help us resolve weird PHP dependencies
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# List to make the image smaller
COPY exclude.list /tmp/exclude.list

RUN set -xe \
    && apk add --no-cache --virtual .build_deps \
        git \
        npm \
        patch \
    && git clone --depth 1 --single-branch --branch $OJS_VERSION --progress https://github.com/pkp/ojs.git . \
    && git submodule update --init --recursive \
    && install-php-extensions \
        gettext \
        intl \
        mysqli \
        pdo_mysql \
    && composer --working-dir=lib/pkp install --no-dev \
    && composer --working-dir=plugins/paymethod/paypal install --no-dev \
    && composer --working-dir=plugins/generic/citationStyleLanguage install --no-dev \
    && npm install -y \
    && npm run build \
    && mkdir -p /var/www/files \
    && chown -R www-data:www-data /var/www/* \
# Clean the image
    && apk del --no-cache .build_deps \
    && cd /var/www/html \
    && rm -rf $(cat /tmp/exclude.list) \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache/*

EXPOSE 9000
