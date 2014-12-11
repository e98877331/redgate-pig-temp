REGISTER /usr/lib/hbase/lib/*.jar;

--- 讀取 SampleRedGateReqNew 資料
logs = LOAD '/user/hdfs/BarReqLog2013Q4New/part-m-*' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray); 

--- logs = LOAD 'SampleRedGateProductNew_v2/part-r-00000' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray);

--- 濾掉 null (UniqueId, DomainName, DumpTime, ECId, ProductId)
logs_without_null = FILTER logs BY UniqueId is not null AND DomainName is not null AND DumpTime is not null AND UniqueId != 'null' AND DomainName != 'null' AND DumpTime != 'null';

--- 取出要使用的欄位, DumpTime 的部份只留「月日年」
logs_with_relevant_fields = FOREACH logs_without_null GENERATE UniqueId AS UserId, DomainName, SUBSTRING(DumpTime, 0, 10) AS DumpDate;

--- 因為原始資料 DumpTime (DumpDate) 會有非預期的日期格式，所以先濾掉
logs_with_right_data = FILTER logs_with_relevant_fields BY DumpDate MATCHES '\\d\\d\\d\\d-\\d\\d-\\d\\d';

--- 按照 UserId, DumpDate 和 DomainName 做群組分類
grp = GROUP logs_with_right_data BY (UserId, DumpDate, DomainName);

--- 計算 DomainName 的造訪次數
request_domains_count = FOREACH grp GENERATE CONCAT(CONCAT(CONCAT(CONCAT(group.DumpDate, '_'), group.UserId), '_'), group.DomainName) AS key:chararray, group.DumpDate, group.UserId, group.DomainName, COUNT(logs_with_right_data) AS ReqCount:long;

--- 儲存結果到 HDFS
--- fs -rm -r RedGate/request_domains;
--- STORE request_domains_count INTO 'RedGate/request_domains';

--- 建立 HBase 的 table 
--- hbase> create 'RequestDomains', 'domains'

--- 儲存結果到 HBase
STORE request_domains_count INTO 'hbase://RequestDomains' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('domains:DumpDate domains:UserId domains:DomainName domains:ReqCount');
