# load in the required libraries
library(packrat)
library(tidyverse)
library(stringi)
library(beepr)

# print the current R version in the console to check if your R version matches mine (which is 4.0.3)
R.Version()

# print the session info to check which language locale is currently configured for this environment
# this is important because the locale sets the text file encoding on the OS
sessionInfo()

# clear the R environment
rm(list=ls(all=TRUE))

# J:\cameratraps\boggy\trail\BGT_07302019_09182019

# Define the location of the files on the external hard drive
# Changing these inputs here makes it so you don't have to change them elsewhere in the script
# Don't repeat yourself (DRY)
root_folder <- "J:"

main_folder <- "cameratraps"

location_folder <- "boggy"

site_folder <- "trail"

collection_folder <- "BGT_07302019_09182019"

# set the working directory to read in the files from the correct location on your hard drive (or on an external hard drive)
# the files you need to access might be in a different location on your computer therefore you likely will need to change the line below
setwd(file.path(root_folder, main_folder, location_folder, site_folder, collection_folder))

# double check the working directory to make sure its correct
getwd()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv(paste0(getwd(), paste0("/metadata/", collection_folder, ".csv")))

