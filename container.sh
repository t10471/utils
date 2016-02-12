#!/bin/bash

#コンテナに対してコマンドを送る
#使い方
#bash container.sh restart ghc

COMMANDS=()
COMMANDS=("${COMMANDS[@]}" "start")
COMMANDS=("${COMMANDS[@]}" "restart")
COMMANDS=("${COMMANDS[@]}" "init")
COMMANDS=("${COMMANDS[@]}" "stop")

CONTAINERS=()
CONTAINERS=("${CONTAINERS[@]}" "ghc")
CONTAINERS=("${CONTAINERS[@]}" "clang")
CONTAINERS=("${CONTAINERS[@]}" "scala")
CONTAINERS=("${CONTAINERS[@]}" "ruby")
CONTAINERS=("${CONTAINERS[@]}" "stack")
CONTAINERS=("${CONTAINERS[@]}" "python")

# container名 docker名 ユーザ名
declare -A ghc
ghc[start]="ghc haskell haskell"
ghc[restart]="ghc haskell haskell"
ghc[init]="ghc"
ghc[stop]="ghc"

declare -A clang
clang[start]="clang c-language clang"
clang[restart]="clang c-language clang"
clang[init]="clang"
clang[stop]="clang"

declare -A scala
scala[start]="scala scala scala"
scala[restart]="scala scala scala"
scala[init]="scala"
scala[stop]="scala"

declare -A ruby
ruby[start]="ruby ruby ruby"
ruby[restart]="ruby ruby ruby"
ruby[init]="ruby"
ruby[stop]="ruby"

declare -A stack
stack[start]="stack stack stack"
stack[restart]="stack stack stack"
stack[init]="stack"
stack[stop]="stack"

declare -A python
python[start]="python python python"
python[restart]="python python python"
python[init]="python"
python[stop]="python"

declare -A mysql
mysql[ghc]="y"
mysql[clang]="y"
mysql[scala]="y"
mysql[stack]="y"
mysql[python]="y"

declare -A postgres
postgres[ghc]="y"
postgres[ruby]="y"
postgres[stack]="y"

declare -A rabbit
rabbit[scala]="y"

declare -A port
port[ghc]="9001:9001"
port[stack]="9002:9002"
port[python]="9003:9003"

# declare -A env
# env[ghc]="LANG=C.UTF-8"

COMMAND=$1
NAME=$2
IS_TEST=$3

. ./libs.sh

container_init() {
    local name=$1
    echo "container_init $name"
    if [ "$IS_TEST" != "test" ]; then
        local id=`docker ps |grep $name |grep -v ghct |grep -v mysql |awk '{ print $1 }'`
        local ip=`docker inspect -f "{{ .NetworkSettings.IPAddress }}" $id`
        scp  -i insecure_key ~/.ssh/id_rsa_github root@$ip:~/.ssh/id_rsa_github
        ssh -i insecure_key root@$ip "bash base.sh"
        ssh -i insecure_key root@$ip "bash init.sh"
    fi
}

container_stop() {
    local name=$1
    echo "container_stop $name"
    if [ "$IS_TEST" != "test" ]; then
        docker stop $name
        docker rm $name
        bash rmi_none_image.sh
    fi
}

container_start() {
    local name=$1
    local image=$2
    local user=$3
    local cmd="docker run -dP --name=\"${name}\"  -v /home/theo/workspace/${user}:/root/workspace -v /home/theo:/home/theo" 
    if [[ "${mysql[$name]+_}" == "_"  ]]; then
        cmd="${cmd} --link mysql:mysql" 
    fi
    if [[ "${postgres[$name]+_}" == "_"  ]]; then
        cmd="${cmd} --link postgres:postgres" 
    fi
    if [[ "${rabbit[$name]+_}" == "_"  ]]; then
        cmd="${cmd} --link rabbit:rabbit" 
    fi
    if [[ "${port[$name]+_}" == "_"  ]]; then
        cmd="${cmd} -p ${port[$name]}" 
    fi
    if [[ "${env[$name]+_}" == "_"  ]]; then
        cmd="${cmd} -e ${env[$name]}" 
    fi
    cmd="${cmd} --privileged=true t10471/${image} /sbin/my_init --enable-insecure-key"
    echo $cmd 
    if [ "$IS_TEST" != "test" ]; then
        $cmd
    fi
    sleep 2s
    container_init $name
}

container_restart() {
    local name=$1
    local image=$2
    local user=$3
    echo "container_restart $name $image $user"
    container_stop $name
    container_start $name $image $user
}

trap 'echo "error has occored"; exit 1' 14

is_valid_args "need command" $COMMAND
is_valid_args "need container name" $NAME
exists_in CONTAINERS $NAME
exists_in COMMANDS $COMMAND

VAL=`eval echo '${'$NAME'['$COMMAND']}'`
container_${COMMAND} $VAL

