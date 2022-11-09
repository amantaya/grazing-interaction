# local r docker container running on port 8787
# this command disables authentication so only use it on a localhost/private network
docker run -d -e DISABLE_AUTH=true -e ROOT=TRUE --rm -p 127.0.0.1:8787:8787 `
-v C:/Users/andre/Dropbox/Dev/grazing-interaction:/home/rstudio/grazing-interaction `
-v C:/Users/andre/temp:/home/rstudio/temp `
-v G:/cameratraps:/home/rstudio/cameratraps `
-v G:/cameratraps2:/home/rstudio/cameratraps2 `
amantaya/rocker-verse:4.0.5
