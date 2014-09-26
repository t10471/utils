#!/bin/sh

if [ -z "$1" ] ;then
    image='ghc'
else
    image="$1"
fi
echo $image
id=`docker ps |grep $image |awk '{ print $1 }'`

if [ -z "$id" ] ;then
  echo "id not found"
  exit
fi

ip=`docker inspect -f "{{ .NetworkSettings.IPAddress }}" $id`

echo $ip

ssh -i insecure_key root@$ip
