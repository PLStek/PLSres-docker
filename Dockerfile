# syntax=docker/dockerfile:1

FROM node:20-alpine AS build_frontend
WORKDIR /app
RUN apk add git
RUN git clone https://github.com/PLStek/PLSres-website
WORKDIR /app/PLSres-website
RUN npm install -g @angular/cli
RUN npm install --silent
RUN ng build --configuration production



FROM php:8.2-fpm-alpine
RUN apk update
RUN apk add --no-cache nginx git
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN docker-php-ext-enable pdo_mysql

WORKDIR /build
RUN git clone https://github.com/PLStek/PLSapi-legacy

RUN cp -r /build/PLSapi-legacy/* /var/www/html
RUN chown www-data /var/www/html
COPY --chown=www-data:www-data --from=build_frontend /app/PLSres-website/dist/plsres /usr/local/share/nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY entrypoint.sh /usr/local/bin/plsres-entrypoint
RUN chmod +x /usr/local/bin/plsres-entrypoint

RUN rm -rf /build


RUN mkdir -p /var/log/php-fpm
EXPOSE 80
ENTRYPOINT ["plsres-entrypoint"]
