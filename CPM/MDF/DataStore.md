
%default relabelTitle 'cf:比價狂'
%default labelTitle '比價狂'

@ModuleDescription: store data into hbase
@Module: DataStore
@Parameters: relabelTitle,labelTitle
@DataLoader: None
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId
@OutAliase: specialDomain
@OutFields: UniqueId:chararray, DomainName:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, ECId:chararray, ProductId:chararray

groupCountingData = group filteredData by UniqueId;
emitData = foreach groupCountingData generate $0, COUNT(uid);

concatLabel = foreach emitData generate $0, 'Y';
STORE concatLabel INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage($relabelTitle);


LOGS_GROUP= GROUP emitData ALL;
LOG_COUNT = FOREACH LOGS_GROUP GENERATE $labelTitle, BagToTuple($1);
STORE LOG_COUNT INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:info1');
--dump LOG_COUNT;
