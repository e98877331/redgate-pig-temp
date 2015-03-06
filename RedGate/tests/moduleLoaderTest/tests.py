import unittest
import os
import json
import pdb

from loader.moduleLoader import ModuleLoader


class TestModuleLoader(unittest.TestCase):
    sp = os.path.dirname(__file__)

    def setUp(self):

        pass

    def tearDown(self):
        pass

    def test_load(self):

        loader = ModuleLoader()
        loader.addSearchPath(["tests/moduleLoaderTest/modules/"])
        a = loader.loadModuleFromPaths("DataLoader.md")
        answerDic = {'templateCode': "dataLoader = LOAD '$dataPath' USING PigStorage('\\u0001') AS (LogId:chararray, UniqueId:chararray, DomainName:chararray, Url:chararray, IPAddress:chararray, DumpTime:chararray, Referer:chararray, SessionId:chararray, ECId:chararray, ProductId:chararray);", 'outFields': ['UniqueId:chararray', 'DomainName:chararray', 'Url:chararray', 'IPAddress:chararray', 'DumpTime:chararray', 'Referer:chararray', 'SessionId:chararray', 'ECId:chararray', 'ProductId:chararray'], 'moduleName': 'DataLoader', 'outAliase': 'dataLoader'}
        self.assertDictEqual(a, answerDic)

        # pdb.set_trace()

#if __name__ == "__main__":
#    print ModuleLoader.loadModule("moduleFile/A1.md")
#    print ModuleLoader.loadModule("moduleFile/B.md")

if __name__ == '__main__':
    unittest.main()
