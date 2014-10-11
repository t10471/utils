#!/bin/bash

is_valid_args() {
    if [ "${#2}" -eq 0 ] ;then
        echo "$1"
        kill -14 "$$"
    fi
    return 0 
}

exists_in() {
    local FLG=true
    local arrayname=$1
    eval ref=\"\${$arrayname[@]}\"
    local list=( ${ref} )
    for a in "${list[@]}"; do
        if [ "$a" == "$2" ]; then
            FLG=false
            break
        fi
    done
    if $FLG ; then
        echo "$2 is not exist"
        kill -14 "$$"
    fi
    return 0
}

