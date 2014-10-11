#!/bin/bash

# github上に言語のプロジェクトかdockerプロジェクトを作成するときに使用
# 使い方
# bash github_init.sh [host|docker] dir user
# bash github_init.sh docker ghc ghc
# bash github_init.sh host haskell haskell


TYPES=()
TYPES=("${TYPES[@]}" "host")
TYPES=("${TYPES[@]}" "docker")

TYPE=$1
TARGET_DIR=$2
URL=$3
IS_TEST=$4

declare -A cd_dir
cd_dir[host]="/home/${TARGET_DIR}/workspace"
cd_dir[docker]="~/docker/${TARGET_DIR}"

declare -A github_url
github_url[host]="git@github.com:t10471/${URL}.git"
github_url[docker]="git@github.com:t10471/docker-${URL}.git"
. ./libs.sh

git_init() {
    local type=$1
    local val=`eval echo '${github_url['$type']}'`
    echo "git_init val = $val"
    if [ "$IS_TEST" != "test" ]; then
        git init
        git config --local user.name 't10471'
        git config --local user.email 't104711202@gmail.com'
        git remote add origin $val
        git fetch origin
        result=$(git branch -a |grep master)
        if [ -z "$1" ] ;then
            echo "not master"
        else
            git pull origin master
            dir="$1"
        fi
        git add --all
        git commit -m 'first commit' -a
        git push origin master
    fi
}

git_init_host() {
    echo "git_init_host"
    git_init host
}

git_init_docker() {
    echo "git_init_docker"
    git_init docker 
    if [ "$IS_TEST" != "test" ]; then
        git checkout -b build
        git push origin build
        git checkout master
    fi
}

check_git() {
    local type=$1
    local val=`eval echo '${cd_dir['$type']}'`
    echo "check_git val = $val"
    eval cd "$val"
    pwd
    if [ -e .git ]; then
        echo ".git exist !!!!"
        if [ "$IS_TEST" != "test" ]; then
            kill -14 "$$"
        fi
    fi
}

trap 'echo "error has occored"; exit 1' 14

is_valid_args "need type" $TYPE
is_valid_args "need dir" $TARGET_DIR
is_valid_args "need url" $URL
exists_in TYPES $TYPE
check_git $TYPE
git_init_${TYPE} 
