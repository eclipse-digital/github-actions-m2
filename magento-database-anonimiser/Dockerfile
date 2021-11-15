FROM php:7.4-cli-alpine
ENV PLATFORM 'magento2'
ENV DATABASE 'magento'
ENV USERNAME 'magento'
ENV PASSWORD 'magento'
ENV DB_HOST  'localost'
ENV PORT     '3306'

RUN ash -c 'mkdir -p /anonymize/{database,prepared}'
RUN curl -L  https://github.com/elgentos/masquerade/releases/latest/download/masquerade.phar -o /bin/masquerade
RUN chmod +x /bin/masquerade

RUN docker-php-ext-install pdo_mysql

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]