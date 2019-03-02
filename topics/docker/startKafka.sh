#!/bin/bash

cd $(dirname $0)

COMMAND="docker run --rm -d \
    -p 9092:9092 \
    -p 2181:2181 \
    -e KAFKA_ADVERTISED_HOST_NAME=localhost \
    -v $PWD/../scripts:/opt/kafka/scripts
    --name docker_kafka_dev \
    blacktop/kafka";

echo -en "\n$ ";
echo -e $COMMAND;

$COMMAND
echo -e "";
