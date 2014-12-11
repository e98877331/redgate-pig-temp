REGISTER /usr/lib/hbase/lib/*.jar;

%default EndDate '2013-12-15'
%default StartDate '2013-11-15'
%default Interval 30
%default Segments 5
%default MaxScorePlusOne 6

--- 讀取 RequestDomains 資料 from HBase
product_count = LOAD 'hbase://RequestProducts' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('products:DumpDate products:UserId products:ECId products:ProductId products:ProductName products:ProductCategory products:ReqCount', '-gt=$StartDate -lt=$EndDate') AS (DumpDate:chararray, UserId:chararray, ECId:chararray, ProductId:chararray, ProductName:chararray, ProductCategory:chararray, ReqCount:long);

--- 計算並產生 Diff 欄位
product_count_with_diff = FOREACH product_count {
	DumpDateInDateTime = ToDate(DumpDate, 'yyyy-MM-dd');
	EndDateInDateTime = ToDate('$EndDate', 'yyyy-MM-dd');
	diff = DaysBetween(EndDateInDateTime, DumpDateInDateTime);
	GENERATE *, diff as Diff;
}

--- 按照 UserId 和 (ECID, ProductId, ProductCategory, ProductName) 做群組分類
group_by_user_product = GROUP product_count_with_diff BY (UserId, ECId, ProductId, ProductName, ProductCategory);

--- 針對每個 User 計算其瀏覽的每個 Product 的 R Score
user_product_with_rscore = FOREACH group_by_user_product {

	min_diff = MIN(product_count_with_diff.Diff);
	r_score = $MaxScorePlusOne - (int) CEIL((double)min_diff * (double)$Segments / (double)$Interval) ;

	GENERATE CONCAT(CONCAT(CONCAT(CONCAT(group.UserId, '_'), group.ECId), '_'), group.ProductId) AS key:chararray, FLATTEN(group) AS (UserId, ECId, ProductId, ProductName, ProductCategory), r_score AS RScore;
}

--- 儲存結果到 HDFS
--- fs -rm -r RedGate/user_product_recently;
--- STORE user_product_with_rscore INTO 'RedGate/user_product_recently';

--- 建立 HBase 的 table 
--- hbase> create 'RequestUserTag', 'summary'

--- 儲存結果到 HBase
STORE user_product_with_rscore INTO 'hbase://RequestUserTag' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ECId summary:ProductId summary:ProductName  summary:ProductCategory summary:RScore');
