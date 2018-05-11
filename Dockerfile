FROM php:7.0-apache

MAINTAINER suculent

ENV VANILLA_VERSION 2.5.1
ENV DEBIAN_FRONTEND noninteractive
ENV SERVER_NAME forums.thinx.cloud

# Uses old Debian repository of Ondrej Sury; would rather use ubuntu-based distro

RUN docker-php-ext-install pdo pdo_mysql \
    && apt-get update && apt-get install -y software-properties-common apt-transport-https lsb-release ca-certificates wget \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt-get update && apt-get install -y --fix-missing unzip nano \
    && curl -sSL "https://github.com/vanilla/vanilla/archive/release/${VANILLA_VERSION}.zip" -o vanilla.zip \
    && unzip vanilla.zip \
    && cp -rT vanilla-release-* /var/www/html \
    && rm -rf vanilla-release-* \
    && chmod -R 777 /var/www/html/conf \
    && chmod -R 777 /var/www/html/cache \
    && chmod -R 777 /var/www/html/uploads \
    && echo 'log_errors=on\nerror_reporting="E_ALL"' > /usr/local/etc/php/php.ini \
    && cd themes \
    && wget https://15254b2dcaab7f5478ab-24461f391e20b7336331d5789078af53.ssl.cf1.rackcdn.com/www.vanillaforums.org/addons/5TNP719UEGVK.zip \
    && unzip 5TNP719UEGVK.zip \
    && echo 'display_errors = Off\nlog_errors = On' >> /usr/local/etc/php/php.ini

VOLUME /var/www/html/uploads
VOLUME /var/www/html/conf

EXPOSE 8080:80
