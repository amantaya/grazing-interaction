# Background and Configuration --------------------------------------------

## Horse-Cattle-Elk Grazing Interaction Study Rproj
## Step 4: Match Subject Photo Text Files and Copy to Subjects Sub-Folder

## What this script does:
## Reads in the subject text files from a photo collection folder
## Copies the subject photos from the text files to the "subjects" sub-folder
## Writes out a csv declaring if each photo in the collection contains a subject

## What this script requires:
## csv file from "01-extract-image-paths.R" containing all photos in a collection (this csv file needs to be located in the "metadata" sub-folder within the collection)
## subject text files (these text files need to be located in the "metadata" sub-folder within the collection)

# Setup R Environment -----------------------------------------------------

# clear the R environment
rm(list=ls(all=TRUE))

# set the working directory and environment variables
source(here::here("environment.R"))

# load in the required packages
source(here::here("packages.R"))

# load in the required functions
source(here::here("functions.R"))

# Select Folders to Extract -----------------------------------------------

# create a variable to hold the file name in case we switch to a different project
project_kanban_file <- here::here("docs", "project boards", "Cameratraps2 Kanban.md")

# read in the kanban board for the Heber project
project_kanban <- readr::read_lines(
  here::here(
    project_kanban_file
  ),
  skip_empty_rows = FALSE,
  progress = readr::show_progress()
)

# heading patterns to find
folders_to_match_heading_regex <- "^##\\sFolders\\sto\\sMatch\\sSubject\\sPhotos"

folders_to_chunk_heading_regex <- "^##\\sFolders\\sto\\sChunk\\sSubject\\sPhotos"

# create and index of the two headings
# we want what's in between the headings
folders_to_match_heading_index <- stringr::str_which(project_kanban, pattern = folders_to_match_heading_regex)

folders_to_chunk_heading_index <- stringr::str_which(project_kanban, pattern = folders_to_chunk_heading_regex)

# add 2 because we don't want to include the first heading and the new line
# subtract 2 because we don't want to include the last heading and the new line
# subset the kanban board using these indexes
kanban_board_subset <- project_kanban[(folders_to_match_heading_index + 2):(folders_to_chunk_heading_index - 2)]

cameratraps_regex_pattern <- "([[:upper:]][[:upper:]][[:upper:]]_\\d{8}_\\d{8}|A\\d{2}_\\d{8}_\\d{8}|[[:upper:]][[:upper:]][[:upper:]]_5min_\\d{8}_\\d{8})"

cameratraps2_regex_pattern <- "[[:upper:]][[:upper:]][[:upper:]]\\d{2}_\\d{8}_\\d{8}"

# extract the folders from the cameratraps project
cameratraps_folders_pattern_matches <-
  stringr::str_extract(kanban_board_subset,
                       pattern = cameratraps_regex_pattern)

# extract the folders from the cameratraps2 projects
# the cameratraps2 project has different site codes and require a different regex
cameratraps2_folder_pattern_matches <-
  stringr::str_extract(kanban_board_subset,
                       pattern = cameratraps2_regex_pattern)

# combine the folder matches so we can match subject text files from both project folders
combined_folder_pattern_matches <- c(cameratraps_folders_pattern_matches, cameratraps2_folder_pattern_matches)

# return only the pattern matches that were not NA
combined_folder_pattern_matches <- combined_folder_pattern_matches[is.na(combined_folder_pattern_matches) == FALSE]

# create a data frame with a "site" column that we can use to construct file paths
# TODO replace these path constructing functions with reading the file paths from a JSON
# the fromJSON creates a data frame whereas the read_json creates a list
sites_from_json <- jsonlite::fromJSON(
  here::here("data", "metadata", "cameratraps.json"))

cameratraps_folders_to_match <-
  cameratraps_path_constructor(combined_folder_pattern_matches)

# TODO this breaks if you run it on a cameratraps folder
cameratraps2_folders_to_match <-
  cameratraps2_path_constructor(combined_folder_pattern_matches)

}

# the character strings are stored in the R environment as \\ (double-backslashes) which are reserved characters
# replace these reserved characters with a single forward-slash, which is how R reads in file paths
# (Windows 10 uses a single back-slash for file paths)
all_subjects_tibble_drop_na$path <-
  str_replace_all(all_subjects_tibble_drop_na$path, "\\\\", "/")

# the path of each photo may be different on each computer
# so we need to make this script as flexible as possible
# to work on as many computers as possible
# we'll do this by splitting the file path string into multiple parts
# discarding the parts of the string that we don't need

# create a series of regular expressions to extract parts of the filepath
collection_folder_regex_pattern <-
  "[[:upper:]][[:upper:]][[:upper:]]_\\d{8}_\\d{8}"

subfolder_regex_pattern <- "\\d{3}\\EK\\d{3}"

# pattern to match on renamed files including files with a trailing underscore
filename_regex_pattern <-
  "(\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}-\\d{2}\\.JPG|\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}-\\d{2}[:punct:]\\d*\\.JPG)"

all_subjects_reconstructed_paths <-
all_subjects_tibble_drop_na %>%
  dplyr::mutate(collection_folder = str_extract(path, collection_folder_regex_pattern)) %>%
  dplyr::mutate(subfolder = str_extract(path, subfolder_regex_pattern)) %>%
  dplyr::mutate(filename = str_extract(path, filename_regex_pattern)) %>%
  dplyr::mutate(path = file.path(cameratraps_folders_to_chunk$full_path[i], subfolder, filename))

# create a file name for the single subjects text file
all_subjects_filename <- paste(cameratraps_folders_to_chunk$collection_folder[i], "all_subjects.csv", sep = "_")

# write out a single text file containing the concatenated subject text files
# encode this text file as UTF-8 depending on your locale
readr::write_csv(all_subjects_reconstructed_paths,
                 file = file.path(cameratraps_folders_to_chunk$full_path[i], "metadata", all_subjects_filename))

# Match Subject Photos to All Photos--------------------------------------

all_subjects_csv <- readr::read_csv(
  file.path(cameratraps_folders_to_chunk$full_path[i],
            "metadata",
            all_subjects_filename))

# compare the subjects vector to all of the photos in the collection to check for matching photos
# the %in% checks for matches from the left object in the object to the right
# if the name of file in the subjects vector matches the name of the file in the all photos data frame, it will report as TRUE
# all values should report as TRUE because the subjects vector is a subset of the all photos data frame
# all_subjects_csv$filename %in% all_photos_in_collection$ImageFilename

# reversing matching function should illustrate how it works
# in this case, it is looking for matches in the all photos data frame using the file names in the subjects vector
# only some of the values should report as TRUE (i.e. they match) because not all photos contain subjects
# all_photos_in_collection$ImageFilename %in% all_subjects_csv$filename

photo_contains_subject <- all_photos_in_collection$ImageFilename %in% all_subjects_csv$filename

# create a new column in the all photos data frame that identifies that if the photo has a subject
# i.e. if SubjectPhoto = TRUE then that photo has been recorded in the subject text files as having something in it (i.e. a subject)
all_photos_in_collection <-
  tibble::add_column(all_photos_in_collection, SubjectPhoto = photo_contains_subject)

# filter out the images with a file size of 0
# i.e. file may be corrupted
all_photos_in_collection <-
  dplyr::filter(all_photos_in_collection, ImageSize != 0)

# create a flexible excel file name that uses the first row of the collection folder
excelfilename <-paste0(
  paste(cameratraps_folders_to_chunk$collection_folder[i],
        "matched_subject_photos",
        sep = "_"),
  ".csv")

# write the new csv to the working directory
# we can use this new file at a later point (for machine learning)
# to identify empty photos from photos with something in them
readr::write_csv(
  all_photos_in_collection,
  file = file.path(cameratraps_folders_to_chunk$full_path[i], "metadata", excelfilename)
  )

# Copy Subject Photos to "Subjects" Folder --------------------------------

# now that we have identified which files contain subjects by reading in the text files created by IrFanView
# we want to copy them to a "subjects" sub-folder in the file directory
# that way we can run the Excel macro on only the photos that containing subjects, greatly speeding up the scoring process

# define explicitly where the files are coming from, and where we want to copy them to
# this function uses vectors defined in a previous step to create file paths for our external hard drives
from <- file.path(all_subjects_csv$path)

to <- file.path(cameratraps_folders_to_chunk$full_path[i], "subjects")

# make a subjects folder if one doesn't already exist
# create a "metadata" directory if one doesn't already exist in the collection folder
if (dir.exists(file.path(cameratraps_folders_to_chunk$full_path[i], "subjects")) == FALSE) {
  dir.create(file.path(cameratraps_folders_to_chunk$full_path[i], "subjects"))
} else {

}

# copy the photos containing subjects into the folders locations defined in the previous step
file.copy(from = from,
          to = to,
          overwrite = FALSE)

# TODO Add a some logic to check if files were not copied due to incorrect paths
# one way to do this would be to compare the number of observations on the all subjects data frame to the number of copied files

# play a sound to indicate the transfer is complete
# beep("coin")
# toc()

# get the current system time to notify when the script is completed
# note that this defaults to UTC (aka Greenwich Mean Time)
system_time <- Sys.time()

# convert into the correct timezone for your locale (mine is Arizona so we follow Mountain Standard)
attr(system_time, "tzone") <- "MST"

msg_body <-
  paste(
    "02-match-subject-photos-and-copy-to-subjects-subfolder.R",
    "ran on folder",
    cameratraps_folders_to_chunk$collection_folder[i],
    "completed at",
    system_time,
    sep = " "
  )

RPushbullet::pbPost(type = "note", title = "Script Completed", body = msg_body)
}

# TODO once this scripts completed, move the collection folder to the next task
