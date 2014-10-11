#!/bin/sh

COMMANDS=()
COMMANDS=("${COMMANDS[@]}" "ip")
COMMANDS=("${COMMANDS[@]}" "login")

COMMAND=$1
NAME=$2
IS_MYSQL=$3
IS_TEST=$4
IP=""
. ./libs.sh

ip() {
    local name=$1
    local is_mysql=$2
    local cmd="docker ps | grep ${name} "
    if ! $is_mysql ; then
        cmd="${cmd} |grep -v mysql "
    fi
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
    local is_mysql=$2
    ip $name $is_mysql
    local cmd="ssh -i insecure_key root@$IP"
    echo $cmd
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
}


trap 'echo "error has occored"; exit 1' 14

is_valid_args "need command" $COMMAND
is_valid_args "need container name" $NAME
is_valid_args "need IS_MySQL" $IS_MYSQL
exists_in COMMANDS $COMMAND

${COMMAND} $NAME $IS_MYSQL
