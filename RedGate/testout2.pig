REGISTER /usr/lib/hbase/lib/*.jar;
/**/
dataLoader = LOAD '/user/hdfs/BarReqLog2013Q4New' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray);

calculateDiffDay = FOREACH dataLoader {
 splitDumpTime = STRSPLIT(DumpTime, ' ');
 DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
 EndDateInDateTime = ToDate('2013-10-03', 'yyyy-MM-dd');
 diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
 GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, DumpDateInDateTime as Date, diffDay as Diffday;
}
dateFilterResult_0 = filter calculateDiffDay by Diffday <= (long)3 and Diffday >=0;
dateFilterResult_0 = FOREACH dateFilterResult_0 GENERATE * AS (UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Date:datetime, DiffDay:chararray);

regenData = foreach dateFilterResult_0 generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId;
specialDomain_1 = FILTER regenData BY (DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*');
specialDomain_1 = FOREACH specialDomain_1 GENERATE * AS (UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray);

calculateDiffDay = FOREACH dataLoader {
 splitDumpTime = STRSPLIT(DumpTime, ' ');
 DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
 EndDateInDateTime = ToDate('2013-09-28', 'yyyy-MM-dd');
 diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
 GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, DumpDateInDateTime as Date, diffDay as Diffday;
}
dateFilterResult_2 = filter calculateDiffDay by Diffday <= (long)3 and Diffday >=0;
dateFilterResult_2 = FOREACH dateFilterResult_2 GENERATE * AS (UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Date:datetime, DiffDay:chararray);

regenData = foreach dateFilterResult_2 generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId;
specialDomain_3 = FILTER regenData BY (DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*');
specialDomain_3 = FOREACH specialDomain_3 GENERATE * AS (UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray);

JoinResult_4 = JOIN specialDomain_1 BY UniqueId, specialDomain_3 BY UniqueId;


JoinResult_4 = FOREACH JoinResult_4 GENERATE * AS (DomainFilter_1::UniqueId:chararray, DomainFilter_1::DomainName:chararray, DomainFilter_1::IPAddress:chararray, DomainFilter_1::DumpTime:chararray, DomainFilter_1::Referer:chararray, DomainFilter_1::ECId:chararray, DomainFilter_1::ProductId:chararray, DomainFilter_3::UniqueId:chararray, DomainFilter_3::DomainName:chararray, DomainFilter_3::IPAddress:chararray, DomainFilter_3::DumpTime:chararray, DomainFilter_3::Referer:chararray, DomainFilter_3::ECId:chararray, DomainFilter_3::ProductId:chararray);
calculateDiffDay = FOREACH dataLoader {
 splitDumpTime = STRSPLIT(DumpTime, ' ');
 DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
 EndDateInDateTime = ToDate('2013-09-28', 'yyyy-MM-dd');
 diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
 GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, DumpDateInDateTime as Date, diffDay as Diffday;
}
dateFilterResult_4 = filter calculateDiffDay by Diffday <= (long)3 and Diffday >=0;
dateFilterResult_4 = FOREACH dateFilterResult_4 GENERATE * AS (UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Date:datetime, DiffDay:chararray);

regenData = foreach dateFilterResult_4 generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId;
specialDomain_5 = FILTER regenData BY (DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*');
specialDomain_5 = FOREACH specialDomain_5 GENERATE * AS (UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray);

JoinResult_6 = JOIN JoinResult_4 BY DomainFilter_1::UniqueId, specialDomain_5 BY UniqueId;


JoinResult_6 = FOREACH JoinResult_6 GENERATE * AS (DomainFilter_1::UniqueId:chararray, DomainFilter_1::DomainName:chararray, DomainFilter_1::IPAddress:chararray, DomainFilter_1::DumpTime:chararray, DomainFilter_1::Referer:chararray, DomainFilter_1::ECId:chararray, DomainFilter_1::ProductId:chararray, DomainFilter_3::UniqueId:chararray, DomainFilter_3::DomainName:chararray, DomainFilter_3::IPAddress:chararray, DomainFilter_3::DumpTime:chararray, DomainFilter_3::Referer:chararray, DomainFilter_3::ECId:chararray, DomainFilter_3::ProductId:chararray, DomainFilter_5::UniqueId:chararray, DomainFilter_5::DomainName:chararray, DomainFilter_5::IPAddress:chararray, DomainFilter_5::DumpTime:chararray, DomainFilter_5::Referer:chararray, DomainFilter_5::ECId:chararray, DomainFilter_5::ProductId:chararray);

DUMP JoinResult_6;
DESCRIBE JoinResult_6;

