#!/bin/sh
nginx

cd /api
echo "DATABASE_URL=mariadb+mariadbconnector://$MARIADB_USER:$MARIADB_PASSWORD@$MARIADB_HOST/$MARIADB_DBNAME" > .env
echo "YOUTUBE_API_KEY=$YOUTUBE_API_KEY" >> .env
gunicorn --workers 2 --worker-class uvicorn.workers.UvicornWorker --bind unix:/run/plsres/gunicorn.sock main:app
