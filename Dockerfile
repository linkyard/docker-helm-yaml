FROM alpine:3.12 as build

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v3.4.2
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=cacde7768420dd41111a4630e047c231afa01f67e49cc0c6429563e024da4b98

WORKDIR /

RUN apk add --update -t deps curl tar gzip
RUN curl -L https://get.helm.sh/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}


# The image we keep
FROM alpine:3.12
LABEL maintainer="mario.siegenthaler@linkyard.ch"


COPY --from=build /tmp/linux-amd64/helm /bin/helm

RUN apk --no-cache add bash
RUN apk add --update --no-cache bash git ca-certificates jq curl wget

ENV SPRUCE_VERSION 1.27.0
RUN wget https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERSION}/spruce-linux-amd64 \
  && chmod a+x spruce-linux-amd64 \
  && mv spruce-linux-amd64 /usr/local/bin/spruce

ENTRYPOINT ["/bin/helm"]
