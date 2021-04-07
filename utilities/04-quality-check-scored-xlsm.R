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

# K:\cameratraps\blackcanyon\timelapsenorth\BKN_08132019_11052019

# Define the location of the files on the external hard drive
root_folder <- "K:"

main_folder <- "cameratraps"

location_folder <- "blackcanyon"

site_folder <- "timelapsenorth"

collection_folder <- "BKN_08132019_11052019"

subjects_folder <- "subjects"

# set the working directory to read in the files from the correct location on your hard drive (or on an external hard drive)
setwd(file.path(root_folder, main_folder, location_folder, site_folder, collection_folder))

# double check the working directory to make sure its correct
getwd()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
all_photos_in_collection <- read.csv(paste0(getwd(), paste0("/metadata/", collection_folder, "_matched_subject_photos", ".csv")))
