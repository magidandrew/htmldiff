#!/bin/bash

on_ctrl_c(){
    echo "exiting and removing tmp files"
    rm -f index1 index2
    exit 0
}
trap on_ctrl_c INT

wget $1 -O index1
grep -v "script" index1 > tmp; mv tmp index1
 
while true; do
    wget $1 -O index2 

    # parses for lines containing script tags
    grep -v "script" index2 > tmp; mv tmp index2

    diff index1 index2
    RETVAL=$?
    if [ $RETVAL -ne 0 ]
    then
        say change detected on $1 
        echo -en "\007" 
    fi

    sleep $[ ( $RANDOM % 5 )  + 1 ]s
done
