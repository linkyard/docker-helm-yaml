FROM linkyard/docker-helm:2.11.0
LABEL maintainer="mario.siegenthaler@linkyard.ch"

RUN apk --no-cache add bash
RUN apk --no-cache add --update curl wget ca-certificates
RUN apk --no-cache add jq

ENV SPRUCE_VERSION 1.18.2
RUN wget https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERSION}/spruce-linux-amd64 \
  && chmod a+x spruce-linux-amd64 \
  && mv spruce-linux-amd64 /usr/local/bin/spruce
