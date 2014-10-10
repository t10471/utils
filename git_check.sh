#!/bin/bash

find /home/ -path "*/.vim" -prune -o -path "*/tmp" -prune -o -path "*/reps" -prune -o -name ".git" -print | while read i; do
PWD="${i}/../"
cd $PWD
RESULT=$(git status)
RESULT=$(echo $RESULT)
RESULT=${RESULT/Your branch is up-to-date with \'origin\/master\'\. /}
if [[ "$RESULT" != "On branch master nothing to commit, working directory clean" ]]; then
    pwd
    #echo $RESULT
fi

done

