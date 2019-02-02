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
DB_DOCKER_LABEL="8.0.14"
DB_DOCKER_NAME="tbrs.club.db"
DB_ROOT_USER="root"
DB_ROOT_PASSWORD="$(gen_pwd)"
DB_SECRET=".db.secret"
SLEEP_IN_SECOND=30

echo "Taking down any running process"
docker stop $DB_DOCKER_NAME
docker rm $DB_DOCKER_NAME

echo "Database password is written to $DB_SECRET"
[ -f "$DB_SECRET" ] && rm -f $DB_SECRET
echo "DB_DOCKER_NAME=$DB_DOCKER_NAME" >> $DB_SECRET
echo "DB_ROOT_USER=$DB_ROOT_USER" >> $DB_SECRET
echo "DB_ROOT_PASSWORD=$DB_ROOT_PASSWORD" >> $DB_SECRET

echo "Bring up database docker process"
docker run \
--name $DB_DOCKER_NAME \
-e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
--expose 3306 \
-d $DB_DOCKER_IMAGE:$DB_DOCKER_LABEL

echo "Sleep $SLEEP_IN_SECOND seconds to wait for the database."
sleep $SLEEP_IN_SECOND

echo "Testing connection to the database"
docker exec -it $DB_DOCKER_NAME mysql -u$DB_ROOT_USER -p$DB_ROOT_PASSWORD -e "show databases"