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
	apk add --update openssl nginx

RUN mkdir /etc/nginx/certificates && \
	openssl req \
	-x509 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/certificates/key.pem \
	-out /etc/nginx/certificates/cert.pem \
	-days 365 \
	-nodes \
	-subj /C=ID/ST=Jakarta/L=Jakarta/O=matriphe/OU=Developer/CN=localhost/emailAddress=halo@matriphe.com

COPY etc/nginx.conf /etc/nginx/nginx.conf
COPY etc/common.conf /etc/nginx/common.conf
COPY etc/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY etc/conf.d/ssl.conf /etc/nginx/conf.d/ssl.conf

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]