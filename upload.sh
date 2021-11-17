#!/bin/bash
set -ex

if [[ -n "$(git status --porcelain)" ]]; then
  echo 'Dirty working directory, exiting.'
  exit 1
fi

version="$(cat Dockerfile | awk '$1 == "ENV" && $2 == "GEOIPUPDATE_VERSION" { print $3; exit }')"
repo="us.gcr.io/sentryio/geoipupdate"

docker build --pull --rm -t "$repo:$version" .

docker push "$repo:$version"
