from abc import ABCMeta, abstractmethod
# from codeGenTable import codeGenTable
from moduleLoader import ModuleLoader
import sys


class Binder:
    @staticmethod
    def bindParams(script, paramsDic):
        for key, value in paramsDic.iteritems():
            script = script.replace('$' + key, value)

        return script


class BaseStep(object):
    __metaclass__ = ABCMeta

    TYPE_OPERATOR = "op"
    TYPE_MODULE = "md"
    mType = None
    mData = None
    mStepId = -1
    outAliase = None
    outFieldsList = None

    @abstractmethod
    def codeGen(self):
        pass

    def getOutAliase(self):
        if self.outAliase is None:
            raise Exception("OutAliase is None: " + self.getId)
        else:
            return self.outAliase

    def getOutFieldsList(self):
        if self.outFieldsList is None:
            raise Exception("OutFieldsLis is None: " + self.getId)
        else:
            return self.outFieldsList

    def getOutFieldsListString(self):
        out = ""
        for i in self.outFieldsList:
            out += i
            out += ", "

        return out.rstrip(", ")
#    @abstractmethod
#    def getOutAliase(self):
#        pass

    def setId(self, id):
        self.mStepId = id

    def getId(self):
        return self.mStepId


class BinaryOperatorStep(BaseStep):
    templateCodeGenString = "$ThisOut = $Operator $Operand1 BY \
$OnField, $Operand2 BY $OnField;\n"
    operator = None
    operationOn = None
    # outAliase = None # defined in super class
    # left/rigth hand side step
    lhs = None
    rhs = None
    # outFieldsList = None   # defined in super class

    def __init__(self, operator, operationOn, lhs, rhs):
        self.mType = BaseStep.TYPE_OPERATOR

        self.operator = operator
        self.operationOn = operationOn

        # TODO support more binOP
        self.outAliase = "JoinResult"

        self.lhs = lhs
        self.rhs = rhs

    def codeGen(self):
        lhsOut = self.lhs.codeGen()
        rhsOut = self.rhs.codeGen()
        params = {"Operator": self.operator,
                  "OnField": self.operationOn,
                  "Operand1": self.lhs.getOutAliase(),
                  "Operand2": self.rhs.getOutAliase(),
                  "ThisOut": self.outAliase}
        genString = lhsOut + rhsOut
        genString += Binder.bindParams(self.templateCodeGenString, params)
        genString += "\n\n"

        # print outString
        # print "\n\n"
        return genString


class ModuleStep(BaseStep):
    params = None
    moduleName = None
    # outAliase = None # defined in super class
    outFields = None
    templateCodeGenString = ""

    def __init__(self, moduleName, params):
        self.mType = BaseStep.TYPE_MODULE
        self.moduleName = moduleName
        self.params = params
        # self.templateCodeGenString = codeGenTable[moduleName]
        moduleData = ModuleLoader.loadModule("moduleFile/" +
                                             moduleName + ".md")
        if moduleData is None:
            sys.exit("ERROR: ModuleLoader returns None")
        if moduleData["moduleName"] != self.moduleName:
            sys.exit("ERROR: ModuleName ERROR")
        self.outAliase = moduleData["outAliase"]
        self.outFields = moduleData["outFields"]

        self.outFieldsList = []
        for i in self.outFields:
            self.outFieldsList.append(moduleName + "::" + i)

        self.templateCodeGenString = moduleData["templateCode"]

    def codeGen(self):

        genString = Binder.bindParams(self.templateCodeGenString, self.params)
        genString += "\n"
        genString += self.genFormatStatement()

        # print outString

        # print formatStatement

        genString += "\n\n"
        # print "\n\n"

        return genString

    def genFormatStatement(self):
        outString = self.outAliase + " = FOREACH " + self.outAliase + \
            " GENERATE * AS (" + self.getOutFieldsListString() + ")"
        return outString


if __name__ == "__main__":
    A1params = {"startRow": "48_1025339", "endRow": "48_1025340"}
    Bparams = {"minReqSum": "15"}
    lop = ModuleStep("A1", A1params)
    rop = ModuleStep("B", Bparams)
    binOp = BinaryOperatorStep(operator="JOIN", operationOn="UserId",
                               lhs=lop, rhs=rop)

    binOp2 = BinaryOperatorStep(operator="JOIN", operationOn="UserId",
                                lhs=binOp, rhs=rop)

    print binOp2.codeGen()
