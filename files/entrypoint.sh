#!/bin/sh

install -d -D -o nginx -g nginx -m 0777 /run/nginx
install -d -D -o nginx -g nginx -m 0777 /var/log/nginx
install -d -D -o nginx -g nginx -m 0777 /var/run/fcgiwrap

echo "Starting fcgiwrap..."

spawn-fcgi -s /var/run/fcgiwrap/fcgiwrap.sock \
					 -P /var/run/fcgiwrap/fcgiwrap.pid \
					 -M 0777 \
					 -u nginx -g nginx \
					 -U nginx -G nginx \
					 -- /usr/bin/fcgiwrap -f

echo "Starting nginx..."
nginx

exec /bin/sh
