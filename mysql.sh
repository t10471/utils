#!/bin/bash

# configファイルを読み見込み以下のようにdocker runをおこなう
# docker run --name mysql -v /var/lib/mysql:/var/lib/mysql --privileged=true \
#     -e MYSQL_ROOT_PASSWORD=pppp \
#     -e MYSQL_PASSWORD=qqqqq \
#     -e MYSQL_DATABASE=dddd \
#     -e MYSQL_USER=uuuuu \
#     -d mysql


COMMANDS=()
COMMANDS=("${COMMANDS[@]}" "start")
COMMANDS=("${COMMANDS[@]}" "connect")

KEYS=()
KEYS=("${KEYS[@]}" "MYSQL_ROOT_PASSWORD")
KEYS=("${KEYS[@]}" "MYSQL_PASSWORD")
KEYS=("${KEYS[@]}" "MYSQL_DATABASE")
KEYS=("${KEYS[@]}" "MYSQL_USER")

declare -A config

COMMAND=$1
IS_TEST=$2

. ./libs.sh

read_config() {
    file=config
    for line in `cat ${file} | grep -v ^#`
    do
      local key=`echo ${line} | cut -d '=' -f 1`
      local val=`echo ${line} | cut -d '=' -f 2`
      config[${key}]=$val
    done
}

check_config() {
    for i in ${!config[@]}; do
        local key=${i}
        local val=${config[$i]}
        for (( j = 0; j < ${#KEYS[@]}; ++j ))
        do
            if [ "${KEYS[$j]}" == "$i" ]; then
               unset KEYS[$j]
               KEYS=(${KEYS[@]})
            fi
        done
    done
    if [ "${#KEYS[@]}" -ne 0 ]; then
        echo "${KEYS[*]} not exist"
        kill -14 "$$"
    fi
    return 0
}

docker_run() {
    local cmd="docker run --name mysql -v /var/lib/mysql:/var/lib/mysql --privileged=true"
    for i in ${!config[@]}; do
        local key=${i}
        local val=${config[$i]}
        cmd="${cmd} -e ${key}=${val}"
    done
    cmd=${cmd}" -d mysql"
    echo $cmd
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
}

mysql_start() {
    read_config
    check_config
    docker_run
}

mysql_connect() {
    local ip=`bash login.sh ip mysql true |awk 'NR == 2'`
    read_config
    local cmd="mysql -u ${config[MYSQL_USER]} -p${config[MYSQL_PASSWORD]} -h ${ip} ${config[MYSQL_DATABASE]}"
    echo $cmd
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
}

trap 'echo "error has occored"; exit 1' 14


is_valid_args "need command" $COMMAND
exists_in COMMANDS $COMMAND
mysql_$COMMAND
