@Module: CountFilter
@Parameters: count
@DataLoader: None
@MinInFields: None
@OutAliase: countingFilterResult
@OutFields: UniqueId:chararray, Visited:long
@TemplateCode: 
groupCountingData = group $input$ by UniqueId;
calucateCount = foreach groupCountingData generate $0 as UniqueId, COUNT ($1) as cunt;
countingFilterResult = filter calucateCount by cunt > (long)$count;
