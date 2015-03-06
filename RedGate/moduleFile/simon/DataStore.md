@ModuleDescription: store data into hbase
@Module: DataStore
@Parameters: relabelTitle,labelTitle
@DataLoader: None
@MinInFields: None
@OutAliase: None
@OutFields: None

@TemplateCode:
concatLabel = foreach $input$ generate CONCAT($0, CONCAT('_',(chararray)'$stime')) as key, 'Y';
STORE concatLabel INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('$relabelTitle');

concatLabel = foreach $input$ generate $0;
LOGS_GROUP= GROUP concatLabel ALL;
LOG_COUNT = FOREACH LOGS_GROUP GENERATE CONCAT('$labelTitle', CONCAT('_',(chararray)'$stime')) as key, BagToTuple($1);
STORE LOG_COUNT INTO 'hbase://r1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:info1');
