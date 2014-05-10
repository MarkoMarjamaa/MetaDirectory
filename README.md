MetaDirectory
=============

Creating searchable meta directory structures from XML metadata

http://flow-morewithless.blogspot.fi/2014/04/metadirectory-creating-searchable-meta.html

Building executable:
python pyinstaller.py -F  MetaDirectory.py
Open file \PyInstaller-2.1\MetaDirectory\build\MetaDirectory\out00-Analysis.toc

and replace line (depending where your Python is ) 
 [('include\\pyconfig.h', 'C:\\Python27\\include\\pyconfig.h', 'DATA'), ('Include\\pyconfig.h', 'C:\\Python27\\Include\\pyconfig.h', 'DATA')],
with 
 [('include\\pyconfig.h', 'C:\\Python27\\include\\pyconfig.h', 'DATA')],
then run bulid again:
python pyinstaller.py -F  MetaDirectory.py
