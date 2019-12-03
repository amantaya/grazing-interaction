## Wild Horse Ecological Interactions Analysis
## White Mountain Sites
## Boggy and Wildcat Creek Grazed Sites
## Stubble Height Caclculations
## 02/07/2019
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

## read in data
Boggy18RAW <- read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Boggy Stubble Height 2018.csv',
                       header=TRUE, 
                       na.strings=c(""," ","NA"))
Wildcat18RAW <- read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Wildcat Stubble Height 2018.csv',
                         header=TRUE,
                         na.strings=c(""," ","NA"))
Boggy17RAW <- read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Boggy Stubble Height 2017.csv',
                       header=TRUE, 
                       na.strings=c(""," ","NA"))
Wildcat17RAW <- read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Wildcat Stubble Height 2017.csv',
                         header=TRUE,
                         na.strings=c(""," ","NA"))


## clean up the data by removing any missing values
Boggy18 <- Boggy18RAW[complete.cases(Boggy18RAW[ ,'Height.in']),]
Boggy17 <- Boggy17RAW[complete.cases(Boggy17RAW[ ,'Height.in']),]
Wildcat18 <- Wildcat18RAW[complete.cases(Wildcat18RAW[ ,'Height.in']),]
Wildcat17 <- Wildcat17RAW[complete.cases(Wildcat17RAW[ ,'Height.in']),]

## take a look at the data
## View(Boggy18)
## View(Boggy17)
## View(Wildcat18)
## View(Wildcat17)

## remove raw data from the environment
rm(Boggy18RAW, Boggy17RAW, Wildcat18RAW, Wildcat17RAW)

## check the data structure
str(Boggy18)
str(Boggy17)
str(Wildcat18)
str(Wildcat17)

## convert from inches to cm
Boggy18[ , "Height.cm"] <- Boggy18$Height.in*2.54
Boggy17[ , "Height.cm"] <- Boggy17$Height.in*2.54
Wildcat18[ , "Height.cm"] <- Wildcat18$Height.in*2.54
Wildcat17[ , "Height.cm"] <- Wildcat17$Height.in*2.54
## data was measured to the nearest half-inch; 
## converting to cm implies a level of precision with the additional sig figs

## calculate some summary statistics
boggy18avg <- mean(Boggy18$Height.cm)
boggy17avg <- mean(Boggy17$Height.cm)
wildcat18avg <- mean(Wildcat18$Height.cm)
wildcat17avg <- mean(Wildcat17$Height.cm)

sd(Boggy18$Height.cm)
sd(Boggy17$Height.cm)
sd(Wildcat18$Height.cm)
sd(Wildcat17$Height.cm)

## custom Standard Error function
se <- function(x) sqrt(var(x)/length(x))

boggy18se <- se(Boggy18$Height.cm)
boggy17se <- se(Boggy17$Height.cm)
wildcat18se <- se(Wildcat18$Height.cm)
wildcat17se <- se(Wildcat17$Height.cm)

show_col(viridis_pal()(2))
viridis_pal()(2)

## start plotting stuff
## plot the Boggy Site First
jpeg(filename = "Boggy Stubble Height.jpeg", ## write a JPEG file
     width=12,
     height=12,
     units="in",
     res=300)
plot.new() ## call a new plot
par(mar=c(5, 7, 7, 0), mfrow = c(1,2)) ## bottom, left, top, right
barplot(boggy17avg,
        col = "#440154FF",
        main = NA,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = "2017",
        ylab = expression(paste("Stubble Height (cm)", " ± SE")),
        ylim = c(0, 10))
axis(2, at=c(seq(0, 10, 1)), labels=c(seq(0, 10, 1)), cex.axis = 2)
segments(0.7, boggy17avg - boggy17se, 0.7, boggy17avg + boggy17se, lwd = 1.5)
arrows(0.7, boggy17avg - boggy17se, 0.7, boggy17avg + boggy17se, lwd = 1.5, angle = 90,code = 3, length = 0.05)
barplot(boggy18avg,
        col = "#FDE725FF",
        xlab = "2018",
        add= F,
        main= NA,
        axes= FALSE,
        cex.names = 2,
        cex.lab = 2,
        ylim = c(0, 10))
segments(0.7, boggy18avg - boggy18se, 0.7, boggy18avg + boggy18se, lwd = 1.5)
arrows(0.7, boggy18avg - boggy18se, 0.7, boggy18avg +  boggy18se, lwd = 1.5, angle = 90,code = 3, length = 0.05)
dev.off()

## plot the wildcat data
jpeg(filename = "Wildcat Stubble Height.jpeg", ## write a JPEG file
     width=12,
     height=12,
     units="in",
     res=300)
plot.new() ## call a new plot
par(mar=c(5, 7, 7, 0), mfrow = c(1,2)) ## bottom, left, top, right
barplot(wildcat17avg,
        col = "#440154FF",
        main = NA,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = "2017",
        ylab = expression(paste("Stubble Height (cm)", " ± SE")),
        ylim = c(0, 10))
axis(2, at=c(seq(0, 10, 1)), labels=c(seq(0, 10, 1)), cex.axis = 2)
segments(0.7, wildcat17avg - wildcat17se, 0.7, wildcat17avg + wildcat17se, lwd = 1.5)
arrows(0.7, wildcat17avg - wildcat17se, 0.7, wildcat17avg + wildcat17se, lwd = 1.5, angle = 90,code = 3, length = 0.05)
barplot(wildcat18avg,
        col = "#FDE725FF",
        xlab = "2018",
        add= F,
        main= NA,
        axes= FALSE,
        cex.names = 2,
        cex.lab = 2,
        ylim = c(0, 10))
segments(0.7, wildcat18avg - wildcat18se, 0.7, wildcat18avg + wildcat18se, lwd = 1.5)
arrows(0.7, wildcat18avg - wildcat18se, 0.7, wildcat18avg +  wildcat18se, lwd = 1.5, angle = 90,code = 3, length = 0.05)
dev.off()

## t-test
t.test(Boggy17$Height.cm, Boggy18$Height.cm)
t.test(Wildcat17$Height.cm, Wildcat18$Height.cm)
