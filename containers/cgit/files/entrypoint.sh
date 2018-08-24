#!/bin/sh

install -d -D -o git -g git -m 0660 /run/lighttpd
install -d -D -o git -g git -m 0774 /var/log/lighttpd

printf "\n\n"
printf "+===========================================\n"
printf "| Completed cgit setup\n"
printf "+-------------------------------------------\n"
printf "| Container Version : "
cat /VERSION
printf "\n"
printf "| cgit version      : "
apk info cgit 2> /dev/null | grep description | awk '{print $1;}'
printf "| Hostname          : $HOSTNAME\n"
printf "| Local ip          : $(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')\n"
printf "+===========================================\n"
printf "\n\n"

exec /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D
