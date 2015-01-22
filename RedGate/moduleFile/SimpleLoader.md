@Module:
SimpleLoader

@OutAliase:
SimpleLoaderOut

@OutFields:
UserId:chararray, ReqSum:int

@TemplateCode:
SimpleLoaderOut = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);




