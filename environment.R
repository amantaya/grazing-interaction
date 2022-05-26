# Use this script to define environment variables that are used across multiple scripts

# Set the working directory to read in the files from the correct location on your computer
# the files you need to access might be in a different location on your computer
# therefore you likely will need to change the path to working directory

# Set your GitHub repo URL
repo_url <- "https://github.com/amantaya/grazing-interaction"
github_username <- "amantaya"
github_email <- "aantaya@email.arizona.edu"

# Set your git username and email address
usethis::use_git_config(user.name = github_username, user.email = github_email)

# Set your GitHub password
# If you have 2-FA enabled on your GitHub account, use a Personal Access Token
# https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
gitcreds::gitcreds_set()

# Check by running a git situation-report:
#   - your user.name and user.email should appear in global Git config
usethis::git_sitrep()

# then enter in your username and password when prompted
# https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
credentials::git_credential_ask(repo_url)

# Copy and paste the path to working directory into the comment below
# ~/cameratraps/cameratraps/blackcanyon/timelapsesouth/BKS_03062018_04102018
full_path_to_collection_folder <- "~/cameratraps/wildcat/exclosure"

# Change this to TRUE if R is currently running in a Docker container
# Change this to FALSE if R is not currently running in a Docker container

# the reason to configure file paths this way is that Docker uses mounted volumes that do not use drive letters
# a small bit of logic will switch to drive letter if it is not a Docker container
# or use the "~" tilde character if it is a Docker container
# Docker will append the path of the mounted volume before the tilde
is_Docker <- TRUE

# also configure if you are running the scripts on a single collection folder set to TRUE
# if you are running the scripts on a multiple collection folders at the same time set to FALSE
is_single_folder <- TRUE

# string split the path into a list
# this can help with keeping parts of the file path while discarding other parts
# such as when students upload text files containing the path to the photos on their computer
# be sure to use a base R function instead of a more convenient function from a package like stringr
# because the packages used in this project might not be loaded yet, causing an error
path_split_into_list <- strsplit(full_path_to_collection_folder, "/")

# these objects are required across multiple scripts, do not delete them
# indexing each element from a list reduces the amount of copy/paste
# when setting up the new working directory

root_folder <- ifelse(is_Docker == TRUE, "~", path_split_into_list[[1]][1])

main_folder <- path_split_into_list[[1]][2]

location_folder <- path_split_into_list[[1]][3]

site_folder <- path_split_into_list[[1]][4]

collection_folder <- path_split_into_list[[1]][5]

subjects_folder <- "subjects"

# construct a system agnostic file path (i.e. works on Windows/Mac/Linux)
# the "~" tilde character is used for mounted volumes on Docker containers
path_to_collection_folder <- file.path(root_folder, main_folder, location_folder, site_folder, collection_folder)

currentwd <- getwd()

# Environment Options
# set the environment time zone to local time
Sys.setenv(TZ = "US/Arizona")

