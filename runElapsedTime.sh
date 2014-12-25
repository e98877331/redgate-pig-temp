
#!/bin/bash

# Get time as a UNIX timestamp (seconds elapsed since Jan 1, 1970 0:00 UTC)
truncate_time="$(date +%s)"
hbase shell ./hbase_table_truncate.sh
truncate_time="$(($(date +%s)-truncate_time))"
echo "Time in seconds: ${truncate_time}"

a1_time="$(date +%s)"
pig ./cyypig.pig
a1_time="$(($(date +%s)-a1_time))"
echo "Time in seconds: ${a1_time}"

bdc_time="$(date +%s)"
pig ./pig_bcd_bc.txt
bdc_time="$(($(date +%s)-bdc_time))"
echo "Time in seconds: ${bdc_time}"

e_time="$(date +%s)"
pig ./children_buyer.pig
e_time="$(($(date +%s)-e_time))"
echo "Time in seconds: ${e_time}"


printf "Truncate_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((truncate_time/86400))" "$((truncate_time/3600%24))" "$((truncate_time/60%60))" "$((truncate_time%60))"

printf "A1_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((a1_time/86400))" "$((a1_time/3600%24))" "$((a1_time/60%60))" "$((a1_time%60))"

printf "BCD_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((bdc_time/86400))" "$((bdc_time/3600%24))" "$((bdc_time/60%60))" "$((bdc_time%60))"

printf "E_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((e_time/86400))" "$((e_time/3600%24))" "$((e_time/60%60))" "$((e_time%60))"

