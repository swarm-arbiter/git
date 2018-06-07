#!/bin/sh

install -d -D -o git -g git -m 0660 /run/lighttpd
install -d -D -o git -g git -m 0774 /var/log/lighttpd

/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

exec /bin/sh

exec /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D
