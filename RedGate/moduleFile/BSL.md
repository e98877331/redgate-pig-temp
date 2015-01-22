@Module:
BSL

@OutAliase:
BResult

@OutFields:
UserId:chararray, ReqSum:int

@TemplateCode:
BResult = filter SimpleLoaderOut BY ReqSum > $minReqSum;
BResult = ORDER BResult By ReqSum;




