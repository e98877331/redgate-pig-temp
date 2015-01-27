from loader import mdfLoader
from step import ModuleStep, BinaryOperatorStep, IndependStep
import pdb


class MDFParser:

    idcount = 0

    def compile(self, fileName):
        jsonArr = mdfLoader.loadMDF(fileName)
        op = jsonArr["Operation"]
        opOn = jsonArr["OperationOn"]
        # pdb.set_trace()
        dataLoaders = jsonArr["DataLoaders"]
        modules = jsonArr["Modules"]
        outputModule = jsonArr["OutputModule"]

        genString = "REGISTER /usr/lib/hbase/lib/*.jar;\n/**/\n"

        preStepList = self.parseDataLoader(dataLoaders)
        for step in preStepList:
            genString += step.codeGen()

        ast = self.parseMain(modules, op, opOn)

        out = self.parseOutputModule(outputModule, ast)
        genString += out.codeGen()

        with open("compiledResult.pig", "w") as outFile:
            outFile.write(genString)

    def parseDataLoader(self, dataLoaders):
        stepList = []
        for item in dataLoaders:
            istep = IndependStep(self.idcount, item["Module"], item["Params"])
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
                binOp = BinaryOperatorStep(self.idcount, operator=op,
                                           operationOn=opOn,
                                           lhs=ast,
                                           rhs=joinList[i])
                self.idcount += 1
                ast = binOp

        return ast

    def parseOutputModule(self, module, ast):
        module = ModuleStep(self.idcount, module["Module"],
                            module["Params"],
                            ast)
        self.idcount += 1
        return module

    def createModuleStep(self, data):
        module = None
        if isinstance(data, dict):
            module = ModuleStep(self.idcount, data["Module"], data["Params"])
            self.idcount += 1
        elif isinstance(data, list):
            for i in xrange(0, len(data)):
                d = data[i]
                if module is None:
                    module = ModuleStep(self.idcount, d["Module"],
                                        d["Params"])
                else:
                    moduleN = ModuleStep(self.idcount, d["Module"],
                                         d["Params"], childNode=module)
                    module = moduleN
                self.idcount += 1
        if module is None:
            raise Exception("frontEnd:createModuleStep error: module is None")
        else:
            return module


if __name__ == "__main__":
    parser = MDFParser()
    # parser.parse("simon.mdf")
    parser.compile("simon.mdf")
