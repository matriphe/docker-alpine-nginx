# Use Alpine Linux
FROM alpine:latest

# Declare maintainer
MAINTAINER Muhammad Zamroni <halo@matriphe.com>

# Let's roll
RUN	apk update && \
	apk upgrade && \
	apk add --update openssl nginx && \
	mkdir /etc/nginx/certificates && \
	openssl req \
		-x509 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/certificates/key.pem \
		-out /etc/nginx/certificates/cert.pem \
		-days 365 \
		-nodes \
		-subj /CN=localhost && \
	mkdir /www

COPY etc/nginx.conf /etc/nginx/nginx.conf
COPY etc/common.conf /etc/nginx/common.conf
COPY etc/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY etc/conf.d/ssl.conf /etc/nginx/conf.d/ssl.conf

# Expose volumes
VOLUME ["/etc/nginx/conf.d", "/usr/share/nginx/html", "/var/log/nginx", "/www"]

# Expose ports
EXPOSE 80 443

# Entry point
ENTRYPOINT ["/usr/sbin/nginx"]