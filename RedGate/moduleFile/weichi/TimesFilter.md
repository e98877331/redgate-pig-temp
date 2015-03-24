@ModuleDescription: filter log data by a given times
@Module: TimesFilter
@Parameters: StartTime, EndTime
@DataLoader: None
@MinInFields: DumpTime, UniqueId, IPAddress
@OutAliase: fittedDateSet
@OutFields: LogId, UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, PageTitle, Sex, Age, LiveCity, ECId, ProductId, ECCatalogName, PGCatalogName, Name, Price, ObjectName, Brand, WebName, WebType

@TemplateCode: 
reFormData = foreach $input$ generate ToDate(DumpTime, 'yyyy-MM-dd HH:mm:ss.SSS') as date,
LogId, UniqueId, DomainName, Url, IPAddress, DumpTime, Referer, SessionId, PageTitle, Sex, Age, LiveCity,
ECId, ProductId, ECCatalogName, PGCatalogName, Name, Price, ObjectName, Brand, WebName, WebType;
fittedData = filter reFormData by GetHour(date) >= $StartTime OR GetHour(date) < $EndTime;
fittedDateSet = FOREACH fittedData {
        GENERATE $1 ..;
}
