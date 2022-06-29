#!/bin/bash

# set the working directory to the grazing-interaction repo
cd ./Users/andre/Dropbox/Dev/grazing-interaction

# set the Cyverse working directory to where we store the grazing data
icd ./grazing_data

# sync the local copy of the data to the Cyverse data store
irsync -rVK ./data i:./data

# this is the corresponding cron command to sync the data every day at 5 PM
# 0 17 * * * /Users/andre/Dropbox/Dev/grazing-interaction/scripts/utilities/sync-data-to-cyverse.sh

# this is the corresponding cron command to sync the data every day at 8 AM
# 0 8 * * * /Users/andre/Dropbox/Dev/grazing-interaction/scripts/utilities/sync-data-to-cyverse.sh

# this assumues the cwd is /iplant/home/aantaya
# irsync -rVK ./cameratraps2 i:./cameratraps2

