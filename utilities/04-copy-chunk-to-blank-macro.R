# what I want to do

# Setup environment by loading in paths to working directories and packages

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory and environment variables
source(paste0(getwd(), "/environment.R"))

# load in the required libraries
source(paste0(currentwd, "/packages.R"))

# list all of the chunk subfolders in the collection
subfolders_in_collection_folder_relative_path <- list.dirs(path_to_collection_folder, full.names = FALSE)

subfolders_in_collection_folder_absolute_path <- list.dirs(path_to_collection_folder, full.names = TRUE)

# create a wildcard pattern that we can use to match just the "chunk" subfolders
chunk_wildcard <- "chunk*"

# use a global regular expression to match and return just the "chunk" subfolders
chunk_subfolders_in_collection_folder <- grep(chunk_wildcard, subfolders_in_collection_folder_relative_path, value = TRUE)

chunk_subfolders_absolute_paths <- grep(chunk_wildcard, subfolders_in_collection_folder_absolute_path, value = TRUE)

# number of chunks in the collection folder
# use this object to indexing
n_chunks_in_collection_folder <- length(chunk_subfolders_in_collection_folder)

# for loop through each chunk in the collection folder

for (i in (1:n_chunks_in_collection_folder)) {
  
  chunk_name <- chunk_subfolders_in_collection_folder[i]
  
  path_to_chunk_csv <- file.path(path_to_collection_folder, "metadata", paste0(collection_folder, "_subjects_", chunk_name, ".csv")) 
  
  chunk1_csv <- readr::read_csv(path_to_chunk_csv)
  
  # keep only the columns that we want
  # "RecordNumber, ImageFilename, ImagePath, ImageRelative, ImageSize, ImageTime, ImageDate, ImageAlert"
  chunk1_discard_columns <- chunk1_csv %>%
    dplyr::select(
      RecordNumber,
      ImageFilename,
      ImagePath,
      ImageRelative,
      ImageSize,
      ImageTime,
      ImageDate,
      ImageAlert
    )
  
  # copy the template excel macro from the git repo into the camera trap folder on the external hard drive
  
  from <-
    file.path(currentwd,
              "excelmacro",
              "HorseImaging-2020-White-Mountains.xlsm")
  
  to <- file.path(path_to_collection_folder, chunk_name)
  
  file.copy(from = from, to = to)
  
  #### Add Warning Message If File Is Not Copied ####
  
  # trim the "/home/rstudio/cameratraps/wildcat/exclosure/WCX_05212019_07102019/101EK113" from the "ImageRelative" column
  # we want to keep just the file name because the excel macro is going to default to relative image paths
  # and altering the rel path to just the filename will tell the macro to look inside just the "chunk" folder
  chunk1_relpaths_split_into_list <-
    stringr::str_split(chunk1_discard_columns$ImageRelative, "/")
  
  keep.last.split.in.file.path <- function(character_vector, pattern) {
    # create an empty object to hold the output of the function
    keep_last_object <- NULL
    
    # string split the character vector on a character or pattern
    all_subjects_string_split <-
      stringr::str_split(character_vector, pattern)
    
    # lengths() detects the number of objects in each list
    # create an index for the last object in a list using the lengths() func
    num_data_objects <- lengths(all_subjects_string_split)
    
    last_object <- num_data_objects
    
    # index the list and keep only the last object
    for (i in 1:length(all_subjects_string_split)) {
      keep_last_object[i] <-
        all_subjects_string_split[[i]][last_object[i]]
    }
    return(keep_last_object)
  }
  
  chunk1_discard_columns$ImageRelative <-
    keep.last.split.in.file.path(chunk1_discard_columns$ImageRelative, "/")
  
  # name the macro by the chunk number
  from <-
    file.path(path_to_collection_folder,
              chunk_name,
              "HorseImaging-2020-White-Mountains.xlsm")
  
  xlsm_file_name <-
    paste0(collection_folder, "_subjects_", chunk_name, ".xlsm")
  
  to <-
    file.path(path_to_collection_folder, chunk_name, xlsm_file_name)
  
  file.rename(from = from, to = to)
  
  #### Add Warning Message if File Is Not Renamed ####
  
  # copy and paste the data from the csv file into the macro
  # the data from the csv file has been corrected and the unnecessary columns dropped
  xlsm_workbook <-
    openxlsx::loadWorkbook(file.path(path_to_collection_folder, chunk_name, xlsm_file_name))
  
  chunk1_discard_columns_df <- as.data.frame(chunk1_discard_columns)
  
  # somewhat confusingly, "writeData" writes data to workbook object bound to R
  # but those changes are not yet saved to the file
  openxlsx::writeData(
    xlsm_workbook,
    "ImageData",
    chunk1_discard_columns,
    startCol = 1,
    startRow = 2,
    colNames = FALSE
  )
  
  # write out a filled macro
  openxlsx::saveWorkbook(
    xlsm_workbook,
    file.path(path_to_collection_folder, chunk_name, xlsm_file_name),
    overwrite = TRUE
  )
}

# create a new folder to use as a temporary folder for uploading to the cloud
temp_folder_for_uploading_chunk <- file.path(currentwd, "data", "chunks", collection_folder)

dir.create(temp_folder_for_uploading_chunk)

# the source is the folder "chunks" on the external hard drive
from <- chunk_subfolders_absolute_paths

# the destination is on local drive inside my git repo (temporarily)
to <- temp_folder_for_uploading_chunk

# copy the chunks onto my local drive for upload
file.copy(from = from, to = to, recursive = TRUE)
