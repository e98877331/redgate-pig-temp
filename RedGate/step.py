from abc import ABCMeta, abstractmethod
from codeGenTable import codeGenTable


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

    @abstractmethod
    def codeGen(self):
        pass


class BinaryOperatorStep(BaseStep):
    templateCodeGenString = "$ThisOut = $Operator $Operand1 BY \
$OnField, $Operand2 BY $OnField;\n"
    operator = None
    operationOn = None
    # left/rigth hand side step
    lhs = None
    rhs = None

    def __init__(self, operator, operationOn, lhs, rhs):
        self.mType = BaseStep.TYPE_OPERATOR

        self.operator = operator
        self.operationOn = operationOn
        self.lhs = lhs
        self.rhs = rhs

    def codeGen(self):
        lhsOut = self.lhs.codeGen()
        rhsOut = self.rhs.codeGen()
        out = "JoinResult"
        params = {"Operator": self.operator, "OnField": self.operationOn,
                  "Operand1": lhsOut, "Operand2": rhsOut, "ThisOut": out}
        outString = Binder.bindParams(self.templateCodeGenString, params)
        print outString
        print "\n\n"
        return out


class ModuleStep(BaseStep):
    templateCodeGenString = ""
    moduleName = None
    params = None

    def __init__(self, moduleName, params):
        self.mType = BaseStep.TYPE_MODULE
        self.moduleName = moduleName
        self.params = params
        self.templateCodeGenString = codeGenTable[moduleName]

    def codeGen(self):
        # TODO implement

        outString = Binder.bindParams(self.templateCodeGenString, self.params)
        print outString
        print "\n\n"
        return self.moduleName + "Result"


A1params = {"startRow": "48_1025339", "endRow": "48_1025340"}
Bparams = {"minReqSum": "15"}
lop = ModuleStep("A1", A1params)
rop = ModuleStep("B", Bparams)
binOp = BinaryOperatorStep(operator="JOIN", operationOn="UserId",
                           lhs=lop, rhs=rop)


binOp2 = BinaryOperatorStep(operator="JOIN", operationOn="UserId",
                           lhs=lop, rhs=rop)
binOp.codeGen()



