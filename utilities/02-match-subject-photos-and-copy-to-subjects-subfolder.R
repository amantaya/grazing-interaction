# clear the R environment
rm(list=ls(all=TRUE))

# load in the required libraries
source("C:/Users/andre/Dropbox/Rproj/Horse-Cattle-Elk-Grazing-Interaction-Study/packages.R")

# set the working directory and environment variables
source("C:/Users/andre/Dropbox/Rproj/Horse-Cattle-Elk-Grazing-Interaction-Study/environment.R")

getwd()

# print the current R version in the console to check if your R version matches mine (which is 4.0.3)
R.Version()

# print the session info to check which language locale is currently configured for this environment
# this is important because the locale sets the text file encoding on the OS
sessionInfo()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv(paste0(getwd(), paste0("/metadata/", collection_folder, ".csv")))

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

# print the list of files (stored in a character vector inside R) in the console to check which text files were read into the R environment
first_subjects_text_file

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
# TODO this function needs to accept strings with different lengths/sections
# I could do this by string splitting each text file separately, then combining only the sections that I need after
# I could then write out the correct text files 
all_subjects_separated <- do.call("rbind", strsplit(all_subjects_vector_string_replaced, split = "/"))

# TODO instead of using the inputs of the student's file paths and cutting out the back half of the string
# this script would replace the front half of student's file paths and replace the string with the location of the files on the external hard drives

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
# collection <- all_subjects_df[ , ncol(all_subjects_df) - 2]

# collection

# extract the second column from the last
sub_folder <- all_subjects_df[ , ncol(all_subjects_df) - 1]

sub_folder

# extract the last column
subject_photos <- all_subjects_df[ , ncol(all_subjects_df)]

subject_photos

# compare the subjects tibble to all of the photos in the collection to check for matching photos
# the %in% checks for matches from the left object in the object to the right
# if the name of file in the subjects tibble matches the name of the file in the all photos tibble, it will report as TRUE
# all values should report as TRUE because the subjects tibble is a subset of the all photos tibble
subject_photos %in% all_photos_in_collection$ImageFilename

# reversing matching function should illustrate how it works
# in this case, it is looking for matches in the all photos tibble using the file names in the subjects tibble
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
write.csv(all_photos_in_collection_add_subjects_column, file = paste0("metadata/", excelfilename), row.names=F)

# now that we have identified which files contain subjects by reading in the text files created by IrFanView
# we want to copy them to a "subjects" sub-folder in the file directory
# that way we can run the Excel macro on only the photos that containing subjects, greatly speeding up the scoring process

# define explicitly where the files are coming from, and where we want to copy them to
# this function uses vectors defined in a previous step to create file paths for our external hard drives
from <- file.path(root_folder, main_folder, location_folder, site_folder, collection_folder, sub_folder, subject_photos)

to <- paste0(getwd(), "/subjects")

# copy the photos containing subjects into the folders locations defined in the previous step
file.copy(from, to, overwrite = FALSE)

# TODO Add a some logic to check if files were not copied due to incorrect paths
# one way to do this would be to compare the number of observations on the all subjects data frame to the number of copied files

close.connection(con)

# play a sound to indicate the transfer is complete
beep("coin")
