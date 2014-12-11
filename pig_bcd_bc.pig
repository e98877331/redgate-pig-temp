--%default EndDate '2013-12-15';
--%default StartDate '2013-11-15';
--%default Interval 10
--%default Segments 5

REGISTER /usr/lib/hbase/lib/*.jar;

/* load from HBase */
myLogs = LOAD 'hbase://RequestDomains' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('domains:DumpDate domains:UserId domains:DomainName domains:ReqCount', '-loadKey true -gt=2013-11-15 -lt=2013-12-15') AS (key:chararray, DumpDate:chararray, UserId:chararray, DomainName:chararray, ReqCount:long);
/*
2013-12-15_018EEB6D-4D7C-431A-A859-1FF47FDFAE11_tw.mall.yahoo.com       2013-12-15      018EEB6D-4D7C-431A-A859-1FF47FDFAE11    tw.mall.yahoo.com       1
*/


-- B compare，goto pingle,ezprice,findprice more than 10
/* filter DomainName, contains pingle、ezprice、findprice */
user_who_visit_pingle_ezprice_findprice = FILTER myLogs By (DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*' OR DomainName matches '.*findprice.*');

/* 將 user_who_visit_pingle_ezprice_findprice 的時間字串改成datetime object */
--toDateObj_compare = FOREACH user_who_visit_pingle_ezprice_findprice generate key, ToDate(DumpDate,'yyyy-MM-dd') AS (dt_compare:datetime), UserId, DomainName, ReqCount;
/* 只取近30天的資料 */
--betweenDays_compare = filter toDateObj_compare by DaysBetween(dt_compare, (datetime)ToDate('2013-12-01','yyyy-MM-dd')) <=(long)Interval;
/* 將使用者分群 */
--group_user_compare = GROUP betweenDays_compare by UserId;
group_user_compare = GROUP user_who_visit_pingle_ezprice_findprice by UserId;

/* 計算去過這些domain的次數 */
visit_domains_count_compare = FOREACH group_user_compare generate group as key, group as UserId, SUM(user_who_visit_pingle_ezprice_findprice.ReqCount) as ReqCount:long;

gt10 = filter visit_domains_count_compare by ReqCount>=(long)10;
gt1_compare = filter visit_domains_count_compare by ReqCount>=(long)1;

/* store into hbase*/
STORE gt1_compare INTO 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum');


-- C part, visit pixnet
user_who_visit_pixnet = FILTER myLogs BY DomainName matches '.*pixnet.*';
--toDateObj = FOREACH user_who_visit_pixnet generate key, ToDate(DumpDate,'yyyy-MM-dd') AS (dt:datetime), UserId, DomainName, ReqCount;
--betweenDays = filter toDateObj by DaysBetween(dt, (datetime)ToDate('2013-12-01','yyyy-MM-dd')) <=(long)Interval;
group_user_reputation = GROUP user_who_visit_pixnet by UserId;
visit_domains_count_reputation = FOREACH group_user_reputation generate group as key, group as UserId, SUM(user_who_visit_pixnet.ReqCount) as ReqCount:long;

gt20 = filter visit_domains_count_reputation by ReqCount >=20;
gt1_reputation = filter visit_domains_count_reputation by ReqCount >=1;

STORE gt1_reputation INTO 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum');


-- D 彩妝，去過 urcosme,fashsionguide 加起來20次以上
user_who_visit_urcosme_fashsionguid = FILTER myLogs By (DomainName matches '.*urcosme.*' OR DomainName matches '.*fashsionguide.*');

--toDateObj_cosmetics = FOREACH user_who_visit_urcosme_fashsionguid generate key, ToDate(DumpDate,'yyyy-MM-dd') AS (dt_cosmetics:datetime), UserId, DomainName, ReqCount;
--betweenDays_cosmetics = filter toDateObj_cosmetics by DaysBetween(dt_cosmetics, (datetime)ToDate('2013-12-01','yyyy-MM-dd')) <=(long)Interval;

group_user_cosmetics = GROUP user_who_visit_urcosme_fashsionguid by UserId;

--visit_domains_count_compare = FOREACH group_user_compare generate group, UserId, SUM(user_who_visit_pingle_ezprice_findprice) AS ReqCount:long;

visit_domains_count_cosmetics = FOREACH group_user_cosmetics generate group as key, group as UserId, SUM(user_who_visit_urcosme_fashsionguid.ReqCount) as ReqCount:long;

gt20_cosmetics = filter visit_domains_count_cosmetics by ReqCount>=(long)20;
gt1_cosmetics = filter visit_domains_count_cosmetics by ReqCount>=(long)1;

STORE gt1_cosmetics INTO 'hbase://RequestCosmetics' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum');


-- part B+C
Y = JOIN gt10 BY key, gt20 BY key;
BC = FOREACH Y GENERATE gt10::key AS key, gt10::key AS UserId, gt10::ReqCount AS RequestB, gt20::ReqCount AS RequestC;
STORE BC INTO 'hbase://RequestBC' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:RequestB summary:RequestC');


-- profile
profile_join2 = JOIN gt10 BY key FULL, gt20 BY key;
--profile: {gt10::key: chararray,gt10::UserId: chararray,gt10::ReqCount: long,gt20::key: chararray,gt20::UserId: chararray
--,gt20::ReqCount: long}
profile_bc = FOREACH profile_join2 GENERATE (gt10::key is not null ? gt10::key : gt20::key) AS key, gt10::ReqCount AS reqB, gt20::ReqCount AS reqC;
profile_join3 = JOIN profile_bc BY key FULL, gt20_cosmetics BY key;
profile_bcd = FOREACH profile_join3 GENERATE (profile_bc::key is not null ? profile_bc::key : gt20_cosmetics::key) AS key,
(profile_bc::key is not null ? profile_bc::key : gt20_cosmetics::key) AS UserId,
(profile_bc::reqB is not null ? 1 : null) AS req3b,
(profile_bc::reqC is not null ? 1 : null) AS req3c,
(gt20_cosmetics::ReqCount is not null ? 1 : null) AS req3d;

STORE profile_bcd INTO 'hbase://UserProfile_95' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('intent:UserId intent:Intent_comparison intent:Intent_reputation intent:Intent_cosmetics');
