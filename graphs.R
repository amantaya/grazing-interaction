# Graphs
# Outputs JPG files of each graph into the working directory

# Boggy Trail 2018 Group Detections
jpeg(filename = "figures/groups/BGT18_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(BGT18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Boggy Creek Trail
        2018", 
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 129, "129", pos = 3, cex = 1.5)
text(1.9, 13, "13", pos = 3, cex = 1.5)
text(3.1, 36, "36", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()

# Boggy West 2017 Group Detections
jpeg(filename = "figures/BGW17_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(BGW17Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Boggy Creek Timelapse
        2017", 
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 119, "119", pos = 3, cex = 1.5)
text(1.9, 43, "43", pos = 3, cex = 1.5)
text(3.1, 72, "72", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()

# Boggy West 2018 Group Detections
jpeg(filename = "figures/BGW18_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(BGW18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Boggy Creek Timelapse
        2018", 
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 74, "74", pos = 3, cex = 1.5)
text(1.9, 11, "11", pos = 3, cex = 1.5)
text(3.1, 57, "57", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()

# Boggy Exclosure 2018 Group Detections
jpeg(filename = "figures/BGX18_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(BGX18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Boggy Creek Exclosure
        2018", 
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 16, "16", pos = 3, cex = 1.5)
text(1.9, 16, "16", pos = 3, cex = 1.5)
text(3.1, 16, "16", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()

# Wildcat South 2017 Group Detections
jpeg(filename = "figures/WCS17_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(WCS17Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Wildcat Creek Timelapse
        2017",
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 218, "218", pos = 3, cex = 1.5)
text(1.9, 73, "73", pos = 3, cex = 1.5)
text(3.1, 135, "135", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()

# Wildcat South 2018 Group Detections
jpeg(filename = "figures/WCS18_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(WCS18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Wildcat Creek Timelapse
        2018",
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 97, "97", pos = 3, cex = 1.5)
text(1.9, 23, "23", pos = 3, cex = 1.5)
text(3.1, 73, "73", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()

# Wildcat Trail 2018 Group Detections
jpeg(filename = "figures/WCT18_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(WCT18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Wildcat Creek Trail
        2018",
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 91, "91", pos = 3, cex = 1.5)
text(1.9, 16, "16", pos = 3, cex = 1.5)
text(3.1, 52, "52", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()

# Wildcat Exclosure 2018 Group Detections
jpeg(filename = "figures/WCX18_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
par(mar=c(5, 7, 7, 0))
barplot(WCX18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Wildcat Creek Exclosure
        2018",
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 47, "47", pos = 3, cex = 1.5)
text(1.9, 0, "0", pos = 3, cex = 1.5)
text(3.1, 47, "47", pos = 3, cex = 1.5)
axis(2, at = seq(0, 250, by=10), cex.axis = 1.5)
dev.off()