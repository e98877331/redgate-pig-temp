
#!/bin/bash

# Get time as a UNIX timestamp (seconds elapsed since Jan 1, 1970 0:00 UTC)
truncate_time="$(date +%s)"
hbase shell ./cyy_truncate.sh
truncate_time="$(($(date +%s)-truncate_time))"
echo "Time in seconds: ${truncate_time}"


product_daily_time="$(date +%s)"
pig ./BP/request_product_daily-v2.pig
product_daily_time="$(($(date +%s)-product_daily_time))"

domains_daily_time="$(date +%s)"
pig ./BP/request_domains_daily-v2.pig
domains_daily_time="$(($(date +%s)-domains_daily_time))"



a1_time="$(date +%s)"
pig ./cyypigA1FromHbase.pig
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

printf "Product_daily_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((product_daily_time/86400))" "$((product_daily_time/3600%24))" "$((product_daily_time/60%60))" "$((product_daily_time%60))"
printf "Domains_daily_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((domains_daily_time/86400))" "$((domains_daily_time/3600%24))" "$((domains_daily_time/60%60))" "$((domains_daily_time%60))"



printf "A1_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((a1_time/86400))" "$((a1_time/3600%24))" "$((a1_time/60%60))" "$((a1_time%60))"

printf "BCD_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((bdc_time/86400))" "$((bdc_time/3600%24))" "$((bdc_time/60%60))" "$((bdc_time%60))"

printf "E_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((e_time/86400))" "$((e_time/3600%24))" "$((e_time/60%60))" "$((e_time%60))"



echo -e "Truncate_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((truncate_time/86400))" "$((truncate_time/3600%24))" "$((truncate_time/60%60))" "$((truncate_time%60))" >> cyyRunElapsedTimeLog.txt

echo -e "Product_daily_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((product_daily_time/86400))" "$((product_daily_time/3600%24))" "$((product_daily_time/60%60))" "$((product_daily_time%60))" >> cyyRunElapsedTimeLog.txt
echo -e "Domains_daily_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((domains_daily_time/86400))" "$((domains_daily_time/3600%24))" "$((domains_daily_time/60%60))" "$((domains_daily_time%60))" >> cyyRunElapsedTimeLog.txt



echo -e "A1_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((a1_time/86400))" "$((a1_time/3600%24))" "$((a1_time/60%60))" "$((a1_time%60))" >> cyyRunElapsedTimeLog.txt

echo -e "BCD_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((bdc_time/86400))" "$((bdc_time/3600%24))" "$((bdc_time/60%60))" "$((bdc_time%60))" >> cyyRunElapsedTimeLog.txt

echo -e "E_ElapsedTime: %02d:%02d:%02d:%02d\n" "$((e_time/86400))" "$((e_time/3600%24))" "$((e_time/60%60))" "$((e_time%60))" >> cyyRunElapsedTimeLog.txt
