from loader import mdfLoader
from loader.moduleLoader import ModuleLoader
from step import ModuleStep, BinaryOperatorStep, IndependStep
import pdb


class MDFCompiler:

    idcount = 0
    mModuleLoader = None

    def __init__(self):
        self.mModuleLoader = ModuleLoader()

    def compile(self, fileName):
        jsonDic = mdfLoader.loadMDF(fileName)
        if "ModulePaths" in jsonDic:
            mdPath = jsonDic["ModulePaths"]
            self.addSearchPath(mdPath)

        op = jsonDic["Operation"]
        opOn = jsonDic["OperationOn"]
        # pdb.set_trace()
        dataLoaders = jsonDic["DataLoaders"]
        modules = jsonDic["Modules"]
        outputModule = jsonDic["OutputModule"]

        genString = "REGISTER /usr/lib/hbase/lib/*.jar;\n/**/\n"
        #genString += "REGISTER 'mySampleLib.py' using jython as myfuncs\n"

        preStepList = self.parseDataLoader(dataLoaders)
        for step in preStepList:
            genString += step.codeGen()

        ast = self.parseMain(modules, op, opOn)

        out = self.parseOutputModule(outputModule, ast)
        genString += out.codeGen()

        return genString
        # with open("compiledResult.pig", "w") as outFile:
        #     outFile.write(genString)

    def addSearchPath(self, path):
        self.mModuleLoader.addSearchPath(path)

    def getSearchPath(self):
        return self.mModuleLoader.paths

    def getModuleLoader(self):
        return self.mModuleLoader

    def parseDataLoader(self, dataLoaders):
        stepList = []
        for item in dataLoaders:
            istep = IndependStep(self, self.idcount, item["Module"], item["Params"])
            stepList.append(istep)
            self.idcount += 1

        return stepList

    def parseMain(self, modules, op, opOn):

        ast = None
        joinList = [self.createModuleStep(x) for x in modules]
        for i in xrange(0, len(joinList)):
            if ast is None:
                ast = joinList[i]
            else:
                binOp = BinaryOperatorStep(self, self.idcount, operator=op,
                                           operationOn=opOn,
                                           lhs=ast,
                                           rhs=joinList[i])
                self.idcount += 1
                ast = binOp

        return ast

    def parseOutputModule(self, module, ast):
        module = ModuleStep(self, self.idcount, module["Module"],
                            module["Params"],
                            ast)
        self.idcount += 1
        return module

    def createModuleStep(self, data):
        module = None
        if isinstance(data, dict):
            module = ModuleStep(self, self.idcount, data["Module"], data["Params"])
            self.idcount += 1
        elif isinstance(data, list):
            for i in xrange(0, len(data)):
                d = data[i]
                if module is None:
                    module = ModuleStep(self, self.idcount, d["Module"],
                                        d["Params"])
                else:
                    moduleN = ModuleStep(self, self.idcount, d["Module"],
                                         d["Params"], childNode=module)
                    module = moduleN
                self.idcount += 1
        if module is None:
            raise Exception("frontEnd:createModuleStep error: module is None")
        else:
            return module


if __name__ == "__main__":
    compiler = MDFCompiler()
    # parser.parse("simon.mdf")
    compiler.compile("simon.mdf")
