#!/bin/bash

if [ -z "$1" ] ;then
    echo "need file name"
    exit
else
    name="$1"
fi

cp ~/workspace/haskell/parconc-examples-0.3.4/$name /var/www/html/heroku/resources/
sudo chown www-data:www-data /var/www/html/heroku/resources/$name

