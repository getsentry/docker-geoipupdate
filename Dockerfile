FROM golang:1.12-alpine3.9 AS builder

ENV GEOIPUPDATE_VERSION 4.0.2

RUN set -ex; \
    apk add --no-cache make; \
    wget -O geoipupdate.tar.gz "https://github.com/maxmind/geoipupdate/archive/v${GEOIPUPDATE_VERSION}.tar.gz"; \
    mkdir -p /go/src/geoipupdate; \
    tar -xzf geoipupdate.tar.gz -C /go/src/geoipupdate --strip-components=1; \
    cd /go/src/geoipupdate/cmd/geoipupdate; \
    go build -ldflags "-s -w -X main.version=$GEOIPUPDATE_VERSION -X main.defaultConfigFile=/etc/GeoIP.conf -X main.defaultDatabaseDirectory=/data"; \
    /go/src/geoipupdate/cmd/geoipupdate/geoipupdate --version

FROM alpine:3.9

RUN addgroup -S geoip && adduser -S -G geoip geoip

RUN apk add --no-cache \
        'su-exec>=0.2' \
        ca-certificates

COPY --from=builder /go/src/geoipupdate/cmd/geoipupdate/geoipupdate /bin/
COPY --from=builder /go/src/geoipupdate/conf/GeoIP.conf.default /etc/GeoIP.conf
COPY docker-entrypoint.sh wrapper /bin/
RUN mkdir -p /data && chown geoip:geoip /data

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/bin/wrapper"]
