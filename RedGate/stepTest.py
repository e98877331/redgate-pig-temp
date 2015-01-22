from step import ModuleStep, IndependStep, BinaryOperatorStep

loadOp = IndependStep(8, "SimpleLoader", {})

A1params = {"startRow": "48_1025339", "endRow": "48_1025340"}
Bparams = {"minReqSum": "15"}
lop = ModuleStep(0, "A1", A1params)
rop = ModuleStep(1, "BSL", Bparams)
binOp = BinaryOperatorStep(stepId=2, operator="JOIN", operationOn="UserId",
                           lhs=lop, rhs=rop)

rop2 = ModuleStep(3, "C", Bparams)
binOp2 = BinaryOperatorStep(stepId=4, operator="JOIN", operationOn="UserId",
                            lhs=binOp, rhs=rop2)

dumpOp = ModuleStep(4, "SimpleDump", {}, childNode=binOp2)
genString = "REGISTER /usr/lib/hbase/lib/*.jar;\n/**/\n"

genString += loadOp.codeGen()
# genString += binOp2.codeGen()
genString += dumpOp.codeGen()
# genString += "\n\nDUMP JoinResult;"
# print genString

with open("testout.pig", "w") as outFile:
    outFile.write(genString)
