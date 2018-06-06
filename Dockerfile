FROM alpine:3.7

# Create git group and user
RUN addgroup git -g 10000
RUN adduser  git -h /home/git \
								 -s /bin/sh \
								 -G git \
								 -u 10000 \
								 -D

# Create nginx group and user
RUN addgroup nginx -g 10001
RUN adduser  nginx -s /sbin/nologin \
								 	 -G nginx \
								 	 -u 10001 \
								 	 -D

# Install packages
RUN apk add --no-cache cgit nginx spawn-fcgi fcgiwrap

# Copy in all files
RUN rm -rf /etc/nginx
COPY files/ /
RUN chmod +x /entrypoint.sh

COPY VERSION /

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
