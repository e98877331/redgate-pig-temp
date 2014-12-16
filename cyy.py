#!/usr/bin/python

#from __future__ import with_statement
from org.apache.pig.scripting import Pig
import json
from pprint import pprint


print "======================start==================="
print "======================start==================="
print "======================start==================="
print "======================start==================="

codegenTable ={
    'A1':
    """
A1Result = LOAD 'hbase://RequestTagUser' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:ECId summary:ProductCategory summary:ProductId summary:ProductName summary:Score summary:UserId', '-gte=48_1025339 -lte=48_1025340') AS (ECId:chararray, ProductCategory:chararray, ProductId:chararray, ProductName:chararray, score:int, UserId:chararray);

A1Group = GROUP A1Result By (ECId, ProductId,ProductName);

A1GroupCount = FOREACH A1Group GENERATE group as grp,A1Result.(UserId,score), COUNT(A1Result) as userCount;

A1GroupCount = FILTER A1GroupCount BY userCount >200;

A1Order = ORDER A1GroupCount BY userCount;
    """
    ,
    'B':
    """
BResult = Load 'hbase://RequestComparison' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);

BResult = filter BResult BY ReqSum > 15;
BResult = ORDER BResult By ReqSum;
    """
    ,
    'C':
    """
CResult = Load 'hbase://RequestReputation' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
CResult = filter CResult BY ReqSum > 20;
CResult = ORDER CResult By ReqSum;
    """
    ,
    'D':
    """
DResult = Load 'hbase://RequestCosmetics' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage ('summary:UserId summary:ReqSum') AS (UserId:chararray, ReqSum:int);
DResult = filter DResult BY ReqSum > 500;
DResult = ORDER DResult By ReqSum;
    """
    }


with open('params.json') as data_file:
  params = json.load(data_file)

#pprint(params)
#params=[["A1",5],["B",5],["C",5]]

pigString = "REGISTER /usr/lib/hbase/lib/*.jar;"

for i in params:
  pigString += codegenTable[i[0]]

pigString += """
A1BResult = JOIN BResult BY UserId, CResult By UserId;
DUMP A1BResult;
"""
  #  if i[0] == "A1":
#    pigString +="""
#    this is a book,
#    a very good book
#    why don't you buy on1\
#    hahahah
#    """
#  if i[0] == "B":
#    pigString += """
#    """

print(pigString)

#with open('cyygeneratedPig.pig','a') as outFile:
#    outFile.write(pigString)

P = Pig.compile(pigString)
#P = Pig.compileFromFile('pig_bcd_bc.pig')

result = P.bind().runSingle()

if result.isSuccessful():
  print 'run success'
else:
  raise 'run failed'
