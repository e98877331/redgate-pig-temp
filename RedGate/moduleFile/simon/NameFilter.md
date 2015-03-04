@ModuleDescription: filter log data by a given name
@Module: NameFilter
@Parameters: filterString
@DataLoader: None
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name
@OutAliase: fittedName
@OutFields: UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray, PGCatalogName:chararray, Name:chararray, ObjectName:chararray

@TemplateCode: 
regenData = foreach $input$ generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, PGCatalogName, Name, ObjectName;
fittedName = FILTER regenData BY $filterString; 
