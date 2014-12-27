@Module:
B

@OutAliase:
BResult

@OutFields:
UserId:chararray, ReqSum:int

@TemplateCode:
BResult = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
BResult = filter BResult BY ReqSum > $minReqSum;
BResult = ORDER BResult By ReqSum;




