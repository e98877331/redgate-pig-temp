
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
	GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, DumpDateInDateTime as Date, diffDay as Diffday;
}

dateFilterResult = filter calculateDiffDay by Diffday <= (long)$diff and Diffday >=0;

regenData = foreach dateFilterResult generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Diffday;
specialDomain = FILTER regenData BY (DomainName matches '.*buy.yahoo.*' OR DomainName matches '.*ezprice.*'); 


%default count '2';

  = group specialDomain by UniqueId;
calucateCount = foreach groupCountingData generate $0 as UniqueId, COUNT ($1) as cunt;
countingFilterResult = filter calucateCount by cunt > (long)$count;

pickupResult = JOIN groupCountingData by $0, countingFilterResult by UniqueId;

orderedResult = order countingFilterResult by Diffday;
11
fs -rm -r test;
STORE orderedResult INTO 'test' using PigStorage('\u0001');
