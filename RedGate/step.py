from abc import ABCMeta, abstractmethod
# from codeGenTable import codeGenTable
from loader.moduleLoader import ModuleLoader
import pdb


class Binder:
    @staticmethod
    def bindParams(script, paramsDic):
        for key, value in paramsDic.iteritems():
            print "key: " + str(key) + " value: " + str(value)
            script = script.replace('$' + key, str(value))

        return script

    @staticmethod
    def bindChildOutAliase(script, childNode):
        return script.replace("$input$", childNode.getOutAliaseU())

    @staticmethod
    def bindOutAliaseU(script, step):
        return script.replace(step.getOutAliase(), step.getOutAliaseU())


class BaseStep(object):
    __metaclass__ = ABCMeta

    TYPE_BINOP = "op"
    TYPE_MODULE = "md"
    TYPE_INDEPEND = "ind"
    moduleName = None
    mType = None
    mData = None
    mStepId = -1
    outAliase = None
    outFieldsList = None
    templateCodeGenString = ""

    @abstractmethod
    def codeGen(self):
        pass

    def getOutAliase(self):
        if self.outAliase is None:
            raise Exception("OutAliase is None: " + self.getId())
        else:
            return self.outAliase

    # U means unique
    def getOutAliaseU(self):
        return self.getOutAliase() + "_" + self.getId()

    def getModuleName(self):
        if self.moduleName is None:
            raise Exception("moduleName is None: " + self.getId())
        else:
            return self.moduleName

    # U means unique
    def getModuleNameU(self):
        return self.getModuleName() + "_" + self.getId()

    def getOutFieldsList(self, withType=True):
        if self.outFieldsList is None:
            raise Exception("OutFieldsLis is None: " + self.getId())
        else:
            if withType:
                return self.outFieldsList
            else:
                return [x.rsplit(":", 1)[0] for x in self.outFieldsList]

    def getOutFieldsListString(self, withType=True):
        out = ""
        for i in self.outFieldsList:
            if not withType:
                i = i[:i.rfind(":")]
            out += i
            out += ", "

        return out.rstrip(", ")
#    @abstractmethod
#    def getOutAliase(self):
#        pass

    def getStepType(self):
        return self.mType

    def setId(self, stepId):
        self.mStepId = stepId

    def getId(self):
        if self.mStepId == -1:
            return "NotSet"
        else:
            return str(self.mStepId)

    def loadModule(self, moduleName):
        moduleData = ModuleLoader.loadModule("moduleFile/" +
                                             moduleName + ".md")
        if moduleData is None:
            raise Exception("ERROR: ModuleLoader returns None")
        if moduleData["moduleName"] != self.moduleName:
            raise Exception("ERROR: ModuleName ERROR")
        self.outAliase = moduleData["outAliase"]
        self.outFieldsList = moduleData["outFields"]
        self.templateCodeGenString = moduleData["templateCode"]


class BinaryOperatorStep(BaseStep):
    # moduleName = "BinOP" #defined in super class
    andTemplate = "$ThisOut = JOIN $Operand1 BY \
$OnField1, $Operand2 BY $OnField2;\n"
    orTemplate = '''
    $ThisOutTMP = UNION ONSCHEMA $Operand1, $Operand2;\n
    $ThisOutTMP = GROUP $ThisOutTMP BY $OnField1;
    $ThisOut = FOREACH $ThisOutTMP GENERATE myfuncs.mergeBag($ThisOutTMP) as gp;
    $ThisOut = FOREACH $ThisOut GENERATE FLATTEN(gp);
    '''
    templateCodeGenString = ""
    operator = None
    operationOn = None
    # outAliase = None # defined in super class
    # left/rigth hand side step
    lhs = None
    rhs = None
    # outFieldsList = None   # defined in super class

    def __init__(self, stepId, operator, operationOn, lhs, rhs):
        self.mType = BaseStep.TYPE_BINOP

        self.setId(stepId=stepId)

        self.operator = operator
        if operator == "AND" or operator == "and":
            self.templateCodeGenString = self.andTemplate
        elif operator == "OR" or operator == "or":
            self.templateCodeGenString = self.orTemplate

        self.operationOn = operationOn
        self.moduleName = self.operator
        # TODO support more binOP
        self.outAliase = "JoinResult"

        self.lhs = lhs
        self.rhs = rhs

    def codeGen(self):
        # handling generated code
        lhsOut = self.lhs.codeGen()
        rhsOut = self.rhs.codeGen()

        # handling fields
        lhsOutFields = self.lhs.getOutFieldsList()[:]
        rhsOutFields = self.rhs.getOutFieldsList()[:]

        if self.lhs.getStepType() == BaseStep.TYPE_MODULE:
            for i in xrange(len(lhsOutFields)):
                lhsOutFields[i] = self.lhs.getModuleNameU() + "::" + lhsOutFields[i]
        if self.rhs.getStepType() == BaseStep.TYPE_MODULE:
            for i in xrange(len(rhsOutFields)):
                rhsOutFields[i] = self.rhs.getModuleNameU() + "::" + rhsOutFields[i]

        self.outFieldsList = lhsOutFields + rhsOutFields

        onField1 = self.operationOn
        onField2 = self.operationOn
        if (self.lhs.getStepType() == BaseStep.TYPE_BINOP):
            onField1 = self.getFullFieldNameOnChildNode(self.lhs, onField1)

        if (self.rhs.getStepType() == BaseStep.TYPE_BINOP):
            onField2 = self.getFullFieldNameOnChildNode(self.rhs, onField2)

        params = {"OnField1": onField1,
                  "OnField2": onField2,
                  "Operand1": self.lhs.getOutAliaseU(),
                  "Operand2": self.rhs.getOutAliaseU(),
                  "ThisOut": self.getOutAliaseU()}
        genString = lhsOut + rhsOut
        script = Binder.bindParams(self.templateCodeGenString, params)
        # script = Binder.bindOutAliaseU(script, self)
        genString += script
        genString += "\n\n"
        genString += self.genFormatStatement()

        return genString

    def genFormatStatement(self):

        outString = self.getOutAliaseU() + " = FOREACH " + \
            self.getOutAliaseU() + \
            " GENERATE * AS (" + \
            self.getOutFieldsListString() + ");\n"

        # below handles duplicate operationOn kList = [self.operationOn + ":chararray"] + self.outFieldsList
        return outString

    # get bin op field with unambigous prefix
    def getFullFieldNameOnChildNode(self, childNode, field):
        for i in childNode.getOutFieldsList(withType=False):
            l = i.split("::")
            if len(l) >= 2:
                if l[1].split(":")[0] == field:
                    return i
            # TODO handle field not found


class ModuleStep(BaseStep):
    params = None
    # moduleName = None #defined in super class
    # outAliase = None # defined in super class
    # templateCodeGenString = "" #defined in super class
    childNode = None

    def __init__(self, stepId, moduleName, params, childNode=None):

        self.setId(stepId=stepId)

        self.mType = BaseStep.TYPE_MODULE
        self.moduleName = moduleName
        self.params = params
        if childNode is not None:
            self.childNode = childNode
        self.loadModule(moduleName)

    def codeGen(self):
        genString = ""
        if self.childNode is not None:
            genString += self.childNode.codeGen()
        script = Binder.bindParams(self.templateCodeGenString, self.params)
        script = Binder.bindOutAliaseU(script, self)
        if self.childNode is not None:
            script = Binder.bindChildOutAliase(script, self.childNode)

        genString += script
        genString += "\n"
        genString += self.genFormatStatement()

        # print outString

        # print formatStatement

        genString += "\n\n"
        # print "\n\n"

        return genString

    def genFormatStatement(self):
        if self.getOutAliase() == "None":
            return ""

        outString = self.getOutAliaseU() + " = FOREACH " + \
            self.getOutAliaseU() + " GENERATE * AS (" + \
            self.getOutFieldsListString() + ");"
        return outString


class IndependStep(BaseStep):
    params = None

    def __init__(self, stepId, moduleName, params):
        self.setId(stepId)
        self.mType = BaseStep.TYPE_INDEPEND
        self.moduleName = moduleName
        self.params = params
        self.loadModule(moduleName)

    def codeGen(self):
        genString = Binder.bindParams(self.templateCodeGenString, self.params)
        genString += "\n\n"
        return genString


if __name__ == "__main__":
    A1params = {"startRow": "48_1025339", "endRow": "48_1025340"}
    Bparams = {"minReqSum": "15"}
    lop = ModuleStep(0, "A1", A1params)
    rop = ModuleStep(1, "B", Bparams)
    binOp = BinaryOperatorStep(stepId=2, operator="JOIN", operationOn="UserId",
                               lhs=lop, rhs=rop)

    rop2 = ModuleStep(3, "C", Bparams)
    binOp2 = BinaryOperatorStep(stepId=4, operator="JOIN", operationOn="UserId",
                                lhs=binOp, rhs=rop2)

    dumpOp = ModuleStep(4, "SimpleDump", {}, childNode=binOp2)
    genString = "REGISTER /usr/lib/hbase/lib/*.jar;\n/**/\n"
    genString += "REGISTER 'mySampleLib.py' using jython as myfuncs\n"
    # genString += binOp2.codeGen()
    genString += dumpOp.codeGen()
    # genString += "\n\nDUMP JoinResult;"
    # print genString

    with open("outt.pig", "w") as outFile:
        outFile.write(genString)
