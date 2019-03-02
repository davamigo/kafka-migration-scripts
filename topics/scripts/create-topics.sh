#!/usr/bin/env bash

cd $(dirname $0)

HELP=false
ENVIRONMENT="dev"
ZOOKEEPER="localhost:2181"
REPLICATION_FACTOR=1
DEF_PARTITIONS=7
TOPICS_FILE=""

ARGS=$(getopt -o "he:z:r:t:" --long "help,environment:,zookeeper:,replication-factor:,topics-file:" -- "$@");
if [ $? != 0 ]; then
    HELP=true;
fi;

eval set -- "${ARGS}";
while [ "$1" != "" ]; do

    case "$1" in

        '-h' | '--help')
            HELP=true;
            shift;;

        '-e' | '--environment')
            ENVIRONMENT=$2
            shift 2;;

        '-z' | '--zookeeper')
            ZOOKEEPER=$2
            shift 2;;

        '-r' | '--replication-factor')
            REPLICATION_FACTOR=$2
            shift 2;;

        '-t' | '--topics-file')
            TOPICS_FILE=$2
            shift 2;;

        '--')
            shift;
            break;;
    esac;
done;


if [ ${HELP} == false ]; then
    if [ "${TOPICS_FILE}" == "" ]; then
        echo -e "\nYou have to specify the topics CSV file."
        HELP=true;
    elif [ ! -f ${TOPICS_FILE} ]; then
        echo -e "\nTopics file does not exist: ${TOPICS_FILE}"
        HELP=true
    fi;
fi;

if [ ${HELP} == true ]; then
    echo -e "\nUsage: $0 [options]"
    echo -e "\t-h, --help\n\t\tShow this help."
    echo -e "\t-e, --environment=[ENV]\n\t\tEnvironment. Default: --environment=dev"
    echo -e "\t-z, --zookeeper=[SERVER]\n\t\tThe connection string for zookeeper (host:port). Default: --zookeeper=localhost:2181"
    echo -e "\t-r, --replication-factor=[FACTOR]\n\t\tThe replication factor for each topic. Default: --replication-factor=1"
    echo -e "\t-t, --topics-file=[FILE]\n\t\tMandatory. The CSV topics file."
    echo -e ""
    exit 0;
fi;

OLDIFS=$IFS

while IFS=";" read TOPIC PARTITIONS CONFIG
do
    FULL_TOPIC=${TOPIC/___ENV___/${ENVIRONMENT}}
    if [ "${PARTITIONS}" == "" ]; then
        PARTITIONS=${DEF_PARTITIONS}
    fi;

    TOPIC_EXIST=$(kafka-topics.sh --list --zookeeper ${ZOOKEEPER} | grep ${FULL_TOPIC})
    if [ "${TOPIC_EXIST}" != "" ]; then
        echo -e "\n>>> topic already exist: ${FULL_TOPIC}... "
    else
        COMMAND="kafka-topics.sh \
            --create \
            --topic ${FULL_TOPIC} \
            --partitions ${PARTITIONS} \
            --replication-factor ${REPLICATION_FACTOR} \
            --zookeeper ${ZOOKEEPER} \
            ${CONFIG}
            ";

        echo -e "\n>>> Creating topic: ${FULL_TOPIC}... "
        echo -en "\n$ ";
        echo -e $COMMAND;
        echo -e ""

        $COMMAND
    fi;

done < ${TOPICS_FILE}

IFS=$OLDIFS
echo -e "";
