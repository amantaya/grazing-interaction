# create a new column to tabulate # of horses in each photo
BGW18$horsecount <- NA

for (i in 1:length(BGW18$RecordNumber)){
  if (BGW18$Count1Species[i]=="Horse"){
    BGW18$horsecount[i]<-BGW18$Count1Total[i]
    print(BGW18$horsecount[i])
  }
  else {BGW18$horsecount[i]<- NA[i]
  }
}

## summarize the number of photos (with subjects) captured on each date
BGW18datecounts <- summary(BGW18$ImageDate)
View(BGW18datecounts)

## summarize the dates when the camera captured images with subjects
BGW18dates <- unique(as.Date(BGW18$ImageDate, "%m/%d/%Y"))
BGW18dates

## coerce tables into dataframes
BGT18detections <- as.data.frame(BGT18detections)
BGW17detections <- as.data.frame(BGW17detections)
BGW18detections <- as.data.frame(BGW18detections)
BGX18detections <- as.data.frame(BGX18detections)
WCS17detections <- as.data.frame(WCS17detections)
WCS18detections <- as.data.frame(WCS18detections)
WCT18detections <- as.data.frame(WCT18detections)
WCX18detections <- as.data.frame(WCX18detections)

## plot detection counts
jpeg(filename = "BGT18_Detections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
barplot(BGT18detections,
        col =c("red", "green", "blue", "yellow", "purple"),
        main ="Boggy Creek Trail Detections
     2018", 
        xlab ="Species",
        ylab ="Number of Detections",
        ylim = c(0, 1000),
        las = 0)
axis(2, at = seq(0, 1000, by=100))
dev.off()