#!/bin/bash 

#remove running containers
docker rm -f $(docker ps -qa)

# Create network
docker network create trio-network

# Build flask app image
docker build -t trio-task-flask:latest flask-app
docker build -t flask-db:latest db

#run mysql container
docker run -d --network trio-network --name mysql flask-db:latest

# Run flask app container in the network
docker run -d --network trio-network --name flask-app trio-task-flask:latest

#run nginx
docker run -d --network trio-network --name nginx --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf -p 80:80 nginx:alpine