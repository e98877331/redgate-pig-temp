from util.dlog import Dlog

import os
import pdb


class ModuleLoader:
    paths = ["moduleFile/"]

    def addSearchPath(self, path):
        self.paths = path + self.paths

    def getSearchPath(self):
        return self.paths

    # paths is array
    def loadModuleFromPaths(self, moduleName):
        for path in self.paths:
            filePath = os.path.join(path, moduleName)
            if os.path.isfile(filePath):
                return self.loadModule(filePath)
        raise Exception("ERROR: Module file \'" + moduleName + "\' not found.\
                        SearchPath:" + str(self.paths))
        return None

    def loadModule(self, fileName):
        try:
            with open(fileName) as data_file:
                content = data_file.read()
                moduleName = self.getStringBetween(content=content,
                                                   sStart="@Module:",
                                                   sEnd="@Parameters:")
                outAliase = self.getStringBetween(content=content,
                                                  sStart="@OutAliase:",
                                                  sEnd="@OutFields:")
                outFields = self.getStringBetween(content=content,
                                                  sStart="@OutFields:",
                                                  sEnd="@TemplateCode:")
                templateCode = self.getStringToEnd(content=content,
                                                   sStart="@TemplateCode:")

                # getting outFields array from string
                outFields = outFields.replace(",", "")
                outFields = outFields.split(" ")
            return {"moduleName": moduleName,
                    "outAliase": outAliase,
                    "outFields": outFields,
                    "templateCode": templateCode}
        except IOError, e:
            Dlog("moduleLoader", "IOERROR: " + str(e))
            return None
        except EnvironmentError, e:
            Dlog("moduleLoader", "loadModule Error")
            return None

    def getStringToEnd(self, content, sStart):
        startP = content.find(sStart)
        if (startP == -1):
            print "error moduel format"
            return -1
        result = content[startP + len(sStart):]
        return result.strip()

    def getStringBetween(self, content, sStart, sEnd):
        startP = content.find(sStart)
        endP = content.find(sEnd)
        if (startP == -1 or endP == -1):
            print "error moduel format"
            return -1

        result = content[startP + len(sStart):endP]
        return result.strip()

