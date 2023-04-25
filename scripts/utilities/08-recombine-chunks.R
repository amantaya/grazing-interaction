## Horse-Cattle-Elk Grazing Interaction Study Rproj
## Step 7: Convert Excel Scoring Macro (XLSM) to CSV and Recombine CSV Chunks

## What this script does:
## Scans a file directory for XLSM files (hopefully completed XLSM)
## Converts XLSM files to CSV
## Recombines chunked CSV files (i.e. chunk1.csv, chunk2.csv, chunk3.csv) into a single CSV file
## Writes out a single CSV file containing all chunks for a collection

## What this script requires:
## Must specify the location of the folder containing XLSM files
## Must specify where to write out CSV files

# set the working directory and environment variables
source("~/grazing-interaction/environment.R")

# load in the required packages
source("~/grazing-interaction/packages.R")

# load in the required functions
source("~/grazing-interaction/functions.R")

# scan the current working directory for excel macro files
xlsm_files <- dir(path = file.path(currentwd, "data", "photo", "completed-xlsm"), pattern = "xlsm")

# replace the xlsm file extension with csv
# use this vector as the xlsx file names
csv_file_names <- str_replace_all(xlsm_files, "xlsm", "csv")

# create a sub-directory to store the xlsx files
if (dir.exists(file.path(currentwd, "data", "photo", "completed-xlsm", "csv")) == FALSE) {
  dir.create(file.path(currentwd, "data", "photo", "completed-xlsm", "csv"))
} else {

}

# read in data from xlsm file as a data frame
# write out data frame as xlsx into sub-directory "xlsx"
# do this for all xlsm files in the current working directory
for (i in 1:length(xlsm_files)) {
  # load the xlsm file
  xlsm_workbook <- loadWorkbook(file.path(currentwd, "data", "photo", "completed-xlsm", xlsm_files[i]))

  # read the data from the first sheet
  xlsm_data <- readWorkbook(xlsm_workbook, sheet = 1)

  # convert the date to a POSIXct class
  if (typeof(xlsm_data$ImageDate) == "double" & typeof(xlsm_data$ImageTime) == "double") {

    # add the numerical date and time values together
    xlsm_data <- dplyr::mutate(xlsm_data, DateTime = (ImageDate + ImageTime), .after = ImageDate)

    # then convert to a DateTime
    xlsm_data$DateTime <- openxlsx::convertToDateTime(xlsm_data$DateTime, tz = Sys.getenv("TZ"))

    } else if (typeof(xlsm_data$ImageDate) == "character" & typeof(xlsm_data$ImageTime) == "character") {

    # create a new column by adding the time and date character strings together
    xlsm_data <- mutate(xlsm_data, DateTime = stringr::str_c(ImageDate, ImageTime, sep = " "), .after = ImageDate)

    # convert the character strings to date time class
    xlsm_data <- mutate(xlsm_data, DateTime = lubridate::ymd_hms(DateTime, tz = Sys.getenv("TZ")), .after = ImageDate)

    } else if (typeof(xlsm_data$ImageDate) == "double" & typeof(xlsm_data$ImageTime) == "character") {

    # convert the numeric Excel formatted date to a datetime
    xlsm_data$ImageDate <- openxlsx::convertToDateTime(xlsm_data$ImageDate, tz = Sys.getenv("TZ"))

    # then convert the datetime to string
    xlsm_data$ImageDate <- as.character(xlsm_data$ImageDate)

    # then combine the two character strings together
    xlsm_data <- mutate(xlsm_data, DateTime = stringr::str_c(ImageDate, ImageTime, sep = " "), .after = ImageDate)

    # convert the character strings to date time class
    xlsm_data <- mutate(xlsm_data, DateTime = lubridate::ymd_hms(DateTime, tz = Sys.getenv("TZ")), .after = ImageDate)

  } else {

    warning(paste("This file failed to parse the date:", xlsm_files[i]))

    break
  }

  # convert the "LastSavedOn" column into a POSIXct class
  xlsm_data$LastSavedOn <- openxlsx::convertToDateTime(xlsm_data$LastSavedOn, tz = Sys.getenv("TZ"))

  # then convert the date back into a ISO string
  xlsm_data$ImageDate <- strftime(xlsm_data$DateTime, format = "%F")

  xlsm_data$ImageTime <- strftime(xlsm_data$DateTime, format = "%T")

  xlsm_data$DateTime <- strftime(xlsm_data$DateTime, usetz = TRUE)

  # write out the xlsm data as an xlsx
  readr::write_csv(xlsm_data,
                    file.path(currentwd, "data", "photo", "completed-xlsm", "csv", csv_file_names[i])
  )
}


# Recombine Chunks --------------------------------------------------------

csv_file_list <- list.files(path = file.path(currentwd, "data", "photo", "completed-xlsm", "csv"), full.names = FALSE, recursive = FALSE)

csv_files_df <- data.frame(csv_file_list)

names(csv_files_df)[names(csv_files_df) == "csv_file_list"] <- "relpath"

csv_files_df_separated <- separate(csv_files_df, relpath,
                                                    into = c("sitecode",
                                                             "deploydate",
                                                             "collectdate",
                                                             "subjects",
                                                             "chunknumber",
                                                             "completed",
                                                             "qc",
                                                             "author"),
                                                    sep = "_",
                                                    remove = FALSE)

# unique sites
sitecodes_in_csv_files <- unique(csv_files_df_separated$sitecode)

# the data frame generated by list.files has the csv files for all sites
# but we want to combine data by site and write out a file for each site
# we can use dplyr to group by the site code
grouped_site_dataframes <- csv_files_df_separated %>% dplyr::group_by(sitecode)

# and then use the group split to create a list
# each element corresponds to a site data frame
grouped_site_list <- dplyr::group_split(grouped_site_dataframes)

# this prints the first site in the list
grouped_site_list[[1]]

# set the names of the elements in the list by using the site codes
# this will help us access components by using their names (instead of index)
# e.g., grouped_site_list$BKS instead of grouped_site_list$1
names(grouped_site_list) <- sitecodes_in_csv_files

# look at the number of deployments for Black Canyon South
# the double $$ operator!
unique(grouped_site_list$BKS$deploydate)

# this function recombines chunks together in the correct order for each site
# it writes out a csv file for each deployment date
# for loop through a site list instead of repeating the function

for (i in 1:length(grouped_site_list)) {
  recombine.chunks(grouped_site_list[[i]], path = file.path(currentwd, "data", "photo", "completed-xlsm", "csv"))
}

# get the current system time to notify when the script is completed
# note that this defaults to UTC (aka Greenwich Mean Time)
system_time <- Sys.time()

# convert into the correct timezone for your locale (mine is Arizona so we follow Mountain Standard)
attr(system_time,"tzone") <- Sys.getenv("TZ")

msg_body <- paste("07-recombine-chunks.R", system_time, sep = " ")

RPushbullet::pbPost(type = "note", title = "Script Completed", body = msg_body)
