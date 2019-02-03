#!/usr/bin/env bash

source .env

mysql \
-u$MYSQL_USER \
-p$MYSQL_PASSWORD \
-P 33061 \
--protocol=tcp \
$MYSQL_DATABASE