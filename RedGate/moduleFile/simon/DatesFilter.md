
@ModuleDescription: filter log data by a given dates
@Module: DatesFilter
@Parameters: StartDate, EndDate
@DataLoader: None
@MinInFields: DumpTime
@OutAliase: fittedDateSet
@OutFields: *

@TemplateCode: 
reFormData = foreach $input$ generate ToDate(DumpTime, 'yyyy-MM-dd HH:mm:ss') as redt:datetime, * as allData;
fittedData = filter reFormData by redt >= ToDate($StartDate, 'yyyy-MM-dd HH:mm:ss') AND redt < ToDate($EndDate, 'yyyy-MM-dd HH:mm:ss');
fittedDateSet = FOREACH fittedData {
	GENERATE $1 ..;
}
