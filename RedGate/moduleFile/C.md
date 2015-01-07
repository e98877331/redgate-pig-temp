@Module:
C

@OutAliase:
CResult

@OutFields:
UserId:chararray, ReqSum:int

@TemplateCode:
CResult = Load 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
CResult = filter CResult BY ReqSum > $minReqSum;
CResult = ORDER CResult By ReqSum;




