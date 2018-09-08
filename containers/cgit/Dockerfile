FROM registry.terry.cloud/stack/git_base:latest

# Install packages
RUN apk add --no-cache cgit lighttpd lighttpd-mod_auth

# Copy in all files
RUN rm -rf /etc/nginx
COPY files/ /
RUN chmod +x /entrypoint.sh

ARG CGIT_VERSION
RUN echo ${CGIT_VERSION} > /VERSION

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
