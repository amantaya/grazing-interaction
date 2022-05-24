## Horse-Cattle-Elk Grazing Interaction Study Rproj
## Step 5: Convert Excel Scoring Macro (XLSM) to CSV and Recombine CSV Chunks

## What this script does:
## Scans a file directory for XLSM files (hopefully completed XLSM)
## Converts XLSM files to CSV
## Recombines chunked CSV files (i.e. chunk1.csv, chunk2.csv, chunk3.csv) into a single CSV file
## Writes out a single CSV file containing all chunks for a collection

## What this script requires:
## Must specify the location of the folder containing XLSM files
## Must specify where to write out CSV files

# clear the R environment
rm(list=ls(all=TRUE))

source(paste0(getwd(), "/environment.R"))

print(currentwd)

# load in the required libraries
source(paste0(currentwd, "/packages.R"))

source(paste0(currentwd, "/functions.R"))

# scan the current working directory for excel macro files
xlsm_files <- dir(path = file.path(currentwd, "data", "xlsm"), pattern = "xlsm")

# read in the xlsm files and convert them to xlsx files
# this only keeps the first sheet. It strips out the macro and other sheets
xlsm_workbook <- loadWorkbook(file.path(currentwd, "data", "xlsm", xlsm_files[1]))

# read the workbook
xlsm_data <- readWorkbook(xlsm_workbook, sheet = 1)

# create a new column by adding the time and date columns together
xlsm_data <- mutate(xlsm_data, DateTime = ImageDate + ImageTime, .after = ImageDate)

# convert the date time to a POSIXct class
xlsm_data$DateTime <- openxlsx::convertToDateTime(xlsm_data$DateTime)

# replace the xlsm file extension with xlsx
# use this vector as the xlsx file names
xlsm_file_names <- str_replace_all(xlsm_files, "xlsm", "xlsx")

# create a sub-directory to store the xlsx files
if (dir.exists(file.path(currentwd, "data", "xlsm", "xlsx")) == FALSE) {
  dir.create(file.path(currentwd, "data", "xlsm", "xlsx"))
} else {
  
}

# read in data from xlsm file as a data frame
# write out data frame as xlsx into sub-directory "xlsx"
# do this for all xlsm files in the current working directory
for (i in 1:length(xlsm_files)) {
  # load the xlsm file
  xlsm_workbook <- loadWorkbook(file.path(currentwd, "data", "xlsm", xlsm_files[i]))
  # read the data from the first sheet
  xlsm_data <- readWorkbook(xlsm_workbook, sheet = 1)
  # create a new column by adding the time and date columns together
  xlsm_data <- mutate(xlsm_data, DateTime = ImageDate + ImageTime, .after = ImageDate)
  # convert the date time to a POSIXct class
  xlsm_data$DateTime <- openxlsx::convertToDateTime(xlsm_data$DateTime)
  # convert the "LastSavedOn" column into a POSIXct class
  xlsm_data$LastSavedOn <- openxlsx::convertToDateTime(xlsm_data$LastSavedOn)
  # convert the "ImageDate" column into S3 Date Class
  xlsm_data$ImageDate <- openxlsx::convertToDate(xlsm_data$ImageDate)
  # then convert the date back into a ISO string
  xlsm_data$ImageDate <- strftime(xlsm_data$ImageDate, format = "%F")
  # convert the "ImageTime" column into S3 Time Class
  xlsm_data$ImageTime <- hms::as_hms(xlsm_data$DateTime)
  # write out the xlsm data as an xlsx
  write.xlsx(xlsm_data, file.path(currentwd, "data", "xlsm", "xlsx", xlsm_file_names[i]), row.names = FALSE)
}

# scan the current working directory for xlsx files
xlsx_files <- dir(path = file.path(currentwd, "data", "xlsm", "xlsx"), pattern = "xlsx")

# replace the xlsx file extension with csv
# use this vector as our file names for the csv files
csv_file_names <- str_replace_all(xlsx_files, "xlsx", "csv")

# create a sub-directory to store the csv files
if (dir.exists(file.path(currentwd, "data", "xlsm", "csv")) == FALSE) {
  dir.create(file.path(currentwd, "data", "xlsm", "csv"))
} else {
  
}

# convert the xlsx files into csv files
# write out data into the "csv" sub-directory
for (i in 1:length(xlsx_files)) {
  rio::convert(file.path(currentwd, "data", "xlsm", "xlsx", xlsx_files[i]), 
               file.path(currentwd, "data", "xlsm", "csv", csv_file_names[i]))
}

# # try splitting the strings
# csv_file_names_string_split<- str_split(csv_file_names, "_")
# 
# # look at how many splits were made in each file name
# lengths(csv_file_names_string_split)
# 
# collection_folders <- save.first.three.parts.of.strings(csv_file_names_string_split)
# 
# df <- data.frame(cbind(collection_folders, csv_file_names))

# try a different approach
# list all the csv files in directory
csv_file_list <- list.files(path = file.path(currentwd, "data", "xlsm", "csv"), full.names = FALSE, recursive = FALSE)

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
  recombine.chunks(grouped_site_list[[i]], path = file.path(currentwd, "data", "xlsm", "csv"))
}

# get the current system time to notify when the script is completed
# note that this defaults to UTC (aka Greenwich Mean Time)
system_time <- Sys.time()

# convert into the correct timezone for your locale (mine is Arizona so we follow Mountain Standard)
attr(system_time,"tzone") <- "MST"

msg_body <- paste("06-recombine-chunks.R", "run on folder", collection_folder, "completed at", system_time, sep = " ")

RPushbullet::pbPost(type = "note", title = "Script Completed", body = msg_body)
