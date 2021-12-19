#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############
word=jj
intv=20
# logfile=x_access.log
logfile=/var/log/apache2/x_access.log
dir=/home/al/w/php-sms-sdk/Demo/

sum=$(sudo grep -w $word $logfile | tail -1 | md5sum | awk '{print $1}')

echo $sum

sum0=$(redis-cli get sum0)

if [ "$sum" != "$sum0" ]; then
    echo sum0 updated.
    redis-cli set sum0 $sum

    date=$(date +%s)
    date0=$(redis-cli get date0)
    let diff=date-date0
    # If have NOT sent in 1 hour
    if [ $diff -gt $intv ]; then
        echo date0 updated.
        redis-cli set date0 $date

        # Run php sms code
        echo Run php sms code...
        cd $dir
        php SendTemplateSMS.php
    fi
    echo $diff
fi 
