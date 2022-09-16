# rename the photos inside of temp folder on my desktop
# command will not rename folders, only JPG files
# photos are renamed by their file modified date
# photos with the same modified date are suffixed with an underscore and a number
C:\Program` Files\BRC64\BRC64.exe /DIR:"C:\Users\andre\Desktop\temp" /NOFOLDERS /RECURSIVE /PATTERN:"*.JPG" /REMOVENAME /APPENDDATE:M:P::-:10:"%Y-%m-%d-%H-%M-%S" /NODUP /EXECUTE
