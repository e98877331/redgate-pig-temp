@ModuleDescription: recent M days, top N products
@Module: Bp3
@Parameters: m, n
@DataLoader: None
@MinInFields: None
@OutAliase: D2
@OutFields: key:chararray, value:chararray

@TemplateCode:
A2 = foreach A generate user_id, name,
                        CONCAT(CONCAT(CONCAT(CONCAT(ec_id, '_'), product_id), '_'), name) as ec_product_name,
                        DaysBetween(CurrentTime(), ToDate(dump_time, 'yyyy-MM-dd HH:mm:ss.SSS')) as date_diff;
A3 = filter A2 by (date_diff >= 0) and (date_diff < $m)
    and (name is not null) and (not name matches 'null');

B = group A3 by (user_id, ec_product_name);
B2 = foreach B generate group.user_id as user_id,
                        group.ec_product_name as ec_product_name,
                        COUNT(A3) as name_count;

C = group B2 by user_id;
C2 = foreach C {
    CC = order B2 by name_count desc, ec_product_name asc;
    generate flatten(Stitch(Over(CC, 'row_number'), CC));
};
C3 = filter C2 by ($0 <= $n);
C4 = foreach C3 generate stitched::user_id as user_id,
                         $0 as row_id,
                         CONCAT(CONCAT(CONCAT(ec_product_name, ' ('), (chararray)name_count), ')') as name_with_count;

D = group C4 by user_id;
D2 = foreach D {
    DD = order C4 by row_id asc;
    generate CONCAT($0, CONCAT('_',(chararray)'$stime')) as key, BagToString(DD.name_with_count, ',') as value;
};
