#!/bin/sh
nginx

cd /api
echo "DATABASE_URL=mariadb+mariadbconnector://$MARIADB_USER:$MARIADB_PASSWORD@$MARIADB_HOST/$MARIADB_DBNAME" > .env
echo "YOUTUBE_API_KEY=$YOUTUBE_API_KEY" >> .env
echo "TOKEN_SECRET=$TOKEN_SECRET" >> .env
echo "DISCORD_CLIENT_ID=$DISCORD_CLIENT_ID" >> .env
echo "DISCORD_CLIENT_SECRET=$DISCORD_CLIENT_SECRET" >> .env
gunicorn --workers 2 --worker-class uvicorn.workers.UvicornWorker --bind unix:/run/plsres/gunicorn.sock main:app
