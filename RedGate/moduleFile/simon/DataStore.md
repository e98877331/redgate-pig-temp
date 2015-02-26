@ModuleDescription: store data into hbase
@Module: DataStore
@Parameters: relabelTitle,labelTitle
@DataLoader: None
@MinInFields: UniqueId, DomainName, IPAddress, DumpTime, Referer, ECId, ProductId
@OutAliase: None
@OutFields: None

@TemplateCode:
concatLabel = foreach $input$ generate $0, 'Y';
STORE concatLabel INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage($relabelTitle);

concatLabel = foreach $input$ generate $0;
LOGS_GROUP= GROUP concatLabel ALL;
LOG_COUNT = FOREACH LOGS_GROUP GENERATE '$labelTitle', BagToTuple($1);
STORE LOG_COUNT INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:info1');
