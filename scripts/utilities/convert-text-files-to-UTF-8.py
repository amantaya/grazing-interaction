import os
import sys
from Npp import notepad

filePathSrc = "G:\cameratraps2\GEO02\GEO02_20210625_20210703\metadata" # Path to the folder with files to convert

filePathSrc = filePathSrc.decode('utf-8')
os.chdir(filePathSrc)
for root, dirs, files in os.walk(".", topdown = False):
    for fn in files:
        if fn[-4:] == '.txt': 
			notepad.open(root + "\\" + fn)             
			notepad.runMenuCommand("Encoding", "Convert to UTF-8")			 
			notepad.save()
			console.write('File ' + fn + ' saved. Closing ... \n')
			notepad.close()
