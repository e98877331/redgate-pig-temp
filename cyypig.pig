REGISTER /usr/lib/hbase/lib/*.jar;
/**/

--Load requests
requests = LOAD 'BarReqLog2013Q4New' USING PigStorage('\u0001') as (Id:chararray,UniqueId:chararray,
DomainName:chararray,Url:chararray,IPAddress:chararray,DumpTime:chararray,Referer:chararray,
SessionId:chararray,ECId:chararray,ProductId:chararray);

--Load products
products = LOAD 'Products2013Q4New' USING PigStorage('\u0001') as (ECId:chararray,ProductId:chararray,Name:chararray,
Price:chararray,ImageUrl:chararray,Categories:chararray,Url:chararray);

--preprecessing data start
--filter invalid product id
fRequests = FILTER requests BY ProductId!='null';
--filter invalid DumpTime
fRequests = FILTER fRequests BY (DumpTime!='null' AND DumpTime is not null);

--In order to get product name instead of product id alone, we need to do join.
pr = JOIN fRequests BY ProductId LEFT OUTER, products BY ProductId;

--get requests with product name.  ( ".." means all fields before)
nrequests = FOREACH pr GENERATE .. fRequests::ProductId, products::Name as ProductName, fRequests::ECId as ECId, products::Categories as ProductCategory;

--turns DumpTime string into datetime object
finalRequests = FOREACH nrequests{
    nProductName = ((ProductName is null)?ProductId:ProductName);
    
    DumpTimeInDateTime = ToDate(SUBSTRING(DumpTime,0,19),'yyyy-MM-dd HH:mm:ss');

    GENERATE UniqueId as UserId, DumpTimeInDateTime as DumpTime,
    MilliSecondsBetween(CurrentTime(),DumpTimeInDateTime) as TimeDiff,
    ProductId as ProductId,nProductName as ProductName, ECId, ProductCategory; 
}

--now we have requests with product name here
/*
finalRequests: {UserId: chararray,DumpTime: chararray,ProductId: chararray,ProductName: chararray,ECId: chararray}
*/
%declare faketime '2013-12-16T00:00:00.000-08:00'

validRequests = ORDER finalRequests BY TimeDiff;
--data too old, all more than 30 days, so instead we get date during $faketime and $faketime -30 days 
validRequests = FILTER validRequests BY (DaysBetween(ToDate('$faketime'),DumpTime)<30);


--start to get user bags group by product ID
groupedRequest = GROUP validRequests BY (ProductId, ProductName, UserId, ECId,ProductCategory);

gr = FOREACH groupedRequest GENERATE *, COUNT(validRequests) as count;

gr = ORDER gr BY count;

gr1 = FOREACH gr {
    -- get most recent tuple from bag. TOP(topn, compare column, bag source) <= this way bug bug der ,don't use now
    --temp = TOP(1,3,validRequests);
    
    --temp = FLATTEN(validRequests);
    temp = ORDER validRequests by TimeDiff;
    temp = Limit temp 1;
    

    GENERATE FLATTEN(group) as (ProductId, ProductName,UserId,ECId,ProductCategory), FLATTEN(temp.(DumpTime,TimeDiff)) as (DumpTime, TimeDiff);
}

--calculating score
gr1WithScore = FOREACH gr1{
    --stands for day diff
    dd = DaysBetween(ToDate('$faketime'),DumpTime);


    Score = (dd>6?(dd>12?(dd>18?(dd>24?(int)1:(int)2):(int)3):(int)4):(int)5);
    GENERATE *,Score as Score;
}

gr2 = GROUP gr1WithScore BY (ProductId,ProductName,ECId,ProductCategory);

gr3 = FOREACH gr2 {
    --ProductId = group.group::ProductId;
    --ProductName = group.(group::ProductName);
    
    Users = gr1WithScore.(UserId, DumpTime, TimeDiff,Score);
    Users = ORDER Users BY Score;

    UsersNum = COUNT(Users);
    GENERATE FLATTEN(group) as (ProductId,ProductName,ECId, ProductCategory), 
    Users.(UserId,DumpTime,TimeDiff,Score) as Users:bag{tuple(UserId,DumpTime,TimeDiff,Score)},UsersNum as UsersNum;
}

gr3 = ORDER gr3 BY UsersNum;
--gr3: {ProductId: chararray,ProductName: chararray,ECId: chararray,Users: {(UserId: chararray,DumpTime: datetime,TimeDiff: long,Score: int)},UsersNum: long}

--DUMP finalRequests;

gr3flatten = FOREACH gr3 GENERATE ProductId,ProductName, ECId,ProductCategory,FLATTEN(Users) as (UserId, DumpTime,TimeDiff, Score);

hbaseRecord = FOREACH gr3flatten {

--rowkey = CONCAT(ECId, '_', ProductId, '_', UserId);
rowkey = CONCAT(CONCAT(CONCAT(CONCAT(ECId,'_'),ProductId),'_'),UserId);
GENERATE rowkey as key:chararray, ECId as ECId:chararray, ProductId as ProductId:chararray,ProductName as ProductName:chararray,
ProductCategory as ProductCategory:chararray, UserId as UserId:chararray, (chararray)Score as Score:chararray;

}


--gr3flatten = FOREACH gr3 {
--
--rowkey = CONCAT(CONCAT(ECId,ProductId),UserId);
--
--GENERATE rowkey as key, FLATTEN(Users);
--}



--DUMP gr3;
--STORE gr3 INTO 'a1output';
--STORE hbaseRecord INTO 'a1output';
STORE hbaseRecord INTO 'hbase://RequestTagUser' USING 
org.apache.pig.backend.hadoop.hbase.HBaseStorage('summary:ECId summary:ProductId summary:ProductName summary:ProductCategory summary:UserId summary:Score');


--DESCRIBE groupedRequest;
DESCRIBE gr;
DESCRIBE gr1;
--DESCRIBE gr2;
DESCRIBE gr3;
DESCRIBE hbaseRecord;

