# Functions for working with timelapse photo data
# Design to be read into the R environment and then called when needed by another script
# Written by Andrew Antaya
# April 8, 2019

# this function counts the number of individuals (of the same species) in each photo
# the species may be the 1st species detected, 2nd species detected, or 3rd species detected in each photo
# "cameradf" is the name of the camera dataframe that you want to analyze
# "species" is the name of the species you want to count (Note: sensitive to case and spelling errors)
# returns a new column in the specified camera dataframe labled by the specified species 

## custom Standard Error function
se <- function(x) sqrt(var(x)/length(x))


#clean dates
cleandates <- function(cameradf){
  cameradf <- unite(cameradf, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
  cameradf$DateTime <- mdy_hms(cameradf$DateTime)
  cameradf <- arrange(cameradf, DateTime)
  return(cameradf)
}

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
  cameradf$horse<- speciestotal (cameradf, species = "Horse")
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
  cameradf.counts <- data.frame(species = c("Horses", "Cattle", "Elk"), 
             freq = (c(sum(cameradf$horse), sum(cameradf$cow), sum(cameradf$elk)
                       )
                     )
             )
}

# function to abstract group detections for each site
group.df <- function (cameradf){
cameradfhorses <- cameradf[cameradf$horse >0, ]
cameradfcows <- cameradf[cameradf$cow >0, ]
cameradfelk <- cameradf[cameradf$elk >0, ]
# 
# cameradfhorses <- unite(cameradfhorses, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
# cameradfcows <- unite(cameradfcows, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
# cameradfelk <- unite(cameradfelk, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
# 
# cameradfhorses$DateTime <- mdy_hms(cameradfhorses$DateTime)
# cameradfcows$DateTime <- mdy_hms(cameradfcows$DateTime)
# cameradfelk$DateTime <- mdy_hms(cameradfelk$DateTime)
# 
# cameradfhorses <- arrange(cameradfhorses, DateTime)
lag_time_diff <- difftime(cameradfhorses$DateTime, lag(cameradfhorses$DateTime, default = cameradfhorses$DateTime[1]), units = "mins")
cameradfhorses$group <- cumsum(ifelse(lag_time_diff>10,1,0))
cameradfhorses$group <- cameradfhorses$group+1

# cameradfcows <- arrange(cameradfcows, DateTime)
lag_time_diff <- difftime(cameradfcows$DateTime, lag(cameradfcows$DateTime, default = cameradfcows$DateTime[1]), units = "mins")
cameradfcows$group <- cumsum(ifelse(lag_time_diff>10,1,0))
cameradfcows$group <- cameradfcows$group+1

# cameradfelk <- arrange(cameradfelk, DateTime)
lag_time_diff <- difftime(cameradfelk$DateTime, lag(cameradfelk$DateTime, default = cameradfelk$DateTime[1]), units = "mins")
cameradfelk$group <- cumsum(ifelse(lag_time_diff>10,1,0))
cameradfelk$group <- cameradfelk$group+1

horses <- if(length(tail(cameradfhorses$group, n = 1)) >0){
  tail(cameradfhorses$group, n = 1)
} else {
  0
}
cows <- if(length(tail(cameradfcows$group, n = 1)) >0){
  tail(cameradfcows$group, n = 1)
} else {
  0
}
elk <- if(length(tail(cameradfelk$group, n = 1)) >0){
  tail(cameradfelk$group, n = 1)
} else {
  0
}
return (cameradfGroups<- data.frame(species = c("horses", "cows", "elk"), 
                         groups = (c(horses, cows, elk)))
)
}


# this function takes the total number of individuals from each hourly interval (e.g., from 00:00:00 to 00:59:00)
# and puts each value into a vector, which is then put into a data frame for plotting
sumbyhour<- function (cameradf, species){

cameradf$hour<- hour(cameradf$DateTime)

hour0 <- sum(ifelse (cameradf$hour == 0, cameradf[,species], 0))
hour1 <- sum(ifelse (cameradf$hour == 1, cameradf[,species], 0))
hour2 <- sum(ifelse (cameradf$hour == 2, cameradf[,species], 0))
hour3 <- sum(ifelse (cameradf$hour == 3, cameradf[,species], 0))
hour4 <- sum(ifelse (cameradf$hour == 4, cameradf[,species], 0))
hour5 <- sum(ifelse (cameradf$hour == 5, cameradf[,species], 0))
hour6 <- sum(ifelse (cameradf$hour == 6, cameradf[,species], 0))
hour7 <- sum(ifelse (cameradf$hour == 7, cameradf[,species], 0))
hour8 <- sum(ifelse (cameradf$hour == 8, cameradf[,species], 0))
hour9 <- sum(ifelse (cameradf$hour == 9, cameradf[,species], 0))
hour10 <- sum(ifelse (cameradf$hour == 10, cameradf[,species], 0))
hour11 <- sum(ifelse (cameradf$hour == 11, cameradf[,species], 0))
hour12 <- sum(ifelse (cameradf$hour == 12, cameradf[,species], 0))
hour13 <- sum(ifelse (cameradf$hour == 13, cameradf[,species], 0))
hour14 <- sum(ifelse (cameradf$hour == 14, cameradf[,species], 0))
hour15 <- sum(ifelse (cameradf$hour == 15, cameradf[,species], 0))
hour16 <- sum(ifelse (cameradf$hour == 16, cameradf[,species], 0))
hour17 <- sum(ifelse (cameradf$hour == 17, cameradf[,species], 0))
hour18 <- sum(ifelse (cameradf$hour == 18, cameradf[,species], 0))
hour19 <- sum(ifelse (cameradf$hour == 19, cameradf[,species], 0))
hour20 <- sum(ifelse (cameradf$hour == 20, cameradf[,species], 0))
hour21 <- sum(ifelse (cameradf$hour == 21, cameradf[,species], 0))
hour22 <- sum(ifelse (cameradf$hour == 22, cameradf[,species], 0))
hour23 <- sum(ifelse (cameradf$hour == 23, cameradf[,species], 0))
df <- data.frame(hour = c(0:23), freq = c(hour0, hour1, hour2, hour3, hour4, hour5, hour6, hour7, hour8, hour9, hour10, hour11, hour12, hour13, hour14, hour15, hour16, hour17, hour18, hour19, hour20, hour21, hour22, hour23))
return(df)
}

grpgrz_seq <- function(subdf) {
  if (length(subdf$group) <= 1) {
    subdf <- 0
    subdf$group_sequence <- 0
    grpgrazingtime <- (as.numeric(subdf$group))
  }else{
    subdf$group_sequence <- 1
    for (i in 2:(length(subdf$group))) {  
      if (subdf[i,"group"]==subdf[(i-1),"group"]) {  
        subdf[i,"group_sequence"]<-subdf[i-1,"group_sequence"]+1  
      }
    }
    first_last <- subdf %>% arrange(group_sequence) %>% group_by(group) %>% slice(c(1,n()))
    first_last<- first_last %>%
      group_by(group) %>% mutate(Diff = DateTime - lag(DateTime)) 
    
    tot<- first_last[!is.na(first_last$Diff),]
    tot$Diff[tot$Diff < 60] <- 60
    grpgrazingtime <- (as.numeric(tot$Diff))
    # grpgrazingtime <- remove_outliers(grpgrazingtime)
    grpgrazingtime <- grpgrazingtime[!is.na(grpgrazingtime)]
    grpgrazingtime <- ceiling(grpgrazingtime/60)
  }
}
