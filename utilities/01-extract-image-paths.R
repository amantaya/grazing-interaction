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

# load in the required libraries
library(packrat)
library(tidyverse)
library(stringi)
library(beepr)

# print the current R version in the console to check if your R version matches mine (which is 4.0.3)
R.Version()

# print the session info to check which language locale is currently configured for this environment
# this is important because the locale sets the text file encoding on the OS
sessionInfo()

# clear the R environment
rm(list=ls(all=TRUE))

# J:\cameratraps\blackcanyon\timelapsesouth\BKS_10222020_10252020

root_folder <- "J:"

main_folder <- "cameratraps"

location_folder <- "blackcanyon"

site_folder <- "timelapsesouth"

collection_folder <- "BKS_10222020_10252020"

# set the working directory to read in the files from the correct location on your hard drive (or on an external hard drive)
# the files you need to access might be in a different location on your computer therefore you likely will need to change the line below
currentfolder <- file.path(root_folder, main_folder, location_folder, site_folder, collection_folder)

setwd(currentfolder)

getwd()

## make a list of all the JPEGs in the file, if images are stored in some other format, update the code below
imagefiles<-list.files(path=currentfolder,full.names=T,pattern=c(".JPG|.jpg"),include.dirs = T,recursive=T)

## create a data.frame from the list of all image files and extract metadata associated with each image	
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

write.csv(imagefilesinfo, file = paste0("metadata/", excelfilename),row.names=F)

# play a sound to indicate the transfer is complete
beep("coin")

