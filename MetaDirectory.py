#!/usr/bin/env python
import os
import sys
import lxml.etree as etree
import win32com.client
import string

import comtypes
import comtypes.shelllink
import comtypes.client
import comtypes.persist

if len(sys.argv) < 5:
	print "Usage"
	print '  %s "Target Dir" "XSLT File" "Source Dir" "Static.XML"' % sys.argv[0]
	sys.exit(2)

strTargetRoot = unicode(sys.argv[1])
strXSLTFilename = sys.argv[2]
strSourceRoot = unicode(sys.argv[3])

if len(sys.argv) > 4:
	strXMLStaticFilename = sys.argv[4]
else:
	strXMLStaticFilename = None


def translate_non_alphanumerics(to_translate, translate_to=u'.'):
	not_letters_or_digits = u'*?"<>|:'
	if isinstance(to_translate, unicode):
		translate_table = dict(
			(ord(char), unicode(translate_to))
			for char in not_letters_or_digits)
	else:
		assert isinstance(to_translate, str)
		translate_table = string.maketrans(
			not_letters_or_digits,
			translate_to * len(not_letters_or_digits))
	return to_translate.translate(translate_table)

# Read XSLT File
xmlXsltRoot = etree.parse(strXSLTFilename)
xmlXSLT = etree.XSLT(xmlXsltRoot)

# Create shortcut
objShortCut = comtypes.client.CreateObject(comtypes.shelllink.ShellLink)
objShortCutUnicode = objShortCut.QueryInterface(comtypes.shelllink.IShellLinkW)
objShortCutFile = objShortCut.QueryInterface(comtypes.persist.IPersistFile)

print "SourceDirectory : %s " % strSourceRoot.encode(sys.stdout.encoding, 'replace')
# Loop recursive dirs
for strRoot, __, straFilenames in os.walk(strSourceRoot):
	# Loop files
	for strFilename in straFilenames:

		# Try to find ADS file 
		strDocPathFilename = os.path.join(strRoot, strFilename)
		strXMLPathFilename = strDocPathFilename + ":MetaDirectory.xml"
		# If ADS file does not exist tr with XML file 
		if os.path.isfile(strXMLPathFilename) is False:
			strXMLPathFilename = None
			strDocPathFilename = None
		
			# Check if file is XML file
			if strFilename.endswith(".xml") is True:
				strXMLPathFilename = os.path.join(strRoot, strFilename)
				strDocPathFilename, __ = os.path.splitext(strXMLPathFilename)
				# Filter only those that have media file
				if os.path.isfile(strDocPathFilename) is False:
					strXMLPathFilename = None
					strDocPathFilename = None

		# If ADS or XML file is found 
		if strXMLPathFilename is not None:
				print "File : %s " % strDocPathFilename.encode(sys.stdout.encoding, 'replace')
				# Create XML object
				xmlRoot = etree.Element('data')
				# Load media XML file
				fXmlSource = open(strXMLPathFilename)
				xmlSource = etree.parse(fXmlSource)
				xmlRoot.append(xmlSource.getroot())
				# Add DocumentFileName element
				__, strDocFilename = os.path.split(strDocPathFilename)
				xmlDocFilenameElem = etree.Element("DocumentFileName")
				xmlDocFilenameElem.text = strDocFilename
				xmlRoot.append(xmlDocFilenameElem)
				# Load Static XML
				if strXMLStaticFilename is not None:
					xmlStatic = etree.parse(strXMLStaticFilename)
					xmlRoot.append(xmlStatic.getroot())
				# Transform with XSLT
				xmlDest = xmlXSLT(xmlRoot)
				# Loop all directory links
				for xmlItem in xmlDest.findall('item'):
					if xmlItem.text:
						strTargetPath = translate_non_alphanumerics(xmlItem.text)
						strShortCutPathFilename = strTargetRoot + "/" + strTargetPath + ".lnk"
						print "\tLink : %s " % (strTargetPath.encode(sys.stdout.encoding, 'replace'))
						if os.path.isfile(strShortCutPathFilename) is False:
							# Create directories
							strShortCutPath, __ = os.path.split(strShortCutPathFilename)
							if os.path.isdir(strShortCutPath) is False:
								os.makedirs(strShortCutPath)
							# Set shortcut path
							objShortCutUnicode.SetPath(strDocPathFilename)
							# Save shortcut
							objShortCutFile.Save(strShortCutPathFilename, True)
					else:
						print "Empty String: Check XSLT!"
