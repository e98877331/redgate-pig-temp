call echo %date%-%time%
call c:\hdp\pig-0.12.1.2.1.3.0-1948\bin\pig -f request_domains_daily-v2.pig
call echo %date%-%time%
call c:\hdp\pig-0.12.1.2.1.3.0-1948\bin\pig -f request_product_daily-v2.pig
call echo %date%-%time%
call c:\hdp\pig-0.12.1.2.1.3.0-1948\bin\pig -f user_product_recently-r.pig
call echo %date%-%time%