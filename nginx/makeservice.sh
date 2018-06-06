#!/bin/bash

set -e
set -x

# You will want to change these parameters to your own
label_friendly="exampledomain.com"
domain="exampledomain.com"
you="you"

if [ "$(whoami)" != 'root' ]; then
  echo "Must be run as root"
  exit 1
fi


# Create images
docker build --build-arg=NGINX_DOMAIN="$domain" \
             --build-arg=NGINX_WWWDOMAIN="www.$domain" \
	     --no-cache \
	     -t $label_friendly:latest \
	     .

# Create volume for bind
docker volume create nginxlogs
docker volume create nginxconf
docker volume create certificates

# Create default html directory (replace contents with your own)
mkdir -p /var/local/nginx/"$label_friendly"

docker run \
	--dns 127.0.0.1 \
	--mount source=nginxconf,target=/etc/nginx/ \
	--mount source=nginxlogs,target=/var/log/ \
	--mount source=certificates,target=/etc/letsencrypt/live/ \
	--name "$label_friendly" \
	-p 80:80 \
	-p 443:443 \
	--restart on-failure \
	$label_friendly:latest

echo "Build completed"
