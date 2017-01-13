#!/bin/bash
# find-class.sh

if [ $# -eq 2 ]; then 
    if [ -d $2 ]; then
        for i in $2/*.jar
            do jar -tvf "$i" | grep -Hsi $1 && echo "$i"
        done
    else
        echo "ERROR"
        exit 1
    fi
else
    echo -e "\nUSAGE: find-class.sh <classname> <path_to_lib> \n"
    exit 0
fi

exit 0
