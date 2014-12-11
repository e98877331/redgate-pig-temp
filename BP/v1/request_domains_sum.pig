REGISTER /usr/lib/hbase/lib/*.jar;

--- 讀取 RequestDomains 資料 from HDFS
--- request_domains_count = LOAD 'RedGate/request_domains/part-r-00000' AS (key:chararray, UserId:chararray, DumpDate:chararray, DomainName:chararray, ReqCount:long);

--- 讀取 RequestDomains 資料 from HBase
--- request_domains_count = LOAD 'hbase://RequestDomains' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('domains:UserId domains:DumpDate domains:DomainName domains:ReqCount', '-loadKey false') AS (UserId:chararray, DumpDate:chararray, DomainName:chararray, ReqCount:long);

request_domains_count = LOAD 'hbase://RequestDomains' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('domains:UserId domains:DumpDate domains:DomainName domains:ReqCount') AS (UserId:chararray, DumpDate:chararray, DomainName:chararray, ReqCount:long);

--- 按照 UserId 和 DomainName 做群組分類
group_by_user_domain = GROUP request_domains_count BY (UserId, DomainName);

--- 計算 DomainName 的造訪次數
request_domains_sum = FOREACH group_by_user_domain GENERATE CONCAT(CONCAT(group.UserId, '_'), group.DomainName) AS key:chararray, group.UserId, group.DomainName, SUM(request_domains_count.ReqCount) as ReqSum;

--- 儲存結果到 HDFS
--- fs -rm -r RedGate/request_domains_sum;
--- STORE request_domains_sum INTO 'RedGate/request_domains_sum';

--- 建立 HBase 的 table 
--- hbase> create 'RequestDomainsSum', 'domains'

--- 儲存結果到 HBase
STORE request_domains_sum INTO 'hbase://RequestDomainsSum' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('domains:UserId domains:DomainName domains:ReqSum');
