# load in the required libraries
library(tidyverse)
library(stringi)
library(readr)

# print the current R version in the console to check if your R version matches mine (which is 4.0.3)
R.Version()

# print the session info to check which language locale is currently configured for this environment
# this is important because the locale sets the text file encoding on the OS
sessionInfo()

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory to read in the files from the correct location on your hard drive (or on an external hard drive)
setwd("C:/TEMP/A51_06112019_07022019/metadata")

# double check the working directory to make sure its correct
getwd()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv("A51_06112019_07022019.csv")

# convert the data frame into a tibble to improve its behavior when printed in the console
all_photos_in_collection_tibble <- as_tibble(all_photos_in_collection)

# print the tibble in the console to check its contents
all_photos_in_collection_tibble

# read in the text files from the metadata folder
# these text files may have an encoding error, if so, open them in Notepad++ and save the encoding as UTF-8
# TODO implement a fix that converts the encoding to UTF-8 if necessary
subject_txt_files <- list.files(getwd(), pattern = ".txt")

# print the list of files (stored in a character vector) in the console to check which text files were read into the R environment
subject_txt_files

readLines(con <- file("Unicode.txt", encoding = "UCS-2LE"))
close(con)

# test how the readLines() function from the base R package differs from read_lines in 
first_subjects_text_file <- readLines(subject_txt_files[1])

# check if files are properly encoded as UTF-8
stri_enc_isutf8(first_subjects_text_file)

stri_enc_mark(first_subjects_text_file)

stri_encode(first_subjects_text_file, "ASCII", "UTF-8") # re-mark encodings

stri_enc_mark(first_subjects_text_file)

# create an empty vector to hold all of the photos with subjects
all_subjects_vector <- NULL

subject_text_files_raw <- read_lines_raw(subject_txt_files[1])


write_lines(subject_text_files_raw, "C:/TEMP/", append = FALSE)

# use this for loop to read in all of subject text files and append (add) them to the vector
for (i in 1:length(subject_txt_files)){
  all_subjects_vector <- append(all_subjects_vector, read_lines(subject_txt_files[i]))
  }

# print the character vector in the console to check the structure of the character strings
all_subjects_vector_utf8 <- enc2utf8(all_subjects_vector)

# print the encoded utf8 character vector
all_subjects_vector_utf8

# the character strings are stored in the R environment as \\ (double-backslashes) which are reserved characters
# replace these reserved characters with a single forward-slash, which is how R reads in file paths 
# (Windows 10 uses a single back-slash for file paths)
all_subjects_vector_string_replaced <- str_replace_all(all_subjects_vector, "\\\\", "/")

# print the character vector to check the structure of the character strings
all_subjects_vector_string_replaced

# convert the vector containing all of photos with subjects into a tibble
# this will improve its display behavior in the console
all_subjects_tibble <- as_tibble(all_subjects_vector_string_replaced)
all_subjects_tibble

# rename the first column in the tibble to something more descriptive
names(all_subjects_tibble)[names(all_subjects_tibble) == "value"] <- "path"

# print the tibble in the console to see how its display behavior changed
all_subjects_tibble

# separate the tibble into multiple columns for better display in the console
# this will also make it easier to subset the tibble
all_subjects_tibble_separated_into_columns <- separate(all_subjects_tibble, path, into = c("rootfolder","mainfolder", "locationfolder", "sitefolder", "collectionfolder", "subfolder", "file"), sep = "/", remove = FALSE)

# print the tibble in the console to check its structure
all_subjects_tibble_separated_into_columns

# compare the subjects tibble to all of the photos in the collection to check for matching photos
# the %in% checks for matches from the left object in the object to the right
# if the name of file in the subjects tibble matches the name of the file in the all photos tibble, it will report as TRUE
# all values should report as TRUE because the subjects tibble is a subset of the all photos tibble
all_subjects_tibble_separated_into_columns$file %in% all_photos_tibble$ImageFilename

# reversing matching function should illustrate how it works
# in this case, it is looking for matches in the all photos tibble using the file names in the subjects tibble
# only some of the values should report as TRUE (i.e. they match) because not all photos contain subjects
all_photos_tibble$ImageFilename %in% all_subjects_tibble_separated_into_columns$file

# now that we have identified which files contain subjects by reading in the text files created by IrFanView
# we want to copy them to a "subjects" sub-folder in the file directory
# that way we can run the Excel macro on only the photos that contain subjects, greatly speeding up the scoring process
# define explicitly where the files are coming from, and where we want to copy them to
# TODO ideally we can use relative file paths to copy files rather than absolute file paths
from <- as.character(all_subjects_tibble_separated_into_columns$path)
to <- "C:/TEMP/subjects_test_copy"

# copy the photos containing subjects into the folders locations defined in the previous step
file.copy(from, to, overwrite = FALSE)
