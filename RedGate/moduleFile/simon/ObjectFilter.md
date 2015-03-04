@ModuleDescription: filter log data by a given object name
@Module: ObjectFilter
@Parameters: filterString
@DataLoader: None
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, ObjectName
@OutAliase: fittedObjectName
@OutFields: UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray, Name:chararray, ObjectName:chararray

@TemplateCode: 
regenData = foreach $input$ generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId, Name, ObjectName;
fittedObjectName = FILTER regenData BY $filterString; 
