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

#clear the R environment
rm(list=ls(all=TRUE))

# J:\cameratraps\fiftyone\timelapse\A51_07022019_08132019

# Define the location of the files on the external hard drive
root_folder <- "J:"

main_folder <- "cameratraps"

location_folder <- "fiftyone"

site_folder <- "timelapse"

collection_folder <- "A51_07022019_08132019"

subjects_folder <- "subjects"

# set the working directory to read in the files from the correct location on your hard drive (or on an external hard drive)
setwd(file.path(root_folder, main_folder, location_folder, site_folder, collection_folder))

# double check the working directory to make sure its correct
getwd()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv(paste0(getwd(), paste0("/metadata/", collection_folder, "_matched_subject_photos", ".csv")))

# select only the subject photos from within the collection
subject_photos_in_collection <- dplyr::filter(all_photos_in_collection, SubjectPhoto == TRUE)

# set the desired chunk size, i.e. how many rows from the data frame will be in each chunk
chunk_size <- 500

# determine the number of subject photos
# be careful not to confuse the "n_rows" object with the function "nrow"
n_rows <- nrow(subject_photos_in_collection)

# the ceiling function takes an single numeric argument x
# and returns a numeric vector containing the smallest integers not less than the corresponding elements of x.
# example: ceiling(3.3) = 4
n_chunks <- ceiling(n_rows/chunk_size)

# create an object to fold the pattern created from 1 to the number of chunks
# the number of chunks is dependent on the chunk size
# if there are 1000 rows and chunk size = 500, then only 2 chunks will be created
# if there are 1000 rows and chunk size = 100, then 10 chunks will be created
chunk_number <- rep(1:n_chunks)

# create a vector to hold character strings that will be used to name directories and csv files
chunk_names <- paste0("chunk", chunk_number)

# divide the number of rows in the data frame by the desired chunk size
# then create a repeating pattern of the chunk number (chunk 1, chunk 2, etc) multiplied by the chunk size
# i.e. if chunk_size = 500, then chunk 1 will be rep(1, each = 500)
# then subset the resulting pattern by the number of rows, which will remove the "excess" rows 
# created by the last chunk which has less rows than the chunk size
pattern  <- rep(1:ceiling(n_rows/chunk_size), each = chunk_size)[1:n_rows]

# split the subject photos into chunks of 500
chunks <- split(subject_photos_in_collection, pattern)

# extract the column names from the subjects data frame
# chunking messed up the file names so we're going to overwrite the column names with the correct column names
# column_names <- colnames(subject_photos_in_collection)

# for (i in chunk_number) {
#  colnames(chunks[i]) <- column_names
# }

# create a new directory to hold each group of 500 photos
# these directories will be temporary and can be deleted after scoring each group of photos
# this for loop creates a new directory for each chunk
for (i in chunk_number) {
  dir.create(file.path(root_folder, main_folder, location_folder, site_folder, collection_folder, chunk_names[i]))
}

# copy the subject photos for each chunk into their corresponding folder
for (i in chunk_number) {
  
  from <- file.path(root_folder, main_folder, location_folder, site_folder, collection_folder, chunks[[i]]$ImageRelative)
  
  to <- file.path(root_folder, main_folder, location_folder, site_folder, collection_folder, chunk_names[i])
  
  file.copy(from, to, overwrite = FALSE)
}

# run the extract-image-paths script on each group of photos to generate 
# name each csv file the collection folder and the name of the chunk (e.g., BGT_07302019_09182019_subjects_chunk1.csv)
for (i in chunk_number) {
  excelfilename <- paste0(paste(collection_folder, subjects_folder, chunk_names[i], sep = "_"), ".csv")
  write.csv(chunks[[i]], excelfilename, row.names=FALSE)
}

beep("coin")

