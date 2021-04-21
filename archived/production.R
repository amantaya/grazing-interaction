## Wild Horse Ecological Interactions Analysis
## White Mountain Sites
## Boggy and Wildcat Creek Grazed Sites
## Production and Utilization calculations
## 02/07/2019
## Written by Andrew Antaya

library("ggplot2", lib.loc="~/R/win-library/3.5")
library("dplyr", lib.loc="~/R/win-library/3.5")
library("jpeg", lib.loc="~/R/win-library/3.5")

## clear the enviroment
rm(list=ls(all=TRUE))
dev.off()

## set working directory and check if it's correct
setwd('C:/Users/Andrew/Dropbox/Horse_Research/Analysis')
getwd()

## read in data
mydata <- read.csv('C:/Users/Andrew/Dropbox/Horse_Research/Analysis/Data/Vegetation/White Mountain Production.csv')
View(mydata)

## select the 2017 Boggy Grazed values
BGW17G <- mydata[28:32, ]

## select the 2017 Boggy Exclosure values
BGW17E <- mydata[23:27, ]

## select the 2017 Wildcat Grazed values
WCS17G <- mydata[38:42, ]

## select the 2017 Wildcat Exclosure values
WCS17E <- mydata[33:37, ]

## select the 2018 Boggy Grazed values
BGW18G <- mydata[7:11, ]

## select the 2018 Boggy Exclosure values
BGW18E <- mydata[1:6, ]

## select the 2018 Wildcat Grazed values
WCS18G <- mydata[18:22, ]

## select the 2018 Wildcat Exclosure values
WCS18E <- mydata[12:17, ]

## create empty table to store mean, standard deviation, standard error, 95% confidence interval
mystats<- data.frame(sites=c("BGW17E", "BGW17G", "WCS17E", "WCS17G", "BGW18E", "BGW18G",  "WCS18E", "WCS18G"))
View(mystats)

## calculate mean production values for each year and site (g/m2)
mystats[1, 2] <- mean(BGW17E$TotalDry)
mystats[2, 2] <- mean(BGW17G$TotalDry)
mystats[3, 2] <- mean(WCS17E$TotalDry)
mystats[4, 2] <- mean(WCS17G$TotalDry)
mystats[5, 2] <- mean(BGW18E$TotalDry)
mystats[6, 2] <- mean(BGW18G$TotalDry)
mystats[7, 2] <- mean(WCS18E$TotalDry)
mystats[8, 2] <- mean(WCS18G$TotalDry)

## convert mean production values from g/m2 to kg/ha by *10
mystats[1, 3] <- 10*mean(BGW17E$TotalDry)
mystats[2, 3] <- 10*mean(BGW17G$TotalDry)
mystats[3, 3] <- 10*mean(WCS17E$TotalDry)
mystats[4, 3] <- 10*mean(WCS17G$TotalDry)
mystats[5, 3] <- 10*mean(BGW18E$TotalDry)
mystats[6, 3] <- 10*mean(BGW18G$TotalDry)
mystats[7, 3] <- 10*mean(WCS18E$TotalDry)
mystats[8, 3] <- 10*mean(WCS18G$TotalDry)
View(mystats)

## standard deviation SD
mystats[1, 4] <- 10*sd(BGW17E$TotalDry)
mystats[2, 4] <- 10*sd(BGW17G$TotalDry)
mystats[3, 4] <- 10*sd(WCS17E$TotalDry)
mystats[4, 4] <- 10*sd(WCS17G$TotalDry)
mystats[5, 4] <- 10*sd(BGW18E$TotalDry)
mystats[6, 4] <- 10*sd(BGW18G$TotalDry)
mystats[7, 4] <- 10*sd(WCS18E$TotalDry)
mystats[8, 4] <- 10*sd(WCS18G$TotalDry)
View(mystats)

## custom Standard Error function
se <- function(x) sqrt(var(x)/length(x))

## standard error SE
mystats[1, 5] <- 10*se(BGW17E$TotalDry)
mystats[2, 5] <- 10*se(BGW17G$TotalDry)
mystats[3, 5] <- 10*se(WCS17E$TotalDry)
mystats[4, 5] <- 10*se(WCS17G$TotalDry)
mystats[5, 5] <- 10*se(BGW18E$TotalDry)
mystats[6, 5] <- 10*se(BGW18G$TotalDry)
mystats[7, 5] <- 10*se(WCS18E$TotalDry)
mystats[8, 5] <- 10*se(WCS18G$TotalDry)
View(mystats)

## Lower 95% confidence intervals of the production mean
mystats[1, 6] <- 10*(mean(BGW17E$TotalDry)-2*se(BGW17E$TotalDry))
mystats[2, 6] <- 10*(mean(BGW17G$TotalDry)-2*se(BGW17G$TotalDry))
mystats[3, 6] <- 10*(mean(WCS17E$TotalDry)-2*se(WCS17E$TotalDry))
mystats[4, 6] <- 10*(mean(WCS17G$TotalDry)-2*se(WCS17G$TotalDry))
mystats[5, 6] <- 10*(mean(BGW18E$TotalDry)-2*se(BGW18E$TotalDry))
mystats[6, 6] <- 10*(mean(BGW18G$TotalDry)-2*se(BGW18G$TotalDry))
mystats[7, 6] <- 10*(mean(WCS18E$TotalDry)-2*se(WCS18E$TotalDry))
mystats[8, 6] <- 10*(mean(WCS18G$TotalDry)-2*se(WCS18G$TotalDry))
View(mystats)

## Upper 95% confidence intervals of the production mean
mystats[1, 7] <- 10*(mean(BGW17E$TotalDry)+2*se(BGW17E$TotalDry))
mystats[2, 7] <- 10*(mean(BGW17G$TotalDry)+2*se(BGW17G$TotalDry))
mystats[3, 7] <- 10*(mean(WCS17E$TotalDry)+2*se(WCS17E$TotalDry))
mystats[4, 7] <- 10*(mean(WCS17G$TotalDry)+2*se(WCS17G$TotalDry))
mystats[5, 7] <- 10*(mean(BGW18E$TotalDry)+2*se(BGW18E$TotalDry))
mystats[6, 7] <- 10*(mean(BGW18G$TotalDry)+2*se(BGW18G$TotalDry))
mystats[7, 7] <- 10*(mean(WCS18E$TotalDry)+2*se(WCS18E$TotalDry))
mystats[8, 7] <- 10*(mean(WCS18G$TotalDry)+2*se(WCS18G$TotalDry))
View(mystats)

## add column names to the dataframe used to organize
colnames(mystats) <- c("sites", "prod_g_m2", "prod_kg_ha", "SD", "SE", "L95%CI", "U95%CI")

## Didn't end up using this line of code, but it might be useful in the future
## BGW17 <- cbind(mystats[1,3], mystats[2,3])

## start plotting stuff
jpeg(filename = "Boggy Creek Utilization 2017.jpg",
     width=12,
     height=12,
     units="in",
     res=300)
plot.new()
## bottom, left, top, right
par(mar=c(5, 7, 5, 0), mfrow = c(1,2))
barplot(mystats[1,3],
        col = "#404788FF",
        main = NA,
        axes = FALSE,
        xlab = "Ungrazed",
        ylab = expression(paste("kg ", "ha"^"-1", " ± SE")),
        cex.lab = 3,
        ylim = c(0, 6500))
axis(2,at=c(seq(0,6500,1000)),labels=c(seq(0,6500,1000)), cex.axis=2)
segments(0.7, mystats[1, 3] - mystats[1, 5], 0.7,
         mystats[1, 3] + mystats[1, 5], lwd = 2)
arrows(0.7, mystats[1, 3] - mystats[1, 5], 0.7,
       mystats[1, 3] + mystats[1, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
barplot(mystats[2,3],
        col = "#FDE725FF",
        add=F,
        main=NA,
        axes=FALSE,
        xlab = "Grazed",
        cex.lab = 3,
        ylim = c(0, 6500))
segments(0.7, mystats[2, 3] - mystats[2, 5], 0.7,
         mystats[2, 3] + mystats[2, 5], lwd = 2)
arrows(0.7, mystats[2, 3] - mystats[2, 5], 0.7,
       mystats[2, 3] + mystats[2, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
dev.off()

## plot number 2
jpeg(filename = "Boggy Creek Utilization 2018.jpg",
     width=12,
     height=12,
     units="in",
     res=300)
plot.new()
## bottom, left, top, right
par(mar=c(5, 7, 5, 0), mfrow = c(1,2))
barplot(mystats[5, 3],
        col = "#404788FF",
        main = NA,
        axes = FALSE,
        xlab = "Ungrazed",
        ylab = expression(paste("kg ", "ha"^"-1", " ± SE")),
        cex.lab = 3,
        ylim = c(0, 6500))
axis(2,at=c(seq(0,6500,1000)),labels=c(seq(0,6500,1000)), cex.axis=2)
segments(0.7, mystats[5, 3] - mystats[5, 5], 0.7,
         mystats[5, 3] + mystats[5, 5], lwd = 2)
arrows(0.7, mystats[5, 3] - mystats[5, 5], 0.7,
       mystats[5, 3] + mystats[5, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
barplot(mystats[6,3],
        col = "#FDE725FF",
        add=F,
        main=NA,
        axes=FALSE,
        xlab = "Grazed",
        cex.lab = 3,
        ylim = c(0, 6500))
segments(0.7, mystats[6, 3] - mystats[6, 5], 0.7,
         mystats[6, 3] + mystats[6, 5], lwd = 2)
arrows(0.7, mystats[6, 3] - mystats[6, 5], 0.7,
       mystats[6, 3] + mystats[6, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
dev.off()

## plot number 3
jpeg(filename = "Wildcat Creek Utilization 2017.jpg",
     width=12,
     height=12,
     units="in",
     res=300)
plot.new()
## bottom, left, top, right
par(mar=c(5, 7, 5, 0), mfrow = c(1,2))
barplot(mystats[3, 3],
        col = "#404788FF",
        main = NA,
        axes = FALSE,
        xlab = "Ungrazed",
        ylab = expression(paste("kg ", "ha"^"-1", " ± SE")),
        cex.lab = 3,
        ylim = c(0, 6500))
axis(2,at=c(seq(0,6500,1000)),labels=c(seq(0,6500,1000)), cex.axis=2)
segments(0.7, mystats[3, 3] - mystats[3, 5], 0.7,
         mystats[3, 3] + mystats[3, 5], lwd = 2)
arrows(0.7, mystats[3, 3] - mystats[3, 5], 0.7,
       mystats[3, 3] + mystats[3, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
barplot(mystats[4,3],
        col = "#FDE725FF",
        add=F,
        main=NA,
        axes=FALSE,
        xlab = "Grazed",
        cex.lab = 3,
        ylim = c(0, 6500))
segments(0.7, mystats[4, 3] - mystats[4, 5], 0.7,
         mystats[4, 3] + mystats[4, 5], lwd = 2)
arrows(0.7, mystats[4, 3] - mystats[4, 5], 0.7,
       mystats[4, 3] + mystats[4, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
dev.off()

## plot number 4
jpeg(filename = "Wildcat Creek Utilization 2018.jpg",
     width=12,
     height=12,
     units="in",
     res=300)
plot.new()
## bottom, left, top, right
par(mar=c(5, 7, 5, 0), mfrow = c(1,2))
barplot(mystats[7, 3],
        col = "#404788FF",
        main = NA,
        axes = FALSE,
        xlab = "Ungrazed",
        ylab = expression(paste("kg ", "ha"^"-1", " ± SE")),
        cex.lab = 3,
        ylim = c(0, 6500))
axis(2,at=c(seq(0,6500,1000)),labels=c(seq(0,6500,1000)), cex.axis=2)
segments(0.7, mystats[7, 3] - mystats[7, 5], 0.7,
         mystats[7, 3] + mystats[7, 5], lwd = 2)
arrows(0.7, mystats[7, 3] - mystats[7, 5], 0.7,
       mystats[7, 3] + mystats[7, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
barplot(mystats[8,3],
        col = "#FDE725FF",
        add=F,
        main=NA,
        axes=FALSE,
        xlab = "Grazed",
        cex.lab = 3,
        ylim = c(0, 6500))
segments(0.7, mystats[8, 3] - mystats[8, 5], 0.7,
         mystats[8, 3] + mystats[8, 5], lwd = 2)
arrows(0.7, mystats[8, 3] - mystats[8, 5], 0.7,
       mystats[8, 3] + mystats[8, 5], lwd = 2, angle = 90,
       code = 3, length = 0.05)
dev.off()

View(BGW17E)

## calculate % utilization
BGW17Utilization <- (mystats[1, 3]-mystats[2, 3])/mystats[1, 3]
WCS17Utilization <- (mystats[3, 3]-mystats[4, 3])/mystats[3, 3]
BGW18Utilization <- (mystats[5, 3]-mystats[6, 3])/mystats[5, 3]
WCS18Utilization <- (mystats[7, 3]-mystats[8, 3])/mystats[7, 3]

## t test for production values between years
t.test(BGW17E$TotalDry, BGW18E$TotalDry)
t.test(WCS17E$TotalDry, WCS18E$TotalDry)

## t test for utilization values between years
t.test(BGW17G$TotalDry, BGW18G$TotalDry)
t.test(WCS17G$TotalDry, WCS18G$TotalDry)
