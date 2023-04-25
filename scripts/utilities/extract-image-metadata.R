
library(exifr)
library(dplyr)

currentfolder<-getwd()

files <- list.files(path=getwd(),full.names=T,pattern=c(".JPG|.jpg"),include.dirs = T,recursive=T)
dat <- exifr::read_exif(files)

excelfilename<-paste(rev(strsplit(currentfolder,split="/")[[1]])[1],".csv",sep="")

write.csv(dat,excelfilename,row.names=F)
