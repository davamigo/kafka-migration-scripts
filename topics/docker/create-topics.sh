#!/bin/bash

cd $(dirname $0)

ARGS=""
while [[ $# -ge 1 ]]; do
    ARGS="$ARGS $1"
    shift
done

COMMAND="docker exec -i \
    docker_kafka_dev \
    bash /opt/kafka/scripts/create-topics.sh \
    ${ARGS} \
    ";

echo -en "\n$ ";
echo -e $COMMAND;

$COMMAND
echo -e "";
