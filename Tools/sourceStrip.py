#recursively stips non header files from a directory.

import os

myPath = os.path.dirname(os.path.realpath(__file__))

includePath = myPath + "/../Dolphin/Include"

for dirName, subdirList, fileList in os.walk(includePath):
    for fname in fileList:
        if fname[-2:] != ".h":
            os.remove(dirName+"/"+fname)