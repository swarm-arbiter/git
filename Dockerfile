FROM alpine:3.7

# Create git group and user
RUN addgroup git -g 10000
RUN adduser  git -h /home/git \
								 -s /bin/sh \
								 -G git \
								 -u 10000 \
								 -D

# Install packages
RUN apk add --no-cache cgit lighttpd

# Copy in all files
RUN rm -rf /etc/nginx
COPY files/ /
RUN chmod +x /entrypoint.sh

COPY VERSION /

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
