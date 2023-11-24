# Pilih gambar base yang mencakup PHP dan Composer
FROM php:8.2.12

RUN apt-get update \
        && apt-get install -y \
            libzip-dev \
            zlib1g-dev\
            unzip \
        && docker-php-ext-install \
            pdo \
            pdo_mysql \
            sockets \
            zip
    # Clear out the local repository of retrieved package files
    RUN apt-get clean
    RUN mkdir /app
    ADD my-laravel-app /app
    WORKDIR /app
    # Install Composer
    RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
    # RUN composer install 
    CMD [ "CMD bash -c "composer install --no-plugins --no-scripts && php main.php"" ]
    CMD php artisan serve --host=0.0.0.0 --port=8082
    EXPOSE 8082

