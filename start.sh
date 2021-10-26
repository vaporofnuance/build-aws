#!/bin/bash

echo Initializing Container

docker-entrypoint.sh &

exec "$@"
