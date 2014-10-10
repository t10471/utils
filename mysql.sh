#!/bin/sh

if [ -z "$1" ] ;then
    echo "need user"
else
    user="$1"
fi

if [ -z "$2" ] ;then
    echo "need user"
else
    password="$2"
fi

echo $image
id=`docker ps |grep mysql  |awk '{ print $1 }'`

if [ -z "$id" ] ;then
  echo "id not found"
  exit
fi

ip=`docker inspect -f "{{ .NetworkSettings.IPAddress }}" $id`

mysql -u $user -p${password} -h $ip
