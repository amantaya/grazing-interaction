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
                                                             "qc"), 
                                                    sep = "_", 
                                                    remove = FALSE)

# unique sites
str(unique(csv_files_df_separated$sitecode))

# need to match chunks based on their names
test_site <- filter(csv_files_df_separated, sitecode == "A51")

# TODO this would work for only a handful of sites but needs to be optimized for many sites
A51 <- filter(csv_files_df_separated, sitecode == "A51")
BKD <- filter(csv_files_df_separated, sitecode == "BKD")
BKN <- filter(csv_files_df_separated, sitecode == "BKN")
BKS <- filter(csv_files_df_separated, sitecode == "BKS")
BRL <- filter(csv_files_df_separated, sitecode == "BRL")
BRT <- filter(csv_files_df_separated, sitecode == "BRT")

# look at the number of deployments for Area 51
str(unique(A51$deploydate))

deployments <- unique(A51$deploydate)

# # create a new directory to hold the recombined chunks
# if (dir.exists(file.path(currentwd, "data", "xlsm", "csv", "recombined")) == FALSE) {
#   dir.create(file.path(currentwd, "data", "xlsm", "csv", "recombined"))
# } else {
#   
# }

# print the name of the sites in the console to put into the 
site_list <- as.list(A51, BKD, BKN, BKS, BRL, BRT)

# this function recombines chunks together in the correct order
# for each site, it writes out a csv file for each deployment date
# TODO ideally this would for loop through a site list instead of repeating the function
recombine.chunks(A51, path = file.path(currentwd, "data", "xlsm", "csv"))
recombine.chunks(BKD, path = file.path(currentwd, "data", "xlsm", "csv"))
recombine.chunks(BKN, path = file.path(currentwd, "data", "xlsm", "csv"))
recombine.chunks(BKS, path = file.path(currentwd, "data", "xlsm", "csv"))
recombine.chunks(BRL, path = file.path(currentwd, "data", "xlsm", "csv"))
recombine.chunks(BRT, path = file.path(currentwd, "data", "xlsm", "csv"))

beep("complete")
