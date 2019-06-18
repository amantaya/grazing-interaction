# Graphs
# Outputs JPG files of each graph into the working directory

# Boggy West 2017 Group Detections
jpeg(filename = "figures/BGW17_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(BGW17Detections$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Boggy Creek
Grazed Site 2017 ", 
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

# Wildcat South 2017 Group Detections
jpeg(filename = "figures/WCS17_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(WCS17Detections$groups,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Wildcat Creek
Grazed Site 2017 ", 
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

