%declare stime $time_start

dataLoader = LOAD '/user/hdfs/ReddoorExportDb002' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Name:chararray);

calculateDiffDay = FOREACH dataLoader {
	splitDumpTime = STRSPLIT(DumpTime, ' ');
	DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
	EndDateInDateTime = ToDate('2014-11-30', 'yyyy-MM-dd');
	diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
	GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, Name, DumpDateInDateTime as Date, diffDay as Diffday;
}

dateFilterResult_1 = filter calculateDiffDay by Diffday <= (long)30 and Diffday >=0;
dateFilterResult_1 = FOREACH dateFilterResult_1 GENERATE * AS (UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Name:chararray, Date:datetime, DiffDay:chararray);

regenData = foreach dateFilterResult_1 generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name;
specialDomain_2 = FILTER regenData BY (DomainName matches '.*www.bnext.com.tw.*');
specialDomain_2 = FOREACH specialDomain_2 GENERATE * AS (UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray, Name:chararray);

groupCountingData = group specialDomain_2 by UniqueId;
calucateCount = foreach groupCountingData generate $0 as UniqueId, COUNT ($1) as cunt;
countingFilterResult_3 = filter calucateCount by cunt > (long)2;
countingFilterResult_3 = FOREACH countingFilterResult_3 GENERATE * AS (UniqueId:chararray, Visited:long);

calculateDiffDay = FOREACH dataLoader {
	splitDumpTime = STRSPLIT(DumpTime, ' ');
	DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
	EndDateInDateTime = ToDate('2014-11-30', 'yyyy-MM-dd');
	diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
	GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, Name, DumpDateInDateTime as Date, diffDay as Diffday;
}

dateFilterResult_4 = filter calculateDiffDay by Diffday <= (long)30 and Diffday >=0;
dateFilterResult_4 = FOREACH dateFilterResult_4 GENERATE * AS (UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Name:chararray, Date:datetime, DiffDay:chararray);

regenData = foreach dateFilterResult_4 generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name;
fittedObjectName_5 = FILTER regenData BY (Name matches '.*iPhone.*');
fittedObjectName_5 = FOREACH fittedObjectName_5 GENERATE * AS (UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray, Name:chararray);

groupCountingData = group fittedObjectName_5 by UniqueId;
calucateCount = foreach groupCountingData generate $0 as UniqueId, COUNT ($1) as cunt;
countingFilterResult_6 = filter calucateCount by cunt > (long)2;
countingFilterResult_6 = FOREACH countingFilterResult_6 GENERATE * AS (UniqueId:chararray, Visited:long);

JoinResult_7 = JOIN countingFilterResult_3 BY UniqueId, countingFilterResult_6 BY UniqueId;


JoinResult_7 = FOREACH JoinResult_7 GENERATE * AS (CountFilter_3::UniqueId:chararray, CountFilter_3::Visited:long, CountFilter_6::UniqueId:chararray, CountFilter_6::Visited:long);
JoinResult_7 = FOREACH JoinResult_7 GENERATE CountFilter_3::UniqueId AS UniqueId,CountFilter_3::Visited, CountFilter_6::Visited;
concatLabel = foreach JoinResult_7 generate CONCAT($0, CONCAT('_',(chararray)'$stime')) as key, 'Y';
STORE concatLabel INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:看過iPhone且去過數位時代網站');

concatLabel = foreach JoinResult_7 generate $0;
LOGS_GROUP= GROUP concatLabel ALL;
LOG_COUNT = FOREACH LOGS_GROUP GENERATE CONCAT('看過iPhone且去過數位時代網站', CONCAT('_',(chararray)'$stime')) as key, BagToTuple($1);
STORE LOG_COUNT INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:info1');


