# clear the R environment
rm(list=ls(all=TRUE))

# load in the required libraries
source("C:/Users/andre/Dropbox/Rproj/Horse-Cattle-Elk-Grazing-Interaction-Study/packages.R")
source("C:/Users/andre/Dropbox/Rproj/Horse-Cattle-Elk-Grazing-Interaction-Study/functions.R")

# set working directory to location of excel files
# file.path() is system agnostic (i.e. works on Mac/PC/Linux)
setwd(file.path("C:", "temp", "xlsm", "csv", "recombined"))

# check that working directory is correct
getwd()

# store the location of the current working directory
currentwd <- getwd()

csv_file_list <- list.files(currentwd, pattern = ".csv")

print(csv_file_list)

csv_files_df <- data.frame(csv_file_list)

names(csv_files_df)[names(csv_files_df) == "csv_file_list"] <- "path"

csv_files_df

csv_files_df_separated <- separate(csv_files_df, path, 
                                   into = c("sitecode",
                                            "deploydate",
                                            "collectdate",
                                            "subjects",
                                            "all",
                                            "chunks"),
                                   sep = "_", 
                                   remove = FALSE)

View(csv_files_df_separated)

# print the site codes in console
unique(csv_files_df_separated$sitecode)

A51 <- filter(csv_files_df_separated, sitecode == "A51")
BKD <- filter(csv_files_df_separated, sitecode == "BKD")
BKN <- filter(csv_files_df_separated, sitecode == "BKN")
BKS <- filter(csv_files_df_separated, sitecode == "BKS")
BRL <- filter(csv_files_df_separated, sitecode == "BRL")
BRT <- filter(csv_files_df_separated, sitecode == "BRT")


