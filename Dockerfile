# syntax=docker/dockerfile:1

FROM node:20-alpine AS build_frontend
WORKDIR /app
RUN apk add git
RUN git clone https://github.com/PLStek/PLSres-website
WORKDIR /app/PLSres-website
RUN npm install -g @angular/cli
RUN npm install --silent
RUN ng build --configuration production



FROM python:3.11-alpine
RUN apk update
RUN apk add --no-cache nginx git mariadb-dev build-base

WORKDIR /api
RUN git clone https://github.com/PLStek/PLSapi .
COPY requirements.txt /api/requirements.txt
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

COPY --chown=www-data:www-data --from=build_frontend /app/PLSres-website/dist/plsres /usr/local/share/nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /usr/local/bin/plsres-entrypoint
RUN chmod +x /usr/local/bin/plsres-entrypoint
RUN mkdir -p /run/plsres

EXPOSE 80
ENTRYPOINT ["plsres-entrypoint"]
