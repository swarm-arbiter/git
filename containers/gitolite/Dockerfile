FROM registry.terry.cloud/stack/git_base:latest

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

ARG GITOLITE_VERSION
RUN echo ${GITOLITE_VERSION} > /VERSION

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sshd"]
