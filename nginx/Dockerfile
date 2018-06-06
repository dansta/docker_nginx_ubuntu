FROM ubuntu:latest
# We base this on ubuntu

# Static content nginx

# Set env. replace right most column with values specific to your environment
ARG NGINX_USER
ENV NGINX_USER ${NGINX_USER:-enjinecks}
ARG NGINX_GROUP
ENV NGINX_GROUP ${NGINX_GROUP:-enjinecks}
ARG NGINX_WORKER_PROCESSES
ENV NGINX_WORKER_PROCESSES ${NGINX_WORKER_PROCESSES:-4}
ARG NGINX_HTTP_PORT
ENV NGINX_HTTP_PORT ${NGINX_HTTP_PORT:-80}
ARG NGINX_HTTPS_PORT
ENV NGINX_HTTPS_PORT ${NGINX_HTTPS_PORT:-443}
ARG NGINX_DOMAIN
ENV NGINX_DOMAIN ${NGINX_DOMAIN:-example.com}
ARG NGINX_WWWDOMAIN
ENV NGINX_WWWDOMAIN ${NGINX_WWWDOMAIN:-www.example.com}
ARG NGINX_SSL_PROTOCOLS
ENV NGINX_SSL_PROTOCOLS ${NGINX_SSL_PROTOCOLS:-TLSv1 TLSv1.1 TLSv1.2}
ARG NGINX_SSL_CIPHERS
ENV NGINX_SSL_CIPHERS ${NGINX_SSL_CIPHERS:-CHACHA20:HIGH:!aNULL:!MD5:!RC4:!DES:!3DES}

LABEL maintainer=dansta

# Check ourselves to know we are alive
#HEALTHCHECK --interval=15s --timeout=3s CMD curl -x 127.0.0.1:80 || exit 1

# Update and install packages
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:certbot/certbot

RUN apt update
RUN apt-get install -y nginx \
                       curl \
                       python3 \
		       python3-certbot-nginx \
                       cron && \
    rm -rf /var/lib/apt/lists/*

# Add renewalscripts
ADD files/crontab /etc/cron.d/certbot_renew
RUN chmod 0644 /etc/cron.d/certbot_renew
RUN touch /var/log/cron.log



# Add user, do not add home
RUN useradd ${NGINX_USER} -M -s /usr/sbin/nologin

# Add our own config file and mime types
#ADD files/etc/nginx.conf /etc/nginx/sites-available/${NGINX_WWWDOMAIN}
ADD files/etc/nginx.conf /etc/nginx/nginx.conf
ADD files/wrapper.sh /usr/local/bin/wrapper.sh
ADD files/etc/mime.types /etc/nginx/conf/mime.types

# Replace params
ADD replace.py /usr/local/bin/replace_conf
RUN chmod u+x /usr/local/bin/replace_conf /usr/local/bin/wrapper.sh
RUN /usr/local/bin/replace_conf /usr/local/bin/wrapper.sh NGINX
#RUN /usr/local/bin/replace_conf /etc/nginx/sites-available/${NGINX_WWWDOMAIN} NGINX
RUN /usr/local/bin/replace_conf /etc/nginx/nginx.conf NGINX
RUN rm /usr/local/bin/replace_conf

# Remove what we do not need for runtime
RUN apt-get -y autoremove

# Permissions
RUN chown -R ${NGINX_USER}:${NGINX_GROUP} /etc/nginx/

# Add remote log directory volume and a directory from which we grab the web content
VOLUME /var/log/
VOLUME /usr/local/nginx/
VOLUME /usr/share/nginx/html/

# Document port usage for docker in case you are going to use it as a service
EXPOSE ${NGINX_HTTP_PORT}/tcp \
       ${NGINX_HTTPS_PORT}/tcp

CMD ["/usr/local/bin/wrapper.sh"]
# Run this per default
#CMD ["nginx", "-g", "daemon off;"]
