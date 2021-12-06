## 23Jan2017
## D. Christianson
##
## This R Script when executed in R will create a .csv file (Comma seperated values) that stores the
## name, date and time of every photo in a folder.  All the data from this .csv file can then be copied into the 
## Excel form for photo classification.
## 
## This script should be stored in a directory with the photos to be classified. The photos can be in the same 
##	directory as this script and in subfolders within this directory.
## 
## If images are organized by trap-site, then naming image storage folders after each trap-site is good practice as 
## the image path (with the trapsite folder names) will be included in the data produced by this script.
## the name of the folder can be extracted from the image path using simple R commands (e.g., "substr()" or "rep()")
## or Excel functions (e.g. "=MID()") and trapsite names can be linked to trapsite covariates stored in anotther
## spreadsheet or file (using "match" in R or "vLOOKUP" in Excel)
##
## There are two sets of optional settings.
##		1. define a subset of the available images to include based on time (rather than all images)
##		2. define a schedule when an custom pop-up alter message will appear on the excel form.
##
## If these options are not desired, the entire script can be run in R without alteration. the code is annoated to provide 
## an explanation of the process, should this need to be update

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory and environment variables
source(paste0(getwd(), "/environment.R"))

# load in the required libraries
source(paste0(currentwd, "/packages.R"))

tic("run entire script")

# exiftoolr::install_exiftool()

# make a list of all the JPEGs in the file, if images are stored in some other format, update the code below
imagefiles<-list.files(path=currentfolder,full.names=T,pattern=c(".JPG|.jpg"),include.dirs = T,recursive=T)

# extract metadata associated with each image
# benchmark the time taken to read exif data
tic("read exif data")
exif_data <- exiftoolr::exif_read(path = imagefiles)
toc()

# convert the character column to a POSIXct DateTime class
# this may not be wholly necessary because we're writing out a CSV
exif_data$DateTimeOriginal <- exif_data %>% dplyr::pull(DateTimeOriginal) %>% lubridate::ymd_hms()

# create a data.frame from the list of all image files	
imagefilesinfo<-as.data.frame(imagefiles)

# add the file size from the exif data to the new data frame
imagefilesinfo$ImageSize <- exif_data %>% dplyr::pull(FileSize) %>% as.numeric()

# add the exif DateTime to the new data frame
# using the old column name "mtime" to preserve functionallity of old code
# TODO instead of storing it as the old column name "mtime" store it as a POSIXct
imagefilesinfo$mtime <- exif_data %>% dplyr::pull(DateTimeOriginal)

# add the file paths (full names) to the new data frame
imagefilesinfo$ImagePath<-imagefiles

# split the file name string, saving the last two splits to create a relative path
imagefilesinfo$ImageRelative<-do.call("rbind",lapply(strsplit(imagefiles,split=paste(currentfolder,"/",sep="")),rev))[,1]

# split the file name string, saving only the file name
imagefilesinfo$ImageFilename<-do.call("rbind",lapply(strsplit(imagefiles,split="/"),rev))[,1]

# split the "mtime" string, saving only the image time
imagefilesinfo$ImageTime<-gsub("[[:space:]]", "",substr(as.character(imagefilesinfo$mtime),regexpr(":",imagefilesinfo$mtime)-2,regexpr(":",imagefilesinfo$mtime)+5))

# split the "mtime" string, saving only the image date
imagefilesinfo$ImageDate<-gsub("[[:space:]]", "",substr(as.character(imagefilesinfo$mtime),1,10))

# create an index of the rows in the data frame
imagefilesinfo$RecordNumber<-seq(1:length(imagefilesinfo$ImagePath))

# move the "RecordNumber" column to the first position
imagefilesinfo <- imagefilesinfo %>% dplyr::relocate(RecordNumber, .before = 1)

# move the "ImageFilename" column to right after the "RecordNumber" column
imagefilesinfo <- imagefilesinfo %>% dplyr::relocate(ImageFilename, .after = RecordNumber)

# drop the "mtime" (modified time- which we changed to exif DateTimeOriginal)
# also drop the "imagefiles" column
imagefilesinfo <- imagefilesinfo %>% dplyr::select(-c(mtime, imagefiles))

# move the "ImageSize" column to right after the "ImageRelative" column
imagefilesinfo <- imagefilesinfo %>% dplyr::relocate(ImageSize, .after = ImageRelative)

#remove images of size 0 - some cameras have image write-errors that cannot be processed
imagefilesinfo<-imagefilesinfo[imagefilesinfo$ImageSize!=0,]

# ## OPTIONAL - DEFINE A SUBSET OF IMAGES TO PROCESS BASED ON A REGULAR TIME SCHEDULE
# #Make list of images to include by listing all years wanted (must be four-digit years: 2015,2016,...)
# useyears = c("2012","2013","2014","2015","2016","2017")
# #Make list of images to include by listing all months wanted (quotes are necessary as it must be two-digit months: c("01","02",...))
# usemonths = c("01","02","03","04","05","06","07","08","09","10","11","12")
# #Make list of images to include by listing all days of the month wanted (must be two-digit days: 01,02,...)
# usedays = c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31")
# #Make list of images to include by listing all hous of the day wanted (must be two-digit hours: 01,02,...)
# usehours = c("00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")
# #Now subset the list of all images to just those matching the time criteria above
# imagefilesinfo<-imagefilesinfo[which(substr(imagefilesinfo$ImageDate,1,4) %in% useyears &
#                                        substr(imagefilesinfo$ImageDate,6,7) %in% usemonths &
#                                        substr(imagefilesinfo$ImageDate,9,10) %in% usedays &
#                                        substr(imagefilesinfo$ImageTime,1,2) %in% usehours),]

## OPTIONAL - SET A TIME FOR A CUSTOM ALERT MESSAGE TO DISPLAY ON THE EXCEL FORM
# set an alert based on time or date, These images will all be included but the 'ImageAlert' will be set to True. If no Alert is Desired, set Alert=F.
# when an alert is set, a custom message can be defined to 'pop-up' on the excel form for every image with Altert set to TRUE.
# this feature is nice for reminding the user to record certain data types that are not necessarily recorded for every image (e.g. temperature)
# by default all years, months, days of the month, hours of the day, and minutes of the hour are listed for alerts which would slow down data entry
# as it would post the alert message on every image
Alert=FALSE

# If an alert is desired:
#Make list of images to alert by listing all years when alerts are wanted (must be four-digit years: 2015,2016,...)
alertyears = as.character(c(2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020))
#Make list of images to alert by listing all months when alerts are wanted (quotes are necessary as it must be two-digit months: c("01","02",...))
alertmonths = c("01","02","03","04","05","06","07","08","09","10","11","12")
#Make list of images to alert by listing all days of the month when alerts are wanted (must be two-digit days: 01,02,...)
alertdays = c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31")
#Make list of images to alert by listing all hours of the day when alerts are wanted (must be two-digit hours: 01,02,...)
alerthours = c("06","15")
#Make list of images to alert by listing all minutes of the hour wanted (must be two-digit minutes: 01,02,...)
alertminutes = c("00")
# this code will set the ImageAlert to "TRUE" for all images matching the above specified time conditions
if (Alert==T){
  imagefilesinfo$ImageAlert <- c(substr(imagefilesinfo$ImageDate,1,4) %in% alertyears & 
                                   substr(imagefilesinfo$ImageDate,6,7) %in% alertmonths & 
                                   substr(imagefilesinfo$ImageDate,9,10) %in% alertdays & 
                                   substr(imagefilesinfo$ImageTime,1,2) %in% alerthours & 
                                   substr(imagefilesinfo$ImageTime,4,5) %in% alertminutes)
} else {
  imagefilesinfo$ImageAlert<- FALSE
}

## write a .csv file named after the working directory containing the image data.  All the data from this .csv file should be copied into the 
## Excel form.  The .csv file will show up in the same directory as this script once this script is run.
excelfilename<-paste(rev(strsplit(currentfolder,split="/")[[1]])[1],".csv",sep="")

exif_filename <- paste0(paste(rev(strsplit(currentfolder,split="/")[[1]])[1], "exif", "metadata", sep = "_"),  ".csv")

# create a "metadata" directory if one doesn't already exist in the collection folder
if (dir.exists(paste0(currentfolder, "/metadata")) == FALSE) {
  dir.create(paste0(currentfolder, "/metadata"))
} else {
  
}

write.csv(imagefilesinfo, file = paste0(currentfolder, "/metadata/", excelfilename), row.names=F)

exif_data %>% readr::write_csv(file = file.path(currentfolder, "metadata", exif_filename))

# play a sound to indicate the transfer is complete
beep("coin")

toc()