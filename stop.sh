#!/bin/bash

SERVER_NO=$(hostname | sed -r "s|[a-z]+||")
CMD="stop"
if [ -n "$1" ]
then
    CMD="$1"
fi

docker $CMD "zk$SERVER_NO"
docker $CMD "kafka$SERVER_NO"
docker $CMD "spark-worker$SERVER_NO"
docker $CMD "spark-master$SERVER_NO"
