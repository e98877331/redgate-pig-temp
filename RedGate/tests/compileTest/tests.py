import unittest
from os import listdir
import os

from frontend import MDFCompiler
import pdb

class TestCompileProcess(unittest.TestCase):
    sp = os.path.dirname(__file__)

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_compile(self):

        inDirPath = os.path.join(self.sp, "in")
        answerDirPath = os.path.join(self.sp, "answer")
        outDirPath = os.path.join(self.sp, "out")
        files = listdir(inDirPath)
        for f in files:

            compiler = MDFCompiler()
            result = compiler.compile(os.path.join(inDirPath, f))
            outFilePath = os.path.join(outDirPath, f.split('.')[0] + ".pig")
            with open(outFilePath, "w") as outFile:
                outFile.write(result.encode('utf8'))

            answerFilePath = os.path.join(answerDirPath,
                                          f.split('.')[0] + ".pig")
            with open(answerFilePath) as answerFile:
                answer = answerFile.read()

            # self.assertEqual(result.encode('utf8'), answer)
            self.assertEqual(result, answer.decode('utf8'))

if __name__ == '__main__':
    # print os.path.dirname(os.path.abspath(__file__))
    # print os.getcwd()
    unittest.main()

