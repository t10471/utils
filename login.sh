#!/bin/bash

# bash login.sh [login|ip|rm] container名 [test]

COMMANDS=()
COMMANDS=("${COMMANDS[@]}" "ip")
COMMANDS=("${COMMANDS[@]}" "login")
COMMANDS=("${COMMANDS[@]}" "rm")

COMMAND=$1
NAME=$2
IS_TEST=$3
IP=""
. ./libs.sh

ip() {
    local name=$1
    local cmd="docker ps | grep ${name} "
    case $name in
        mysql)    cmd="${cmd} |grep -v postgres ";;
        postgres) cmd="${cmd} |grep -v mysql ";;
        *)        cmd="${cmd} |grep -v mysql |grep -v postgrs";;
    esac
    cmd="${cmd}|awk ""'"'{ print $1 }'"'"
    echo $cmd
    id=$(eval $cmd)
    if [ -z "$id" ] ;then
      echo "id not found"
      kill -14 "$$"
    fi
    IP=`docker inspect -f "{{ .NetworkSettings.IPAddress }}" $id`
    echo $IP
}

login() {
    local name=$1
    ip $name
    local cmd="ssh -i insecure_key root@$IP"
    echo $cmd
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
}

rm() {
    local name=$1
    ip $name
    ssh-keygen -f "/home/theo/.ssh/known_hosts" -R $IP 
}

trap 'echo "error has occored"; exit 1' 14

is_valid_args "need command" $COMMAND
is_valid_args "need container name" $NAME
exists_in COMMANDS $COMMAND

${COMMAND} $NAME
