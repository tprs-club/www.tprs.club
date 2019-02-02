#!/usr/bin/env bash
#
# An utility script to bring up standalone database docker process.

set -u -o pipefail

function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

function gen_pwd() {
    export LC_CTYPE=C
    #echo "$(head /dev/urandom | tr -dc 'A-Za-z0-9\!#$\&\(\)\*+,-./\:\\\\\;\<=\>\?@[]^_{\|}~' | head -c 16)"
    echo "$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 16)"
}

DB_DOCKER_IMAGE="mysql"
DB_DOCKER_LABEL="5.7.25"
DB_DOCKER_NAME="tbrs.club.db"
MYSQL_DATABASE="tbrs.club"
MYSQL_USER="tbrs"
MYSQL_PASSWORD="$(gen_pwd)"
MYSQL_ROOT_USER="root"
MYSQL_ROOT_PASSWORD="$(gen_pwd)"
ENV_FILE=".env"
SLEEP_IN_SECOND=30

echo "Taking down any running process"
docker stop $DB_DOCKER_NAME
docker rm $DB_DOCKER_NAME

echo "Database password is written to $ENV_FILE"
[ -f "$ENV_FILE" ] && rm -f $ENV_FILE
echo "DB_DOCKER_NAME=$DB_DOCKER_NAME" >> $ENV_FILE
echo "MYSQL_ROOT_USER=$MYSQL_ROOT_USER" >> $ENV_FILE
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >> $ENV_FILE
echo "MYSQL_DATABASE=$MYSQL_DATABASE" >> $ENV_FILE
echo "MYSQL_USER=$MYSQL_USER" >> $ENV_FILE
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> $ENV_FILE

echo "Bring up database docker process"
docker run \
--name $DB_DOCKER_NAME \
-e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
-e MYSQL_DATABASE=$MYSQL_DATABASE \
-e MYSQL_USER=$MYSQL_USER \
-e MYSQL_PASSWORD=$MYSQL_PASSWORD \
-p 127.0.0.1:33061:3306 \
-d $DB_DOCKER_IMAGE:$DB_DOCKER_LABEL

echo "Sleep $SLEEP_IN_SECOND seconds to wait for the database."
sleep $SLEEP_IN_SECOND

echo "Testing connection to the database from docker"
docker exec -it $DB_DOCKER_NAME mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "show databases"
docker exec -it $DB_DOCKER_NAME mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "show databases"