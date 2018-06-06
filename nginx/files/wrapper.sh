#!/bin/bash

set -e
set -x

/bin/ln -s /etc/nginx/sites-available/NGINX_WWWDOMAIN /etc/nginx/sites-enabled/NGINX_WWWDOMAIN
/usr/sbin/nginx 
/usr/bin/certbot run -n --nginx --cert-name NGINX_DOMAIN --agree-tos --reinstall -d NGINX_DOMAIN --email you@exampledomain.com
