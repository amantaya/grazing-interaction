# Use this script to define environment variables that are used across multiple scripts

# Set the working directory to read in the files from the correct location on your computer
# the files you need to access might be in a different location on your computer 
# therefore you likely will need to change the path to working directory

# Copy and paste the path to working directory into the comment below
# J:\cameratraps\blackcanyon\timelapsesouth\BKS_07022019_08132019

# these objects are required across multiple scripts, do not delete them
root_folder <- "J:"

main_folder <- "cameratraps"

location_folder <- "blackcanyon"

site_folder <- "timelapsesouth"

collection_folder <- "BKS_07022019_08132019"

subjects_folder <- "subjects"

currentfolder <- file.path(root_folder, main_folder, location_folder, site_folder, collection_folder)

setwd(currentfolder)
