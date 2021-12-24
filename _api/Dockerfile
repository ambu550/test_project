FROM php:7.3-fpm

COPY . /usr/src/app

RUN chown -R www-data:www-data /usr/src/app

EXPOSE 9000

CMD ["php-fpm7"]