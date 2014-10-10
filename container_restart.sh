#!/bin/bash

if [ -z "$1" ] ;then
    echo "need container name"
    exit
else
    name="$1"
fi

if [ -z "$2" ] ;then
    echo "need image name"
    exit
else
    image="$2"
fi

nouser=0
if [ -z "$3" ] ;then
    echo "need user"
    exit
elif [ "nouser" = "$2" ] ;then
    nouser=1
else
    user="$3"
fi

docker stop $name
docker rm $name
sh rmi_none_image.sh
if [ $nouser -eq 1 ] ;then
    sudo docker run -i -t $name /bin/bash
else
    docker run -dP --name="$name"  -v /home/${user}/workspace:/root/workspace --link mysql:mysql --privileged=true t10471/${image} /sbin/my_init --enable-insecure-key
    sh container_init.sh $name
fi

