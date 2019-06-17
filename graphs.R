# Graphs
# Outputs JPG files of each graph into the working directory

jpeg(filename = "figures/BGW17_GroupDetections.jpeg",
     width=12,
     height=12,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(5, 7, 7, 0))
barplot(BGW17Detections$freq,
        col = c("#4472C4", "#ED7D31", "#A5A5A5"), 
        main ="Boggy Creek Grazed Site
     2017 ", 
        cex.main = 3,
        cex.lab = 2,
        cex.names = 2,
        axes = FALSE,
        xlab = NA,
        ylab ="Number of Group Detections",
        ylim = c(0, 150),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 1.5)
text(0.7, 119, "119", pos = 3, cex = 1.5)
text(1.9, 43, "43", pos = 3, cex = 1.5)
text(3.1, 72, "72", pos = 3, cex = 1.5)
axis(2, at = seq(0, 150, by=10), cex.axis = 2)
dev.off()