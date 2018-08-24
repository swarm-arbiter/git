FROM alpine:3.7

# Create git group and user
RUN addgroup git -g 10000
RUN adduser  git -h /home/git \
								 -s /bin/sh \
								 -G git \
								 -u 10000 \
								 -D
