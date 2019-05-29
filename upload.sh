#!/bin/bash

version="$(cat Dockerfile | awk '$1 == "ENV" && $2 == "GEOIPUPDATE_VERSION" { print $3; exit }')"
repo=mattrobenolt/geoipupdate

docker build --pull --rm -t "$repo:$version" .
docker tag "$repo:$version" "$repo:latest"

docker push "$repo:$version"
docker push "$repo:latest"

docker rmi "$repo:$version"
docker rmi "$repo:latest"
