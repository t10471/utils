#!/bin/bash

if [ -z "$1" ] ;then
    echo "need container name"
    exit
else
    name="$1"
fi

docker run -i -t $name /bin/bash

