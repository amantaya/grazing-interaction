# Compare CSV Files

rm(list = ls())

# set the working directory and environment variables
source("~/grazing-interaction/environment.R")

# load in the required packages
source("~/grazing-interaction/packages.R")

# load in the required functions

current_csv_file <- file.path(currentwd,
                              "data",
                              "photo",
                              "combined-by-site-year",
                              "unprocessed",
                              "2018_BGT.csv")

old_csv_file <- file.path(currentwd,
                          "data",
                          "photo",
                          "combined-by-site-year",
                          "archive",
                          "2022-08-04",
                          "2018_BGT.csv")

diffobj::diffCsv(target = old_csv_file,
                 current = current_csv_file,
                 mode = "sidebyside")



