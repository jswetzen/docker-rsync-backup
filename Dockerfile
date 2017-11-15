FROM alpine:3.6
MAINTAINER Johan Swetzén <johan@swetzen.com>

ENV REMOTE_HOSTNAME="" \
    BACKUPDIR="/home" \
    SSH_PORT="22" \
    SSH_IDENTITY_FILE="/root/.ssh/id_rsa" \
    ARCHIVEROOT="/backup" \
    EXCLUDES="" \
    CRON_TIME="0 1 * * *"

RUN apk add --no-cache rsync openssh-client

COPY docker-entrypoint.sh /usr/local/bin/
COPY backup.sh /backup.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD /backup.sh && crond -f
