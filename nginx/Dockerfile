FROM ubuntu:latest
# we base this on ubuntu

# static content nginx

# set env. replace right most column with values specific to your environment
ENV NGINX_HTTP_PORT 80
ENV NGINX_DOMAIN example.com
ENV NGINX_WWWDOMAIN www.example.com

LABEL maintainer=dansta

# check ourselves to know we are alive
HEALTHCHECK --interval=15s --timeout=3s CMD curl -x 127.0.0.1:80 || exit 1

# update and install packages
RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y rsyslog

# add our own config file
ADD files/etc/nginx.conf /etc/nginx/nginx.conf
# replace params
ADD replace_nginxconf.sh /usr/local/bin/replace_nginxconf
ADD key.awk /usr/local/bin/key.awk
ADD value.awk /usr/local/bin/value.awk
RUN chmod u+x /usr/local/bin/replace_nginxconf
RUN /usr/local/bin/replace_nginxconf

# add mime.types
ADD files/etc/mime.types /etc/nginx/conf/mime.types

# document port usage for docker in case you are going to use it as a service
EXPOSE ${NGINX_HTTP_PORT}/tcp

# remote logging made possible
RUN service rsyslog start

# test nginx for build, run in foreground
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
