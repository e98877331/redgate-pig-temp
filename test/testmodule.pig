REGISTER /usr/lib/hbase/lib/*.jar;
/**/

-- loader
dataLoader = LOAD '/user/hdfs/BarReqLog2013Q4New' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray);

-- filter by domain
regenData = foreach dataLoader generate UniqueId, DomainName;
specialDomain = FILTER regenData BY $filterString;

-- filter by frequency
regenDataCount = GROUP specialDomain BY (UniqueId, DomainName) as domains
regenDataCount = FOREACH regenDataCount generate UniqueId as uiqueId, COUNT(domains) as count
regenDataCount = filter regenDataCount By count > 4

-- store
STORE regenDataCount

-- loader INTO .......
