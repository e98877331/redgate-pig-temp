REGISTER /usr/lib/hbase/lib/*.jar;

--- [LOG]
--- 讀取 SampleRedGateReq 資料
logs = LOAD '/user/hdfs/BarReqLog2013Q4New/part-m-*' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray); 

--- logs = LOAD 'SampleRedGateProductNew_v2/part-r-00000' USING PigStorage('\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray);

--- 濾掉 null (UniqueId, DomainName, DumpTime, ECId, ProductId)
logs_without_null = FILTER logs BY UniqueId is not null AND DomainName is not null AND DumpTime is not null AND ECId is not null AND ProductId is not null AND UniqueId != 'null' AND DomainName != 'null' AND DumpTime != 'null' AND ECId != 'null' AND ProductId != 'null';

--- 取出 logs 要使用的欄位, DumpTime 的部份只留「年月日」
logs_with_relevant_fields = FOREACH logs_without_null GENERATE UniqueId AS UserId, DomainName, SUBSTRING(DumpTime, 0, 10) AS DumpDate, ECId, ProductId;

--- 因為原始資料 DumpTime (DumpDate) 會有非預期的日期格式，所以先濾掉
logs_with_right_data = FILTER logs_with_relevant_fields BY DumpDate MATCHES '\\d\\d\\d\\d-\\d\\d-\\d\\d';

--- [PRODUCT]
--- 讀取 products 資料
products = LOAD '/user/hdfs/Products2013Q4New/part-m-*' USING PigStorage('\u0001') AS (ECId: chararray, ProductId: chararray, Name: chararray, Price: chararray, ImageUrl: chararray, Category: chararray, Url: chararray);

--- 取出 products 要使用的欄位
products_with_relevant_fields = FOREACH products GENERATE ECId, ProductId, Name, Category;

--- [LOG join PRODUCT]
--- join with Product
logs_with_products = JOIN logs_with_right_data BY (ECId, ProductId), products_with_relevant_fields BY (ECId, ProductId);

--- 取得需要欄位
logs_alias = FOREACH logs_with_products GENERATE logs_with_right_data::UserId AS UserId, logs_with_right_data::DumpDate AS DumpDate, logs_with_right_data::DomainName AS DomainName, logs_with_right_data::ECId AS ECId, logs_with_right_data::ProductId AS ProductId, products_with_relevant_fields::Name AS ProductName, products_with_relevant_fields::Category AS ProductCategory;

--- 以 DumpDate, UserId ＆（ECId, ProductId）作群組分類
group_dumpdate_userid_ecid_productid = GROUP logs_alias BY (DumpDate, UserId, ECId, ProductId, ProductName, ProductCategory);

--- 計算 (ECId, ProductId) by (UserId & DumpDate) 的點擊次數
request_ecid_productid_count = FOREACH group_dumpdate_userid_ecid_productid GENERATE CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(group.DumpDate, '_'), group.UserId), '_'), group.ECId), '_'), group.ProductId) AS key:chararray, group.DumpDate, group.UserId, group.ECId, group.ProductId, group.ProductName, group.ProductCategory, COUNT(logs_alias) AS ReqCount:long;

--- 儲存結果到 HDFS
--- fs -rm -r RedGate/request_products;
--- STORE request_ecid_productid_count INTO 'RedGate/request_products';

--- 建立 HBase 的 table 
--- hbase> create 'RequestProducts', 'products'

--- 儲存結果到 HBase
STORE request_ecid_productid_count INTO 'hbase://RequestProducts' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('products:DumpDate products:UserId products:ECId, products:ProductId, products:ProductName, products:ProductCategory products:ReqCount');

