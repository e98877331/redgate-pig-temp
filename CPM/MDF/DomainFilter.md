%default filterString '(DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*')'
@ModuleDescription: filter log data by domain name

@Module: DomainFilter
@Parameters: filterString
@DataLoader: None
@InAliase: $input
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId
@OutAliase: specialDomain
@OutFields: UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray

regenData = foreach $input generate UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId;
specialDomain = FILTER regenData BY $filterString; 
