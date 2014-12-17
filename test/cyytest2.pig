
REGISTER /usr/lib/hbase/lib/*.jar;
/*
*/



--loading B
BResult = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);

BResult = filter BResult BY ReqSum > 15;
BResult = ORDER BResult By ReqSum;



--loading C

CResult = Load 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
CResult = filter CResult BY ReqSum > 20;
CResult = ORDER CResult By ReqSum;



Result = JOIN BResult BY UserId, CResult By UserId;

--DUMP A1Order;
/*
DUMP BResult;
DESCRIBE BResult;
DUMP CResult;
DESCRIBE CResult;
DUMP DResult;
DESCRIBE DResult;
*/
Dump Result;
DESCRIBE Result;

