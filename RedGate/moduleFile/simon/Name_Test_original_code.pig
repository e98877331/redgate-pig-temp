
register /usr/hdp/2.2.0.0-2041/pig/*.jar;
DEFINE BagToString org.apache.pig.builtin.BagToString();

-- data loader --
dataLoader = LOAD 'ReddoorExport201411' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, PageTitle:chararray, Sex:chararray, Age:chararray, LiveCity:chararray, ECId:chararray, ProductId:chararray, ECCatalogName:chararray, PGCatalogName:chararray, Name:chararray, Price:chararray, ObjectName:chararray, Brand:chararray); 


%default diff '30';
%default EndDate '2014-11-30';

calculateDiffDay = FOREACH dataLoader {
	splitDumpTime = STRSPLIT(DumpTime, ' ');
	DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
	EndDateInDateTime = ToDate('$EndDate', 'yyyy-MM-dd');
	diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
	GENERATE UniqueId, DomainName, Url, DumpTime, Name, DumpDateInDateTime as Date, diffDay as Diffday;
}

dateFilterResult = filter calculateDiffDay by Diffday <= (long)$diff and Diffday >=0;

regenData = foreach dateFilterResult generate UniqueId, DomainName, DumpTime, Name, Diffday;
specialDomain = FILTER regenData BY (Name matches '.*iPhone.*'); 


%default count '1';

groupCountingData = group specialDomain by UniqueId;
calucateCount = foreach groupCountingData generate $0 as UniqueId, COUNT ($1) as cunt;
countingFilterResult = filter calucateCount by cunt > (long)$count;

-- keeping user log history
--pickupResult = JOIN groupCountingData by $0, countingFilterResult by UniqueId;

%default relabelTitle 'cf:看過iPhone';
%default labelTitle '看過iPhone';

-- attaching user label
concatLabel = foreach countingFilterResult generate $0, 'Y';
STORE concatLabel INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('$relabelTitle');

concatLabel = foreach countingFilterResult generate $0;
LOGS_GROUP= GROUP concatLabel ALL;
LOG_COUNT = FOREACH LOGS_GROUP GENERATE '$labelTitle', BagToTuple($1);
STORE LOG_COUNT INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:info1');
--dump LOG_COUNT;



--orderedResult = order countingFilterResult by Diffday;

--fs -rm -r test;
--STORE pickupResult INTO 'test' using PigStorage('\u0001');
