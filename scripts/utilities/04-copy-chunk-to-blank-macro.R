###########################################################################
###########################################################################
###                                                                     ###
###               SECTION 1: BACKGROUND AND CONFIGURATION               ###
###                                                                     ###
###########################################################################
###########################################################################

# TODO update what this script does


############################################################################
###                                                                      ###
###                    SECTION 2: SETUP R ENVIRONMENT                    ###
###                                                                      ###
############################################################################
############################################################################


# Section 2: Setup R Environment ------------------------------------------

# clear the R environment
# rm(list=ls(all=TRUE))

# set the working directory and environment variables
source("~/grazing-interaction/environment.R")

# load in the required packages
source("~/grazing-interaction/packages.R")

# load in the required functions
source("~/grazing-interaction/functions.R")

############################################################################
############################################################################
###                                                                      ###
###                 SECTION 3: SELECT FOLDERS TO EXTRACT                 ###
###                                                                      ###
############################################################################
############################################################################

project_switch <- "heber"

if (project_switch == "heber") {
  blankmacro <- "HorseImaging-2021-Heber.xlsm"
} else if (project_switch == "white mountains") {
  blankmacro <- "HorseImaging-2020-White-Mountains.xlsm"
} else {
  warning("The project has not been selected or was entered incorrectly.")
}

# create a variable to hold the file name in case we switch to a different project
# and the file name is different we can switch it once here
file <- "Heber Project Kanban.md"

# read in the kanban board for the Heber project
heber_project_kanban <- readr::read_lines(
  file.path(
    "~",
    "grazing-interaction",
    "docs",
    "heber-project-notes",
    file
  ),
  skip_empty_rows = FALSE,
  progress = readr::show_progress()
)

# heading patterns to find

copy_to_blank_macro_heading_regex <- "##\\sFolders\\sto\\sCopy\\sinto\\sBlank\\sMacro"

upload_to_box_scoring_heading_regex <- "##\\sFolders\\sto\\sUpload\\sto\\sBox\\sfor\\sSCORING"

# create and index of the two headings
# we want what's in between the headings
copy_to_blank_macro_heading_index <- stringr::str_which(heber_project_kanban, pattern = copy_to_blank_macro_heading_regex)

upload_to_box_scoring_heading_index <- stringr::str_which(heber_project_kanban, pattern = upload_to_box_scoring_heading_regex)

# add 1 because we don't want to include the first heading
# subtract 1 because we don't want to include the last heading
# subset the kanban board using these indexes
# TODO should I consider not using the index?
folders_to_chunk <- heber_project_kanban[(copy_to_blank_macro_heading_index + 2):(upload_to_box_scoring_heading_index - 2)]

folders_to_chunk_regex_pattern <-
  "([[:upper:]][[:upper:]][[:upper:]]_\\d{8}_\\d{8}|[[:upper:]]\\d{2}_\\d{8}_\\d{8})"

folders_to_chunk_pattern_matches <-
  stringr::str_extract(folders_to_chunk,
                       pattern = folders_to_chunk_regex_pattern)

# return only the pattern matches that were not NA
folders_to_chunk <- folders_to_chunk_pattern_matches[is.na(folders_to_chunk_pattern_matches) == FALSE]

# create a data frame with a "site" column that we can use to construct file paths
cameratraps_folders_to_chunk <-
  cameratraps_path_constructor(folders_to_chunk)

# Section 4: Copy Subjects to Blank Macro ---------------------------------

for (i in 1:nrow(cameratraps_folders_to_chunk)) {

# list all of the chunk subfolders in the collection
subfolders_in_collection_folder_relative_path <- list.dirs(cameratraps_folders_to_chunk$full_path[i], full.names = FALSE)

subfolders_in_collection_folder_absolute_path <- list.dirs(cameratraps_folders_to_chunk$full_path[i])

# create a wildcard pattern that we can use to match just the "chunk" subfolders
chunk_wildcard <- "chunk*"

# use a global regular expression to match and return just the "chunk" subfolders
chunk_subfolders_in_collection_folder <- grep(chunk_wildcard,
                                              subfolders_in_collection_folder_relative_path,
                                              value = TRUE)

chunk_subfolders_absolute_paths <- grep(chunk_wildcard,
                                        subfolders_in_collection_folder_absolute_path,
                                        value = TRUE)

# number of chunks in the collection folder
# use this object to indexing
n_chunks_in_collection_folder <- length(chunk_subfolders_in_collection_folder)

# for loop through each chunk in the collection folder

for (j in (1:n_chunks_in_collection_folder)) {

  chunk_name <- chunk_subfolders_in_collection_folder[j]

  path_to_chunk_csv <- file.path(cameratraps_folders_to_chunk$full_path[i],
                                 "metadata",
                                 paste0(cameratraps_folders_to_chunk$collection_folder[i],
                                        "_subjects_", chunk_name, ".csv"))

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
              "templates",
              "excelmacro",
              blankmacro)

  to <- file.path(cameratraps_folders_to_chunk$full_path[i], chunk_name)

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
    file.path(cameratraps_folders_to_chunk$full_path[i],
              chunk_name,
              blankmacro)

  xlsm_file_name <-
    paste0(cameratraps_folders_to_chunk$collection_folder[i], "_subjects_", chunk_name, ".xlsm")

  to <-
    file.path(cameratraps_folders_to_chunk$full_path[i], chunk_name, xlsm_file_name)

  file.rename(from = from, to = to)

  #### Add Warning Message if File Is Not Renamed ####

  # copy and paste the data from the csv file into the macro
  # the data from the csv file has been corrected and the unnecessary columns dropped
  xlsm_workbook <-
    openxlsx::loadWorkbook(file.path(cameratraps_folders_to_chunk$full_path[i], chunk_name, xlsm_file_name))

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
    file.path(cameratraps_folders_to_chunk$full_path[i], chunk_name, xlsm_file_name),
    overwrite = TRUE
  )
}

# create a new folder to use as a temporary folder for uploading to the cloud
temp_folder_for_uploading_chunk <- file.path(currentwd,
                                             "data",
                                             "temp",
                                             "chunks",
                                             cameratraps_folders_to_chunk$collection_folder[i])

dir.create(temp_folder_for_uploading_chunk)

# the source is the folder "chunks" on the external hard drive
from <- chunk_subfolders_absolute_paths

# the destination is on local drive inside my git repo (temporarily)
to <- temp_folder_for_uploading_chunk

# copy the chunks onto my local drive for upload
file.copy(from = from, to = to, recursive = TRUE)

toc()

system_time <- Sys.time()

# convert into the correct timezone for your locale (mine is Arizona so we follow Mountain Standard)
attr(system_time,"tzone") <- "MST"

msg_body <- paste("04-copy-chunk-to-blank-macro.R", "ran on folder", cameratraps_folders_to_chunk$collection_folder[i], "completed at", system_time, sep = " ")

RPushbullet::pbPost(type = "note", title = "Script Completed", body = msg_body)

}
