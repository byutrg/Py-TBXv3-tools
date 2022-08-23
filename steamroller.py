import os
import sys
from xml import sax
import codecs
from lxml import etree

# TODO list in order of priority.
# TODO: Write output to log file
# TODO: Figure out something to do with non-matching picklist values (note or run similarity check?)
# TODO: Insert a <p> element saying the file was processed with steamroller
# TODO: Eliminate useless dictionaries taken from Perl version
# TODO: Run for more situation checking (multiple bad attributes in one line?

# Steamroller version
version = 1.2

# TBX Basic v3 Schema
declaration = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
v3Schema = '<?xml-model href="https://raw.githubusercontent.com/LTAC-Global/TBX-Basic_dialect/master/DCA/TBX-Basic_DCA.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>'
v3rngSchema = '<?xml-model href="https://raw.githubusercontent.com/LTAC-Global/TBX-Basic_dialect/master/DCA/TBXcoreStructV03_TBX-Basic_integrated.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>'

# Open logfile for recording changes made
logfile = open('steamroller_log.txt', 'w+')

# Dictionary of element compatibility, mapped parent to child
comp = {
    0: ['tbx'],
    'tbx': ['tbxHeader', 'text'],
    'tbxHeader': ['fileDesc', 'encodingDesc', 'revisionDesc'],
    'fileDesc': ['titleStmt', 'publicationStmt', 'sourceDesc'],
    'p': ['#PCDATA'],
    'titleStmt': ['title', 'note'],
    'title': ['#PCDATA'],
    'publicationStmt': ['p'],
    'sourceDesc': ['p'],
    'encodingDesc': ['p'],
    'revisionDesc': ['change'],
    'change': ['p'],
    'text': ['body', 'back'],
    'body': ['conceptEntry'],
    'back': ['refObjectSec'],
    'refObjectSec': ['refObject'],
    'refObject': ['item'],
    'item': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'conceptEntry': ['langSec', 'descrip', 'descripGrp', 'admin', 'transacGrp', 'note', 'ref', 'xref'],
    'langSec': ['termSec', 'descrip', 'descripGrp', 'admin', 'transacGrp', 'note', 'ref', 'xref'],
    'termSec': ['term', 'termNote', 'descrip', 'descripGrp', 'admin', 'transacGrp', 'note', 'ref', 'xref'],
    'term': ['#PCDATA', 'hi'],
    'termNote': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'descrip': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'descripGrp': ['descrip', 'admin'],
    'admin': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'transacGrp': ['transac', 'transacNote', 'date'],
    'note': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'ref': ['#PCDATA'],
    'xref': ['#PCDATA'],
    'trasnac': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'transacNote': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'date': ['#PCDATA'],
    'hi': ['#PCDATA'],
    'foreign': ['#PCDATA', 'hi', 'foreign', 'sc', 'ec', 'ph'],
    'sc': ['#PCDATA'],
    'ec': ['#PCDATA'],
    'ph': ['#PCDATA']
}

# Dictionary of element compatibility, child to possible parents
renp = {
    'tbxHeader': 'tbx',
    'text': 'tbx',
    'fileDesc': 'tbxHeader',
    'encodingDesc': 'tbxHeader',
    'revisionDesc': 'tbxHeader',
    'titleStmt': 'fileDesc',
    'publicationStmt': 'fileDesc',
    'sourceDesc': 'fileDesc',
    'title': 'titleStmt',
    'change': 'revisionDesc',
    'p': ['publicationStmt', 'sourceDesc', 'encodingDesc', 'change'],
    'body': 'text',
    'back': 'text',
    'conceptEntry': 'body',
    'placeholder': 'body',
    'refObjectSec': 'back',
    'refObject': 'refObjectSec',
    'item': 'refObject',
    'langSec': 'conceptSec',
    'termSec': 'langSec',
    'term': 'termSec',
    'termNote': 'termSec',
    'descrip': ['conceptEntry', 'langSec', 'termSec', 'descripGrp'],
    'descripGrp': ['conceptEntry', 'langSec', 'termSec'],
    'admin': ['conceptEntry', 'langSec', 'termSec', 'descripGrp'],
    'transacGrp': ['conceptEntry', 'langSec', 'termSec'],
    'note': ['titleStmt', 'conceptEntry', 'langSec', 'termSec'],
    'ref': ['conceptEntry', 'langSec', 'termSec'],
    'xref': ['conceptEntry', 'langSec', 'termSec'],
    'transac': ['conceptEntry', 'langSec', 'termSec', 'transacGrp'],
    'trasnacNote': 'transacGrp',
    'date': 'transacGrp',
    'hi': ['term', 'termNote', 'descrip', 'admin', 'note', 'transac', 'transacNote', 'foreign'],
    'foreign': ['termNote', 'descrip', 'admin', 'note', 'transac', 'transacNote', 'foreign'],
    'sc': ['termNote', 'descrip', 'admin', 'note', 'transac', 'transacNote', 'foreign'],
    'ec': ['termNote', 'descrip', 'admin', 'note', 'transac', 'transacNote', 'foreign'],
    'ph': ['termNote', 'descrip', 'admin', 'note', 'transac', 'transacNote', 'foreign'],
    '#PCDATA': ['title', 'note', 'p', 'item', 'term', 'termNote', 'descrip', 'admin', 'note', 'ref', 'xref',
                'transac', 'transacNote', 'date', 'hi', 'foreign', 'sc', 'ec', 'ph']
}

# Dictionary of all allowed attributes by element
atts = {
    'tbx': ['style', 'type', 'xml:lang', 'xmlns'],
    'tbxHeader': ['id'],
    'fileDesc': ['id'],
    'p': ['id', 'type', 'xml:lang'],
    'titleStmt': ['id', 'xml:lang'],
    'title': ['title', 'xml:lang'],
    'note': ['id', 'xml:lang'],
    'publicationStmt': ['id'],
    'sourceDesc': ['id', 'xml:lang'],
    'encodingDesc': 'id',
    'revisionDesc': ['id', 'xml:lang'],
    'change': ['id', 'xml:lang'],
    'text': ['id'],
    'body': ['id'],
    'back': ['id'],
    'refObjectSec': ['id', 'type'],
    'refObject': ['id'],
    'item': ['id', 'type'],
    'conceptEntry': ['id'],
    'langSec': ['id', 'xml:lang'],
    'termSec': ['id'],
    'term': ['id'],
    'termNote': ['id', 'xml:lang', 'type', 'target', 'datatype'],
    'descrip': ['id', 'xml:lang', 'type', 'target', 'datatype'],
    'descripGrp': ['id'],
    'admin': ['id', 'xml:lang', 'type', 'target', 'datatype'],
    'transacGrp': ['id'],
    'ref': ['id', 'xml:lang', 'type', 'target', 'datatype'],
    'xref': ['id', 'target', 'type'],
    'transac': ['id', 'xml:lang', 'type', 'target', 'datatype'],
    'transacNote': ['id', 'xml:lang', 'type', 'target', 'datatype'],
    'date': ['id'],
    'hi': ['type', 'target', 'xml:lang'],
    'foreign': ['id', 'xml:lang'],
    'sc': ['id', 'type'],
    'ec': ['id'],
    'ph': ['type'],
    '#PCDATA': ['']
}

# Compare datacategories within the attributes of the current element for validity
concomp = {
    'administrativeStatus': 'termNote',
    'geographicalUsage': 'termNote',
    'grammaticalGender': 'termNote',
    'partOfSpeech': 'termNote',
    'termLocation': 'TermNote',
    'termType': 'termNote',
    'context': 'descrip',
    'definition': 'descrip',
    'subjectField': 'descrip',
    'crossReference': 'ref',
    'externalCrossReference': 'xref',
    'xGraphic': 'xref',
    'customerSubset': 'admin',
    'projectSubset': 'admin',
    'source': 'admin',
    'responsibility': 'transacNote',
    'transactionType': 'transac',
    'DCSName': 'p',
    'XCSURI': 'p',
    'XCSContent': 'p',
    'respPerson': 'refObjectSec',
    'fn': 'item',
    'n': 'item',
    'nickname': 'item',
    'adr': 'item',
    'tel': 'item',
    'email': 'item',
    'title': 'item',
    'role': 'item',
    'bold': 'sc',
    'ulined': 'sc',
    'dulined': 'sc',
    'color': 'sc',
    'struct': 'sc',
    'italic': 'sc',
    'scap': 'sc',
    'font': 'sc',
    'link': 'sc',
    'index': 'ph',
    'time': 'ph',
    'enote': 'ph',
    'image': 'ph',
    'lb': 'ph',
    'inset': 'ph',
    'date': 'ph',
    'fnote': 'ph',
    'alt': 'ph',
    'pb': 'ph'
}

dataComp = {
    'termNote' : ['administrativeStatus', 'geographicalUsage','grammaticalGender',
                  'partOfSpeech','termLocation', 'termType'],
    'descrip' : ['context', 'definition', 'subjectField'],
    'ref' : ['crossReference'],
    'xref' : ['externalCrossReference', 'xGraphic'],
    'admin' : ['customerSubset', 'projectSubset', 'source'],
    'transacNote' : ['responsibility'],
    'transac' : ['transactionType'],
    'p' : ['DCSName', 'XCSURI', 'XCSContent'],
    'refObjectSec' : ['respPerson'],
    'item': ['fn', 'n', 'nickname', 'adr', 'tel', 'email', 'title',
             'role'],
    'sc': ['bold','ulined','dulined','color','struct','italic','scap',
           'font','link'],
    'ph': ['index','time','enote','image','lb','inset','date',
           'fnote','alt','pb']
}

picklist = {
    'administrativeStatus': ['preferredTerm-admn-sts', 'admittedTerm-admn-sts','deprecatedTerm-admn-sts',
                             'supersededTerm-admn-sts'],
    'grammaticalGender': ['masculine', 'feminine', 'neuter', 'other'],
    'partOfSpeech': ['noun', 'verb', 'adjective', 'adverb', 'properNoun', 'other'],
    'termType': ['abbreviation', 'acronym', 'fullForm', 'shortForm', 'variant', 'phrase'],
    'termLocation': ['checkBox', 'comboBox', 'comboBoxElement','dialogBox', 'groupBox', 'informativeMessage',
                    'interactiveMessage', 'menuItem', 'progressBar', 'pushButton', 'radioButton', 'slider',
                     'spinBox', 'tab', 'tableText', 'textBox', 'toolTip', 'user-definedType']
}

lowerPicklist = {
    "preferred": "preferredTerm-admn-sts",
    "admitted": "admittedTerm-admn-sts",
    "notrecommended": "deprecatedTerm-admn-sts",
    "obsolete": "supersededTerm-admn-sts",
    "preferredterm-admn-sts": "preferredTerm-admn-sts",
    "admittedterm-admn-sts": "admittedTerm-admn-sts",
    "deprecatedterm-admn-sts": "deprecatedTerm-admn-sts",
    "supersededterm-admn-sts": "supersededTerm-admn-sts",
    "masculine": "masculine",
    "feminine": "feminine",
    "neuter": "neuter",
    "other": "other",
    "noun": "noun",
    "verb": "verb",
    "adjective": "adjective",
    "adverb": "adverb",
    "propernoun": "properNoun",
    "abbreviation": "abbreviation",
    "acronym": "acronym",
    "fullform": "fullForm",
    "shortform": "shortForm",
    "variant": "variant",
    "phrase": "phrase",
    "checkbox": "checkBox",
    "combobox": "comboBox",
    "comboboxelement": "comboBoxElement",
    "dialogbox": "dialogBox",
    "groupbox": "groupBox",
    "informativemessage": "informativeMessage",
    "interactivemessagae": "interactiveMessage",
    "menuitem": "menuItem",
    "progressbar": "progressBar",
    "pushbutton": "pushButton",
    "radiobutton": "radioButton",
    "slider": "slider",
    "spinbox": "spinBox",
    "tab": "tab",
    "tabletext": "tableText",
    "textbox": "textBox",
    "tooltip": "toolTip",
    "user-definedtype": "user-definedType"
}

#TODO: if all lowercase does not work, return null string? Similarity check then note below?
def checkPickList(data, picklistvalue):
    validPicklist = picklist.get(picklistvalue)
    pickFound = False
    for pick in validPicklist:
        if data == pick:
            pickFound = True

        if data in pick:
            data = pick
            pickFound = True

    if pickFound is True:
        #print(f"Found data {data} in picklist!")
        return data

    data = data.replace(" ", "")

    for secondCheck in validPicklist:
        if data == secondCheck:
            pickFound = True

    if pickFound is True:
        #print(f"Found data {data} in picklist on second check!")
        return data

    data = data.lower()

    findPick = lowerPicklist.get(data)

    if findPick:
        #print(f"Found data {findPick} in picklist on third check!")
        return findPick
    else:
        #print(f"Did not find data {data} in picklist!")
        return None

# Content Handler for main Steamroller functionality
class TBXHandler(sax.ContentHandler):
    def __init__(self, outfile):
        self.outfile = outfile
        self.outfile.write(f"{declaration}\n{v3rngSchema}\n{v3Schema}\n")
        self.linecount = 4
        self.addtext = str()
        self.correctpicklisttags = str()
        self.incorrectpicklisttags = str()
        self.termnotestring = str()
        self.notecreated = False
        self.checkPicklist = False
        self.parsingterm = False
        self.picklistValue = ""

    def startElement(self, name, attrs):
        self.notecreated = False
        self.correctpicklisttags = ""
        self.incorrectpicklisttags = ""

        attributes = attrs.getNames()
        attributematch = False
        acceptableattributes = atts.get(name)

        if name == "termSec":
            print(f"termSec found at line# {self.linecount}")
            self.parsingterm = True

        for attribute in attributes:
            attributematch = False

            for a in acceptableattributes:
                if a == attribute:
                    attributematch = True

            # Check if legal attribute, if not, prepare to append to
            if attributematch is False:
                print(f"Attribute {attribute} on line {self.linecount} is not legal")
                self.addtext += (f"{attribute}::{attrs.getValue(attribute)}")
                self.notecreated = True

            # Get legal datacategory list for current attribute
            acceptabledatacategories = dataComp.get(name)

            datacategorymatch = False

            # Check if the value of the current attribute is legal
            if acceptabledatacategories is not None:
                for dc in acceptabledatacategories:
                    if dc == attrs.getValue(attribute):
                        datacategorymatch = True

            # Check for None
            if acceptabledatacategories is None:
                datacategorymatch = True

            if name == "xref":
                url = "http"
                if url in attrs.getValue(attribute):
                    datacategorymatch = True

            if datacategorymatch is False:
                # print(f"Datacategory {attrs.getValue(attribute)} is not legal")
                self.notecreated = True
                self.addtext += (f"{attrs.getValue(attribute)}::")

        # No illegal categories detected, print current tag as normal.
        if self.notecreated is False:
            self.correctpicklisttags += f"<{name}"
            self.incorrectpicklisttags += "<note>"

            for printattrs in attributes:
                # Bools to check for invalid attributes & replace them
                printTBXBasic = False
                conceptEntryID = False

                if name == "tbx":
                    if printattrs == "type":
                        printTBXBasic = True

                if name == "conceptEntry":
                    if printattrs == "id":
                        idData = attrs.getValue(printattrs)
                        if idData[0].isdigit():
                            conceptEntryID = True

                if attrs.getValue(printattrs) == "administrativeStatus":
                    self.checkPicklist = True
                    self.picklistValue = attrs.getValue(printattrs)
                    self.incorrectpicklisttags += f"{self.picklistValue}::"
                elif attrs.getValue(printattrs) == "grammaticalGender":
                    self.checkPicklist = True
                    self.picklistValue = attrs.getValue(printattrs)
                    self.incorrectpicklisttags += f"{self.picklistValue}::"
                elif attrs.getValue(printattrs) == "partOfSpeech":
                    self.checkPicklist = True
                    self.picklistValue = attrs.getValue(printattrs)
                    self.incorrectpicklisttags += f"{self.picklistValue}::"
                elif attrs.getValue(printattrs) == "termType":
                    self.checkPicklist = True
                    self.picklistValue = attrs.getValue(printattrs)
                    self.incorrectpicklisttags += f"{self.picklistValue}::"
                elif attrs.getValue(printattrs) == "termLocation":
                    self.checkPicklist = True
                    self.picklistValue = attrs.getValue(printattrs)
                    self.incorrectpicklisttags += f"{self.picklistValue}::"

                if printTBXBasic is True:
                    self.correctpicklisttags += (f" {printattrs}=\"TBX-Basic\"")
                elif conceptEntryID is True:
                    self.correctpicklisttags += (f" {printattrs}=\"C{attrs.getValue(printattrs)}\"")
                else:
                    self.correctpicklisttags += (f" {printattrs}=\"{attrs.getValue(printattrs)}\"")

            if name == "xref":
                self.correctpicklisttags += ("/>")
            else:
                self.correctpicklisttags += (">")
        else:
            name = "note"
            if self.parsingterm is True:
                print(f"Note found inside termSec on line {self.linecount}")
                self.termnotestring += f"<{name}>"
            else:
                self.outfile.write(f"<{name}>")

        if self.checkPicklist is False:
            self.outfile.write(self.correctpicklisttags)

    def endElement(self, name):
        if self.notecreated is True:
            name = "note"
            self.notecreated = False

        if name != "xref":
            if self.parsingterm is True:
                if name == "note":
                    self.termnotestring += f"</{name}>"
                elif name == "termSec":
                    print(f"termSec ends on line# {self.linecount}")
                    self.parsingterm = False
                    self.outfile.write(self.termnotestring)
                    self.termnotestring = ""
                    self.outfile.write(f"</{name}>")
                else:
                    self.outfile.write(f"</{name}>")
            else:
                self.outfile.write(f"</{name}>")


    def characters(self, data):
        if self.addtext:
            if self.parsingterm is True:
                self.termnotestring += self.addtext
            else:
                self.outfile.write(self.addtext)
            self.addtext = ""

        if data.isspace() is False:
            if self.checkPicklist is True:
                getPick = checkPickList(data, self.picklistValue)

                if getPick:
                    data = getPick
                    self.outfile.write(self.correctpicklisttags)
                else: # Did not make a match in looking for the picklist, create a note
                    if self.parsingterm is True:
                        print(f"Note found inside termSec on line {self.linecount}")
                        self.termnotestring += self.incorrectpicklisttags
                    else:
                        self.outfile.write(self.incorrectpicklisttags)

                    self.notecreated = True

                self.picklistValue = ""
                self.checkPicklist = False


        if self.notecreated is True:
            self.termnotestring += data
        else:
            self.outfile.write(data)

        if data == "\n":
            self.linecount = self.linecount + 1
def steamroll(filename):

    if not os.path.exists(filename):
        print("Selected file was not found. Please try again.")
        exit(1)

    # TODO: Check if all input files are expected to be TBX or if this code needs to be more flexible
    outfilename = filename.replace('.tbx', "Steamroller.tbx")

    # TODO: Append steamroller to file name, pass in as parameter for parser
    outfile = codecs.open(outfilename, 'w', encoding='UTF-8')

    parser = sax.make_parser()
    handler = TBXHandler(outfile)
    parser.setContentHandler(handler)

    # First parsing with Steamroller Content Handler
    parser.parse(filename)

    outfile.close()

    # Pretty print to fix spacing after re-arranging note elements
    prettyprintparser = etree.XMLParser(remove_blank_text=True)
    steamrolledtree = etree.parse(outfilename, prettyprintparser)
    steamrolledtree.write(outfilename, xml_declaration=True, encoding='UTF-8', pretty_print=True)


