# Use this script to define environment variables that are used across multiple scripts

# Setup Git/Github Credentials --------------------------------------------
# Change this stuff
repo_url <- "https://github.com/amantaya/grazing-interaction"
github_username <- "amantaya"
github_email <- "aantaya@email.arizona.edu"
cyverse_username <- "aantaya"

# Set your git username and email address
usethis::use_git_config(user.name = github_username, user.email = github_email)

# Set your GitHub password
# If you have 2-FA enabled on your GitHub account, use a Personal Access Token
# https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
credentials::git_credential_ask(repo_url)

# Adds .DS_Store, .Rproj.user, .Rdata, .Rhistory, and .httr-oauth to your global (a.k.a. user-level) .gitignore
usethis::git_vaccinate()

# Check by running a git situation-report:
# - your user.name and user.email should appear in global Git config
usethis::git_sitrep()

# tell Git that the project directory is yours and is safe
# you may need to start a new R Studio session by clicking the "Power" button at the top-right
system("git config --global --add safe.directory /home/rstudio/grazing-interaction")

# Setup File Paths --------------------------------------------------------

# set the working directory to the default mount location in the Docker container
# the empty quotes causes file.path() to add a backslash before the first folder
setwd(file.path("", "home", "rstudio", "grazing-interaction"))
#
# check the current working directory and store it in an object for future reference
# this is where the code is temporarily stored
# IT WILL BE ERASED WHEN THE CONTAINER STOPS
currentwd <- file.path("", "home", "rstudio", "grazing-interaction")
#
# # Setup file paths to cameratraps data
path_to_cameratraps_folder <- file.path("", "home", "rstudio", "work", "data", "iplant", "home", cyverse_username, "cameratraps")
#
path_to_cameratraps2_folder <- file.path("", "home", "rstudio", "work", "data", "iplant", "home", cyverse_username, "cameratraps2")
#
# # this is the path to Cyverse user folder
path_to_user_folder <- file.path("", "home", "rstudio", "work", "data", "iplant", "home", cyverse_username)
#
# # this is the path to input data that we copied to the Docker container
path_to_data_input_folder <- file.path("", "home", "rstudio", "work", "data", "input", "grazing_data", "data")

# this is the path to the data folder on a local file system
path_to_local_data <- file.path("~", "grazing-interaction", "data")

path_to_local_cameratraps_folder <- file.path("", "home", "rstudio", "cameratraps")

# Setup Environmental Variables -------------------------------------------

# set the environment time zone to Arizona timezone
Sys.setenv(TZ = "US/Arizona")

# set the number of digits to 2
options(digits = 2)

sessioninfo <- utils::sessionInfo()

# copy my rstudio preferences into the config folder
system("cp ~/grazing-interaction/.rstudio/rstudio/rstudio-prefs.json ~/.config/rstudio/rstudio-prefs.json")

# RPushBullet Setup -------------------------------------------------------

# Enter an API key for the Push Bullet push notification service
# RPushbullet::pbSetup()

# warn if you are missing a rpushbullet config file
if (RPushbullet::pbValidateConf(conf = "~/.rpushbullet.json") == FALSE) {
  RPushbullet::pbSetup()
}

# options(error = function() {
#   RPushbullet::pbPost("note", "Error", geterrmessage())
#   if(!interactive()) stop(geterrmessage())
# })
