#!/bin/bash

# You will want to change these parameters to your own
label_cert="certbot"
label_webserver="nginx:0.0.1"
domain="example.com"
you="me"

if [ "$(whoami)" != 'root' ]; then
  echo "Must be run as root"
  exit 1
fi


# Create images
docker build -t $label_cert -f Dockerfile_certbot .
docker build -t $label_webserver -f Dockerfile_webserver .

# Create east-west and multicast network
docker network create \
            --opt encrypted \
            --subnet 10.0.0.0/24 \
            --subnet 224.0.0.0/24 \
            --driver overlay \
            nginx 

# Create volume for bind
docker volume create nginxlogs
docker volume create nginxconf
docker volume create certificates

# Create default html directory (replace contents with your own)
mkdir -p /var/local/nginx/"$label_webserver"

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
            --mount source=nginxconfig,target=/etc/nginx/,readonly \
            --mount source=nginxlogs,target=/var/log/ \
            --mount source=certificates,target=/usr/share/nginx/html/,readonly \
            --mount type=bind,source=/var/local/nginx/"$label_webserver",target=/usr/share/nginx/html/,readonly \
            --name "$label_webserver" \
            --publish published=80,target=80,protocol=tcp \
            --publish published=443,target=443,protocol=tcp \
            $label_webserver


# Start the certificate service, disabled because currently we are making it inhouse
docker run -d \
           -e NGINX_DOMAIN=$domain \
           -e NGINX_ADMIN=$you \
           --name="$label_cert" \
           --restart on-failure \
           --mount source=certificates,target=/usr/share/nginx/html \
           --mount source=nginxconf,target=/etc/nginx/ \
           $label_cert


echo
echo "Build completed"
