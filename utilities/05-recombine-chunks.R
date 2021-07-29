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
xlsm <- dir(path = currentwd, pattern = "xlsm")

# read in the xlsm files and convert them to xlsx files
# this only keeps the first sheet and strips out the macro
xlsx <- read.xlsx(xlsm, 1)


csv <- mapply(convert, xlsm, gsub("xlsm", "csv", xlsm))

