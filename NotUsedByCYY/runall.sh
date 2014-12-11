#!/bin/bash

date1=$(date "+%T")

hbase shell ./hbase_table_truncate.sh

date2=$(date "+%T")
 
pig ./cyypig.pig

date3=$(date "+%T")

pig ./pig_bcd_bc.txt

date4=$(date "+%T")

pig ./children_buyer.pig

date5=$(date "+%T")

#date6=$(date "+%T")

#date7=$(date "+%T")

echo "===== report ====="
echo "start time, truncate table : $date1"
echo "a1 : $date2"
echo "b+c+d+bc : $date3"
echo "e : $date4"
echo "finished time : $date5"
#echo "BCD start time : $date6"
#echo "BCD finish time : $date7"

exit 0
