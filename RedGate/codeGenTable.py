codeGenTable = {
    'A1':
    """
    A1Result = LOAD 'hbase://RequestTagUser' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:ECId summary:ProductCategory summary:ProductId summary:ProductName summary:Score summary:UserId', '-gte=$startRow -lte=$endRow') AS (ECId:chararray, ProductCategory:chararray, ProductId:chararray, ProductName:chararray, score:int, UserId:chararray);

    A1Group = GROUP A1Result By (ECId, ProductId,ProductName);

    A1GroupCount = FOREACH A1Group GENERATE group as grp,A1Result.(UserId,score), COUNT(A1Result) as userCount;

    A1GroupCount = FILTER A1GroupCount BY userCount >200;

    A1Order = ORDER A1GroupCount BY userCount;
    """
    ,
    'B':
    """
    BResult = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);

    BResult = filter BResult BY ReqSum > $minReqSum;
    BResult = ORDER BResult By ReqSum;
    """
    ,
    'C':
    """
    CResult = Load 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
    CResult = filter CResult BY ReqSum > $minReqSum;
    CResult = ORDER CResult By ReqSum;
    """
    ,
    'D':
    """
    DResult = Load 'hbase://RequestCosmetics' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
    DResult = filter DResult BY ReqSum > $minReqSum;
    DResult = ORDER DResult By ReqSum;
    """
}
