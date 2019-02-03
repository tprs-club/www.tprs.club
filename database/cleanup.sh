#!/usr/bin/env bash

DB_DOCKER_NAME=tbrs.club.db

docker stop $DB_DOCKER_NAME
docker rm $DB_DOCKER_NAME