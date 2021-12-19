#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############
pwd=$(dirname $0)
. $pwd/.env
. $pwd/.env.local

#echo $word
#echo $intv
#echo $logfile
#echo $dir

sum=$(sudo grep -w $word $logfile | tail -1 | md5sum | awk '{print $1}')

# echo $sum

sum0=$(redis-cli get sum0)

if [ "$sum" != "$sum0" ]; then
    echo sum0 updated. New visit.
    redis-cli set sum0 $sum

    date=$(date +%s)
    date0=$(redis-cli get date0)
    let diff=date-date0
    # If have NOT sent in 1 hour
    if [ $diff -gt $intv ]; then
        echo date0 updated.
        redis-cli set date0 $date

        echo Run php sms code...
        cd $dir
        php SendTemplateSMS.php
    fi
    echo $diff
fi 
