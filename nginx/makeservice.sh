#!/bin/bash

set -e
set -x

# You will want to change these parameters to your own
label_cert="certbot"
label_webserver="nginx:0.0.1"
label_friendly="www_example_com"
domain="example.com"
you="me"

if [ "$(whoami)" != 'root' ]; then
  echo "Must be run as root"
  exit 1
fi


# Create images
docker build --build-arg=NGINX_DOMAIN="$domain" \
             --build-arg=NGINX_WWWDOMAIN="www.$domain" \
            -t "$label_webserver" \
            -f Dockerfile_webserver \
            .

docker build -t $label_cert \
            -f Dockerfile_certbot \
            .


# Create volume for bind
docker volume create nginxlogs
docker volume create nginxconf
docker volume create certificates

# Create default html directory (replace contents with your own)
mkdir -p /var/local/nginx/"$label_friendly"

# Create service
if 
docker service create \
            --env NGINX_DOMAIN=$domain \
            --env NGINX_WWWDOMAIN=www.$domain \
            --mode global \
            --update-delay 60s \
            --update-parallelism 1 \
            --dns 127.0.0.1 \
            --name "$label_friendly" \
            --mount source=nginxconfig,target=/etc/nginx/,readonly \
            --mount source=nginxlogs,target=/var/log/ \
            --mount source=certificates,target=/usr/share/nginx/html/,readonly \
            --publish published=80,target=80,protocol=tcp \
            --publish published=443,target=443,protocol=tcp \
            $label_webserver
            then

# Start the certificate service, disabled because currently we are making it inhouse
        docker run -d \
                   -e NGINX_DOMAIN=$domain \
                   -e NGINX_ADMIN=$you \
                   --name="$label_cert" \
                   --restart on-failure \
                   --mount source=certificates,target=/usr/share/nginx/html/ \
                   --mount source=nginxconf,target=/etc/nginx/ \
                   $label_cert
            else
            echo "Service creation failed"
            exit 1
fi


echo
echo "Build completed"
