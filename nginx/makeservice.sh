#!/bin/bash

# Run as root in the same directory as the Dockerfile

# Create image
docker build -t nginx:0.0.1 .

# Create east-west and multicast network
docker network create \
            --opt encrypted \
            --subnet 10.0.0.0/24 \
            --subnet 224.0.0.0/24 \
            --driver overlay \
            nginx 

# Create volume for bind
docker volume create nginx

# Create service
docker service create \
            --mode global \
            --update-delay 60s \
            --update-parallelism 1 \
            --dns 127.0.0.1 \
            --network nginx \
            --mount source=nginx,target=/var/log/ \
            --mount source=nginx,target=/var/local/nginx/,readonly \
            --name "nginx" \
            --publish published=80,target=80,protocol=tcp \
						--publish published=443,target=443,protocol=tcp \
            bind:0.0.1


