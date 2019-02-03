#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)

cd $SCRIPT_DIR/..
graphql get-schema -p prisma --dotenv config/dev.env