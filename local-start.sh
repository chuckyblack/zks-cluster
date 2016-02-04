#!/bin/bash

export SERVER_IP="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
export ZK_SERVERS="server.1=172.17.0.2:2888:3888"
export ZK_POOL="172.17.0.2:2181"
export SPARK_POOL="172.17.0.6:7077"
export SPARK_MASTER_IP="172.17.0.6"

# run 1 zookeeper
# !! different config when running alone !!
docker run --name="zk1" -d -e "ZK_SERVER_ID=$SERVER_NO" performio/zookeeper

# run 3 kafkas
docker run --name="kafka1" -d -e "KAFKA_ADVERTISED_PORT=9092" -e "KAFKA_ADVERTISED_HOST_NAME=172.17.0.3" -e "KAFKA_BROKER_ID=1" -e "KAFKA_ZOOKEEPER_CONNECT=$ZK_POOL" performio/kafka
docker run --name="kafka2" -d -e "KAFKA_ADVERTISED_PORT=9092" -e "KAFKA_ADVERTISED_HOST_NAME=172.17.0.4" -e "KAFKA_BROKER_ID=2" -e "KAFKA_ZOOKEEPER_CONNECT=$ZK_POOL" performio/kafka
docker run --name="kafka3" -d -e "KAFKA_CREATE_TOPICS=test:12:3" -e "KAFKA_ADVERTISED_PORT=9092" -e "KAFKA_ADVERTISED_HOST_NAME=172.17.0.5" -e "KAFKA_BROKER_ID=3" -e "KAFKA_ZOOKEEPER_CONNECT=$ZK_POOL" performio/kafka


#run 1 spark-master
docker run --name="spark-master1" -d -e "RUN_MASTER=1" -e "SPARK_MASTER_IP=$SPARK_MASTER_IP" -e "ZK_ENSAMBLE_IP=$ZK_POOL" performio/spark

#run 1 spark-worker
docker run --name="spark-worker1" -d -e "RUN_WORKER=1" -e "SPARK_MASTER_IP=$SPARK_POOL" performio/spark
