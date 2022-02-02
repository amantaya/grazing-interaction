## Boggy Trail 2018
BGT18horses <- unite(BGT18horses, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGT18cows <- unite(BGT18cows, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGT18elk <- unite(BGT18elk, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)

BGT18horses$DateTime <- mdy_hms(BGT18horses$DateTime)
BGT18cows$DateTime <- mdy_hms(BGT18cows$DateTime)
BGT18elk$DateTime <- mdy_hms(BGT18elk$DateTime)

BGT18horses <- arrange(BGT18horses, DateTime)
lag_time_diff <- difftime(BGT18horses$DateTime, lag(BGT18horses$DateTime, default = BGT18horses$DateTime[1]), units = "mins")
BGT18horses$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGT18horses$group <- BGT18horses$group+1

BGT18cows <- arrange(BGT18cows, DateTime)
lag_time_diff <- difftime(BGT18cows$DateTime, lag(BGT18cows$DateTime, default = BGT18cows$DateTime[1]), units = "mins")
BGT18cows$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGT18cows$group <- BGT18cows$group+1

BGT18elk <- arrange(BGT18elk, DateTime)
lag_time_diff <- difftime(BGT18elk$DateTime, lag(BGT18elk$DateTime, default = BGT18elk$DateTime[1]), units = "mins")
BGT18elk$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGT18elk$group <- BGT18elk$group+1

horses <- tail(BGT18horses$group, n = 1)
cows <- tail(BGT18cows$group, n = 1)
elk <- tail(BGT18elk$group, n = 1)

BGT18Groups<- data.frame(species = c("horses", "cows", "elk"), 
                         groups = (c(horses, cows, elk)
                         )
)

head(BGT18Groups)

## Boggy West 2017
BGW17horses <- unite(BGW17horses, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGW17cows <- unite(BGW17cows, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGW17elk <- unite(BGW17elk, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)

BGW17horses$DateTime <- mdy_hms(BGW17horses$DateTime)
BGW17cows$DateTime <- mdy_hms(BGW17cows$DateTime)
BGW17elk$DateTime <- mdy_hms(BGW17elk$DateTime)

BGW17horses <- arrange(BGW17horses, DateTime)
lag_time_diff <- difftime(BGW17horses$DateTime, lag(BGW17horses$DateTime, default = BGW17horses$DateTime[1]), units = "mins")
BGW17horses$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGW17horses$group <- BGW17horses$group+1

BGW17cows <- arrange(BGW17cows, DateTime)
lag_time_diff <- difftime(BGW17cows$DateTime, lag(BGW17cows$DateTime, default = BGW17cows$DateTime[1]), units = "mins")
BGW17cows$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGW17cows$group <- BGW17cows$group+1

BGW17elk <- arrange(BGW17elk, DateTime)
lag_time_diff <- difftime(BGW17elk$DateTime, lag(BGW17elk$DateTime, default = BGW17elk$DateTime[1]), units = "mins")
BGW17elk$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGW17elk$group <- BGW17elk$group+1

tail(BGW17horses$group, n = 1)
tail(BGW17cows$group, n = 1)
tail(BGW17elk$group, n = 1)

BGW17Groups<- data.frame(species = c("horses", "cows", "elk"), 
                         groups = (c(tail(BGW17horses$group, n = 1), tail(BGW17cows$group, n = 1), tail(BGW17elk$group, n = 1))))

head(BGW17Groups)

## Boggy West 2018
BGW18horses <- unite(BGW18horses, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGW18cows <- unite(BGW18cows, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGW18elk <- unite(BGW18elk, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)

BGW18horses$DateTime <- mdy_hms(BGW18horses$DateTime)
BGW18cows$DateTime <- mdy_hms(BGW18cows$DateTime)
BGW18elk$DateTime <- mdy_hms(BGW18elk$DateTime)

BGW18horses <- arrange(BGW18horses, DateTime)
lag_time_diff <- difftime(BGW18horses$DateTime, lag(BGW18horses$DateTime, default = BGW18horses$DateTime[1]), units = "mins")
BGW18horses$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGW18horses$group <- BGW18horses$group+1

BGW18cows <- arrange(BGW18cows, DateTime)
lag_time_diff <- difftime(BGW18cows$DateTime, lag(BGW18cows$DateTime, default = BGW18cows$DateTime[1]), units = "mins")
BGW18cows$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGW18cows$group <- BGW18cows$group+1

BGW18elk <- arrange(BGW18elk, DateTime)
lag_time_diff <- difftime(BGW18elk$DateTime, lag(BGW18elk$DateTime, default = BGW18elk$DateTime[1]), units = "mins")
BGW18elk$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGW18elk$group <- BGW18elk$group+1

horses <- if(length(tail(BGW18horses$group, n = 1)) >0){
  tail(BGW18horses$group, n = 1)
} else {
  0
}

cows <- if(length(tail(BGW18cows$group, n = 1)) >0){
  tail(BGW18cows$group, n = 1)
} else {
  0
}

elk <- if(length(tail(BGW18elk$group, n = 1)) >0){
  tail(BGW18elk$group, n = 1)
} else {
  0
}

BGW18Groups<- data.frame(species = c("horses", "cows", "elk"), 
                         groups = (c(horses, cows, elk))
)

head(BGW18Groups)

## Boggy Exclosure 2018
BGX18horses <- unite(BGX18horses, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGX18cows <- unite(BGX18cows, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
BGX18elk <- unite(BGX18elk, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)

BGX18horses$DateTime <- mdy_hms(BGX18horses$DateTime)
BGX18cows$DateTime <- mdy_hms(BGX18cows$DateTime)
BGX18elk$DateTime <- mdy_hms(BGX18elk$DateTime)

BGX18horses <- arrange(BGX18horses, DateTime)
lag_time_diff <- difftime(BGX18horses$DateTime, lag(BGX18horses$DateTime, default = BGX18horses$DateTime[1]), units = "mins")
BGX18horses$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGX18horses$group <- BGX18horses$group+1

BGX18cows <- arrange(BGX18cows, DateTime)
lag_time_diff <- difftime(BGX18cows$DateTime, lag(BGX18cows$DateTime, default = BGX18cows$DateTime[1]), units = "mins")
BGX18cows$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGX18cows$group <- BGX18cows$group+1

BGX18elk <- arrange(BGX18elk, DateTime)
lag_time_diff <- difftime(BGX18elk$DateTime, lag(BGX18elk$DateTime, default = BGX18elk$DateTime[1]), units = "mins")
BGX18elk$group <- cumsum(ifelse(lag_time_diff>10,1,0))
BGX18elk$group <- BGX18elk$group+1

horses <- if(length(tail(BGX18horses$group, n = 1)) >0){
  tail(BGX18horses$group, n = 1)
} else {
  0
}

cows <- if(length(tail(BGX18cows$group, n = 1)) >0){
  tail(BGX18cows$group, n = 1)
} else {
  0
}

elk <- if(length(tail(BGX18elk$group, n = 1)) >0){
  tail(BGX18elk$group, n = 1)
} else {
  0
}

BGX18Groups<- data.frame(species = c("horses", "cows", "elk"), 
                         groups = (c(horses, cows, elk))
)

head(BGX18Groups)

## Wildcat Exclosure 2018
WCX18Groups <- group.df(WCX18)
WCX18Groups

WCX18horses <- WCX18[WCX18$horse >0, ]
WCX18cows <- WCX18[WCX18$cow >0, ]
WCX18elk <- WCX18[WCX18$elk >0, ]

WCX18horses <- unite(WCX18horses, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
WCX18cows <- unite(WCX18cows, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
WCX18elk <- unite(WCX18elk, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)

WCX18horses$DateTime <- mdy_hms(WCX18horses$DateTime)
WCX18cows$DateTime <- mdy_hms(WCX18cows$DateTime)
WCX18elk$DateTime <- mdy_hms(WCX18elk$DateTime)

WCX18horses <- arrange(WCX18horses, DateTime)
lag_time_diff <- difftime(WCX18horses$DateTime, lag(WCX18horses$DateTime, default = WCX18horses$DateTime[1]), units = "mins")
WCX18horses$group <- cumsum(ifelse(lag_time_diff>10,1,0))
WCX18horses$group <- WCX18horses$group+1

WCX18cows <- arrange(WCX18cows, DateTime)
lag_time_diff <- difftime(WCX18cows$DateTime, lag(WCX18cows$DateTime, default = WCX18cows$DateTime[1]), units = "mins")
WCX18cows$group <- cumsum(ifelse(lag_time_diff>10,1,0))
WCX18cows$group <- WCX18cows$group+1

WCX18elk <- arrange(WCX18elk, DateTime)
lag_time_diff <- difftime(WCX18elk$DateTime, lag(WCX18elk$DateTime, default = WCX18elk$DateTime[1]), units = "mins")
WCX18elk$group <- cumsum(ifelse(lag_time_diff>10,1,0))
WCX18elk$group <- WCX18elk$group+1

horses <- if(length(tail(WCX18horses$group, n = 1)) >0){
  tail(WCX18horses$group, n = 1)
} else {
  0
}

cows <- if(length(tail(WCX18cows$group, n = 1)) >0){
  tail(WCX18cows$group, n = 1)
} else {
  0
}

elk <- if(length(tail(WCX18elk$group, n = 1)) >0){
  tail(WCX18elk$group, n = 1)
} else {
  0
}

WCX18Groups<- data.frame(species = c("horses", "cows", "elk"), 
                         groups = (c(horses, cows, elk))
)

head(WCX18Groups)

```{r}
group1 <- filter(BGW17horses, BGW17horses$group == 1)
group1time <- difftime(max(group1$DateTime), min(group1$DateTime), units = "secs")
group1time
```
```{r}
filter(BGW17horses, BGW17horses$group == 13)
```

```{r}
if (length(BGW17horses$group) < 1) {
  BGW17horses <- 0
  BGW17horses$group_sequence <- 0
  grpgrazingtime <- (as.numeric(BGW17horses$group))
} else {
  BGW17horses$group_sequence <- 1
  for (i in 2:(length(BGW17horses$group))) {  
    if (BGW17horses[i,"group"] == BGW17horses[(i-1),"group"]) {  
      BGW17horses[i,"group_sequence"] <- BGW17horses[i-1,"group_sequence"]+1
    }
  }
  first_last <- BGW17horses %>% arrange(group_sequence) %>% group_by(group) %>% slice(c(1,n()))
  first_last <- first_last %>% group_by(group) %>% mutate(Diff = DateTime - lag(DateTime))
  tot<- first_last[!is.na(first_last$Diff),]
  tot$Diff[tot$Diff < 60] <- 60 # this assumes that if the time difference between the first and last photo is less than 0, then set it to 60 seconds
  grpgrazingtime <- (as.numeric(tot$Diff))
  # grpgrazingtime <- remove_outliers(grpgrazingtime)
  grpgrazingtime <- grpgrazingtime[!is.na(grpgrazingtime)]
  grpgrazingtime <- ceiling(grpgrazingtime/60)
}
grpgrazingtime
```