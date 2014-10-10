#!/bin/sh

id=`docker ps |grep mysql  |awk '{ print $1 }'`

if [ -z "$id" ] ;then
  echo "id not found"
  exit
fi

ip=`docker inspect -f "{{ .NetworkSettings.IPAddress }}" $id`

echo $ip
