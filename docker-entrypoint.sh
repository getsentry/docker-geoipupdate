#!/bin/sh

if [ "$1" = 'wrapper' -a "$(id -u)" = '0' ]; then
    find /data \! -user geoip -exec chown geoip '{}' +
    exec su-exec geoip "$0" "$@"
fi

exec "$@"
