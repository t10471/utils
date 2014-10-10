#!/bin/bash

#使い方
#bash github_docker_init.shjava7 docker-java

if [ -z "$1" ] ;then
    echo "need docker dir"
    exit
else
    dir="$1"
fi

if [ -z "$2" ] ;then
    echo "need url"
    exit
else
    url="$2"
fi

cd ~/docker/$dir

if [ -e .git ]; then
    echo ".git exist !!!!"
fi


git init
git config --local user.name 't10471'
git config --local user.email 't104711202@gmail.com'
git remote add origin git@github.com:t10471/${url}.git
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
git checkout -b build
git push origin build
git checkout master
