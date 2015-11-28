# Use Alpine Linux
FROM alpine:latest

# Declare maintainer
MAINTAINER Muhammad Zamroni <halo@matriphe.com>

# Choose Nginx version
ENV ROOT_DIR /root

# Set working directory
WORKDIR ${ROOT_DIR}

# Let's roll
RUN	rm /etc/apk/repositories && \
	echo "http://mirrors.gigenet.com/alpinelinux/v3.2/main/" > /etc/apk/repositories && \
	apk update && \
	apk upgrade && \
	apk add --update nginx

COPY etc/nginx.conf /etc/nginx/nginx.conf;
COPY etc/common.conf /etc/nginx/common.conf;
COPY etc/conf.d/default.conf /etc/nginx/conf.d/default.conf;
COPY etc/conf.d/ssl.conf /etc/nginx/conf.d/ssl.conf;

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]