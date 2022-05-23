
BGW17water.df <- BGW17[complete.cases(BGW17[ , 'water']),]
BGW17water <- BGW17water.df[BGW17water.df$water == "Yes", ]
write.csv(BGW17water, file = "BGW17water_inclmulti.csv")

BGW18water.df <- BGW18[complete.cases(BGW18[ , 'water']),]
BGW18water <- BGW18water.df[BGW18water.df$water == "Yes", ]
write.csv(BGW18water, file = "BGW18water_inclmulti.csv")

BGT18water.df <- BGT18[complete.cases(BGT18[ , 'water']),]
BGT18water <- BGT18water.df[BGT18water.df$water == "Yes", ]
write.csv(BGT18water, file = "BGT18water_inclmulti.csv")

BGX18water.df <- BGX18[complete.cases(BGX18[ , 'water']),]
BGX18water <- BGX18water.df[BGX18water.df$water == "Yes", ]
write.csv(BGX18water, file = "BGX18water_inclmulti.csv")

WCS17water.df <- WCS17[complete.cases(WCS17[ , 'water']),]
WCS17water <- WCS17water.df[WCS17water.df$water == "Yes", ]
write.csv(WCS17water, file = "WCS17water_inclmulti.csv")

WCS18water.df <- WCS18[complete.cases(WCS18[ , 'water']),]
WCS18water <- WCS18water.df[WCS18water.df$water == "Yes", ]
write.csv(WCS18water, file = "WCS18water_inclmulti.csv")

WCT18water.df <- WCT18[complete.cases(WCT18[ , 'water']),]
WCT18water <- WCT18water.df[WCT18water.df$water == "Yes", ]
write.csv(WCT18water, file = "WCT18water_inclmulti.csv")

WCX18water.df <- WCX18[complete.cases(WCX18[ , 'water']),]
WCX18water <- WCX18water.df[WCX18water.df$water == "Yes", ]
write.csv(WCX18water, file = "WCX18water_inclmulti.csv")