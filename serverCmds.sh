#!/usr/bin/env bash

export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PWD=$3
echo $DOCKER_PWD | sudo docker login -u $DOCKER_USER --password-stdin
sudo docker-compose -f docker-compose.yaml up -d
echo "Success in running"
