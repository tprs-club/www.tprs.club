#!/usr/bin/env bash
#
# Utility script to bring up dev environment.


SCRIPT_DIR=$(dirname $0)
cd $SCRIPT_DIR/../config

source dev.env

DC_TEMPLATE="dc.template.yml"
DC_RUNTIME=".runtime.docker-compose.yml"

cp $DC_TEMPLATE $DC_RUNTIME
sed -i -e "s,REPLACE_WITH_MYSQL_ROOT_PASSWORD,$MYSQL_ROOT_PASSWORD,g" $DC_RUNTIME
sed -i -e "s,REPLACE_WITH_PRISMA_SECRET,$PRISMA_SECRET,g" $DC_RUNTIME
sed -i -e "s,REPLACE_WITH_JWT_SECRET,$JWT_SECRET,g" $DC_RUNTIME

docker-compose -f $DC_RUNTIME $1 $2
rm $DC_RUNTIME