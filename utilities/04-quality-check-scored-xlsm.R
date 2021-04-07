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

# C:\TEMP\completed_xlsm\quality-check\in-progress\BKN_06112019_07022019\chunk11

# Define the location of the files on the external hard drive
root_folder <- "C:"

main_folder <- "TEMP"

location_folder <- "completed_xlsm"

site_folder <- "quality-check"

status_folder <- "in-progress"

collection_folder <- "BKN_06112019_07022019"

chunk_folder <- "chunk1"

# set the working directory to read in the files from the correct location on your hard drive (or on an external hard drive)
setwd(file.path(root_folder, main_folder, location_folder, site_folder, status_folder, collection_folder, chunk_folder))

# double check the working directory to make sure its correct
getwd()

# read in the csv file that contains the metadata for all photos in the collection folder (e.g., BRL_06052019_07022019)
chunk1csv <- read.csv(paste0(paste(collection_folder, "subjects", chunk_folder, sep = "_"), ".csv"))

sample_size <- ceiling(nrow(chunk1csv) / 10)

test_data <- slice_sample(chunk1csv, n = sample_size)

excelfilename <- paste0(paste(collection_folder, "subjects", chunk_folder, "test_data", sep = "_"), ".csv")

write.csv(test_data, excelfilename, row.names=FALSE)

andrew_data <- read.csv(paste0(paste(collection_folder, "subjects", chunk_folder, "andrew_data", sep = "_"), ".csv"))

andrew_species <- allspecies(andrew_data)

test_species <- allspecies(test_data)

andrew_counts <- counts.df(andrew_species)

andrew_counts

test_counts <- counts.df(test_species)

test_counts
