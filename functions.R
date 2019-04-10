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
  ## calculate the number of horses in from the 1st detection, store that in new column 
  
  count1 <- ifelse(cameradf$Count1Species %in% species, cameradf$Count1Total, 0)
  count2 <- ifelse(cameradf$Count2Species %in% species, cameradf$Count2Total, 0)
  count3 <- ifelse(cameradf$Count3Species %in% species, cameradf$Count3Total, 0)
  count4 <- ifelse(cameradf$Count4Species %in% species, cameradf$Count4Total, 0)
  count5 <- ifelse(cameradf$Count5Species %in% species, cameradf$Count5Total, 0)
  total <- (count1+count2+count3+count4+count5)
  return(total)
}

# this function uses the "speciestotal" function and applys it to all species in the dataframe
allspecies <- function(cameradf) {
  cameradf$ATVcount <- speciestotal(cameradf,  species = "ATV")
  cameradf$bearcount <- speciestotal(cameradf,  species = "Bear")
  cameradf$bobcatcount <- speciestotal(cameradf,  species = "Bobcat")
  cameradf$cottontailcount <- speciestotal(cameradf, species = "Cottontail")
  cameradf$cowcount <- speciestotal (cameradf, species = "Cow")
  cameradf$coyotecount <- speciestotal(cameradf, species = "Coyote")
  cameradf$dogcount <- speciestotal(cameradf, species = "Dog")
  cameradf$elkcout <- speciestotal (cameradf, species = "Elk")
  cameradf$greyfoxcount <- speciestotal(cameradf, species = "Greyfox")
  cameradf$horsecount <- speciestotal (cameradf, species = "Horse")
  cameradf$horsebackcount <- speciestotal (cameradf, species = "Horseback")
  cameradf$jackrabbitcount <- speciestotal (cameradf, species = "Jackrabbit")
  cameradf$deercount <- speciestotal (cameradf, species = "Muledeer")
  cameradf$othercount <- speciestotal (cameradf, species = "Other")
  cameradf$humancount <- speciestotal (cameradf, species = "Person")
  cameradf$pronghorncount <- speciestotal (cameradf, species = "Pronghorn")
  cameradf$raccooncount <- speciestotal (cameradf, species = "Raccoon")
  cameradf$skunkcount <- speciestotal (cameradf, species = "Skunk")
  cameradf$truckcount <- speciestotal(cameradf, species = "Truck/SUV")
  cameradf$turkeycount <- speciestotal(cameradf, species = "Turkey")
  cameradf$ukncaninecount <- speciestotal(cameradf, species = "Unk Canine")
  cameradf$UTVcount <- speciestotal(cameradf, species = "UTV")
  cameradf$wolfcount <- speciestotal(cameradf, species = "Wolf")
  cameradf$NAcount <- speciestotal(cameradf, species = "NA")
  return(cameradf)
}