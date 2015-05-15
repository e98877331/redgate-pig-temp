@ModuleDescription: recent M days, top N categories, order by frequency
@Module: Bp4
@Parameters: m, n
@DataLoader: None
@MinInFields: None
@OutAliase: E2
@OutFields: key:chararray, value:chararray

@TemplateCode:
A2 = foreach A generate user_id, object_name,
                        DaysBetween(CurrentTime(), ToDate(dump_time, 'yyyy-MM-dd HH:mm:ss.SSS')) as date_diff;
A3 = filter A2 by (date_diff >= 0) and (date_diff < $m)
    and (object_name is not null) and (not object_name matches 'null');

B = foreach A3 generate user_id, flatten(STRSPLIT(object_name, '\\|'));
B2 = foreach B generate (chararray)$0, (bag{tuple()})TOBAG($1 ..) as b2_bag:bag{b2_tuple:tuple()};
B3 = foreach B2 generate $0, flatten($1);
B4 = foreach B3 generate (chararray)$0 as user_id, (chararray)$1 as object_name;

C = group B4 by (user_id, object_name);
C2 = foreach C generate group.user_id as user_id,
                        group.object_name as object_name,
                        COUNT(B4) as object_count;

D = group C2 by user_id;
D2 = foreach D {
    DD = order C2 by object_count desc, object_name asc;
    generate flatten(Stitch(Over(DD, 'row_number'), DD));
};
D3 = filter D2 by ($0 <= $n);
D4 = foreach D3 generate stitched::user_id as user_id,
                         $0 as row_id,
                         CONCAT(CONCAT(CONCAT(object_name, ' ('), (chararray)object_count), ')') as object_with_count;

E = group D4 by user_id;
E2 = foreach E {
    EE = order D4 by row_id asc;
    generate CONCAT($0, CONCAT('_',(chararray)'$stime')) as key, BagToString(EE.object_with_count, ',') as value;
};
