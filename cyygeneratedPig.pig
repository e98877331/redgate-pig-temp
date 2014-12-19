REGISTER /usr/lib/hbase/lib/*.jar;
/**/
  A1Result = LOAD 'hbase://RequestTagUser' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:ECId summary:ProductCategory summary:ProductId summary:ProductName summary:Score summary:UserId', '-gte=48_1025339 -lte=48_1025340') AS (ECId:chararray, ProductCategory:chararray, ProductId:chararray, ProductName:chararray, score:int, UserId:chararray);
  
  A1Group = GROUP A1Result By (ECId, ProductId,ProductName);
  
  A1GroupCount = FOREACH A1Group GENERATE group as grp,A1Result.(UserId,score), COUNT(A1Result) as userCount;
  
  A1GroupCount = FILTER A1GroupCount BY userCount >200;
  
  A1Order = ORDER A1GroupCount BY userCount;
      
  BResult = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
  
  BResult = filter BResult BY ReqSum > 15;
  BResult = ORDER BResult By ReqSum;
      
  CResult = Load 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
  CResult = filter CResult BY ReqSum > 15;
  CResult = ORDER CResult By ReqSum;
      Result = A1Result;
Result = JOIN Result BY UserId, BResult BY UserId;
Result = FOREACH Result GENERATE $0, $1, $2, $3, $4, $5, $7;
Result = FOREACH Result GENERATE * AS (A1::ECId:chararray, A1::ProductCategory:chararray, A1::ProductId:chararray, A1::ProductName:chararray, A1::score:int, UserId, B::ReqSum:int);
  DESCRIBE Result;
Result = JOIN Result BY UserId, CResult BY UserId;
  DESCRIBE Result;
Result = FOREACH Result GENERATE $0, $1, $2, $3, $4, $5, $7, $9;
  DESCRIBE Result;
Result = FOREACH Result GENERATE * AS (A1::ECId:chararray, A1::ProductCategory:chararray, A1::ProductId:chararray, A1::ProductName:chararray, A1::score:int, UserId, B::ReqSum:int, C::ReqSum:int);

  DUMP Result;
  DESCRIBE Result;
  
