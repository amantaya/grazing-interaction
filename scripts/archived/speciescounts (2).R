## Wild Horse Ecological Interactions Analysis
## White Mountain Sites
## Boggy West Timelapse, Boggy Exclosure, Boggy Trail (Motion), Wildcat South Timelapse, Wildcat Exclosure, Wildcat Trail (Motion)
## 2/20/2019
## Written by Andrew Antaya

library("ggplot2", lib.loc= "~/R/win-library/3.5")
library("dplyr", lib.loc= "~/R/win-library/3.5")
library("jpeg", lib.loc= "~/R/win-library/3.5")
library("viridis", lib.loc = "~/R/win-library/3.5")
library("scales", lib.loc = "~/R/win-library/3.5")

## clear the enviroment
rm(list=ls(all=TRUE))

## set working directory and check if it's correct
setwd('C:/Users/Andrew/Dropbox/Horse_Research/Analysis')
getwd()

## read in the 2018 data, treating all blanks, spaces, and "NA"s as NA's
BGX18RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/BGX_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
BGW18RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/BGW_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
BGT18RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/BGT_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
WCX18RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/WCX_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
WCS18RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/WCS_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
WCT18RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/WCT_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))

## read in the 2017 data, treating all blanks, spaces, and "NA"s as NA's
BGW17RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/BGW_Analysis_2017.csv', header=TRUE, na.strings=c(""," ","NA"))
WCS17RAW<-read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Photo/WCS_Analysis_2017.csv', header=TRUE, na.strings=c(""," ","NA"))

## preview the file
## View(BGW18RAW)

## look at data frame structure
str(BGW18RAW)

## remove the observations that have NAs in the Count1Species column
BGT18<- BGT18RAW[complete.cases(BGT18RAW[ , 'Count1Species']),]
BGW17<- BGW17RAW[complete.cases(BGW17RAW[ , 'Count1Species']),]
BGW18<- BGW18RAW[complete.cases(BGW18RAW[ , 'Count1Species']),]
BGX18<- BGX18RAW[complete.cases(BGX18RAW[ , 'Count1Species']),]
WCS17<- WCS17RAW[complete.cases(WCS17RAW[ , 'Count1Species']),]
WCS18<- WCS18RAW[complete.cases(WCS18RAW[ , 'Count1Species']),]
WCT18<- WCT18RAW[complete.cases(BGW18RAW[ , 'Count1Species']),]
WCX18<- WCX18RAW[complete.cases(BGW18RAW[ , 'Count1Species']),]

## start simplfying this dataframe
## remove the Species 25 to Species 68 columns, they're empty
BGW18[65:109] <- list(NULL)
BGW17[65:109] <- list(NULL)
BGT18[65:109] <- list(NULL)
BGX18[65:109] <- list(NULL)
WCS17[65:109] <- list(NULL)
WCS18[65:109] <- list(NULL)
WCT18[65:109] <- list(NULL)
WCX18[65:109] <- list(NULL)

## View the new dataframe with the NA species removed from the Count1Species column
#View(BGW18)

## check the dimesions on the new data frame, compare to old 
dim(BGW18)
dim(BGW18RAW)

## remove the RAW .csv files from the Enviornment; don't need them anymore
rm(BGT18RAW, BGW17RAW, BGW18RAW, BGX18RAW, WCS17RAW, WCS18RAW, WCT18RAW, WCX18RAW)

## double check in Excel that the functioned removed only the No Detections
## write.csv(BGW18, file = "BGW18_NAs_Removed.csv", col.names = TRUE)

str(BGW18)

## summarize the number of photos by species detection (does not account for # indv in each photo)
summary(BGW18$Count1Species)
summary(BGW18$Count2Species)
summary(BGW18$Count3Species)

## count the number of individuals in each photo, not sorted by species
sum(BGW18$Count1Total, na.rm = TRUE)
sum(BGW18$Count2Total, na.rm = TRUE)
sum(BGW18$Count3Total, na.rm = TRUE)

## how many photos are multi-species detections?
summary(BGW18$TraitB2)

## add in blank column to count the number of horses in each photo
BGW18$horsecount1 <- 0
BGW17$horsecount1 <- 0
BGT18$horsecount1 <- 0
BGX18$horsecount1 <- 0
WCS17$horsecount1 <- 0
WCS18$horsecount1 <- 0
WCT18$horsecount1 <- 0
WCX18$horsecount1 <- 0

## if the 1st species detected in a photo is a horse, add the number of horses in each photo to the horse count column
BGW18$horsecount1<- ifelse(BGW18$Count1Species == "Horse", BGW18$Count1Total, 0)
BGW17$horsecount1<- ifelse(BGW17$Count1Species == "Horse", BGW17$Count1Total, 0)
BGT18$horsecount1<- ifelse(BGT18$Count1Species == "Horse", BGT18$Count1Total, 0)
BGX18$horsecount1<- ifelse(BGX18$Count1Species == "Horse", BGX18$Count1Total, 0)
WCS17$horsecount1<- ifelse(WCS17$Count1Species == "Horse", WCS17$Count1Total, 0)
WCS18$horsecount1<- ifelse(WCS18$Count1Species == "Horse", WCS18$Count1Total, 0)
WCT18$horsecount1<- ifelse(WCT18$Count1Species == "Horse", WCT18$Count1Total, 0)
WCX18$horsecount1<- ifelse(WCX18$Count1Species == "Horse", WCX18$Count1Total, 0)

## add in blank column to count the number of horses in each photo
BGW18$horsecount2 <- 0
BGW17$horsecount2 <- 0
BGT18$horsecount2 <- 0
BGX18$horsecount2 <- 0
WCS17$horsecount2 <- 0
WCS18$horsecount2 <- 0
WCT18$horsecount2 <- 0
WCX18$horsecount2 <- 0

## if the 2nd species detected in the photo is a horse, add the number of horses in each photo to the horse count column
BGW18$horsecount2<- ifelse(BGW18$Count2Species == "Horse", BGW18$Count2Total, 0)
BGW17$horsecount2<- ifelse(BGW17$Count2Species == "Horse", BGW17$Count2Total, 0)
BGT18$horsecount2<- ifelse(BGT18$Count2Species == "Horse", BGT18$Count2Total, 0)
BGX18$horsecount2<- ifelse(BGX18$Count2Species == "Horse", BGX18$Count2Total, 0)
WCS17$horsecount2<- ifelse(WCS17$Count2Species == "Horse", WCS17$Count2Total, 0)
WCS18$horsecount2<- ifelse(WCS18$Count2Species == "Horse", WCS18$Count2Total, 0)
WCT18$horsecount2<- ifelse(WCT18$Count2Species == "Horse", WCT18$Count2Total, 0)
WCX18$horsecount2<- ifelse(WCX18$Count2Species == "Horse", WCX18$Count2Total, 0)

## add in blank column to count the number of horses in each photo
BGW18$horsecount3 <- 0
BGW17$horsecount3 <- 0
BGT18$horsecount3 <- 0
BGX18$horsecount3 <- 0
WCS17$horsecount3 <- 0
WCS18$horsecount3 <- 0
WCT18$horsecount3 <- 0
WCX18$horsecount3 <- 0

## if the 3rd species detected in the photo is a horse, add the number of horses in each photo to the horse count column
BGW18$horsecount3<- ifelse(BGW18$Count3Species == "Horse", BGW18$Count3Total, 0)
BGW17$horsecount3<- ifelse(BGW17$Count3Species == "Horse", BGW17$Count3Total, 0)
BGT18$horsecount3<- ifelse(BGT18$Count3Species == "Horse", BGT18$Count3Total, 0)
BGX18$horsecount3<- ifelse(BGX18$Count3Species == "Horse", BGX18$Count3Total, 0)
WCS17$horsecount3<- ifelse(WCS17$Count3Species == "Horse", WCS17$Count3Total, 0)
WCS18$horsecount3<- ifelse(WCS18$Count3Species == "Horse", WCS18$Count3Total, 0)
WCT18$horsecount3<- ifelse(WCT18$Count3Species == "Horse", WCT18$Count3Total, 0)
WCX18$horsecount3<- ifelse(WCX18$Count3Species == "Horse", WCX18$Count3Total, 0)

##
sum(BGW18$horsecount1, na.rm = TRUE)
sum(BGW18$horsecount2, na.rm = TRUE)
sum(BGW18$horsecount3, na.rm = TRUE)
sum(BGW18$horsetotal, na.rm = TRUE)

BGW18$horsetotal <- 0
BGW17$horsetotal <- 0
BGT18$horsetotal <- 0
BGX18$horsetotal <- 0
WCS17$horsetotal <- 0
WCS18$horsetotal <- 0
WCT18$horsetotal <- 0
WCX18$horsetotal <- 0

BGW18$horsetotal <- BGW18$horsecount1+BGW18$horsecount2
BGW17$horsetotal <- sum(BGW17$horsecount1+BGW17$horsecount2+BGW17$horsecount3)
BGT18$horsetotal <- sum(BGT18$horsecount1+BGT18$horsecount2+BGT18$horsecount3)
BGX18$horsetotal <- sum(BGX18$horsecount1+BGX18$horsecount2+BGX18$horsecount3)
WCS17$horsetotal <- sum(WCS17$horsecount1+WCS17$horsecount2+WCS17$horsecount3)
WCS18$horsetotal <- sum(WCS18$horsecount1+WCS18$horsecount2+WCS18$horsecount3)
WCT18$horsetotal <- sum(WCT18$horsecount1+WCT18$horsecount2+WCT18$horsecount3)
WCX18$horsetotal <- sum(WCX18$horsecount1+WCX18$horsecount2+WCX18$horsecount3)