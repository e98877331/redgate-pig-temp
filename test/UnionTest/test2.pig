
REGISTER /usr/lib/hbase/lib/*.jar;

/**/
REGISTER 'mySampleLib.py' using jython as myfuncs

--A = load '/user/hdfs/ReddoorExportDb' using PigStorage('\u0001')
--A = load 'ReddoorExport201411' using PigStorage('\u0001')
A = load 'ReddoorExportCYY/part-m-00000' using PigStorage('\u0001')
as (log_id:int, user_id:chararray, domain_name:chararray,
url:chararray, ip_address:chararray, dump_time:chararray,
referer:chararray, session_id:chararray, page_title:chararray,
sex:chararray, age:int, live_city:chararray,
ecid:chararray, product_id:chararray,
eccatalog_name:chararray, pgcatalog_name:chararray,
name:chararray, price:chararray, object_name:chararray, brand:chararray);


A2 = load 'ReddoorExportCYY/part-m-00001' using PigStorage('\u0001')
as (log_id:int, user_id:chararray, domain_name:chararray,
url:chararray, ip_address:chararray, dump_time:chararray,
referer:chararray, session_id:chararray, page_title:chararray,
sex:chararray, age:int, live_city:chararray,
ecid:chararray, product_id:chararray,
eccatalog_name:chararray, pgcatalog_name:chararray,
name:chararray, price:chararray, object_name:chararray, brand:chararray);

B = FOREACH A GENERATE user_id,domain_name,  ip_address;
--B = LIMIT B 2;
C = FOREACH A2 GENERATE user_id,session_id,sex;
--C = FOREACH A2 GENERATE user_id,domain_name,  ip_address;
--C = LIMIT C 3;

DUMP B;
DESCRIBE B;

DUMP C;
DESCRIBE C;

--E = UNION ONSCHEMA B, C;
E = JOIN B BY user_id FULL, C BY user_id;
DUMP E;
DESCRIBE E;

--E = UNION ONSCHEMA B, C;
F =  UNION ONSCHEMA B, C;
DUMP F;
DESCRIBE F;

G = GROUP F BY user_id;

G = FOREACH G GENERATE group ,myfuncs.mergeBag(F) as F;

G = FOREACH G GENERATE FLATTEN(F);

DUMP G;
DESCRIBE G;


