## Horse-Cattle-Elk Grazing Interaction Study Rproj
## Step 2: Match Subject Photo Text Files and Copy to Subjects Sub-Folder

## What this script does:
## Reads in the subject text files from a photo collection folder
## Copies the subject photos from the text files to the "subjects" sub-folder
## Writes out a csv declaring if each photo in the collection contains a subject

## What this script requires:
## csv file from "01-extract-image-paths.R" containing all photos in a collection (this csv file needs to be located in the "metadata" sub-folder within the collection)
## subject text files (these text files need to be located in the "metadata" sub-folder within the collection)

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory and environment variables
source(paste0(getwd(), "/environment.R"))

# load in the required libraries
source(paste0(currentwd, "/packages.R"))

tic("run entire script")

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv(paste0(currentfolder, paste0("/metadata/", collection_folder, ".csv")))

# read in the text files from the metadata sub-folder
# be careful not to put any other files with the file extension ".txt" inside of the metadata sub-folder because this function will read them in to R
# TODO prevent reading in the "~all_subjects.txt" file in case this script is re-run on the same collection folder
subject_txt_files <- list.files(paste0(currentfolder, "/metadata"), pattern = ".txt", full.names = TRUE)

# print the list of files (stored in a character vector inside R) in the console to check which text files were read into the R environment
subject_txt_files

# open a file connection to the first text file (inside of each text file is a list of photo files that contain subjects)
# define the text file encoding explicitly because R has trouble recognizing this type of file encoding
# print the character string to the console to check if R read in the strings correctly
# if R misreads the text files, you will see embedded nulls, strange characters, or blank strings printed in the console
readLines(con <- file(subject_txt_files[1], encoding = "UCS-2LE"))

# store the photos with subjects from the first text file in the metadata subfolder into a character vector
# this will allow us to test converting from UCS-2LE to UTF-8
first_subjects_text_file <- readLines(con <- file(subject_txt_files[1], encoding = "UCS-2LE"))

# print the list of files (stored in a character vector inside R) in the console to check which text files were read into the R environment
first_subjects_text_file

length(first_subjects_text_file)

first_subjects_text_file[3:length(first_subjects_text_file)]

# create an empty vector to hold all of the photos with subjects
all_subjects_vector <- NULL

# use this for loop to read in all of subject text files and append (add) them to the vector
for (i in 1:length(subject_txt_files)){
  subjects_from_text_file <- readLines(con <- file(subject_txt_files[i], encoding = "UCS-2LE"))
  
  if (length(subjects_from_text_file) != 0) {
    
    number_of_lines_in_text_file <- length(subjects_from_text_file)
    
    all_subjects_vector <- append(all_subjects_vector, subjects_from_text_file[3:number_of_lines_in_text_file])
    
  } else{
      
    }
  }

# print the character vector in the console to check the structure of the character strings
all_subjects_vector

# TODO closing the file connection still results in warnings() printed in the console
# close the open file connections
closeAllConnections()

# the character strings are stored in the R environment as \\ (double-backslashes) which are reserved characters
# replace these reserved characters with a single forward-slash, which is how R reads in file paths 
# (Windows 10 uses a single back-slash for file paths)
all_subjects_vector_string_replaced <- str_replace_all(all_subjects_vector, "\\\\", "/")

# print the character vector to check the structure of the character strings
all_subjects_vector_string_replaced

# create a variable to hold the differences in number of characters in each string
character_count <- nchar(all_subjects_vector_string_replaced)

# display this character count as a summary table with counts
table(character_count)

# the path of each photo may be different on each computer so we need to make this script as flexible as possible to work on as many computers as possible
# we'll do this by splitting the file path string into multiple parts, discarding the parts of the string that we don't need

all_subjects_string_split <- stringr::str_split(all_subjects_vector_string_replaced, "/")
all_subjects_string_split

# lengths() detects the number of objects in each list
num_data_objects <- lengths(all_subjects_string_split)
num_data_objects

last_object <- num_data_objects

second_to_last_object <- num_data_objects - 1

# keep_last_object <- all_subjects_string_split[[1]][last_object[1]]
# keep_last_object
# 
# keep_second_to_last_object <- all_subjects_string_split[[1]][second_to_last_object[1]]
# keep_second_to_last_object
# 
# first_all_subjects_rebound <- str_c(keep_second_to_last_object, keep_last_object, sep = "/", collapse = "")
# first_all_subjects_rebound

all_subjects_keep_last_two_splits <- NULL
keep_last_object <- NULL
keep_second_to_last_object <- NULL

for (i in 1:length(all_subjects_string_split)) {
  
  keep_last_object[i] <- all_subjects_string_split[[i]][last_object[i]]

  keep_second_to_last_object[i] <- all_subjects_string_split[[i]][second_to_last_object[i]]

  all_subjects_keep_last_two_splits[i] <- str_c(keep_second_to_last_object[i],
                                                keep_last_object[i],
                                                sep = "/",
                                                collapse = "")

  # print(keep_second_to_last_object)
  # print(keep_last_object)
  # print(all_subjects_keep_last_two_splits)
}
# print the vector to check its contents
all_subjects_keep_last_two_splits

# this subsetting technique selects only the last two elements
# all_subjects_separated[[500]][8:9]

# this subsetting technique selects everything but the first 7 elements (leaving the last 2 elements)
# all_subjects_separated[[500]][-(1:7)]

# try indexing each string by keeping only the last characters representing the sub-folder (e.g., 100EK113) and the file name (e.g., 2019-06-05-11-08-18.JPG)
# all_subjects_vector_extract_substrings <- stringr::str_sub(all_subjects_vector_string_replaced, start = -32, end = -1)
# all_subjects_vector_extract_substrings

# using the current working directory, keep the first half of the working directory string
# append the working directory to string to the back half of the string containing the path to the sub-folder and filepath
all_subjects_vector_append_working_directory <- paste("~", main_folder, site_folder, collection_folder, all_subjects_keep_last_two_splits, sep = "/")

print(all_subjects_vector_append_working_directory)

# create a file name for the single subjects text file
textfilename <- paste(collection_folder, "all_subjects.csv", sep = "_")

print(textfilename)

all_subjects_df <- data.frame(all_subjects_vector_append_working_directory)

names(all_subjects_df) <- "path"

print(all_subjects_df)

# write out a single text file containing the concatenated subject text files
# encode this text file as UTF-8 depending on your locale
readr::write_csv(all_subjects_df, file = paste0(currentfolder, "/metadata/", textfilename))

# rename the first column in the tibble to something more descriptive
# names(all_subjects_vector_string_replaced)[names(all_subjects_vector_string_replaced) == "value"] <- "path"

# TODO instead of string splitting and then rbinding, it would be more efficient to just use the "~all_subjects.txt" to copy the subject photos into the subjects sub-folder
# however, this would require re-writing the photo matching logic because it's expecting a subjects vector

# split the path strings by their separator (forward slash "/")
# then row bind them together
all_subjects_separated <- do.call("rbind", strsplit(all_subjects_vector_append_working_directory, split = "/"))

# print the character vector to check if the string split worked correctly
# there should be multiple parts to each string if this worked correctly
all_subjects_separated

# covert the linked list into a data frame to improve it's behavior in the console
all_subjects_df <- as.data.frame(all_subjects_separated)

# print the data frame in the console to check its structure
all_subjects_df

# extract the third column from the last
collection <- all_subjects_df[ , ncol(all_subjects_df) - 2]

collection

# extract the second column from the last
sub_folder <- all_subjects_df[ , ncol(all_subjects_df) - 1]

sub_folder

# extract the last column
subject_photos <- all_subjects_df[ , ncol(all_subjects_df)]

subject_photos

# compare the subjects vector to all of the photos in the collection to check for matching photos
# the %in% checks for matches from the left object in the object to the right
# if the name of file in the subjects vector matches the name of the file in the all photos data frame, it will report as TRUE
# all values should report as TRUE because the subjects vector is a subset of the all photos data frame
subject_photos %in% all_photos_in_collection$ImageFilename

# reversing matching function should illustrate how it works
# in this case, it is looking for matches in the all photos data frame using the file names in the subjects vector
# only some of the values should report as TRUE (i.e. they match) because not all photos contain subjects
all_photos_in_collection$ImageFilename %in% subject_photos

# store all the subject photos that match to all the photos in the collection in a vector
photo_contains_subject <- all_photos_in_collection$ImageFilename %in% subject_photos

# create a new column in the all photos data frame that identifies that if the photo has a subject
# i.e. if SubjectPhoto = TRUE then that photo has been recorded in the subject text files as having something in it (i.e. a subject)
all_photos_in_collection_add_subjects_column<- add_column(all_photos_in_collection, SubjectPhoto = photo_contains_subject)

# print this data frame in the console to view the new column
all_photos_in_collection_add_subjects_column

# create a flexible excel file name that uses the first row of the collection folder
excelfilename <- paste0(paste(collection_folder, "matched_subject_photos", sep = "_"), ".csv")

# write the new csv to the working directory
# we can use this new file at a later point (for machine learning) to identify empty photos from photos with something in them 
write.csv(all_photos_in_collection_add_subjects_column, file = paste0(currentfolder, "/metadata/", excelfilename), row.names=F)

# now that we have identified which files contain subjects by reading in the text files created by IrFanView
# we want to copy them to a "subjects" sub-folder in the file directory
# that way we can run the Excel macro on only the photos that containing subjects, greatly speeding up the scoring process

# define explicitly where the files are coming from, and where we want to copy them to
# this function uses vectors defined in a previous step to create file paths for our external hard drives
from <- file.path(root_folder, main_folder, site_folder, collection_folder, sub_folder, subject_photos)

to <- paste0(currentfolder, "/subjects")

# make a subjects folder if one doesn't already exist
# create a "metadata" directory if one doesn't already exist in the collection folder
if (dir.exists(paste0(currentfolder, "/subjects")) == FALSE) {
  dir.create(paste0(currentfolder, "/subjects"))
} else {
  
}

# copy the photos containing subjects into the folders locations defined in the previous step
file.copy(from, to, overwrite = FALSE)

# TODO Add a some logic to check if files were not copied due to incorrect paths
# one way to do this would be to compare the number of observations on the all subjects data frame to the number of copied files

# play a sound to indicate the transfer is complete
beep("coin")
toc()