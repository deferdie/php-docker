FROM alpine:3.7

RUN apk add --update libcurl curl libxml2-dev

# Install PHP and various php dependencies
RUN apk add php7 php7-fileinfo php7-intl php7-bz2 php7-apcu php7-fpm php7-openssl php7-pdo_mysql \
    php7-mbstring php7-tokenizer php7-xml php7-ctype \
    php7-json php7-session php7-dom php7-curl php7-bcmath \
    php7-xmlwriter zlib php7-phar php7-zip openssh-client

## Copying php default settings
COPY ./php-fpm.conf /etc/php7/
COPY ./www.conf /etc/php7/php-fpm.d/
COPY ./php.ini /etc/php7/php.ini

# Install composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer && \
    curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig && \
    php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
    php /tmp/composer-setup.php --quiet && \
    rm /tmp/composer-setup.php && \
    mv composer.phar /usr/local/bin/composer

## Clean apk cache
RUN rm -rf /var/cache/apk/*