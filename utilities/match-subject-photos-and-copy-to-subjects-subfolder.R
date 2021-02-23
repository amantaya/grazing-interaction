# load in the required libraries
library(packrat)
library(tidyverse)
library(stringi)

# print the current R version in the console to check if your R version matches mine (which is 4.0.3)
R.Version()

# print the session info to check which language locale is currently configured for this environment
# this is important because the locale sets the text file encoding on the OS
sessionInfo()

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory to read in the files from the correct location on your hard drive (or on an external hard drive)
# the files you need to access might be in a different location on your computer therefore you likely will need to change the line below
setwd(file.path("J:", "cameratraps", "boggy", "trail", "BGT_06252019_07302019"))

# double check the working directory to make sure its correct
getwd()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv("metadata/BGT_06252019_07302019.csv")

# read in the text files from the metadata sub-folder
# be careful not to put any other files with the file extension ".txt" inside of the metadata sub-folder because this function will read them in to R
subject_txt_files <- list.files(paste0(getwd(), "/metadata"), pattern = ".txt", full.names = TRUE)

# print the list of files (stored in a character vector inside R) in the console to check which text files were read into the R environment
subject_txt_files

# open a file connection to the first text file (inside of each text file is a list of photo files that contain subjects)
# define the text file encoding explicitly because R has trouble recognizing this type of file encoding
# print the character string to the console to check if R read in the strings correctly
# if R misreads the text files, you will see embedded nulls or blank strings printed in the console
readLines(con <- file(subject_txt_files[1], encoding = "UCS-2LE"))

# store the photos with subjects from the first text file in the metadata subfolder into a character vector
# this will allow us to test converting from UCS-2LE to UTF-8
first_subjects_text_file <- readLines(con <- file(subject_txt_files[1], encoding = "UCS-2LE"))

# create an empty vector to hold all of the photos with subjects
all_subjects_vector <- NULL

# use this for loop to read in all of subject text files and append (add) them to the vector
for (i in 1:length(subject_txt_files)){
  all_subjects_vector <- append(all_subjects_vector, readLines(con <- file(subject_txt_files[i], encoding = "UCS-2LE")))
  }

# print the character vector in the console to check the structure of the character strings
all_subjects_vector

# the character strings are stored in the R environment as \\ (double-backslashes) which are reserved characters
# replace these reserved characters with a single forward-slash, which is how R reads in file paths 
# (Windows 10 uses a single back-slash for file paths)
all_subjects_vector_string_replaced <- str_replace_all(all_subjects_vector, "\\\\", "/")

# print the character vector to check the structure of the character strings
all_subjects_vector_string_replaced

# rename the first column in the tibble to something more descriptive
# names(all_subjects_vector_string_replaced)[names(all_subjects_vector_string_replaced) == "value"] <- "path"

# the path of each photo may be different on each computer so we need to make this script as flexible as possible to work on as many computers as possible
# we'll do this by splitting the file path string into multiple parts, throwing away the parts of the string that we don't need
# i.e. we'll use the absolute path and use it create relative paths
all_subjects_separated <- do.call("rbind", strsplit(all_subjects_vector_string_replaced, split = "/"))

# print the character vector to check if the string split worked correctly
# there should be multiple parts to each string if this worked correctly
all_subjects_separated

# covert the linked list into a data frame to improve it's behavior in the console
all_subjects_df <- as.data.frame(all_subjects_separated)

# print the data frame in the console to check its structure
all_subjects_df

# subset the data frame to make the file paths relative rather than absolute
# there are many ways to do this, in our case we want to be as flexible as possible to account for differences in computers

# extract the third column from the last
collection_folder <- all_subjects_df[ , ncol(all_subjects_df) - 2]

# extract the second column from the last
sub_folder <- all_subjects_df[ , ncol(all_subjects_df) - 1]

# extract the last column
subject_photos <- all_subjects_df[ , ncol(all_subjects_df)]

# separate the tibble into multiple columns for better display in the console
# this will also make it easier to subset the tibble
# all_subjects_tibble_separated_into_columns <- separate(all_subjects_tibble, path, into = c("rootfolder","", "locationfolder", "sitefolder", "collectionfolder", "subfolder", "file"), sep = "/", remove = FALSE)

# compare the subjects tibble to all of the photos in the collection to check for matching photos
# the %in% checks for matches from the left object in the object to the right
# if the name of file in the subjects tibble matches the name of the file in the all photos tibble, it will report as TRUE
# all values should report as TRUE because the subjects tibble is a subset of the all photos tibble
# all_subjects_tibble_separated_into_columns$file %in% all_photos_in_collection_tibble$ImageFilename

# reversing matching function should illustrate how it works
# in this case, it is looking for matches in the all photos tibble using the file names in the subjects tibble
# only some of the values should report as TRUE (i.e. they match) because not all photos contain subjects
# all_photos_in_collection_tibble$ImageFilename %in% all_subjects_tibble_separated_into_columns$file

# now that we have identified which files contain subjects by reading in the text files created by IrFanView
# we want to copy them to a "subjects" sub-folder in the file directory
# that way we can run the Excel macro on only the photos that containing subjects, greatly speeding up the scoring process

# define explicitly where the files are coming from, and where we want to copy them to
# this function uses vectors defined in a previous step to create file paths for our external hard drives
from <- file.path("J:", "cameratraps", "boggy", "trail", collection_folder, sub_folder, subject_photos)

to <- paste0(getwd(), "/subjects")

# copy the photos containing subjects into the folders locations defined in the previous step
file.copy(from, to, overwrite = FALSE)

# TODO create an csv output that matches the all_photos_in_collection_tibble to the all_subjects_tibble
# and writes a csv file that says "subject? = TRUE" or conversely "empty = FALSE"
# probably subject = TRUE makes more sense