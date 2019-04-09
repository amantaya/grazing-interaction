# Functions for working with timelapse photo data
# Design to be read into the R environment and then called when needed by another script
# Written by Andrew Antaya
# April 8, 2019

# this function counts the number of individuals (of the same species) in each photo
# the species may be the 1st species detected, 2nd species detected, or 3rd species detected in each photo
# "cameradf" is the name of the camera dataframe that you want to analyze
# "species" is the name of the species you want to count (Note: sensitive to case and spelling errors)
# returns a new column in the specified camera dataframe labled by the specified species 

speciestotal <- function(cameradf, species) {
  count1 <- ifelse(cameradf$Count1Species %in% species, cameradf$Count1Total, 0)
  count2 <- ifelse(cameradf$Count2Species %in% species, cameradf$Count2Total, 0)
  count3 <- ifelse(cameradf$Count3Species %in% species, cameradf$Count3Total, 0)
  total <- (count1+count2+count3)
  return(total)
}
