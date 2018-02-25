#!/bin/bash

# Using simp_le for now

# Change this to your domain
domain=$1
you=$2

docker run --rm \
    -v /etc/nginx/certificates:/simp_le/www \
    -v "$PWD":/certificates/certs \
    zenhack/simp_le \
    --email "$you@$domain" \
    -f account_key.json \
    -f fullchain.pem \
    -f cert.pem \
    -f key.pem \
    -d "$domain.com" \
    -d "www.$domain" \
    -d "mail.$domain" \
    --default_root /simp_le/www
