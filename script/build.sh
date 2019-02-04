#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)

pushd $SCRIPT_DIR/../web
rm -fr dist
cp src/connection.js src/__saved.js
sed "s,'.*','http://node:4000',g" src/connection.js
npm run build
cp src/__saved.js src/connection.js
rm -f src/__saved.js
docker build -t qiwenzhao/tbrs.web:latest .
popd

pushd $SCRIPT_DIR/../server/node
rm -fr dist
npm run build
cp *.graphql dist
docker build -t qiwenzhao/tbrs.node:latest .
popd