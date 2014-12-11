

# HDFS only
hadoop jar redgate.jar a100.redgate.BatchV2_HDFS -D mapreduce.job.reduces=4 -D redgate.table=RequestDomains_Tmp  "/user/hadoop/BarReqLog2013Q4New/part-m-00000,/user/hadoop/BarReqLog2013Q4New/part-m-00001,/user/hadoop/BarReqLog2013Q4New/part-m-00002,/user/hadoop/BarReqLog2013Q4New/part-m-00003"  /user/hadoop/test

# HBase :   create 'RequestDomains_Tmp', 'domains'
hadoop jar redgate.jar a100.redgate.BatchV2 -D mapreduce.job.reduces=4 -D redgate.table=RequestDomains_Tmp  "/user/hadoop/BarReqLog2013Q4New/part-m-00000,/user/hadoop/BarReqLog2013Q4New/part-m-00001,/user/hadoop/BarReqLog2013Q4New/part-m-00002,/user/hadoop/BarReqLog2013Q4New/part-m-00003"  /user/hadoop/test
