# Background and Configuration --------------------------------------------

# TODO add what this script does

# Setup R Environment -----------------------------------------------------

# clear the R environment
# rm(list=ls(all=TRUE))

# set the working directory and environment variables
source("~/grazing-interaction/environment.R")

# load in the required packages
source("~/grazing-interaction/packages.R")

# load in the required functions
source("~/grazing-interaction/functions.R")

# Select Folders to Copy --------------------------------------------------

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
folders_to_upload_heading_regex <-
  "##\\sFolders\\sto\\sUpload\\sfor\\sSORTING"

folders_to_add_to_basecamp_heading_regex <-
  "##\\sFolders\\sto\\sAdd\\sas\\sAssignments\\sto\\sBasecamp\\sfor\\sSORTING"

# create and index of the two headings
# we want what's in between the headings
folders_to_upload_heading_index <- stringr::str_which(heber_project_kanban, pattern = folders_to_upload_heading_regex)

folders_to_add_to_basecamp_heading_index <- stringr::str_which(heber_project_kanban, pattern = folders_to_add_to_basecamp_heading_regex)

# add 2 because we don't want to include the first heading and a blank line
# subtract 2 because we don't want to include the last heading and a blank line
# subset the kanban board using these indexes
# TODO should I consider not using the index?
folders_to_chunk <- heber_project_kanban[(folders_to_upload_heading_index + 2):(folders_to_add_to_basecamp_heading_index - 2)]

cameratraps_regex_pattern <- "([[:upper:]][[:upper:]][[:upper:]]_\\d{8}_\\d{8}|A\\d{2}_\\d{8}_\\d{8})"

cameratraps2_regex_pattern <- "[[:upper:]][[:upper:]][[:upper:]]\\d{2}_\\d{8}_\\d{8}"

cameratraps_pattern_matches <-
  stringr::str_extract(folders_to_chunk,
                       pattern = cameratraps_regex_pattern)

cameratraps2_pattern_matches <-
  stringr::str_extract(folders_to_chunk,
                       pattern = cameratraps2_regex_pattern)


# return only the pattern matches that were not NA
cameratraps_folders_to_copy <- cameratraps_pattern_matches[is.na(cameratraps_pattern_matches) == FALSE]

cameratraps2_folders_to_copy <- cameratraps2_pattern_matches[is.na(cameratraps2_pattern_matches) == FALSE]

# create a data frame with a "site" column that we can use to construct file paths
cameratraps_folders_to_copy_df <-
  cameratraps_path_constructor(cameratraps_folders_to_copy)

cameratraps2_folders_to_copy_df <-
  cameratraps2_path_constructor(cameratraps2_folders_to_copy)

folders_to_copy <- dplyr::bind_rows(cameratraps_folders_to_copy_df, cameratraps2_folders_to_copy_df)

# Copy Folders to Box -----------------------------------------------------

from <- folders_to_copy$full_path

to <- file.path(path_to_local_data, "temp")

# file.copy(from = from, to = to, recursive = TRUE)

# TODO 5 minute timelapse photos have a error

for (i in 1:length(from)) {
  print(paste("Copying...", from[i]))
  file.copy(from[i], to, recursive = TRUE)
}

# get the current system time to notify when the script is completed
# note that this defaults to UTC (aka Greenwich Mean Time)
system_time <- Sys.time()

# convert into the correct timezone for your locale (mine is Arizona so we follow Mountain Standard)
attr(system_time, "tzone") <- "MST"

msg_body <-
  paste(
    "copy-and-upload-folders-to-Box.R",
    "completed at",
    system_time,
    sep = " "
  )

RPushbullet::pbPost(type = "note", title = "Script Completed", body = msg_body)
