FROM alpine:3.7

# Create git group and user
RUN addgroup git -g 10000
RUN adduser  git -h /home/git \
								 -s /bin/sh \
								 -G git \
								 -u 10000 \
								 -D

# Install packages
RUN apk add --no-cache gitolite openssh

# Unlock git user (locked by gitolite)
RUN passwd -u git

# Copy in ssh config and setup directory structure
RUN mkdir -p /etc/ssh/hostkeys
COPY files/sshd_config /etc/ssh/sshd_config

# Copy in entrypoint
COPY files/entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY VERSION /

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sshd"]
