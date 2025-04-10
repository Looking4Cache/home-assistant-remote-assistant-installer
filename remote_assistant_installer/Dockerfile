FROM alpine:latest

RUN apk add --no-cache git bash curl coreutils unzip

COPY run.sh /run.sh
COPY update.sh /update.sh
COPY install.sh /install.sh
COPY restart.sh /restart.sh

RUN chmod +x /run.sh /update.sh /install.sh /restart.sh

CMD [ "/run.sh" ]