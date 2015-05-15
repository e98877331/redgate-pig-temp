@ModuleDescription: load each fields from raw data
@Module: DataLoader
@Parameters: dataPath
@DataLoader: None
@MinInFields: None
@OutAliase: A
@OutFields:
  log_id:long, user_id:chararray, domain_name:chararray,
  url:chararray, ip_address:chararray, dump_time:chararray,
  referer:chararray, session_id:chararray, page_title:chararray,
  sex:chararray, age:chararray, live_city:chararray, ec_id:chararray,
  product_id:chararray, name:chararray, price:chararray,
  ec_catalog_name:chararray, pg_catalog_name:chararray,
  object_name:chararray, brand_name:chararray, web_name:chararray,
  web_type:chararray

@TemplateCode:
%declare stime $time_start

register /usr/hdp/2.2.0.0-2041/pig/piggybank.jar;
define Stitch org.apache.pig.piggybank.evaluation.Stitch;
define Over org.apache.pig.piggybank.evaluation.Over('int');

A = load '$dataPath' using PigStorage('\u0001')
as (log_id:long, user_id:chararray, domain_name:chararray,
    url:chararray, ip_address:chararray, dump_time:chararray,
    referer:chararray, session_id:chararray, page_title:chararray,
    sex:chararray, age:chararray, live_city:chararray, ec_id:chararray,
    product_id:chararray, name:chararray, price:chararray,
    ec_catalog_name:chararray, pg_catalog_name:chararray,
    object_name:chararray, brand_name:chararray, web_name:chararray,
    web_type:chararray);
