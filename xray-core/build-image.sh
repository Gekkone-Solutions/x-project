#!/bin/bash

if [ ! -d core ]; then
   git clone git@github.com:XTLS/Xray-core.git -b main ./core
fi

cd ./core
git pull origin main

VERSION=`git ls-remote --refs --sort="version:refname" --tags 'git@github.com:XTLS/Xray-core.git' | cut -d/ -f3-|tail -n1`
git checkout $VERSION

rm -r ../build-$VERSION > /dev/null 2>&1
cp -r ./ ../build-$VERSION > /dev/null 2>&1
cp ../Dockerfile ../build-$VERSION
cp ../docker/xray/config.json ../build-$VERSION

cd ../build-$VERSION
docker buildx build --platform linux/amd64/v3 -t gekkone/xray-core:$VERSION ./ && cd ../ && rm -rf build-$VERSION
docker tag gekkone/xray-core:$VERSION gekkone/xray-core:latest
docker push gekkone/xray-core:$VERSION
docker push gekkone/xray-core:latest
