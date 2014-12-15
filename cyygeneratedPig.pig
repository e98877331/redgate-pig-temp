
A1Result = LOAD 'hbase://RequestTagUser' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:ECId summary:ProductCategory summary:ProductId summary:ProductName summary:Score summary:UserId', '-gte=48_1025339 -lte=48_1025340') AS (ECId:chararray, ProductCategory:chararray, ProductId:chararray, ProductName:chararray, score:int, UserId:chararray);

A1Group = GROUP A1Result By (ECId, ProductId,ProductName);

A1GroupCount = FOREACH A1Group GENERATE group as grp,A1Result.(UserId,score), COUNT(A1Result) as userCount;

A1GroupCount = FILTER A1GroupCount BY userCount >200;

A1Order = ORDER A1GroupCount BY userCount;
    
BResult = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);

BResult = filter BResult BY ReqSum > 15;
BResult = ORDER BResult By ReqSum;
    
CResult = Load 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
CResult = filter CResult BY ReqSum > 20;
CResult = ORDER CResult By ReqSum;
    
A1BResult = JOIN BResult BY UserId, CResult By UserId;
DUMP A1BResult;
