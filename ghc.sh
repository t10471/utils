#!/bin/bash

case "$1" in
    "start" )  bash container_start.sh  ghc haskell haskell;;
    "restart" )  bash container_restart.sh ghc haskell haskell;;
    "init" )  bash container_init.sh  ghc;;
    * ) echo "fist arg is start or restartor init" 
        exit ;;
esac

