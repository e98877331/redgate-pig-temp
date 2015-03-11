%declare stime $time_start

dataLoader = LOAD '/user/hdfs/ReddoorExportDb002' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, PageTitle:chararray, Sex:chararray, Age:chararray, LiveCity:chararray, ECId:chararray, ProductId:chararray, ECCatalogName:chararray, PGCatalogName:chararray, Name:chararray, Price:chararray, ObjectName:chararray, Brand:chararray, WebName:chararray, WebType:chararray);

calculateDiffDay = FOREACH dataLoader {
	splitDumpTime = STRSPLIT(DumpTime, ' ');
	DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
	EndDateInDateTime = ToDate('2014-11-30', 'yyyy-MM-dd');
	diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
	GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, Name, ObjectName, DumpDateInDateTime as Date, diffDay as Diffday;
}

dateFilterResult_1 = filter calculateDiffDay by Diffday <= (long)30 and Diffday >=0;
dateFilterResult_1 = FOREACH dateFilterResult_1 GENERATE * AS (UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Name:chararray, ObjectName:chararray, Date:datetime, DiffDay:chararray);

regenData = foreach dateFilterResult_1 generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name, ObjectName;
specialDomain_2 = FILTER regenData BY (DomainName matches '.*www.fashionguide.com.tw.*' OR DomainName matches '.*www.urcosme.com.*');
specialDomain_2 = FOREACH specialDomain_2 GENERATE * AS (UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray, Name:chararray, ObjectName:chararray);

groupCountingData = group specialDomain_2 by UniqueId;
calucateCount = foreach groupCountingData generate $0 as UniqueId, COUNT ($1) as cunt;
countingFilterResult_3 = filter calucateCount by cunt > (long)5;
countingFilterResult_3 = FOREACH countingFilterResult_3 GENERATE * AS (UniqueId:chararray, Visited:long);

concatLabel = foreach countingFilterResult_3 generate CONCAT($0, CONCAT('_',(chararray)'$stime')) as key, 'Y';
STORE concatLabel INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:去過美妝社群');

concatLabel = foreach countingFilterResult_3 generate $0;
LOGS_GROUP= GROUP concatLabel ALL;
LOG_COUNT = FOREACH LOGS_GROUP GENERATE CONCAT('去過美妝社群', CONCAT('_',(chararray)'$stime')) as key, BagToTuple($1);
STORE LOG_COUNT INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:info1');


