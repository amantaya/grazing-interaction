#!bin/bash

# this script is intended for running R Studio inside of docker containers
# to create a consistent developer experience when moving between docker containers

# copy my rstudio preferences to the .config folder for R Studio
cp ~/grazing-interaction/.rstudio/rstudio/rstudio-prefs.json ~/.config/rstudio/rstudio-prefs.json
