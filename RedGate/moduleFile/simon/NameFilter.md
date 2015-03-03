@ModuleDescription: filter log data by a given name
@Module: NameFilter
@Parameters: filterString
@DataLoader: None
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name
@OutAliase: fittedObjectName
@OutFields: UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray, Name:chararray

@TemplateCode: 
regenData = foreach $input$ generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name;
fittedObjectName = FILTER regenData BY $filterString; 
