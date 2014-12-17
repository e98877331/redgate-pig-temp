#!/usr/bin/python

#from __future__ import with_statement
from org.apache.pig.scripting import Pig
import json
from pprint import pprint

#class Binder:
#  @staticmethod
#  def bindParams(script,params)
#  """
#  script : pig code string
#  params : params dictionary
#  """
#    for key,value in params.iteritems:
#        script.replace('$'+key,value)
#    return script

def bindParams(script,paramsDic):
  for key,value in paramsDic.iteritems():
      script = script.replace('$'+key,value)
       
  return script


if __name__ == "__main__":



  print "======================start==================="
  print "======================start==================="
  print "======================start==================="
  print "======================start==================="
  
  codegenTable ={
      'A1':
      """
  A1Result = LOAD 'hbase://RequestTagUser' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:ECId summary:ProductCategory summary:ProductId summary:ProductName summary:Score summary:UserId', '-gte=$startRow -lte=$endRow') AS (ECId:chararray, ProductCategory:chararray, ProductId:chararray, ProductName:chararray, score:int, UserId:chararray);
  
  A1Group = GROUP A1Result By (ECId, ProductId,ProductName);
  
  A1GroupCount = FOREACH A1Group GENERATE group as grp,A1Result.(UserId,score), COUNT(A1Result) as userCount;
  
  A1GroupCount = FILTER A1GroupCount BY userCount >200;
  
  A1Order = ORDER A1GroupCount BY userCount;
      """
      ,
      'B':
      """
  BResult = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
  
  BResult = filter BResult BY ReqSum > $minReqSum;
  BResult = ORDER BResult By ReqSum;
      """
      ,
      'C':
      """
  CResult = Load 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
  CResult = filter CResult BY ReqSum > $minReqSum;
  CResult = ORDER CResult By ReqSum;
      """
      ,
      'D':
      """
  DResult = Load 'hbase://RequestCosmetics' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
  DResult = filter DResult BY ReqSum > $minReqSum;
  DResult = ORDER DResult By ReqSum;
      """
      }
  
  
  with open('params.json') as data_file:
    jsonArr = json.load(data_file)
  
  #pprint(params)
  #params=[["A1",5],["B",5],["C",5]]
  
  pigString = "REGISTER /usr/lib/hbase/lib/*.jar;"
  
  #run all module individually
  for i in jsonArr:
    script = codegenTable[i['action']]
    script = bindParams(script,i['params'])
    pigString += script
  
  postString =""
  #combine modules
  for i in range(0,len(jsonArr)):
    currentAction = jsonArr[i]['action']
    if i == 0:
      postString = "Result = " + currentAction + "Result;\n"
    else:
      postString += "Result = JOIN Result BY UserId, " +currentAction+"Result BY UserId;\n"
      postString += "Result = FOREACH Result GENERATE " + currentAction+ "Result::UserId AS UserId, *;\n"

  #A1BResult = JOIN BResult BY UserId, CResult By UserId;
  pigString += postString
  pigString += """
  DUMP Result;
  DESCRIBE Result;
  """
  
  print(pigString)
  
  #with open('cyygeneratedPig.pig','a') as outFile:
  #    outFile.write(pigString)
  
  P = Pig.compile(pigString)
  #P = Pig.compileFromFile('pig_bcd_bc.pig')
  
  #run the pig script
  
  if True:
    result = P.bind().runSingle()
  
    if result.isSuccessful():
      print 'run success'
    else:
      raise 'run failed'
