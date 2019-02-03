#!/usr/bin/env bash
#
# Utility script to bring up dev environment.

source .env

DC_TEMPLATE="dc.template.yml"
DC_RUNTIME=".runtime.docker-compose.yml"

cp $DC_TEMPLATE $DC_RUNTIME
sed -i -e "s,REPLACE_WITH_MYSQL_ROOT_PASSWORD,$MYSQL_ROOT_PASSWORD,g" $DC_RUNTIME

docker-compose -f $DC_RUNTIME up -d

echo "Wait a bit to deploy schema"
sleep 30
cd orm
prisma deploy -e ../.env
prisma token -e ../.env > ../.runtime.orm.token

echo "Prisma token is at .runtime.orm.token"
