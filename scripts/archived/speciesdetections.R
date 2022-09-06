## Wild Horse Ecological Interactions Analysis
## White Mountain Sites
## Boggy West Timelapse, Boggy Exclosure, Boggy Trail (Motion), Wildcat South Timelapse, Wildcat Exclosure, Wildcat Trail (Motion)
## 01/29/2019
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

## View the new dataframe with the NA species removed from the Count1Species column
View(BGW18)

## check the dimesions on the new data frame, compare to old 
dim(BGW18)

## remove the RAW .csv files from the Enviornment; don't need them anymore
rm(BGT18RAW, BGW17RAW, BGW18RAW, BGX18RAW, WCS17RAW, WCS18RAW, WCT18RAW, WCX18RAW)

## double check in Excel that the functioned removed only the No Detections
## write.csv(BGW18, file = "BGW18_NAs_Removed.csv", col.names = TRUE)

## summarize the species count
summary(BGW18$Count1Species)
summary(BGW18$Count2Species)

## store number of detections (i.e. # of photos) in a new object
BGT18detections<- (table(BGT18$Count1Species))
BGW17detections<- (table(BGW17$Count1Species))
BGW18detections<- (table(BGW18$Count1Species))
BGX18detections<- (table(BGX18$Count1Species))
WCS17detections<- (table(WCS17$Count1Species))
WCS18detections<- (table(WCS18$Count1Species))
WCT18detections<- (table(WCT18$Count1Species))
WCX18detections<- (table(WCX18$Count1Species))

## View(BGW18detections)
str(BGW18detections)

# remove non-grazers from detections
BGT18detections<- BGT18detections[-c(1, 3, 4, 7, 9, 10)]
BGW17detections<- BGW17detections[-c(1, 3, 4, 6, 9, 10, 11)]
BGW18detections<- BGW18detections[-c(1, 3, 5, 8, 9, 11)]
BGX18detections<- BGX18detections[-c(1, 3, 5, 6, 7)]
WCS17detections<- WCS17detections[-c(1, 3, 4, 8, 9, 11, 12, 13, 14, 15)]
WCS18detections<- WCS18detections[-c(1, 2, 4, 8, 9, 11, 12, 13)]
WCT18detections<- WCT18detections[-c(1, 2, 4, 6, 9, 10, 12, 13)]
WCX18detections<- WCX18detections[-c(1, 2, 3, 7, 8, 10, 11, 12)]

show_col(viridis_pal()(5))
## viridis_pal()(5)
## "#440154FF" Cow
## "#3B528BFF" Elk
## "#21908CFF" Horse
## "#5DC863FF" Mule Deer
## "#FDE725FF" Pronghorn

## plot detection count as a preliminary summary
## plot 1
plot.new()
jpeg(filename = "BGT18_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(BGT18detections,
     col = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
     main ="Boggy Creek Grazed Site
Trail Camera  2018",
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 1000),
     las = 0)
axis(2, at = seq(0, 1000, by=100), cex.axis = 2)
#axis(1, at = seq(0.7, 5.5, by=1.2), labels = c("Cattle", "Elk", "Horses", "Mule Deer", "Pronghorn"), cex.axis = 1.5)
dev.off()

## plot 2
jpeg(filename = "BGW17_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(BGW17detections,
        col = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
     main ="Boggy Creek Grazed Site
     2017 ", 
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 2000),
     las = 0)
axis(2, at = seq(0, 2000, by=100), cex.axis = 2)
dev.off()

## plot 3
jpeg(filename = "BGW18_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(BGW18detections,
        col = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
     main ="Boggy Creek Grazed Site
     2018",
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 2000),
     las = 0)
axis(2, at = seq(0, 2000, by=100), cex.axis = 2)
dev.off()

## plot 4
jpeg(filename = "BGX18_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(BGX18detections,
        col = c("#3B528BFF", "#5DC863FF"),
     main ="Boggy Creek Exclosure Site
     2018",
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 1000),
     las = 0)
axis(2, at = seq(0, 1000, by=100), cex.axis = 2)
dev.off()

## plot 5
jpeg(filename = "WCS17_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(WCS17detections,
        col = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
     main ="Wildcat Creek Grazed Site
     2017",
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 6000),
     las = 0)
axis(2, at = seq(0, 6000, by=500), cex.axis = 2)
dev.off()

## plot 6
jpeg(filename = "WCS18_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(WCS18detections,
        col = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
     main ="Wildcat Creek Grazed Site
     2018",
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 6000),
     las = 0)
axis(2, at = seq(0, 6000, by=500), cex.axis = 2)
dev.off()

## plot 7
jpeg(filename = "WCT18_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(WCT18detections,
        col = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
     main ="Wildcat Creek Grazed Site
Trail Camera 2018",
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 1000),
     las = 0)
axis(2, at = seq(0, 1000, by=100), cex.axis = 2)
dev.off()

## plot 8
jpeg(filename = "WCX18_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(WCX18detections,
        col = c("#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
     main ="Wildcat Creek Exclosure Site
     2018",
     cex.main = 3,
     cex.lab = 2,
     cex.names = 2,
     axes = FALSE,
     xlab = NA,
     ylab ="Number of Detections",
     ylim = c(0, 1000),
     las = 0)
axis(2, at = seq(0, 1000, by=100), cex.axis = 2)
dev.off()

## 