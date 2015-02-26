#!/usr/bin/env python
# Pig Module Framework Compiler Driver

import sys
from frontend import MDFCompiler
import pdb

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
    pdb.set_trace()
    outFile.write(result.encode('utf8'))
