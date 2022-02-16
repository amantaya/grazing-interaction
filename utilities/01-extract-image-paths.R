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
source(paste0(getwd(), "/packages.R"))

# start the benchmark 
# this will time how long it takes to extract the metadata from all of the photos
# and compute file hashes for each photo in the collection (if enabled- it can take a very long time to run)
tic("run entire script")

# if you want to loop through multiple folders include all of the collection folders
# OR you can specify a single collection folder
if (is_single_folder == TRUE) {
  all_folders_to_extract <- path_to_collection_folder
} else {
  # scan the directory for all of the collections
  all_folders_to_extract <- list.dirs(path_to_collection_folder, recursive = FALSE, full.names = TRUE)
  
  # exlcude "subjects" sub-directories from each collection folder
  # this is to prevent duplicate entries in the CSV files 
  # from re-extracting a collection folder (for whatever reason)
  all_folders_to_extract_exclude_subjects_folders <- all_folders_to_extract[!grepl("subjects", all_folders_to_extract)]
  
  # also exlcude the "metadata" folders from extracting
  all_folders_to_extract_exclude_metadata_folders <- all_folders_to_extract_exclude_subjects_folders[!grepl("metadata", all_folders_to_extract_exclude_subjects_folders)]
  
  # reassign the values into the original object
  all_folders_to_extract <- all_folders_to_extract_exclude_metadata_folders
}

# check that all "subjects" and "metadata" folders will be excluded from extracting their file metadata
print(all_folders_to_extract)

# list the subfolders in the folders we want to extract
# this will be the "full" list that we will then cut down to only the folders we want to extract
list_of_folders_in_folders_to_extract <- list.dirs(all_folders_to_extract)

# create a wildcard pattern that will be use to select only the folders created by the cameratrap
# 100EK113, 101EK113, etc
subfolder_wildcard <- "*EK113"

# include only the folders matching on the wildcard pattern
include_only_ek113_subfolders <- grep(subfolder_wildcard, list_of_folders_in_folders_to_extract, value = TRUE)

# overwrite the variable so we don't have to refactor the code below
all_folders_to_extract <- include_only_ek113_subfolders

# create a new object to hold the image paths
imagefiles <- NULL

# list ONLY jpg files from ONLY the *EK113 subfolders and append to a list
# TODO this may not work with multiple collections folders, ideally each collection folder should be done one at a time
for (i in 1:length(all_folders_to_extract)) {
  
  currentfolder <- all_folders_to_extract[i]
  
  ## make a list of all the JPEGs in the file, if images are stored in some other format, update the code below
  imagefiles <- append(imagefiles, list.files(path = currentfolder, pattern = c(".JPG|.jpg"), full.names = TRUE))
  
  }

  ## create a data.frame from the list of all image files and extract metadata associated with each image	
  imagefilesinfo <- as.data.frame(do.call("rbind", lapply(imagefiles, file.info)))
  
  imagefilesinfo <- imagefilesinfo[,c("size","mtime")]
  
  imagefilesinfo$ImagePath <- imagefiles
  
  imagefilesinfo$ImageRelative <- do.call("rbind", lapply(strsplit(imagefiles, split = paste(collection_folder, "/", sep="")), rev))[,1]
  
  imagefilesinfo$ImageFilename <- do.call("rbind", lapply(strsplit(imagefiles, split="/"), rev))[,1]
  
  imagefilesinfo$ImageTime <- gsub("[[:space:]]", "",substr(as.character(imagefilesinfo$mtime),regexpr(":",imagefilesinfo$mtime)-2,regexpr(":",imagefilesinfo$mtime)+5))
  
  imagefilesinfo$ImageDate <- gsub("[[:space:]]", "",substr(as.character(imagefilesinfo$mtime),1,10))
 
  imagefilesinfo$RecordNumber <- seq(1:length(imagefilesinfo$ImagePath))
  
  imagefilesinfo$ImageSize <- as.numeric(imagefilesinfo$size)
  
  imagefilesinfo <- imagefilesinfo[,c(8,5,3,4,9,6,7)]
  
  imagefilesinfo['md5'] <- NA
  
  imagefilesinfo['sha256'] <- NA
  
  #remove images of size 0 - some cameras have image write-errors that cannot be processed
  # imagefilesinfo<-imagefilesinfo[imagefilesinfo$ImageSize!=0,]
  
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
  excelfilename <- paste0(collection_folder, ".csv")
  
  
  # create a "metadata" directory if one doesn't already exist in the collection folder
  if (dir.exists(paste0(path_to_collection_folder, "/metadata")) == FALSE) {
    dir.create(paste0(path_to_collection_folder, "/metadata"))
  } else {
    
  }
  
  # for (i in 1:nrow(imagefilesinfo)) {
  #   con <- file(imagefilesinfo$ImagePath[i])
  #   md5hash <- openssl::md5(con)
  #   # print(md5hash)
  # 
  #   con <- file(imagefilesinfo$ImagePath[i])
  #   sha256hash <- openssl::sha256(con)
  #   # print(sha256hash)
  # 
  #   imagefilesinfo$md5[i] <- as.character(md5hash)
  #   imagefilesinfo$sha256[i] <- as.character(sha256hash)
  # }
  
write.csv(imagefilesinfo, file = paste0(path_to_collection_folder, "/metadata/", excelfilename), row.names = FALSE)
  
  # play a sound to indicate the transfer is complete
  # beep("coin")

# hashfilename <- paste(rev(strsplit(currentfolder, split="/")[[1]])[1], "_MD5.csv", sep="")

# myfile <- system.file(imagefilesinfo$ImagePath)

# openssl::md5(file(myfile))
# openssl::sha256(file(myfile))
# beep("mario")
toc()