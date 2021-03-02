# Remove duplicate photos script
# Before using this script, you MUST rename the photos using the Bulk Rename Tool using command line script
# Doing so ensures that there is a difference in file names between the duplicates and the original files

rm(list=ls(all=TRUE))

setwd("C:/temp/duplicates")

wd <- getwd()

# read in the photo file names
imagefiles<-list.files(path=getwd(),full.names=T,pattern=c(".JPG|.jpg"),include.dirs = T,recursive=T)

# create a data.frame from the list of all image files and extract metadata associated with each image
# this may take several minutes depending on the number of files
imagefilesinfo<-as.data.frame(do.call("rbind",lapply(imagefiles,file.info)))
imagefilesinfo<-imagefilesinfo[,c("size","mtime")]
imagefilesinfo$ImagePath<-imagefiles
imagefilesinfo$ImageRelative<-do.call("rbind",lapply(strsplit(imagefiles,split=paste(currentfolder,"/",sep="")),rev))[,1]
imagefilesinfo$ImageFilename<-do.call("rbind",lapply(strsplit(imagefiles,split="/"),rev))[,1]
imagefilesinfo$ImageTime<-gsub("[[:space:]]", "",substr(as.character(imagefilesinfo$mtime),regexpr(":",imagefilesinfo$mtime)-2,regexpr(":",imagefilesinfo$mtime)+5))
imagefilesinfo$ImageDate<-gsub("[[:space:]]", "",substr(as.character(imagefilesinfo$mtime),1,10))
imagefilesinfo$RecordNumber<-seq(1:length(imagefilesinfo$ImagePath))
imagefilesinfo$ImageSize<-as.numeric(imagefilesinfo$size)
imagefilesinfo<-imagefilesinfo[,c(8,5,3,4,9,6,7)]

# remove images of size 0 - some cameras have image write-errors that cannot be processed
imagefilesinfo<-imagefilesinfo[imagefilesinfo$ImageSize!=0,]

# selects files that have file names less than or equal to 12 characters
# if you renamed the photos using the Bulk Rename Tool, then the correct file names should 23 characters
imagefilesinfo_dupl <- subset(imagefilesinfo, nchar(imagefilesinfo$ImageFilename) <= 12)

# removes duplicate files from you system- use carefully!
file.remove(imagefilesinfo_dupl$ImagePath)
