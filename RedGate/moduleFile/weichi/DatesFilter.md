@ModuleDescription: filter log data by a given dates
@Module: DatesFilter
@Parameters: StartDate, EndDate
@DataLoader: None
@MinInFields: DumpTime, UniqueId, IPAddress
@OutAliase: fittedDateSet
@OutFields: LogId, UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, PageTitle, Sex, Age, LiveCity, ECId, ProductId, ECCatalogName, PGCatalogName, Name, Price, ObjectName, Brand, WebName, WebType

@TemplateCode: 
reFormData = foreach dataLoader generate ToDate(DumpTime, 'yyyy-MM-dd HH:mm:ss.SSS') as date,
LogId, UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, PageTitle, Sex, Age, LiveCity, 
ECId, ProductId, ECCatalogName, PGCatalogName, Name, Price, ObjectName, Brand, WebName, WebType;
fittedData = filter reFormData by date >= ToDate('$StartDate', 'yyyy-MM-dd') AND date < ToDate('$EndDate', 'yyyy-MM-dd');
fittedDateSet = FOREACH fittedData {
	GENERATE $1 ..;
}
