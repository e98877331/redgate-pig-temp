@Module: DataLoader
@Parameters: dataPath
@DataLoader: None
@MinInFields: None
@OutAliase: dataLoader
@OutFields: LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, PageTitle:chararray, Sex:chararray, Age:chararray, LiveCity:chararray, ECId:chararray, ProductId:chararray, ECCatalogName:chararray, PGCatalogName:chararray, Name:chararray, Price:chararray, ObjectName:chararray, Brand:chararray, WebName:chararray, WebType:chararray
@TemplateCode: dataLoader = LOAD '$dataPath' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, PageTitle:chararray, Sex:chararray, Age:chararray, LiveCity:chararray, ECId:chararray, ProductId:chararray, ECCatalogName:chararray, PGCatalogName:chararray, Name:chararray, Price:chararray, ObjectName:chararray, Brand:chararray, WebName:chararray, WebType:chararray);
