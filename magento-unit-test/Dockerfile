FROM ghcr.io/eclipse-digital/magento-php-fpm:feature-php7.4-alpine-dev

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

COPY docker-files /docker-files

ENTRYPOINT ["ash", "/entrypoint.sh"]

