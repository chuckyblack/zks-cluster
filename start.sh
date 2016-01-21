#!/bin/bash

$SERVER_NO = (hostname | sed -r "s|[a-z]+||")
$SERVER_IP="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

# run zookeeper
$ZK_SERVERS = "server.1=172.16.60.80:2888:3888 server.2=172.16.60.81:2888:3888 server.3=172.16.60.82:2888:3888"
docker run --name="zk$SERVER_NO" --net="host" -d -e "ZK_SERVERS=$ZK_SERVERS" -e "ZK_SERVER_ID=$SERVER_NO" performio/zookeeper

# run kafka
$ZK_POOL = "172.16.60.80:2181,172.16.60.81:2181,172.16.60.82:2181"
docker run --name="kafka$SERVER_NO" -d -p $SERVER_IP:9092:9092 -e "KAFKA_ADVERTISED_PORT=9092" -e "KAFKA_BROKER_ID=$SERVER_NO" -e "KAFKA_ZOOKEEPER_CONNECT=$ZK_POOL" -e "KAFKA_ADVERTISED_HOST_NAME=$SERVER_IP" kafka_kafka