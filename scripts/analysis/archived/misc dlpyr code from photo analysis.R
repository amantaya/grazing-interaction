BGW18$horsecount <- NA
BGW17$horsecount <- NA
BGT18$horsecount <- NA
BGX18$horsecount <- NA
WCS17$horsecount <- NA
WCS18$horsecount <- NA
WCT18$horsecount <- NA
WCX18$horsecount <- NA

## use dlpyr to select the photos with horse detections (can be primary species, secondary species or more)
BGW18Horses <- filter(BGW18, Species1 == "Horse")
BGW17Horses <- filter(BGW17, Species1 == "Horse")
BGT18Horses <- filter(BGT18, Species1 == "Horse")
BGX18Horses <- filter(BGX18, Species1 == "Horse")
WCS18Horses <- filter(WCS18, Species1 == "Horse")
WCS17Horses <- filter(WCS17, Species1 == "Horse")
WCT18Horses <- filter(WCT18, Species1 == "Horse")
WCX18Horses <- filter(WCX18, Species1 == "Horse")

## use dlpyr to select the photos with cow detections can be primary species, secondary species or more)
BGW18Cows <- filter(BGW18, Species2 == "Cow")
BGW17Cows <- filter(BGW17, Species2 == "Cow")
BGT18Cows <- filter(BGT18, Species2 == "Cow")
BGX18Cows <- filter(BGX18, Species2 == "Cow")
WCS18Cows <- filter(WCS18, Species2 == "Cow")
WCS17Cows <- filter(WCS17, Species2 == "Cow")
WCT18Cows <- filter(WCT18, Species2 == "Cow")
WCX18Cows <- filter(WCX18, Species2 == "Cow")

## use dlpyr to select the photos with elk detections can be primary species, secondary species or more)
BGW18Elk <- filter(BGW18, Species3 == "Elk")
BGW17Elk <- filter(BGW17, Species3 == "Elk")
BGT18Elk <- filter(BGT18, Species3 == "Elk")
BGX18Elk <- filter(BGX18, Species3 == "Elk")
WCS18Elk <- filter(WCS18, Species3 == "Elk")
WCS17Elk <- filter(WCS17, Species3 == "Elk")
WCT18Elk <- filter(WCT18, Species3 == "Elk")
WCX18Elk <- filter(WCX18, Species3 == "Elk")