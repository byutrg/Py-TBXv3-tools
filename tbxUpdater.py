import re
from lxml import etree
from steamroller import *
def updater(filename):
    fileTree = etree.parse(filename)
    root = fileTree.getroot()
    print (root.tag)
    if root.tag == "{urn:iso:std:iso:30042:ed-2}tbx":
        return "Already TBXv3"
    elif root.tag == "martif":
            file = open(filename)
            string = file.read()
            newString = string
            newString = re.sub("martif>", "tbx>", newString)
            newString = re.sub("martifHeader", "tbxHeader", newString)
            newString = re.sub("<martif", "<tbx style='dca' xmlns='urn:iso:std:iso:30042:ed-2'", newString)
            newString = re.sub("termEntry", "conceptEntry", newString)
            newString = re.sub("langSet", "langSec", newString)
            newString = re.sub("tig", "termSec", newString)
            newString = re.sub("refObjectList", "refObjectSec", newString)
            newfile = open("newfile.tbx", "w")
            newfile.write(newString)
            TbxBasic = steamroll(newFile)

            return "Updated"