#!/bin/bash

# confファイルを読み見込み以下のようにdocker runをおこなう
# docker run --name mysql -v /var/lib/mysql:/var/lib/mysql --privileged=true \
#     -e MYSQL_ROOT_PASSWORD=pppp \
#     -e MYSQL_PASSWORD=qqqqq \
#     -e MYSQL_DATABASE=dddd \
#     -e MYSQL_USER=uuuuu \
#     -d mysql


COMMANDS=()
COMMANDS=("${COMMANDS[@]}" "start")
COMMANDS=("${COMMANDS[@]}" "connect")
COMMANDS=("${COMMANDS[@]}" "login")

TYPES=()
TYPES=("${TYPES[@]}" "mysql")
TYPES=("${TYPES[@]}" "postgres")

MYSQL_KEYS=()
MYSQL_KEYS=("${MYSQL_KEYS[@]}" "MYSQL_ROOT_PASSWORD")
MYSQL_KEYS=("${MYSQL_KEYS[@]}" "MYSQL_PASSWORD")
MYSQL_KEYS=("${MYSQL_KEYS[@]}" "MYSQL_DATABASE")
MYSQL_KEYS=("${MYSQL_KEYS[@]}" "MYSQL_USER")

POSTGRES_KEYS=()
POSTGRES_KEYS=("${POSTGRES_KEYS[@]}" "POSTGRES_PASSWORD")
POSTGRES_KEYS=("${POSTGRES_KEYS[@]}" "POSTGRES_DATABASE")
POSTGRES_KEYS=("${POSTGRES_KEYS[@]}" "POSTGRES_USER")
declare -A conf

COMMAND=$1
TYPE=$2
IS_TEST=$3

. ./libs.sh

read_conf() {
    file=config
    for line in `cat ${file} | grep -v ^#`
    do
      local key=`echo ${line} | cut -d '=' -f 1`
      local val=`echo ${line} | cut -d '=' -f 2`
      if [ "$TYPE" == "mysql" -a 0 -ne `expr "$key" : "^MYSQL"` ]; then
          conf[${key}]=$val
      elif [ "$TYPE" == "postgres" -a 0 -ne `expr "$key" : "^POSTGRES"` ]; then
          conf[${key}]=$val
      fi
    done
}

check_conf() {
    for i in ${!conf[@]}; do
        local key=${i}
        local val=${conf[$i]}
        if [ "$TYPE" == 'mysql' ]; then
            for (( j = 0; j < ${#MYSQL_KEYS[@]}; ++j ))
            do
                if [ "${MYSQL_KEYS[$j]}" == "$i" ]; then
                    unset MYSQL_KEYS[$j]
                    MYSQL_KEYS=(${MYSQL_KEYS[@]})
                fi
            done
        else
            for (( j = 0; j < ${#POSTGRES_KEYS[@]}; ++j ))
            do
                if [ "${POSTGRES_KEYS[$j]}" == "$i" ]; then
                    unset POSTGRES_KEYS[$j]
                    POSTGRES_KEYS=(${POSTGRES_KEYS[@]})
                fi
            done
        fi
    done
    if [ "$TYPE" == 'mysql' ]; then
        if [ "${#MYSQL_KEYS[@]}" -ne 0 ]; then
            echo "${MYSQL_KEYS[*]} not exist"
            kill -14 "$$"
        fi
    else
        if [ "${#POSTGRES_KEYS[@]}" -ne 0 ]; then
            echo "${POSTGRES_KEYS[*]} not exist"
            kill -14 "$$"
        fi
    fi
    return 0
}

docker_run() {
    if [ "$TYPE" == 'mysql' ]; then
        local cmd="docker run --name mysql -v /var/lib/mysql:/var/lib/mysql --privileged=true"
    else
        local cmd="docker run --name postgres -v /var/lib/postgresql/data:/var/lib/postgresql/data --privileged=true"
    fi
    for i in ${!conf[@]}; do
        local key=${i}
        local val=${conf[$i]}
        cmd="${cmd} -e ${key}=${val}"
    done
    if [ "$TYPE" == 'mysql' ]; then
        cmd=${cmd}" -d mysql"
    else
        cmd=${cmd}" -d postgres:9.4"
    fi
    echo $cmd
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
}

do_start() {
    read_conf
    check_conf
    docker_run
}

do_connect() {
    local ip=`bash login.sh ip ${TYPE} true |awk 'NR == 2'`
    read_conf
    case $TYPE in
        mysql)    local cmd="mysql -u ${conf[MYSQL_USER]} -p${conf[MYSQL_PASSWORD]} -h ${ip} ${conf[MYSQL_DATABASE]}";;
        postgres) local cmd="psql  -U ${conf[POSTGRES_USER]} -w ${conf[POSTGRES_PASSWORD]} -h ${ip} -d ${conf[POSTGRES_DATABASE]}";;
    esac
    echo $cmd
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
}

do_login() {
    local cmd="docker exec -it $TYPE bash"
    echo $cmd
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
}

trap 'echo "error has occored"; exit 1' 14

is_valid_args "need command" $COMMAND
is_valid_args "need type" $TYPE
exists_in COMMANDS $COMMAND
exists_in TYPES $TYPE
do_$COMMAND $TYPE
