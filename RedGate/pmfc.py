# Pig Module Framework Compiler Driver

import sys
from frontend import MDFCompiler


argv = sys.argv
argc = len(sys.argv)

if argc == 1:
    print "No input file"
    print "USAGE: python pmfc.py input.mdf output.pig"
    exit()

outFileName = ""

if argc == 2:
    outFileName = "compiledResult.pig"
elif argc == 3:
    outFileName = argv[2]

compiler = MDFCompiler()
result = compiler.compile(argv[1])

with open(outFileName, "w") as outFile:
    outFile.write(result)
