import pdb
class ModuleLoader:

    @classmethod
    def loadModule(cls, fileName):
        try:
            with open(fileName) as data_file:
                content = data_file.read()
                moduleName = cls.getStringBetween(content=content,
                                                  sStart="@Module:",
                                                  sEnd="@Parameters:")
                outAliase = cls.getStringBetween(content=content,
                                                 sStart="@OutAliase:",
                                                 sEnd="@OutFields:")
                outFields = cls.getStringBetween(content=content,
                                                 sStart="@OutFields:",
                                                 sEnd="@TemplateCode:")
                templateCode = cls.getStringToEnd(content=content,
                                                  sStart="@TemplateCode:")

                # getting outFields array from string
                outFields = outFields.replace(",", "")
                outFields = outFields.split(" ")
            return {"moduleName": moduleName,
                    "outAliase": outAliase,
                    "outFields": outFields,
                    "templateCode": templateCode}
        except IOError:
            print "IOERROR"
            return None
        except EnvironmentError:
            print "loadModule ERROR"
            return None

    @staticmethod
    def getStringToEnd(content, sStart):
        startP = content.find(sStart)
        if (startP == -1):
            print "error moduel format"
            return -1
        result = content[startP + len(sStart):]
        return result.strip()

    @staticmethod
    def getStringBetween(content, sStart, sEnd):
        startP = content.find(sStart)
        endP = content.find(sEnd)
        if (startP == -1 or endP == -1):
            print "error moduel format"
            return -1

        result = content[startP + len(sStart):endP]
        return result.strip()

if __name__ == "__main__":
    print ModuleLoader.loadModule("moduleFile/A1.md")
    print ModuleLoader.loadModule("moduleFile/B.md")
