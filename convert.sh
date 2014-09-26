#!/bin/sh

#python  gen_md.py /home/clang/workspace/HeadFistC/pointer/memo.md /var/www/html/memo.html

if [ -z "$1" ] ;then
    echo'need input file'
    exit
else
    in="$1"
fi
if [ -z "$2" ] ;then
    echo'need output file'
    exit
else
    out="$1"
fi

python  gen_md.py $in $out 
