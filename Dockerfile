# Use Alpine Linux
FROM alpine:latest

# Declare maintainer
MAINTAINER Muhammad Zamroni <halo@matriphe.com>

# Choose Nginx version
ENV NGINX_VERSION 1.9.7
ENV PCRE_VERSION 8.38
ENV ZLIB_VERSION 1.2.8
ENV OPENSSL_VERSION 1.0.1p
ENV BUILD_DEP "gcc g++ make perl openssl"
ENV WGET_ARGS "-c -T 300"

# Set working directory
WORKDIR /root

# Let's roll
RUN	rm /etc/apk/repositories && \
	echo "http://mirror.yandex.ru/mirrors/alpine/v3.2/main/" > /etc/apk/repositories && \
	apk update && \
	apk add --update ${BUILD_DEP} && \
	wget ${WGET_ARGS} http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	wget ${WGET_ARGS} ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz && \
	wget ${WGET_ARGS} http://prdownloads.sourceforge.net/libpng/zlib-${ZLIB_VERSION}.tar.gz?download -O zlib-${ZLIB_VERSION}.tar.gz && \
	wget ${WGET_ARGS} ftp://ftp.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
	tar -xzf nginx-${NGINX_VERSION}.tar.gz && \
	tar -xzf pcre-${PCRE_VERSION}.tar.gz && \
	tar -xzf zlib-${ZLIB_VERSION}.tar.gz && \
	tar -xzf openssl-${OPENSSL_VERSION}.tar.gz && \
	cd /root/nginx-${NGINX_VERSION} && \
	./configure \
		--user=apache \
		--group=apache \
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/nginx/nginx.conf \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--with-http_gzip_static_module \
		--with-http_stub_status_module \
		--with-http_ssl_module \
		--with-pcre \
		--with-http_realip_module \
		--without-http_scgi_module \
		--without-http_uwsgi_module \
		--with-pcre=/root/pcre-${PCRE_VERSION} \
		--with-openssl=/root/openssl-${OPENSSL_VERSION} \
		--with-zlib=/root/zlib-${ZLIB_VERSION} && \
	make && \
	make install && \
	cd /root && \
	rm -rf * &&\
	apk del ${BUILD_DEP} && \
	rm -rf /var/cache/apk/* 

EXPOSE 80 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]