import unittest
import os
import json
import pdb

from frontend import MDFCompiler


class TestFrontend(unittest.TestCase):
    sp = os.path.dirname(__file__)
    compiler = None

    def setUp(self):
        self.compiler = MDFCompiler()
        self.compiler.addSearchPath([os.path.join(self.sp, "modules/")])

    def tearDown(self):
        pass

    def loadFile(self):
        fp = os.path.join(self.sp, "in/sample1.mdf")
        with open(fp) as inFile:
            jsonArr = json.load(inFile)

        return jsonArr

    def test_getAndAddSearchPath(self):
        path = self.compiler.getSearchPath()
        self.assertEqual(path, ['modules/', 'moduleFile/'])
        self.compiler.addSearchPath(["test/path1/", "test/path2/"])
        path2 = self.compiler.getSearchPath()
        self.assertEqual(path2, ['test/path1/', 'test/path2/',
                                 'modules/', 'moduleFile/'])

    def test_parseDataLoader(self):
        jsonArr = self.loadFile()
        loaders = jsonArr["DataLoaders"]
        # compiler = MDFCompiler()
        out = self.compiler.parseDataLoader(loaders)

        self.assertEqual(len(out), 4)
        self.assertEqual(out[0].moduleName, u"DataLoader")
        self.assertEqual(out[1].moduleName, u"DataLoader2")
        self.assertEqual(out[2].moduleName, u"DataLoader3")
        self.assertEqual(out[3].moduleName, u"DataLoader4")


if __name__ == '__main__':
    unittest.main()
