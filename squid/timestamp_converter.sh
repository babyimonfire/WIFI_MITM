#!/bin/bash

#convert the timestamp of squid log file to time 

line_num=`cat 10_28-30_url.log|wc -l`
count=1
while [ $count -le $line_num ]
do
        #getline from file 10_28-30_url.log
        line_str=`sed -n $count'p' 10_28-30_url.log`
        #get timestamp from line
        time_stamp=`echo $line_str|awk -F. '{print $1}'`
        #convert timestamp to time
        time_date=`date -d "1970-01-01 UTC $time_stamp seconds" "+%F %T"`
        #echo $time_stamp,$time_date
        #save each altered line to another file 10_28-30_time.log
        echo $line_str|sed -n "s/$time_stamp/$time_date/p" >> 10_28-30_time.log
        #next line
        count=$[$count+1]
done
