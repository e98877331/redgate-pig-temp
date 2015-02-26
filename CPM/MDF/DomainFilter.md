%default filterString '(DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*')'
@ModuleDescription: filter log data by domain name

@Module: DomainFilter
@Parameters: filterString
@DataLoader: None
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId
@OutAliase: specialDomain
@OutFields: UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray

@TemplateCode: 
regenData = foreach $input$ generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId;
specialDomain = FILTER regenData BY $filterString; 
