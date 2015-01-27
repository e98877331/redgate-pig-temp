import json


def loadMDF(fileName):
    with open(fileName) as mdfFile:
        jsonArr = json.load(mdfFile)

    return jsonArr

