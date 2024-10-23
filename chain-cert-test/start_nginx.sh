#!/bin/sh
set -x
docker stop test
docker rm test
#docker run --name test -p 80:80 -p 443:443 -v ./nginx.conf:/etc/nginx/nginx.conf -d --rm nginx-ssl
docker run --name test -p 80:80 -p 443:443 -v ./ssl.conf:/etc/nginx/conf.d/ssl.conf -d nginx-ssl
docker ps -a
#docker logs test
#docker stop test
#docker rm test
docker logs test --follow
