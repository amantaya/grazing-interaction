# what I want to do

# Setup environment by loading in paths to working directories and packages

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory and environment variables
source(paste0(getwd(), "/environment.R"))

# load in the required libraries
source(paste0(currentwd, "/packages.R"))

# copy columns into the blank excel macro
# "RecordNumber, ImageFilename, ImagePath, ImageRelative, ImageSize, ImageTime, ImageDate, ImageAlert"

# TODO set this up to loop through all chunks in a collection folder

chunk_name <- "chunk1"

path_to_chunk_csv <- file.path(path_to_collection_folder, "metadata", paste0(collection_folder, "_subjects_", chunk_name, ".csv")) 

chunk1_csv <- readr::read_csv(path_to_chunk_csv)

chunk1_discard_columns <- chunk1_csv %>% 
  dplyr::select(RecordNumber, ImageFilename, ImagePath, ImageRelative, ImageSize, ImageTime, ImageDate, ImageAlert)

# copy the template excel macro from the git repo into the camera trap folder on the external hard drive

from <- file.path(currentwd, "excelmacro", "HorseImaging-2020-White-Mountains.xlsm")

to <- file.path(path_to_collection_folder, chunk_name)

file.copy(from=from, to=to)

#### Add Warning Message If File Is Not Copied ####

# trim the "/home/rstudio/cameratraps/wildcat/exclosure/WCX_05212019_07102019/101EK113" from the "ImageRelative" column
# we want to keep just the file name because the excel macro is going to default to relative image paths
# and altering the rel path to just the filename will tell the macro to look inside just the "chunk" folder
chunk1_relpaths_split_into_list <- stringr::str_split(chunk1_discard_columns$ImageRelative, "/")

keep.last.split.in.file.path <- function(character_vector, pattern){
  # create an empty object to hold the output of the function
  keep_last_object <- NULL
  
  # string split the character vector on a character or pattern
  all_subjects_string_split <- stringr::str_split(character_vector, pattern)
  
  # lengths() detects the number of objects in each list
  # create an index for the last object in a list using the lengths() func
  num_data_objects <- lengths(all_subjects_string_split)
  
  last_object <- num_data_objects
  
  # index the list and keep only the last object
  for (i in 1:length(all_subjects_string_split)) {
    keep_last_object[i] <- all_subjects_string_split[[i]][last_object[i]]
  }
  return(keep_last_object)
}

chunk1_discard_columns$ImageRelative <- keep.last.split.in.file.path(chunk1_discard_columns$ImageRelative, "/")

# name the macro by the chunk number
from <- file.path(path_to_collection_folder, chunk_name, "HorseImaging-2020-White-Mountains.xlsm")

xlsm_file_name <- paste0(collection_folder, "_subjects_", chunk_name, ".xlsm")

to <- file.path(path_to_collection_folder, chunk_name, xlsm_file_name)

file.rename(from = from, to = to)

#### Add Warning Message if File Is Not Renamed ####

# copy and paste the data from the csv file into the macro
# the data from the csv file has been corrected and the unnecessary columns dropped
xlsm_workbook <- openxlsx::loadWorkbook(file.path(path_to_collection_folder, chunk_name, xlsm_file_name))

chunk1_discard_columns_df <- as.data.frame(chunk1_discard_columns)

# somewhat confusingly, "writeData" writes data to workbook object bound to R
# but those changes are not yet saved to the file
openxlsx::writeData(xlsm_workbook, "ImageData", chunk1_discard_columns, startCol = 1, startRow = 2, colNames = FALSE)

# write out a filled macro
openxlsx::saveWorkbook(xlsm_workbook, file.path(path_to_collection_folder, chunk_name, xlsm_file_name), overwrite = TRUE)
