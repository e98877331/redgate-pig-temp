from abc import ABCMeta, abstractmethod
# from codeGenTable import codeGenTable


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
        self.operator = operator
        self.operationOn = operationOn
        self.lhs = lhs
        self.rhs = rhs

    def codeGen(self):
        # TODO impolemnt
        lhsOut = self.lhs.codeGen()
        rhsOut = self.rhs.codeGen()
        out = lhsOut + rhsOut + "Result"
        params = {"Operator": self.operator, "OnField": self.operationOn,
                  "Operand1": lhsOut, "Operand2": rhsOut, "ThisOut": out}
        outString = Binder.bindParams(self.templateCodeGenString, params)
        print outString
        return out


class ModuleStep(BaseStep):

    def __init__(self, data):
        self.mType = BaseStep.TYPE_MODULE
        self.mData = data

    def codeGen(self):
        # TODO implement
        print self.mData
        return self.mData


lop = ModuleStep("ModuelA")
rop = ModuleStep("ModuelB")
binOp = BinaryOperatorStep(operator="JOIN", operationOn="UserId",
                           lhs=lop, rhs=rop)
binOp.codeGen()




