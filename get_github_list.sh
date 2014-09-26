#!/bin/bash

if [ -z "$1" ] ;then
    echo "need name"
    exit
else
    name="$1"
fi

curl https://api.github.com/users/$name/repos?per_page=100 2> /dev/null |grep git_url
