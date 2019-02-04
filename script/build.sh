#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)

pushd $SCRIPT_DIR/../web
rm -fr dist
npm run build
docker build -t qiwenzhao/tbrs.web:latest .
popd

pushd $SCRIPT_DIR/../server/node
rm -fr dist
npm run build
cp *.graphql dist
docker build -t qiwenzhao/tbrs.node:latest .
popd