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

# load in the required libraries
source("C:/Users/andre/Dropbox/Rproj/Horse-Cattle-Elk-Grazing-Interaction-Study/packages.R")
source("C:/Users/andre/Dropbox/Rproj/Horse-Cattle-Elk-Grazing-Interaction-Study/functions.R")

# set working directory to location of excel files
# file.path() is system agnostic (i.e. works on Mac/PC/Linux)
setwd(file.path("C:", "temp", "xlsm"))

# check that working directory is correct
getwd()

# store the location of the current working directory
currentwd <- getwd()

# scan the current working directory for excel macro files
xlsm_files <- dir(path = currentwd, pattern = "xlsm")

# read in the xlsm files and convert them to xlsx files
# this only keeps the first sheet. It strips out the macro and other sheets
xlsm_data <- read.xlsx(xlsm_files[1], 1)

# replace the xlsm file extension with xlsx
# use this vector as the xlsx file names
xlsx_file_names <- str_replace_all(xlsm_files, "xlsm", "xlsx")

# read in data from xlsm file as a data frame
# write out data frame as xlsx into sub-directory "xlsx"
# do this for all xlsm files in a directory (this may take quite awhile)
for (i in 1:length(xlsm_files)) {
  xlsm_data <- read.xlsx(xlsm_files[i], 1)
  write.xlsx(xlsm_data, paste0(currentwd, "/xlsx/", xlsx_file_names[i]), row.names = FALSE)
}

# play a sound to indicate the loop has completed
beep("coin")

# scan the current working directory for xlsx files
xlsx_files <- dir(path = paste0(currentwd, "/xlsx"), pattern = "xlsx")

# replace the xlsx file extension with csv
# use this vector as our file names for the csv files
csv_file_names <- str_replace_all(xlsx_file_names, "xlsx", "csv")

# create a sub-directory to store the csv files
dir.create(paste0(currentwd, "/csv"))

# convert the xlsx files into csv files
# write out data into the "csv" sub-directory
for (i in 1:length(xlsx_files)) {
  rio::convert(paste0(currentwd, "/xlsx/", xlsx_files[i]), 
               paste0(currentwd, "/csv/", csv_file_names[i])
               )
}
beep("coin")
