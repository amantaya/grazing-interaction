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
  cameradf$ATV <- speciestotal(cameradf,  species = "ATV")
  cameradf$bear <- speciestotal(cameradf,  species = "Bear")
  cameradf$bobcat <- speciestotal(cameradf,  species = "Bobcat")
  cameradf$cottontail <- speciestotal(cameradf, species = "Cottontail")
  cameradf$cow <- speciestotal (cameradf, species = "Cow")
  cameradf$coyote <- speciestotal(cameradf, species = "Coyote")
  cameradf$dog <- speciestotal(cameradf, species = "Dog")
  cameradf$elk <- speciestotal (cameradf, species = "Elk")
  cameradf$greyfox <- speciestotal(cameradf, species = "Greyfox")
  cameradf$horse <- speciestotal (cameradf, species = "Horse")
  cameradf$horseback <- speciestotal (cameradf, species = "Horseback")
  cameradf$jackrabbit <- speciestotal (cameradf, species = "Jackrabbit")
  cameradf$deer <- speciestotal (cameradf, species = "Muledeer")
  cameradf$other <- speciestotal (cameradf, species = "Other")
  cameradf$human <- speciestotal (cameradf, species = "Person")
  cameradf$pronghorn <- speciestotal (cameradf, species = "Pronghorn")
  cameradf$raccoon <- speciestotal (cameradf, species = "Raccoon")
  cameradf$skunk <- speciestotal (cameradf, species = "Skunk")
  cameradf$truck <- speciestotal(cameradf, species = "Truck/SUV")
  cameradf$turkey <- speciestotal(cameradf, species = "Turkey")
  cameradf$ukncanine <- speciestotal(cameradf, species = "Unk Canine")
  cameradf$UTV <- speciestotal(cameradf, species = "UTV")
  cameradf$wolf <- speciestotal(cameradf, species = "Wolf")
  cameradf$na <- speciestotal(cameradf, species = "NA")
  return(cameradf)
}

counts.df <- function(cameradf) {
  cameradf.counts <- data.frame(species = c("horse", "cattle", "elk", "muledeer", "pronghorn"), 
             freq = (c(sum(cameradf$horse), sum(cameradf$cow), sum(cameradf$elk), sum(cameradf$deer), sum(cameradf$pronghorn))))
}
