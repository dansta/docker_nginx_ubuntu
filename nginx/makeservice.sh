#!/bin/bash

# Run as root in the same directory as the Dockerfile
label="nginx.0.0.1"
domain=example.com
you=me

# Create image
docker build -t $label .

# Create east-west and multicast network
docker network create \
            --opt encrypted \
            --subnet 10.0.0.0/24 \
            --subnet 224.0.0.0/24 \
            --driver overlay \
            nginx 

# Create volume for bind
docker volume create nginx
docker volume create certificates
docker volume create htmlcontent

# Create default html directory (replace contents with your own)
mkdir -p /var/local/nginx/"$label"

# Create service
docker service create \
            --env NGINX_DOMAIN=$domain \
            --env NGINX_WWWDOMAIN=www.$domain \
            --mode global \
            --update-delay 60s \
            --update-parallelism 1 \
            --dns 127.0.0.1 \
            --network nginx \
            --log-driver syslog \
            --mount source=nginxlogs,target=/var/log/ \
            --mount source=certificates,target=/usr/share/nginx/html/ \
            --mount source=htmlcontent,target=/usr/share/nginx/html/ \
            --mount type=bind,source=/var/local/nginx/"$label",target=/var/local/nginx/,readonly \
            --name "$label" \
            --publish published=80,target=80,protocol=tcp \
            --publish published=443,target=443,protocol=tcp \
            $label


# Start the certificate service, disabled because currently we are making it inhouse
#./certificates.sh $domain $me
