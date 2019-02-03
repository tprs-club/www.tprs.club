#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)

cd $SCRIPT_DIR/../orm
prisma deploy -e ../config/$1.env
prisma token -e ../config/$1.env > ../config/.runtime.orm.token 

echo "Prisma token is at config/.runtime.orm.token"