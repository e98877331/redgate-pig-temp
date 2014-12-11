REGISTER /usr/lib/hbase/lib/*.jar;

--- 讀取 RequestDomains 資料 from HDFS
--- request_domains_count = LOAD 'RedGate/request_domains/part-r-00000' AS (key:chararray, UserId:chararray, DumpDate:chararray, DomainName:chararray, ReqCount:long);

--- 讀取 RequestDomains 資料 from HBase
--- request_domains_count = LOAD 'hbase://RequestDomains' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('domains:UserId domains:DumpDate domains:DomainName domains:ReqCount', '-loadKey false') AS (UserId:chararray, DumpDate:chararray, DomainName:chararray, ReqCount:long);

request_domains_count = LOAD 'hbase://RequestDomains' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('domains:UserId domains:DumpDate domains:DomainName domains:ReqCount') AS (UserId:chararray, DumpDate:chararray, DomainName:chararray, ReqCount:long);

--- 取得不重複的 UserId
userid = FOREACH request_domains_count GENERATE UserId;
uniq_userid = DISTINCT userid;

--- 使用 RANK operator 產生 increasing row id, r11 以上限定
ranked_userid = RANK uniq_userid BY UserId;

--- 儲存結果到 HDFS
--- fs -rm -r RedGate/ranked_user;
--- STORE ranked_userid INTO 'RedGate/ranked_user';

--- 建立 HBase 的 table 
--- hbase> create 'RankedUsers', 'users'

--- 儲存結果到 HBase
STORE ranked_userid INTO 'hbase://RankedUsers' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('users:UserId');
