
library(tidyverse)

# clear the enviroment
rm(list=ls(all=TRUE))

# check that the current working directory is correct
getwd()

# set the current working directory to the correct location if it is not correct
setwd("J:/")

# create a list of all sub-folders within the 'cameratraps' folder
allcamerafolders <- list.dirs(path = "J:/cameratraps", full.names=T)

# view the list of camera trap folders and any sub-folders inside the R environment
View(allcamerafolders)

# check the data structure before converting it to a different data structure
str(allcamerafolders)

# 'allcamerfolders' is a character vector so we should convert it to a dataframe before adding column names
allcamerafolders.df <- as_tibble(allcamerafolders)

# rename the first column "value" in the 'allcamerafolders.df' to "path"
names(allcamerafolders.df)[names(allcamerafolders.df) == "value"] <- "path"

# separate the first column into new columns using the "/" character in the "path" as a separator 
allcamerafolders.df.separated <- separate(allcamerafolders.df, path, into = c("root", "mainfolder", "locationfolder", "sitefolder", "collectionfolder", "subfolder"), sep = "/", remove = FALSE)

# add an additional column to keep the number of files 
allcamerafolders.df.separated$numfiles <- NA

# view the new data frame
View(allcamerafolders.df.separated)

write.csv(allcamerafolders.df.separated, file = "allcamerafolders-2020-03-02.csv", row.names = F)
