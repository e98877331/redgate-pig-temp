REGISTER /usr/lib/hbase/lib/*.jar;

%default EndDate '2013-12-15'
%default StartDate '2013-11-15'
%default Interval 30
%default Segments 5
%default MaxScorePlusOne 6

--- 讀取 RequestDomains 資料 from HBase
product_count = LOAD 'hbase://RequestProducts' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('products:DumpDate products:UserId products:ECId products:ProductId products:ProductName products:ProductCategory products:ReqCount', '-gt=$StartDate -lt=$EndDate') AS (DumpDate:chararray, UserId:chararray, ECId:chararray, ProductId:chararray, ProductName:chararray, ProductCategory:chararray, ReqCount:long);

--- preprecessing data start

--- filter to get children produtct
fRequests = FILTER product_count BY (ProductName MATCHES '.*嬰.*' OR ProductName MATCHES '.*兒童.*' OR ProductName MATCHES '.*幼.*' OR ProductCategory MATCHES '.*嬰幼兒.*');

grouped_by_user = GROUP fRequests BY (UserId);

gr = FOREACH grouped_by_user GENERATE group as key, group as UserId, SUM(fRequests.ReqCount) as count;

--- gr = ORDER gr BY count DESC;

---DUMP gr;

--- 建立 HBase 的 table 
--- hbase> create 'RequestUserTag', 'summary'

--- 儲存結果到 HBase
STORE gr INTO 'hbase://RequestChildren_ethan' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum');


children_intent = FOREACH gr GENERATE UserId as key, UserId as UserID, '1' as IntentChildren ;

DUMP children_intent;

STORE children_intent INTO 'hbase://UserProfile_95' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('intent:UserId intent:Intent_children');
