--- 讀取 SampleRedGateReq 資料
logs = LOAD 'BarReqLog2013Q4/part-m-*' USING PigStorage(',') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray); 

--- 取出要使用的欄位, DumpTime 的部份只留「月日年」
logs_with_relevant_fields = FOREACH logs GENERATE UniqueId AS UserId, DomainName, SUBSTRING(DumpTime, 0, 10) AS DumpDate;

--- Find out null fields 
UserId_is_null = FILTER logs_with_relevant_fields BY UserId is null;
DomainName_is_null = FILTER logs_with_relevant_fields BY DomainName is null;
DumpDate_is_null = FILTER logs_with_relevant_fields BY DumpDate is null;

--- STORE to HDFS
STORE UserId_is_null INTO 'RedGate/NullUserId';
STORE DomainName_is_null INTO 'RedGate/NullDomainName';
STORE DumpDate_is_null INTO 'RedGate/NullDumpDate';
