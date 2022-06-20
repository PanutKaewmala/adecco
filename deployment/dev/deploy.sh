#!/usr/bin/env bash
set -e

# preserve angular dir permission
mkdir -p ./.docker_volumes/angular/dist/app

docker-compose up -d minio redis postgres django mocki
docker-compose restart mocki

# pull new image
docker-compose pull django

# start blue backend
docker-compose up -d django-blue
sleep 10

# generate dhparam
if [ ! -e "./nginx/dhparam.pem" ]; then
    openssl dhparam -out ./nginx/dhparam.pem 2048
fi

touch ./.docker_volumes/angular/dist/app/index.html
docker-compose up -d nginx

docker-compose exec -T nginx sh -c "cat /etc/nginx/nginx.blue.conf > /etc/nginx/nginx.conf"
docker-compose exec -T nginx nginx -s reload
sleep 5

# start new backend
docker-compose up -d django
sleep 10
docker-compose exec -T django bash -c 'python manage.py collectstatic --noinput && python manage.py migrate --noinput && python manage.py init_data'
sleep 5

# switch to green
docker-compose exec -T nginx sh -c "cat /etc/nginx/nginx.green.conf > /etc/nginx/nginx.conf"
docker-compose exec -T nginx nginx -s reload
sleep 5

# stop blue
docker-compose rm -fs django-blue

docker-compose up -d --force-recreate celery-worker celery-beat
docker-compose ps

docker image prune -f
