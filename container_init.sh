#!/bin/bash

if [ -z "$1" ] ;then
    echo "need container name"
    exit
else
    name="$1"
fi

id=`docker ps |grep $name |awk '{ print $1 }'`
ip=`docker inspect -f "{{ .NetworkSettings.IPAddress }}" $id`

scp  -i insecure_key ~/.ssh/id_rsa_github root@$ip:~/.ssh/id_rsa_github

ssh -i insecure_key root@$ip "sh dotfiles.sh"

