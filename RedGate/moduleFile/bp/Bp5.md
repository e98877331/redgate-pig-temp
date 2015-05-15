@ModuleDescription: recent M days, top N categories, order by date
@Module: Bp5
@Parameters: m, n
@DataLoader: None
@MinInFields: None
@OutAliase: E2
@OutFields: key:chararray, value:chararray

@TemplateCode:
A2 = foreach A generate user_id, object_name,
                        DaysBetween(CurrentTime(), ToDate(dump_time, 'yyyy-MM-dd HH:mm:ss.SSS')) as date_diff,
                        MilliSecondsBetween(CurrentTime(), ToDate(dump_time, 'yyyy-MM-dd HH:mm:ss.SSS')) as ms_diff;
A3 = filter A2 by (date_diff >= 0) and (date_diff < $m)
    and (object_name is not null) and (not object_name matches 'null');

B = foreach A3 generate user_id, ms_diff, flatten(STRSPLIT(object_name, '\\|'));
B2 = foreach B generate (chararray)$0, (long)$1, (bag{tuple()})TOBAG($2 ..) as b2_bag:bag{b2_tuple:tuple()};
B3 = foreach B2 generate $0 .. $1, flatten($2);
B4 = foreach B3 generate (chararray)$0 as user_id, (long)$1 as ms_diff, (chararray)$2 as object_name;

C = group B4 by (user_id, object_name);
C2 = foreach C {
    CC = order B4 by ms_diff asc;
    generate flatten(Stitch(Over(CC, 'row_number'), CC));
}
C3 = filter C2 by ($0 == 1);
C4 = foreach C3 generate stitched::user_id as user_id,
                         stitched::object_name as object_name,
                         stitched::ms_diff as ms_diff;

D = group C4 by user_id;
D2 = foreach D {
    DD = order C4 by ms_diff asc, object_name asc;
    generate flatten(Stitch(Over(DD, 'row_number'), DD));
}
D3 = filter D2 by ($0 <= $n);
D4 = foreach D3 generate stitched::user_id as user_id,
                         stitched::object_name as object_name,
                         $0 as row_id;

E = group D4 by user_id;
E2 = foreach E {
    EE = order D4 by row_id asc;
    generate CONCAT($0, CONCAT('_',(chararray)'$stime')) as key, BagToString(EE.object_name, ',') as value;
}
