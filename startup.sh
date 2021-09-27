#!/bin/bash

# Delete running containers

docker rm -f $(docker ps -qa)

# Create network

docker network create triplet

# Build flask app image
cd flask-app/
docker build -t flask-app:latest .

# Build MySQL Database
cd ..
cd db/
docker build -t flask-db:latest .
cd ..

# Run flask app container in the network
cd flask-app/
docker run -d --network triplet --name flask-app flask-app:latest
cd ..

# Run nginx container in the network
cd nginx 
docker run -d --network triplet --name nginx --mount type=bind,source=$(pwd)/nginx.conf,target=/etc/nginx/nginx.conf -p 80:80 nginx:alpine
cd ..
# Run MySQL container in the network
cd db/
docker run -d --network triplet --name mysql flask-db:latest
