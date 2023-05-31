# Background and Configuration --------------------------------------------

## Horse-Cattle-Elk Grazing Interaction Study Rproj
## Step 3: Chunk Subject Photos and Copy to Sub-Folder

## What this script does:
## Reads in the csv file from the photo collection metadata folder
## Copies the subject photos from the column into separate folders (chunks)
## Writes out a csv for each chunk of photos
## this csv can then be copied and pasted into the excel macro for scoring

## What this script requires:
## the csv file from "02-match-subject-photos-and-copy-to-subjects-subfolder.R"
## this csv file should be located in the "metadata" sub-folder
## within the collection folder
## this csv file is named by the photo collection folder and
## "~matched_subject_photos.csv"
## e.g., BRT_11052019_12072019_matched_subject_photos.csv

# Setup R Environment -----------------------------------------------------

# clear the R environment
rm(list = ls(all.names = TRUE))

# set the working directory and environment variables
source(here::here("environment.R"))

# load in the required packages
source(here::here("packages.R"))

# load in the required functions
source(here::here("functions.R"))

# Select Folders to Extract -----------------------------------------------

# create a variable to hold the file name
# in case we switch to a different project kanban board
project_kanban_file <-
  here::here(
    "docs",
    "project boards",
    "Cameratraps2 Kanban.md"
  )

# read in the kanban board for the Heber project
project_kanban <-
  readr::read_lines(
    here::here(
      project_kanban_file
    ),
    skip_empty_rows = FALSE,
    progress = readr::show_progress()
  )

# heading patterns to find
folders_to_chunk_heading_regex <-
  "##\\sFolders\\sto\\sChunk\\sSubject\\sPhotos"

copy_to_blank_macro_heading_regex <-
  "##\\sFolders\\sto\\sCopy\\sinto\\sBlank\\sMacro"

# create and index of the two headings
# we want what's in between the headings
folders_to_chunk_heading_index <-
  stringr::str_which(heber_project_kanban,
    pattern = folders_to_chunk_heading_regex
  )

copy_to_blank_macro_heading_index <-
  stringr::str_which(heber_project_kanban,
                     pattern = copy_to_blank_macro_heading_regex)

# add 2 because we don't want to include the first heading and a new line
# subtract 2 because we don't want to include the last heading and a new line
# subset the kanban board using these indexes
kanban_board_subset <-
  heber_project_kanban[
    (folders_to_chunk_heading_index + 2):(copy_to_blank_macro_heading_index - 2)
  ]

folders_to_chunk_regex <-
  "([[:upper:]][[:upper:]][[:upper:]]_\\d{8}_\\d{8}|A\\d{2}_\\d{8}_\\d{8}|[[:upper:]][[:upper:]][[:upper:]]_5min_\\d{8}_\\d{8}|[[:upper:]][[:upper:]][[:upper:]]\\d{2}_\\d{8}_\\d{8})" # nolint: line_length_linter

folders_to_chunk_pattern_matches <-
  stringr::str_extract(kanban_board_subset,
                       pattern = folders_to_chunk_regex)

# return only the pattern matches that were not NA
folders_to_chunk <-
  folders_to_chunk_pattern_matches[
    is.na(folders_to_chunk_pattern_matches) == FALSE
  ]

# create a data frame with a "site" column
# that we can use to construct file paths
cameratraps_folders_to_chunk <-
  cameratraps_path_constructor(folders_to_chunk)

# Match Subject Photos ----------------------------------------------------

for (i in 1:nrow(cameratraps_folders_to_chunk)) {

# read in the csv file that contains the metadata for all photos
## in the collection folder

all_photos_in_collection <- readr::read_csv(
  file.path(
    cameratraps_folders_to_chunk$full_path[i],
    "metadata",
    paste0(
      cameratraps_folders_to_chunk$collection_folder[i],
      "_matched_subject_photos",
      ".csv"
    )
  )
)

# select only the subject photos from within the collection
subject_photos_in_collection <-
  dplyr::filter(
    all_photos_in_collection,
    SubjectPhoto == TRUE
  )

# set the desired chunk size
## i.e. how many rows from the data frame will be in each chunk
chunk_size <- 500

# determine the number of subject photos
# be careful not to confuse the "n_rows" object with the function "nrow"
n_rows <- nrow(subject_photos_in_collection)

n_chunks <- ceiling(n_rows / chunk_size)

# create an object to fold the pattern created from 1 to the number of chunks
# the number of chunks is dependent on the chunk size
# if there are 1000 rows and chunk size = 500, only 2 chunks will be created
# if there are 1000 rows and chunk size = 100, then 10 chunks will be created
chunk_number <- rep(1:n_chunks)

chunk_names <- paste0("chunk", chunk_number)

# create a pattern to split the data frame into multiple data frames
pattern  <- rep(1:ceiling(n_rows / chunk_size), each = chunk_size)[1:n_rows]

# split the subject photos into chunks of 500
chunks <- split(subject_photos_in_collection, pattern)

# create a new directory to hold each group of 500 photos
# these directories will be temporary
# and can be deleted after scoring each group of photos
# this for loop creates a new directory for each chunk
for (j in chunk_number) {
  dir.create(
    file.path(
      cameratraps_folders_to_chunk$full_path[i],
      chunk_names[j]
    )
  )
}

# copy the subject photos for each chunk into their corresponding folder
for (k in chunk_number) {

  from <- file.path(
    cameratraps_folders_to_chunk$full_path[i],
    chunks[[k]]$ImageRelative)

  to <- file.path(
    cameratraps_folders_to_chunk$full_path[i],
    chunk_names[k])

  file.copy(from, to, overwrite = FALSE)
}

# run the extract-image-paths script on each group of photos to generate
# name each csv file the collection folder and the name of the chunk
# e.g., BGT_07302019_09182019_subjects_chunk1.csv
for (l in chunk_number) {
  excelfilename <- paste0(
    paste(
      cameratraps_folders_to_chunk$collection_folder[i],
      "subjects",
      chunk_names[l],
      sep = "_"
    ), ".csv"
  )
  readr::write_csv(
    chunks[[l]],
    file.path(
      cameratraps_folders_to_chunk$full_path[i],
      "metadata",
      excelfilename
    )
  )
}

system_time <- Sys.time()

msg_body <- paste(
  "05-chunk-subject-photos-and-copy-to-subfolder.R",
  "ran on folder",
  cameratraps_folders_to_chunk$collection_folder[i],
  "completed at",
  system_time,
  sep = " "
)

RPushbullet::pbPost(
  type = "note",
  title = "Script Completed",
  body = msg_body)
}

# source(
#   here:::here(
#     "scripts",
#     "utilities",
#     "05-chunk-subject-photos-and-copy-to-subfolder.R"
#   )
# )
