#!/usr/bin/env bash

while read line; do export $line; done < .env
#printenv | awk '{split($0,m,"="); print "export "m[1]"=\""m[2]"\""}' >> /root/.bashrc
cat .env | awk '{split($0,m,"="); print "export "m[1]"=\""m[2]"\""}' >> /root/.bashrc
printenv

cp -f .php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini || true
cp -f .php-fpm/error.ini /usr/local/etc/php/conf.d/error.ini || true
cp -f .php-fpm/apcu.ini /usr/local/etc/php/conf.d/apcu.ini || true
cp -f .php-fpm/php.ini /usr/local/etc/php/conf.d/php.ini || true
cp -f .php-fpm/sqlsrv.ini /usr/local/etc/php/conf.d/sqlsrv.ini || true
cp -f .php-fpm/pdo_sqlsrv.ini /usr/local/etc/php/conf.d/pdo_sqlsrv.ini || true
cp -f .php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf || true
cp -f supervisor.conf /etc/supervisor/conf.d/supervisor.conf || true
cp -f crontab /etc/cron.d/base-cron || true

echo "Current application environment is ${APP_ENV}"

if [ "${APP_ENV}" != "prod" ]; then
  echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && cp -f .php-fpm/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && docker-php-ext-enable xdebug

  composer install --no-interaction --no-suggest --no-progress 2>&1
elif [ "${APP_ENV}" = "prod" ]; then
  composer install --no-interaction --no-suggest --no-progress --no-dev 2>&1
fi

if [ "${APP_ENV}" = "test" ]; then
 echo "Creating test db "
  php /var/www/bin/console d:d:c
fi

php /var/www/bin/console d:m:m --no-interaction && \
php /var/www/bin/console c:c && \
chown -R www-data /var/www/var && \
chown -R www-data /var/www/public && \
ls -la /var/www

chsh -s /bin/bash www-data

supervisord