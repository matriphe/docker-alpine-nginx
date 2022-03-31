# Alpine  Nginx

This Nginx docker image is based on [Alpine](https://hub.docker.com/_/alpine/). Alpine is based on [Alpine Linux](http://www.alpinelinux.org), lightweight Linux distribution based on [BusyBox](https://hub.docker.com/_/busybox/). The size of the image is very small, less than 10 MB!

## Tags

Versions and are based on Nginx versions.

Here are the supported tags and respective Dockerfile links.

 * `html`, `html-1.8.0` [(Dockerfile)](https://github.com/matriphe/docker-alpine-nginx/blob/master/html/Dockerfile)
 * `php-fpm`, `php-fpm-1.8.0` [(Dockerfile)](https://github.com/matriphe/docker-alpine-nginx/blob/master/php-fpm/Dockerfile)
 
The `html` tag show that the Nginx is used for non PHP-FPM purpose, such as simple static HTML site. And the `php-fpm` is disigned to be used with PHP-FPM. It is fit with [Alpine-PHP](https://hub.docker.com/r/matriphe/alpine-php/) docker image.

## Getting The Image

This image is published in the Docker Hub. Simply run this command below to get it to your machine.

```Shell
docker pull matriphe/alpine-nginx:php-fpm
```

or 

```Shell
docker pull matriphe/alpine-nginx:html
```

Alternatively you can clone this repository and build the image using the `docker build` command.

## Build

This image use `Asia/Jakarta` timezone by default. You can change the timezone by change the `TIMEZONE` environment on `Dockerfile` and then build.

```Shell
docker -t repository/imagename:tag Dockerfile
```

## Configuration

The site data, config, and log data is configured to be located in a Docker volume so that it is persistent and can be shared by other containers or a backup container).

There are three volumes defined in this image, `/etc/nginx/conf.d`, `/var/log/nginx`, and `/www`.

 * `/etc/nginx/conf.d` to store the virtual server configurations
 * `/var/log/nginx` to store the logs, by default, only errors that are logged
 * `/www` to store virtual directory data

You can store the sites data to this directory structure:
```
/www
├─── website1_files
|    └ ...
└─── website2_files
     └ ...
/etc
└─── nginx
	 └─── conf.d
	 	  ├─── website1.conf
	 	  └─── website2.conf
```

The `/etc/nginx/conf.d` operates in the same fashion as the regular `/etc/nginx/conf.d` in Nginx, so place that configurations here.

### Nginx Configuration

You can modify the `nginx.conf` by editing `etc/nginx.conf` in this repository and rebuild the image. Make sure you include `daemon off;` in the configuration.

If you link this container using PHP-FPM container, for example, makes sure to build or use `php-fpm` tag, It will include `etc/common.conf` that will be called on every site config. You can left the config unchanged, or you can change the `phpfpm` with the name of yout PHP-FPM container name.

```Nginx
location ~ \.php$ {
    fastcgi_pass   phpfpm:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
}
```

## Virtual Site Configuration

It's very easy to add the virtual site configuration. Just use this configuration template.

```Nginx
server {
    listen 80;
    server_name website1.com;
    
    root /www/website1_files;
    index index.html index.htm index.php;

    include /etc/nginx/common.conf;
}
```

## Run The Container

### Create and Run The Container

```Shell
docker run -p 80:80 -p 443:443 --name nginx -v /home/user/nginx/conf:/etc/nginx/conf.d -v /home/user/nginx/log:/var/log/nginx:rw --volumes-from phpfpm --link phpfpm:fpm -d matriphe/alpine-nginx:php-fpm
```

If you run and want to link PHP-FPM container, make sure you created and run PHP-FPM the container before running this Nginx container. Make sure the `/www` volume in PHP-FPM container is mapped.

 * The first `-p` argument maps the container's port 80 to port 80 on the host, and the second argument maps the container's 443 to the hosts 443 for SSL connection.
 * `--name` argument sets the name of the container, useful when starting and stopping the container.
 * The first `-v` argument maps the `/home/user/nginx/conf` directory in the host to `/etc/nginx/conf.d` in the container, and  the second argument maps `/home/user/nginx/log` directory to `/var/log/nginx` with read/write access (rw).
 * `--volumes-from` argument gets volumes from the `phpfpm` container and it should have `/www` mapped.
 * `--link` argument allows this container and the `phpfpm` container to talk to each other over IP.
 * `-d` argument runs the container as a daemon.
 
### Stopping The Container

```Shell
docker stop nginx
```
### Start The Container Again

```Shell
docker start nginx
```
