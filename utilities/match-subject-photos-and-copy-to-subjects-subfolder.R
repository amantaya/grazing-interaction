# load in the required libraries
library(tidyverse)
library(stringi)

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directoy to read in the files from the correct location on your hard drive or on an external hard drive
setwd("C:/TEMP/A51_06112019_07022019/metadata")

# double check the working directory to make sure its correct
getwd()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv("A51_06112019_07022019.csv")

# convert the data frame into a tibble to improve its behavior when printed in the console
all_photos_tibble <- as_tibble(all_photos_in_collection)

# print the tibble in the console to check its contents
all_photos_tibble

# read in the text files from the metadata folder
# these text files may have an encoding error, if so, open them in Notepad++ and save the encoding as UTF-8
# TODO implement a fix that converts the encoding to UTF-8 if necessary
subject_txt_files <- list.files(getwd(), pattern = ".txt")
subject_txt_files

# first_subfolder_subjects<- read_lines("metadata/BRL-06052019-07022019-100EK113-subjects.txt")

# create an empty vector that will hold all of the photos with subjects
all_subjects_vector <- NULL

# use this for loop to read in all of subject text files and append (add) them to the vector
for (i in 1:length(subject_txt_files)){
  all_subjects_vector <- append(all_subjects_vector, read_lines(subject_txt_files[i]))
  }

all_subjects_vector

# test <- writeLines(all_subjects_vector)

all_subjects_vector_string_replaced <- str_replace_all(all_subjects_vector, "\\\\", "/")
# all_subjects_vector_string_replaced_2 <- str_replace(all_subjects_vector_string_replaced, "/", "\\")
all_subjects_vector_string_replaced

# convert the vector containing all of photos with subjects into a tibble to improve its display behavior in the console
all_subjects_tibble <- as_tibble(all_subjects_vector_string_replaced)
all_subjects_tibble

# rename the first column in the tibble
names(all_subjects_tibble)[names(all_subjects_tibble) == "value"] <- "path"

# separate the tibble into multiple columns for easier reading
all_subjects_tibble_separated_into_columns <- separate(all_subjects_tibble, path, into = c("rootfolder","mainfolder", "locationfolder", "sitefolder", "collectionfolder", "subfolder", "file"), sep = "/", remove = FALSE)
all_subjects_tibble_separated_into_columns

# compare the subjects tibble to the all of the photos in the collection to check for matching photos
# if the name of file in the subjects tibble matches the name of the file in the all photos tibble it will report as TRUE
all_subjects_tibble_separated_into_columns$file %in% all_photos_tibble$ImageFilename

from <- as.character(all_subjects_tibble_separated_into_columns$path)
to <- "C:/TEMP/subjects_test_copy"

file.copy(from, to, overwrite = FALSE)
