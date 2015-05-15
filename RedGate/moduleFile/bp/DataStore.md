@ModuleDescription: store data into hbase
@Module: DataStore
@Parameters: columnFamily
@DataLoader: None
@MinInFields: None
@OutAliase: None
@OutFields: None

@TemplateCode:
store $input$ into 'hbase://mdays' using org.apache.pig.backend.hadoop.hbase.HBaseStorage('$columnFamily');
