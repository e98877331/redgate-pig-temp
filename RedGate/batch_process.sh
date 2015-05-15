#!/bin/bash

: << 'END'
END

# #1
time_start_1=$(date "+%s%3N")
./pmfc.py moduleFile/bp/bp1.mdf bp1.pig
pig -f bp1.pig -param time_start=$time_start_1
time_end_1=$(date "+%s%3N")
rm bp1.pig

printf "put 'bp_timestamp', 'bp1_start', 'Time', $time_start_1
put 'bp_timestamp', 'bp1_end', 'Time', $time_end_1
exit" > cmd.txt
hbase shell cmd.txt
rm cmd.txt

# #2
time_start_2=$(date "+%s%3N")
./pmfc.py moduleFile/bp/bp2.mdf bp2.pig
pig -f bp2.pig -param time_start=$time_start_2
time_end_2=$(date "+%s%3N")
rm bp2.pig

printf "put 'bp_timestamp', 'bp2_start', 'Time', $time_start_2
put 'bp_timestamp', 'bp2_end', 'Time', $time_end_2
exit" > cmd.txt
hbase shell cmd.txt
rm cmd.txt

# #3
time_start_3=$(date "+%s%3N")
./pmfc.py moduleFile/bp/bp3.mdf bp3.pig
pig -f bp3.pig -param time_start=$time_start_3
time_end_3=$(date "+%s%3N")
rm bp3.pig

printf "put 'bp_timestamp', 'bp3_start', 'Time', $time_start_3
put 'bp_timestamp', 'bp3_end', 'Time', $time_end_3
exit" > cmd.txt
hbase shell cmd.txt
rm cmd.txt

# #4
time_start_4=$(date "+%s%3N")
./pmfc.py moduleFile/bp/bp4.mdf bp4.pig
pig -f bp4.pig -param time_start=$time_start_4
time_end_4=$(date "+%s%3N")
rm bp4.pig

printf "put 'bp_timestamp', 'bp4_start', 'Time', $time_start_4
put 'bp_timestamp', 'bp4_end', 'Time', $time_end_4
exit" > cmd.txt
hbase shell cmd.txt
rm cmd.txt

# #5
time_start_5=$(date "+%s%3N")
./pmfc.py moduleFile/bp/bp5.mdf bp5.pig
pig -f bp5.pig -param time_start=$time_start_5
time_end_5=$(date "+%s%3N")
rm bp5.pig

printf "put 'bp_timestamp', 'bp5_start', 'Time', $time_start_5
put 'bp_timestamp', 'bp5_end', 'Time', $time_end_5
exit" > cmd.txt
hbase shell cmd.txt
rm cmd.txt

: << 'END'
END

printf "result:
time_start_1: $time_start_1
time_end_1: $time_end_1
time_start_2: $time_start_2
time_end_2: $time_end_2
time_start_3: $time_start_3
time_end_3: $time_end_3
time_start_4: $time_start_4
time_end_4: $time_end_4
time_start_5: $time_start_5
time_end_5: $time_end_5
" >> moduleFile/bp/bp_log.txt
