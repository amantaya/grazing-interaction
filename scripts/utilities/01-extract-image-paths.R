###########################################################################
###########################################################################
###                                                                     ###
###               SECTION 1: BACKGROUND AND CONFIGURATION               ###
###                                                                     ###
###########################################################################
###########################################################################

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

############################################################################
############################################################################
###                                                                      ###
###                    SECTION 2: SETUP R ENVIRONMENT                    ###
###                                                                      ###
############################################################################
############################################################################

# set the working directory and environment variables
source("~/grazing-interaction/environment.R")

# load in the required packages
source("~/grazing-interaction/packages.R")

############################################################################
############################################################################
###                                                                      ###
###                 SECTION 3: SELECT FOLDERS TO EXTRACT                 ###
###                                                                      ###
############################################################################
############################################################################

# TODO remove the Boolean switch and
is_single_folder <- TRUE

# intialize an empty object to hold paths to the folders we want to extract
path_to_collection_folder <- NULL

# create a variable to hold the file name in case we switch to a different project
# and the file name is different we can switch it once here
file <- "Heber Project Kanban.md"

# read in the kanban board for the Heber project
heber_project_kanban <- readr::read_lines(file.path("~",
                                                    "grazing-interaction",
                                                    "docs",
                                                    "heber-project-notes",
                                                    file)
                                          )

# slice the kanban board and get just the metadata tasks
# this index will need to be changed if the line numbers change on the kanban board
folders_that_need_metadata <- heber_project_kanban[44:80]

# use a regular expression to extract only the name of the folder we want to extract metadata from
# disregarding any markdown formatting associated with the folder

# the "cameratraps" folders use a different naming scheme than the "cameratraps2" folders
cameratraps_regex_pattern <- "[[:upper:]][[:upper:]][[:upper:]]_\\d{8}_\\d{8}"

cameratraps_pattern_matches <- stringr::str_extract(folders_that_need_metadata,
                                                    pattern = cameratraps_regex_pattern)

# return only the pattern matches that were not NA
cameratraps_folders_to_extract <- cameratraps_pattern_matches[is.na(cameratraps_pattern_matches) == FALSE]

cameratraps2_regex_pattern <- "[[:upper:]][[:upper:]][[:upper:]]\\d\\d_\\d{8}_\\d{8}"

cameratraps2_pattern_matches <- stringr::str_extract(folders_that_need_metadata,
                                                    pattern = cameratraps2_regex_pattern)

cameratraps2_folders_to_extract <- cameratraps2_pattern_matches[is.na(cameratraps2_pattern_matches) == FALSE]

# create a data frame with a "site" column that we can use to contruct file paths
cameratraps_folders_df <-
  data.frame("site" = stringr::str_extract(cameratraps_folders_to_extract,
                                          pattern = "[[:upper:]][[:upper:]][[:upper:]]"),
             "collection_folder" = cameratraps_folders_to_extract)

for (i in 1:length(cameratraps_folders_df)) {
  if (cameratraps_folders_df$site[i] == "BRL") {
    cameratraps_folders_df$relative_path[i] <- file.path("~", "cameratraps", "bear", "timelapse")
  } else if (cameratraps_folders_df$site[i] == "BKT") {
    cameratraps_folders_df$relative_path[i] <- file.path("~", "cameratraps", "blackcanyon", "trail")
  }
}


cameratraps_folders_df$full_path <- file.path(
  cameratraps_folders_df$relative_path, cameratraps_folders_df$collection_folder)

# create file paths for the "cameratraps" folders
path_to_collection_folder <- cameratraps_folders_df$full_path


cameratraps2_folders_df <-
  data.frame("site" = stringr::str_extract(cameratraps2_folders_to_extract,
                                           pattern = "[[:upper:]][[:upper:]][[:upper:]]\\d\\d"),
             "collection_folder" = cameratraps2_folders_to_extract)

cameratraps2_folders_df$relative_path <- file.path("~", "cameratraps2", cameratraps2_folders_df$site)

cameratraps2_folders_df$full_path <- file.path(
  cameratraps2_folders_df$relative_path, cameratraps2_folders_df$collection_folder)

# create file paths for the "cameratraps" folders
folders_to_extract_df <- dplyr::bind_rows(cameratraps_folders_df, cameratraps2_folders_df)

path_to_collection_folder <- folders_to_extract_df$full_path

collection_folder <- folders_to_extract_df$collection_folder

all_folders_to_extract <- path_to_collection_folder

# if you want to loop through multiple folders include all of the collection folders
# OR you can specify a single collection folder
# if (is_single_folder == TRUE) {
#   all_folders_to_extract <- path_to_collection_folder
# } else {
  # scan the directory for all of the collections
#  all_folders_to_extract <- list.dirs(path_to_collection_folder, recursive = FALSE, full.names = TRUE)

  # exlcude "subjects" sub-directories from each collection folder
  # this is to prevent duplicate entries in the CSV files
  # from re-extracting a collection folder (for whatever reason)
#  all_folders_to_extract_exclude_subjects_folders <- all_folders_to_extract[!grepl("subjects", all_folders_to_extract)]

  # also exlcude the "metadata" folders from extracting
#  all_folders_to_extract_exclude_metadata_folders <- all_folders_to_extract_exclude_subjects_folders[!grepl("metadata", all_folders_to_extract_exclude_subjects_folders)]

  # reassign the values into the original object
#  all_folders_to_extract <- all_folders_to_extract_exclude_metadata_folders
# }

# check that all "subjects" and "metadata" folders will be excluded from extracting their file metadata
# print(all_folders_to_extract)

# list the subfolders in the folders we want to extract
# this will be the "full" list that we will then cut down to only the folders we want to extract
# list_of_folders_in_folders_to_extract <- list.dirs(all_folders_to_extract)

# create a wildcard pattern that will be use to select only the folders created by the cameratrap
# 100EK113, 101EK113, etc
# subfolder_wildcard <- "*EK113"

# include only the folders matching on the wildcard pattern
# include_only_ek113_subfolders <- grep(subfolder_wildcard, list_of_folders_in_folders_to_extract, value = TRUE)

# overwrite the variable so we don't have to refactor the code below
# all_folders_to_extract <- include_only_ek113_subfolders

# list ONLY jpg files from ONLY the *EK113 subfolders and append to a list

############################################################################
############################################################################
###                                                                      ###
###             SECTION 4: EXTRACT METADATA FROM EACH FOLDER             ###
###                                                                      ###
############################################################################
############################################################################

for (i in 1:length(all_folders_to_extract)) {

  # create a new object to hold the image paths
  imagefiles <- NULL

  ## make a list of all the JPEGs in the file, if images are stored in some other format, update the code below
  imagefiles <- append(imagefiles, list.files(path = all_folders_to_extract[i], pattern = c(".JPG|.jpg"), full.names = TRUE, recursive = TRUE))

  ## create a data.frame from the list of all image files and extract metadata associated with each image
  imagefilesinfo <- as.data.frame(do.call("rbind", lapply(imagefiles, file.info)))

  imagefilesinfo <- imagefilesinfo[,c("size","mtime")]

  imagefilesinfo$ImagePath <- imagefiles

  imagefilesinfo$ImageRelative <- do.call("rbind", lapply(strsplit(imagefiles, split = paste(collection_folder[i], "/", sep="")), rev))[,1]

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
  excelfilename <- paste0(collection_folder[i], ".csv")


  # create a "metadata" directory if one doesn't already exist in the collection folder
  if (dir.exists(paste0(path_to_collection_folder[i], "/metadata")) == FALSE) {
    dir.create(paste0(path_to_collection_folder[i], "/metadata"))
  } else {

  }

  for (j in 1:nrow(imagefilesinfo)) {
    con <- file(imagefilesinfo$ImagePath[j])
    md5hash <- openssl::md5(con)
    print(md5hash)

    con <- file(imagefilesinfo$ImagePath[j])
    sha256hash <- openssl::sha256(con)
    print(sha256hash)

    imagefilesinfo$md5[j] <- as.character(md5hash)
    imagefilesinfo$sha256[j] <- as.character(sha256hash)
  }

  write.csv(imagefilesinfo, file = paste0(path_to_collection_folder[i], "/metadata/", excelfilename), row.names = FALSE)

  # play a sound to indicate the transfer is complete
  # beep("coin")

# hashfilename <- paste(rev(strsplit(currentfolder, split="/")[[1]])[1], "_MD5.csv", sep="")

# myfile <- system.file(imagefilesinfo$ImagePath)

# openssl::md5(file(myfile))
# openssl::sha256(file(myfile))
# beep("mario")
# toc()

  # get the current system time to notify when the script is completed
  # note that this defaults to UTC (aka Greenwich Mean Time)
  system_time <- Sys.time()

  # convert into the correct timezone for your locale (mine is Arizona so we follow Mountain Standard)
  attr(system_time,"tzone") <- "MST"

  msg_body <- paste("01-extract-image-paths.R", "run on folder", collection_folder[i], "completed at", system_time, sep = " ")

  RPushbullet::pbPost(type = "note", title = "Script Completed", body = msg_body)

}
