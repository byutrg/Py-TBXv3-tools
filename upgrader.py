from re import T


def upgrade(filename):
    import re
    import lxml

    file = open(filename)

    filestring = file.read()

    tree = lxml.etree.parse(filestring)
    if tree[0].tag == "tbx":
        return "This is a TBXv3 file already"
    elif tree[0].tag == "martif":
        return "TBXv2"
    else:
        return "Not a tbx file"