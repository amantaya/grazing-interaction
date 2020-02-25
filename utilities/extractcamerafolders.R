
library(tidyverse)

# check that the current working directory is correct
getwd()

# set the current working directory to the correct location if it is not correct
# setwd("K:/")

# create a list of all sub-folders within the 'cameratraps' folder
allcamerafolders <- list.dirs(path = "J:/cameratraps", full.names=T)

# view the list of camera trap folders and any sub-folders inside the R environment
View(allcamerafolders)

# check the data structure before converting it to a different data structure
str(allcamerafolders)

# 'allcamerfolders' is a character vector so we should convert it to a dataframe before adding column names
allcamerafolders.df <- as_data_frame(allcamerafolders)

# rename the first column "value" in the 'allcamerafolders.df' to "path"
names(allcamerafolders.df)[names(allcamerafolders.df) == "value"] <- "path"

# rm(allcamerafiles)

allcamerafiles <- list.files(path = allcamerafolders.df$path, full.names = TRUE)

write.csv(allcamerafiles, file = "allcamerafiles-2020-02-21.csv", row.names = F)

# View(allcamerafiles)

length(allcamerafiles)

# separate the first column into new columns using the "/" character in the "path" as a separator 
allcamerafolders.df.separated <- separate(allcamerafolders.df, path, into = c("root", "mainfolder", "locationfolder", "sitefolder", "collectionfolder", "subfolder"), sep = "/", remove = FALSE)

View(allcamerafolders.df.separated)

write.csv(allcamerafolders.df.separated, file = "allcamerafolders-2020-02-21.csv", row.names = F)
