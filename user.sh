#!/bin/bash

# ユーザを追加
# workspaceを作成
# 実行ユーザをworkspaceのグループに登録
# ユーザ削除
# ユーザ追加の反対
# 使い方
# bash user.sh [add|del] user
# bash user.sh add scala
# bash user.sh del scala

COMMANDS=()
COMMANDS=("${COMMANDS[@]}" "add")
COMMANDS=("${COMMANDS[@]}" "del")

. ./libs.sh

COMMAND=$1
ADD_USER=$2
IS_TEST=$3

user_add() {
    local user=$1
    local my=`whoami`
    echo "user_add $user"
    if [ "$IS_TEST" != "test" ]; then
        sudo addgroup $user
        sudo adduser  --shell /sbin/nologin --home /home/$user  --ingroup $user --disabled-login --disabled-password $user
        sudo gpasswd -a $my $user

        sudo mkdir /home/$user/workspace/
        sudo chown -R $user:$user /home/$user/workspace/
        sudo chmod -R 775 /home/$user/workspace/
    fi
}

user_del() {
    local user=$1
    echo "user_del $user"
    if [ "$IS_TEST" != "test" ]; then
        sudo userdel $user
        sudo rm -rf /home/$user
        sudo groupdel $user
    fi
}

trap 'echo "error has occored"; exit 1' 14

is_valid_args "need command" $COMMAND 
is_valid_args "need user" $ADD_USER
exists_in COMMANDS $COMMAND
user_${COMMAND} $ADD_USER
