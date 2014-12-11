0. put raw data into hdfs

1. hbase shell ./hbase_table_create_cyy.txt

//load data from hdfs into hbase
2. pig BP/request_product_daily-v2.pig
3. pig BP/request_domains_daily-v2.pig

4. cyyRunElapsedTime.sh
