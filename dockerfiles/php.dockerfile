FROM php:7.1.33-fpm-alpine3.10

WORKDIR /var/www/html

RUN apk add --no-cache gmp-dev libzip-dev \
    && docker-php-ext-install gmp zip bcmath mysqli pdo_mysql

COPY web .
