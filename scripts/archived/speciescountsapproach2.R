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
BGX18RAW<-read.csv('./Data/Photo/BGX_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
BGW18RAW<-read.csv('./Data/Photo/BGW_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
BGT18RAW<-read.csv('./Data/Photo/BGT_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
WCX18RAW<-read.csv('./Data/Photo/WCX_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
WCS18RAW<-read.csv('./Data/Photo/WCS_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))
WCT18RAW<-read.csv('./Data/Photo/WCT_Analysis_2018.csv', header=TRUE, na.strings=c(""," ","NA"))

## read in the 2017 data, treating all blanks, spaces, and "NA"s as NA's
BGW17RAW<-read.csv('./Data/Photo/BGW_Analysis_2017.csv', header=TRUE, na.strings=c(""," ","NA"))
WCS17RAW<-read.csv('./Data/Photo/WCS_Analysis_2017.csv', header=TRUE, na.strings=c(""," ","NA"))

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
## remeber that to use the sum function you must first 
sum(BGW18$Count1Total, na.rm = TRUE)
sum(BGW18$Count2Total, na.rm = TRUE)
sum(BGW18$Count3Total, na.rm = TRUE)

## how many photos are multi-species detections?
summary(BGW18$TraitB2)

# ## calculate the number of horses in from the 1st detection, store that in new column 
# BGW18 <- mutate(BGW18, horsecount1 = ifelse(Count1Species %in% "Horse", Count1Total, 0))
# ## calculate the number of horses in from the 2nd detection, store that in new column 
# BGW18 <- mutate(BGW18, horsecount2 = ifelse(Count2Species %in% "Horse", Count2Total, 0))
# ## calculate the number of horses in from the 3rd detection, store that in new column 
# BGW18 <- mutate(BGW18, horsecount3 = ifelse(Count3Species %in% "Horse", Count3Total, 0))
# ## sum the number of horses from each detection, and put that into a new column
# BGW18 <- mutate(BGW18, horsetotal = horsecount1+horsecount2+horsecount3)
# 
# ## calculate the number of cows in from the 1st detection, store that in new column 
# BGW18 <- mutate(BGW18, cowcount1 = ifelse(Count1Species %in% "Cow", Count1Total, 0))
# ## calculate the number of cows in from the 2nd detection, store that in new column 
# BGW18 <- mutate(BGW18, cowcount2 = ifelse(Count2Species %in% "Cow", Count2Total, 0))
# ## calculate the number of cows in from the 3rd detection, store that in new column 
# BGW18 <- mutate(BGW18, cowcount3 = ifelse(Count3Species %in% "Cow", Count3Total, 0))
# ## sum the number of cows from each detection, and put that into a new column
# BGW18 <- mutate(BGW18, cowtotal = cowcount1+cowcount2+cowcount3)
# 
# ## calculate the number of elks in from the 1st detection, store that in new column 
# BGW18 <- mutate(BGW18, elkcount1 = ifelse(Count1Species %in% "Elk", Count1Total, 0))
# ## calculate the number of elks in from the 2nd detection, store that in new column 
# BGW18 <- mutate(BGW18, elkcount2 = ifelse(Count2Species %in% "Elk", Count2Total, 0))
# ## calculate the number of elks in from the 3rd detection, store that in new column 
# BGW18 <- mutate(BGW18, elkcount3 = ifelse(Count3Species %in% "Elk", Count3Total, 0))
# ## sum the number of elks from each detection, and put that into a new column
# BGW18 <- mutate(BGW18, elktotal = elkcount1+elkcount2+elkcount3)
# 
# ## sum the number of horses in each column
# sum(BGW18$horsecount1)
# sum(BGW18$horsecount2)
# sum(BGW18$horsecount3)
# sum(BGW18$horsetotal)
# 
# ## sum the number of cows in each column
# sum(BGW18$cowcount1)
# sum(BGW18$cowcount2)
# sum(BGW18$cowcount3)
# sum(BGW18$cowtotal)
# 
# ## sum the number of elk in each column
# sum(BGW18$elkcount1)
# sum(BGW18$elkcount2)
# sum(BGW18$elkcount3)
# sum(BGW18$elktotal)

## write a function to abstract the above code
speciestotal <- function(cameradf, species) {
  ## calculate the number of horses in from the 1st detection, store that in new column 

  count1 <- ifelse(cameradf$Count1Species %in% species, cameradf$Count1Total, 0)
  count2 <- ifelse(cameradf$Count2Species %in% species, cameradf$Count2Total, 0)
  count3 <- ifelse(cameradf$Count3Species %in% species, cameradf$Count3Total, 0)
  total <- (count1+count2+count3)
  return(total)
}

BGW18$horses <- speciestotal (BGW18, "Horse")
BGW18$cows <- speciestotal (BGW18, "Cow")
BGW18$elk <- speciestotal (BGW18, "Elk")
BGW18$muledeer <- speciestotal (BGW18, "Muledeer")
BGW18$pronghorn <- speciestotal (BGW18, "Pronghorn")
BGW18$person <- speciestotal (BGW18, "Person")
View(BGW18)

## some summary plots to visualize the data
plot(BGW18$horsetotal)
hist(BGW18$horsetotal)
barplot(BGW18$horsetotal)

## create a new df
df<- data.frame(species = c("horses", "cows", "elk", "muledeer", "pronghorn"), 
                freq = (c(sum(BGW18$horses), sum(BGW18$cows), sum(BGW18$elk), sum(BGW18$muledeer), sum(BGW18$pronghorn)))
                )
## examine what this new data frame to hold the species counts looks like 
head(df)
## examine the structure of the new data frame to see how the variable are stored
str(df)
## use the base graphics package to create a basic graph
barplot(df$freq)

## experimenting with ggplot 2
## ggplot2 is a more efficient way to create figures (i.e. fewer lines of code) 
## summary count for Boggy West 2018
## I'm using the convention 'f' supplied by the ggplot2 cheatsheet

vignette("ggplot2-specs")
## alpha represents column/point transparency
## color represents column/point outline color
## fill represents column/point fill color
## size represents the width/weight of the column/point outline
## linetype represents the type of line: 0 = blank, 1 = solid, 2 = dashed, 3 = dotted, 4 = dotdash, 5 = longdash, 6 = twodash

f <- ggplot(df, aes(x = species, y = freq))
f + 
  geom_col(alpha = 1,
           color = "Black",
           fill = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
           size = .5,
           linetype = 1) +
  ggtitle("Boggy West Timelapse 2018") +
  theme(plot.title = element_text(hjust = 0.5, size = 18),
        axis.title.x = element_text(size = 18), 
        axis.title.y = element_text(size = 18),
        axis.text.x = element_text(color = "Black", size = 14),
        axis.text.y = element_text(color = "Black", size = 14)) + 
  annotate(geom = "text", x = 1, y = 400, label = "199") +
  annotate(geom = "text", x = 2, y = 1100, label = "898") +
  annotate(geom = "text", x = 3, y = 5300, label = "5135") +
  annotate(geom = "text", x = 4, y = 500, label = "329") +
  annotate(geom = "text", x = 5, y = 200, label = "55") +
  scale_x_discrete(name = NULL, labels = c("Cattle", "Elk", "Horses", "Mule Deer", "Pronghorn")) + 
  scale_y_continuous(name = "Count", breaks = seq(0, 6000, by=1000), limits = c(0, 6000))
ggsave("BGW18Counts.png", width = 7, height = 5)


