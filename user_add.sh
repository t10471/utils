#!/bin/sh

if [ -z "$1" ] ;then
    echo "need user name"
    exit
else
    user="$1"
fi

my=`whoami`
echo $my
sudo addgroup $user
sudo adduser  --shell /sbin/nologin --home /home/$user  --ingroup $user --disabled-login --disabled-password $user
sudo gpasswd -a $my $user

sudo mkdir /home/$user/workspace/
sudo chown -R $user:$user /home/$user/workspace/
sudo chmod -R 775 /home/$user/workspace/

