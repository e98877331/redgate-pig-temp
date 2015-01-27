from step import ModuleStep, IndependStep, BinaryOperatorStep

loadOp = IndependStep(8, "DataLoader", {})

dfparams1 = {"diff": 3, "EndDate": "2013-10-03"}
dofparams1 = {"filterString": "(DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*')"}
df1 = ModuleStep(0, "DaysFilter", dfparams1)
dof1 = ModuleStep(1, "DomainFilter", dofparams1, childNode=df1)

dfparams2 = {"diff": 3, "EndDate": "2013-09-28"}
dofparams2 = {"filterString": "(DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*')"}
df2 = ModuleStep(2, "DaysFilter", dfparams2)
dof2 = ModuleStep(3, "DomainFilter", dofparams2, childNode=df2)

binOp = BinaryOperatorStep(stepId=4, operator="JOIN", operationOn="UniqueId",
                           lhs=dof1, rhs=dof2)

dfparams3 = {"diff": 3, "EndDate": "2013-09-28"}
dofparams3 = {"filterString": "(DomainName matches '.*pingle.*' OR DomainName matches '.*ezprice.*')"}
df3 = ModuleStep(4, "DaysFilter", dfparams3)
dof3 = ModuleStep(5, "DomainFilter", dofparams3, childNode=df3)

binOp2 = BinaryOperatorStep(stepId=6, operator="JOIN", operationOn="UniqueId",
                            lhs=binOp, rhs=dof3)
dumpOp = ModuleStep(7, "SimpleDump", {}, childNode=binOp2)
genString = "REGISTER /usr/lib/hbase/lib/*.jar;\n/**/\n"

genString += loadOp.codeGen()
# genString += binOp2.codeGen()
genString += dumpOp.codeGen()
# genString += "\n\nDUMP JoinResult;"
# print genString

with open("testout2.pig", "w") as outFile:
    outFile.write(genString)
