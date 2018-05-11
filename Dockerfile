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
    && cd /var/www/html \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install \
    && echo 'log_errors=on\nerror_reporting="E_ALL"' > /usr/local/etc/php/php.ini \
    && cd themes \
    && wget https://us.v-cdn.net/5018160/uploads/addons/1BBGR0AIXD80.zip \
    && unzip 1BBGR0AIXD80.zip \

    && echo 'display_errors = Off\nlog_errors = On' >> /usr/local/etc/php/php.ini

VOLUME /var/www/html/uploads
VOLUME /var/www/html/conf

EXPOSE 8080:80
