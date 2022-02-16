## Horse-Cattle-Elk Grazing Interaction Study Rproj
## Step 3: Chunk Subject Photos and Copy to Sub-Folder

## What this script does:
## Reads in the csv file from the photo collection metadata folder
## Copies the subject photos from the column into separate folders (chunks)
## Writes out a csv for each chunk of photos
## this csv can then be copied and pasted into the excel macro (HorseImaging2018.xlsm) for scoring 

## What this script requires:
## the csv file from "02-match-subject-photos-and-copy-to-subjects-subfolder.R" 
## this csv file should be located in the "metadata" sub-folder within the collection folder
## this csv file is named by the photo collection folder and "~matched_subject_photos.csv" 
## e.g., BRT_11052019_12072019_matched_subject_photos.csv
tic("run entire script")
# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory and environment variables
source(paste0(getwd(), "/environment.R"))

# load in the required libraries
source(paste0(currentwd, "/packages.R"))

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv(paste0(path_to_collection_folder, paste0("/metadata/", collection_folder, "_matched_subject_photos", ".csv")))

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
  dir.create(file.path(path_to_collection_folder, chunk_names[i]))
}

# copy the subject photos for each chunk into their corresponding folder
for (i in chunk_number) {
  
  from <- file.path(chunks[[i]]$ImagePath)
  
  to <- file.path(path_to_collection_folder, chunk_names[i])
  
  file.copy(from, to, overwrite = FALSE)
}

# run the extract-image-paths script on each group of photos to generate 
# name each csv file the collection folder and the name of the chunk (e.g., BGT_07302019_09182019_subjects_chunk1.csv)
for (i in chunk_number) {
  excelfilename <- paste0(paste(collection_folder, subjects_folder, chunk_names[i], sep = "_"), ".csv")
  write.csv(chunks[[i]], paste0(path_to_collection_folder, "/metadata/", excelfilename), row.names=FALSE)
}

# beep("coin")
toc()
