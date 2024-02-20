FROM golang:1.14-alpine3.11 AS build

COPY . /go/src/github.com/d-a-s-h-o/bin404
WORKDIR /go/src/github.com/d-a-s-h-o/bin404

RUN set -ex \
        && apk add --no-cache --virtual .build-deps git \
        && go get -v . \
        && apk del .build-deps

FROM alpine:3.11

COPY --from=build /go/bin/bin404 /usr/local/bin/bin404

ENV GOPATH /go

COPY static /go/src/github.com/d-a-s-h-o/bin404/static/
COPY templates /go/src/github.com/d-a-s-h-o/bin404/templates/

RUN mkdir -p /data/files && mkdir -p /data/meta && chown -R 65534:65534 /data

EXPOSE 8080
USER nobody
ENTRYPOINT ["/usr/local/bin/bin404", "-bind=0.0.0.0:8080", "-filespath=/data/files/", "-metapath=/data/meta/", "-nologs", "-maxsize=11274289152"]
CMD ["-sitename=Bin404", "-allowhotlink"]
LABEL org.opencontainers.image.source https://github.com/d-a-s-h-o/bin404
