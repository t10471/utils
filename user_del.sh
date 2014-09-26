#!/bin/sh

if [ -z "$1" ] ;then
    echo "need user name"
    exit
else
    user="$1"
fi

sudo userdel $user
sudo rm -rf /home/$user
sudo groupdel $user

