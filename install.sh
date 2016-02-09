#!/bin/bash

# install docker
apt-get purge lxc-docker*
apt-get purge docker.io*
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo $(lsb_release -si | awk '{print tolower($0)}')-$(lsb_release -sc) main" > /etc/apt/sources.list.d/docker.list
apt-get install -y apt-transport-https
apt-get update
# apt-cache policy docker-engine
apt-get install -y docker-engine

apt-get install -y curl

# install docker-compose
# curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose
# curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose --version | awk 'NR==1{print $NF}')/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

# install git
apt-get install -y git

# install pykafka
apt-get install -y python-pip

git clone git@github.com:jonsource/kafka-spark.git kafka
git clone git@github.com:jonsource/zookeeper-docker.git zookeeper
git clone git@github.com:jonsource/docker-spark.git spark
