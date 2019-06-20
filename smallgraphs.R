# Boggy Trail 2018 Counts
jpeg(filename = "figures/counts/BGT18_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(BGT18Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Boggy Creek Trail 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 10000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 2775, "2775", pos = 3, cex = 0.75)
text(1.9, 114, "114", pos = 3, cex = 0.75)
text(3.1, 344, "344", pos = 3, cex = 0.75)
axis(2, at = seq(0, 10000, by=500), cex.axis = .5, padj = 2)
dev.off()

# Boggy West 2017 Counts
jpeg(filename = "figures/counts/BGW17_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(BGW17Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Boggy Creek Timelapse 2017",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 10000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 7686, "7686", pos = 3, cex = 0.75)
text(1.9, 2095, "2095", pos = 3, cex = 0.75)
text(3.1, 1942, "1942", pos = 3, cex = 0.75)
axis(2, at = seq(0, 10000, by=500), cex.axis = .5, padj = 2)
dev.off()

# Boggy West 2018 Counts
jpeg(filename = "figures/counts/BGW18_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(BGW18Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Boggy Creek Timelapse 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 10000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 5135, "5135", pos = 3, cex = 0.75)
text(1.9, 199, "199", pos = 3, cex = 0.75)
text(3.1, 898, "898", pos = 3, cex = 0.75)
axis(2, at = seq(0, 10000, by=500), cex.axis = .5, padj = 2)
dev.off()

# Boggy Exclosure 2018 Counts
jpeg(filename = "figures/counts/BGX18_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(BGX18Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Boggy Creek Exclosure 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 10000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 0, "0", pos = 3, cex = 0.75)
text(1.9, 0, "0", pos = 3, cex = 0.75)
text(3.1, 634, "634", pos = 3, cex = 0.75)
axis(2, at = seq(0, 10000, by=500), cex.axis = .5, padj = 2)
dev.off()

# Wildcat South 2017 Counts
jpeg(filename = "figures/counts/WCS17_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(WCS17Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Wildcat Creek Timelapse 2017",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 25000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 22906, "22906", pos = 3, cex = 0.75)
text(1.9, 13317, "13317", pos = 3, cex = 0.75)
text(3.1, 13486, "13486", pos = 3, cex = 0.75)
axis(2, at = seq(0, 25000, by=5000), cex.axis = .5, padj = 2)
dev.off()

# Wildcat South 2018 Counts
jpeg(filename = "figures/counts/WCS18_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(WCS18Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Wildcat Creek Timelapse 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 25000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 9400, "9400", pos = 3, cex = 0.75)
text(1.9, 6544, "6544", pos = 3, cex = 0.75)
text(3.1, 1817, "1817", pos = 3, cex = 0.75)
axis(2, at = seq(0, 25000, by=5000), cex.axis = .5, padj = 2)
dev.off()

# Wildcat Trail 2018 Counts
jpeg(filename = "figures/counts/WCT18_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(WCT18Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Wildcat Creek Trail 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 25000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 2071, "2071", pos = 3, cex = 0.75)
text(1.9, 342, "342", pos = 3, cex = 0.75)
text(3.1, 398, "398", pos = 3, cex = 0.75)
axis(2, at = seq(0, 25000, by=5000), cex.axis = .5, padj = 2)
dev.off()

# Wildcat Exclosure 2018 Counts
jpeg(filename = "figures/counts/WCX18_Counts_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 1, 2))
barplot(WCX18Counts$freq,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Wildcat Creek Exclosure 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 25000),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Counts", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 494, "494", pos = 3, cex = 0.75)
text(1.9, 0, "0", pos = 3, cex = 0.75)
text(3.1, 2110, "2110", pos = 3, cex = 0.75)
axis(2, at = seq(0, 25000, by=5000), cex.axis = .5, padj = 2)
dev.off()

# Boggy Trail 2018 Groups
jpeg(filename = "figures/BGT18_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
## bottom, left, top, right
par(mar=c(2, 2, 2, 2))
barplot(BGT18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main = "Boggy Creek Trail 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 129, "129", pos = 3, cex = 0.75)
text(1.9, 13, "13", pos = 3, cex = 0.75)
text(3.1, 36, "36", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()

# Boggy West 2017 Groups
jpeg(filename = "figures/BGW17_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
par(mar=c(2, 2, 2, 2))
barplot(BGW17Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main ="Boggy Creek Timelapse 2017", 
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 119, "119", pos = 3, cex = 0.75)
text(1.9, 43, "43", pos = 3, cex = 0.75)
text(3.1, 72, "72", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()

# Boggy West 2018 Groups
jpeg(filename = "figures/BGW18_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
par(mar=c(2, 2, 2, 2))
barplot(BGW18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main ="Boggy Creek Timelapse 2018", 
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 74, "74", pos = 3, cex = 0.75)
text(1.9, 11, "11", pos = 3, cex = 0.75)
text(3.1, 57, "57", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()

# Boggy Exclosure 2018 Groups
jpeg(filename = "figures/BGX18_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
par(mar=c(2, 2, 2, 2))
barplot(BGX18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main ="Boggy Creek Exclosure 2018", 
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 0, "0", pos = 3, cex = 0.75)
text(1.9, 0, "0", pos = 3, cex = 0.75)
text(3.1, 16, "16", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()

# Wildcat South 2017 Groups
jpeg(filename = "figures/WCS17_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
par(mar=c(2, 2, 2, 2))
barplot(WCS17Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main ="Wildcat Creek Timelapse 2017",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 218, "218", pos = 3, cex = 0.75)
text(1.9, 73, "73", pos = 3, cex = 0.75)
text(3.1, 135, "135", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()

# Wildcat South 2018 Groups
jpeg(filename = "figures/WCS18_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
par(mar=c(2, 2, 2, 2))
barplot(WCS18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main ="Wildcat Creek Timelapse 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 97, "97", pos = 3, cex = 0.75)
text(1.9, 23, "23", pos = 3, cex = 0.75)
text(3.1, 73, "73", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()

# Wildcat Trail 2018 Groups
jpeg(filename = "figures/WCT18_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
par(mar=c(2, 2, 2, 2))
barplot(WCT18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main ="Wildcat Creek Trail 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 91, "91", pos = 3, cex = 0.75)
text(1.9, 16, "16", pos = 3, cex = 0.75)
text(3.1, 52, "52", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()

# Wildcat Exclosure 2018 Groups
jpeg(filename = "figures/WCX18_Groups_Small.jpeg",
     width=3.2,
     height=3.2,
     units="in",
     res=300)
par(mar=c(2, 2, 2, 2))
barplot(WCX18Groups$groups,
        col = c("#4472C4", "#ED7D31", "#FFC000"), 
        main ="Wildcat Creek Exclosure 2018",
        cex.main = 0.75,
        cex.lab = 0.5,
        cex.names = 0.75,
        axes = FALSE,
        xlab = NA,
        ylab = NA,
        ylim = c(0, 250),
        las = 0)
axis(1, at = seq(0.7, 3.1, by=1.2), labels = c("Horses", "Cattle", "Elk"), cex.axis = 0.75)
mtext("Number of Groups", 2, las = 0 , cex = 0.66, padj = -3)
text(0.7, 47, "47", pos = 3, cex = 0.75)
text(1.9, 0, "0", pos = 3, cex = 0.75)
text(3.1, 47, "47", pos = 3, cex = 0.75)
axis(2, at = seq(0, 250, by=50), cex.axis = .5, padj = 2)
dev.off()