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
# system("git config --global --add safe.directory /home/rstudio/grazing-interaction")

# Setup File Paths --------------------------------------------------------

currentwd <- here::here()

# Paths to Data on Cyverse ------------------------------------------------

# path to "cameratraps" data on Cyverse
path_to_cameratraps_folder <- file.path("", "home", "rstudio", "work", "data", "iplant", "home", cyverse_username, "cameratraps")

# path to "cameratraps2" data on Cyverse
path_to_cameratraps2_folder <- file.path("", "home", "rstudio", "work", "data", "iplant", "home", cyverse_username, "cameratraps2")

# path to user folder on Cyverse
path_to_user_folder <- file.path("", "home", "rstudio", "work", "data", "iplant", "home", cyverse_username)

# path to input data that we copied or mounted to the Docker container
path_to_data_input_folder <- file.path("", "home", "rstudio", "work", "data", "input", "grazing_data", "data")

# Paths to Local Data -----------------------------------------------------

# this is the path to the data folder on a local file system
path_to_temp_data <- file.path("C:","Users", "andre", "temp")

path_to_external_hdd <- file.path("G:")

path_to_box_sorting_folder <- file.path("C:", "Users", "andre", "Box", "1.Ruyle_lab", "Photos-to-Sort")

# Setup Environmental Variables -------------------------------------------

# set the environment time zone to Arizona timezone
Sys.setenv(TZ = "US/Arizona")

# set the number of digits to 2
options(digits = 5)

# set the max print to 10,000
options(max.print = 100)

# RPushBullet Setup -------------------------------------------------------

# Requires a free Pushbullet API Key
# https://www.rdocumentation.org/packages/RPushbullet/versions/0.3.4/topics/pbSetup

if (interactive() == TRUE) {

# Enter an API key for the Push Bullet push notification service
options(rpushbullet.dotfile = file.path(currentwd, ".rpushbullet.json"))

# warn if you are missing a rpushbullet config file
if (RPushbullet::pbValidateConf(getOption("rpushbullet.dotfile")) == FALSE) {
  RPushbullet::pbSetup()
  }

 options(error = function() {
   RPushbullet::pbPost("note", "Error", geterrmessage())
   if (!interactive()) stop(geterrmessage())
 })
}
