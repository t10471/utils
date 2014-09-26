#!/bin/bash

case "$1" in
    "start" )  bash container_start.sh  clang c-language clang;;
    "restart" )  bash container_restart.sh  clang c-language clang;;
    "init" )  bash container_init.sh  clang;;
    * ) echo "fist arg is start or restartor init" 
        exit ;;
esac

