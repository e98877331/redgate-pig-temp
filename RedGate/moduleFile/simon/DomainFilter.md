@ModuleDescription: filter log data by domain name
@Module: DomainFilter
@Parameters: filterString
@DataLoader: None
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name
@OutAliase: specialDomain
@OutFields: UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray, PGCatalogName:chararray, Name:chararray, ObjectName:chararray

@TemplateCode: 
regenData = foreach $input$ generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, PGCatalogName, Name, ObjectName;
specialDomain = FILTER regenData BY $filterString; 
