
%default diff '3';
%default EndDate '2014-11-05';
@ModuleDescription: filter log data by a given days

@Module: DaysFilter
@Parameters: diff, EndDate
@DataLoader: None
@InAliase: $dataLoader
@MinInFields: None
@OutAliase: dateFilterResult
@OutFields: UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray, Date:datetime, DiffDay:chararray

@TemplateCode: 
calculateDiffDay = FOREACH $dataLoader {
	splitDumpTime = STRSPLIT(DumpTime, ' ');
	DumpDateInDateTime = ToDate(splitDumpTime.$0, 'yyyy-MM-dd');
	EndDateInDateTime = ToDate('$EndDate', 'yyyy-MM-dd');
	diffDay = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
	GENERATE UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, ECId, ProductId, DumpDateInDateTime as Date, diffDay as Diffday;
}

dateFilterResult = filter calculateDiffDay by Diffday <= (long)$diff and Diffday >=0;

