#!/bin/bash

case "$1" in
    "start" )  bash container_start.sh  scala scala scala;;
    "restart" )  bash container_restart.sh scala scala scala ;;
    "init" )  bash container_init.sh  scala;;
    * ) echo "fist arg is start or restartor init" 
        exit ;;
esac

