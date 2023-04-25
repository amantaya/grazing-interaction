# this script reads in a csv created by the "extractcamerafiles.R" script
# which must be created before running this script

# load in required packages
library(tidyverse)
library(lubridate)

# clear the enviroment
rm(list=ls(all=TRUE))

# set the working directory and store it in a variable
wd <- setwd('J:/cameratraps')

# check that the working directory is correct
getwd()

# read in the csv and store it in a dataframe
filecount <- read.csv("file-count-by-collection-folder-2020-04-30.csv", header = TRUE)

# convert the dataframe to a tibble to make it easier to view
filecount.tibble <- as_tibble(filecount)

# view this tibble
View(filecount.tibble)

# select the locations that we want to analyse and store them in a new tibble
heber.tibble <- filter(filecount.tibble, locationfolder == "blackcanyon" |  locationfolder == "bear" | locationfolder == "fiftyone")

# view this tibble
View(heber.tibble)

# the 'collectionfolder' column is a code that reads sitecode_cameradeploymentdate_cameracollectiondate
# e.g., BRT_01012019_02012019 which is the bear trail camera, deployed on Jan 01, 2019 and collected on Feb 01, 2019
# separate  the 'collectionfolder' code into new columns by which are separated by the underscore character
heber.tibble.sep <- separate(heber.tibble, collectionfolder, into = c("sitecode", "deploydate", "collectiondate", "renamed"), sep = "_", remove = FALSE)

# view this tibble
View(heber.tibble.sep)

# some hidden SyncToy data files were included in the csv file
# remove these from our tibble by selecting all the files that aren't SyncToy dat files
heber.tibble.sep <- filter(heber.tibble.sep, sitecode != "SyncToy")

# view the new tibble
View(heber.tibble.sep)

# change the collectiondate and deploydate folders are in a month-day-year format
# convert the month-day-year format to a date-time using the mdy() lubirdate function
heber.tibble.sep$collectiondate <- mdy(heber.tibble.sep$collectiondate)
heber.tibble.sep$deploydate <- mdy(heber.tibble.sep$deploydate)

# using the year() function from lubridate to extract the year from collectiondate column
# create a new column in the tibble to store this year value
heber.tibble.sep <- add_column(heber.tibble.sep, year = year(heber.tibble.sep$collectiondate), .after = "collectiondate")

# view this tibble
View(heber.tibble.sep)

# select the data from the year of interest
heber.tibble.2019 <- filter(heber.tibble.sep, year == 2019)

# view this tibble
View(heber.tibble.2019)

# sum up values from the file column
# the resulting value will be the total number of files collected in that year
# but this value does not include files from 'analysis' or 'subjects' folders
sum(heber.tibble.2019$file)
