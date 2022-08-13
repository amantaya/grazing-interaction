#' ---
#' title: "Functions"
#' author: "Andrew Antaya"
#' date: "June 24, 2019"
#' output: html_notebook
#' ---
#' ***
#' #### Designed to be read into the R environment first and then called when needed by a different script.
#' ***
#' ### The "se" (Standard Error) Function
#'
#' **Input:** The values of a single variable in numerical vector format.
#'
#' **What it Does:** Calculates the standard error (se) commongly used in statistics.
#'
#' **Output:** A single numerical value.
## ------------------------------------------------------------------------
se <- function(x){sqrt(var(x)/length(x))}

#' ***
#' ### The "cleandates" Funcion
#' TODO consider changing the clean_dates function to specify a column
#' TODO also consider adding a warning if the data frame columns handled by this function are not characters vectors
#' **Input:** A standardized camera trap dataframe generated
#' by our custom Excel macro (HorseImaging.xlsm).
#'
#' **What it Does:** It takes the "ImageDate" and "ImageTime" columns
#' and combines them together into a new column "DateTime",
#' then removes the "ImageDate" and "ImageTime" columns.
#' It then converts the "DateTime" column into a S3 class POSIXlt (calendar date and time)
#' It then arranges the dataframe from lowest time to greatest time.
#'
#' **Output:** A 'cleaned' dataframe that has the correct date and time format,
#' with all rows arranged in chronological order.
#' (Note: you have assign the output of the function to the original dataframe
#' if you want to overwrite the original dataframe).
## ------------------------------------------------------------------------
clean_dates <- function(cameradf) {
  # combine the "ImageDate" and "ImageTime" columns into a single column "DateTime"
  # however it is not a datetime class yet its is a character vector
  cameradf <- dplyr::unite(cameradf, ImageDate, ImageTime, col = "DateTime", sep = " ", remove = TRUE)
  # convert the "DateTime" column into a datetime class
  cameradf$DateTime <- lubridate::mdy_hms(cameradf$DateTime)
  # arrange the data frame from
  cameradf <- dplyr::arrange(cameradf, DateTime)
  # return a "cleaned" data frame
  cameradf
}

datetime_cleaner_csv <- function(cameradf) {

  column_search <- stringr::str_detect(colnames(cameradf), "DateTime")

  if (any(column_search) != TRUE) {

  if (typeof(cameradf$ImageDate) == "double" & typeof(cameradf$ImageTime) == "double") {

    # add the numerical date and time values together
    cameradf <- dplyr::mutate(cameradf, DateTime = (ImageDate + ImageTime), .after = ImageDate)

    # then convert to a DateTime
    cameradf$DateTime <- openxlsx::convertToDateTime(cameradf$DateTime, tz = Sys.getenv("TZ"))

    } else if (typeof(cameradf$ImageDate) == "character" & typeof(cameradf$ImageTime) == "character") {

    # create a new column by adding the time and date character strings together
    cameradf <- mutate(cameradf,
                       DateTime = stringr::str_c(ImageDate, ImageTime, sep = " "),
                       .after = ImageDate)

    } else if (typeof(cameradf$ImageDate) == "double" & typeof(cameradf$ImageTime) == "character") {

      # convert the numeric Excel formatted date to a datetime
      cameradf$ImageDate <- openxlsx::convertToDateTime(cameradf$ImageDate,
                                                        tz = Sys.getenv("TZ"))

      # then convert the datetime to string
      cameradf$ImageDate <- as.character(cameradf$ImageDate)

      # then combine the two character strings together
      cameradf <- mutate(cameradf,
                         DateTime = stringr::str_c(ImageDate, ImageTime, sep = " "),
                         .after = ImageDate)

    } else if (typeof(cameradf$ImageDate) == "character" & typeof(cameradf$ImageTime) == "double") {

      # convert the `hms` class into a character
      cameradf <- dplyr::mutate(cameradf, ImageTime = as.character(ImageTime))

      # then combine the two character strings together
      cameradf <- mutate(cameradf,
                         DateTime = stringr::str_c(ImageDate, ImageTime, sep = " "),
                         .after = ImageDate)

    } else {

      warning(paste("This file failed to parse the date:", names(cameradf)))

    }

  # there are potentially 2 different types of date formats in our data
  # year month day and month day year
  # we need to identify how the column in formatted before we can convert it properly

  # month day year pattern
  date_regex_match <- stringr::str_detect(cameradf$DateTime, pattern = "\\d{1,2}/\\d{1,2}/\\d{4}")

  if (date_regex_match[1] == TRUE) {

    # convert the character strings to date-time class
    cameradf <- mutate(cameradf,
                       DateTime = lubridate::mdy_hms(DateTime, tz = Sys.getenv("TZ")),
                       .after = ImageDate)

  } else {
    # convert the character strings to date-time class
    cameradf <- mutate(cameradf,
                       DateTime = lubridate::ymd_hms(DateTime, tz = Sys.getenv("TZ")),
                       .after = ImageDate)
  }

  # convert the "LastSavedOn" column into a POSIXct class
  cameradf$LastSavedOn <- openxlsx::convertToDateTime(cameradf$LastSavedOn,
                                                     tz = Sys.getenv("TZ"))

  cameradf <- dplyr::mutate(cameradf, ImageTime = as.character(ImageTime))

  cameradf <- dplyr::mutate(cameradf, ImageDate = as.character(ImageDate))

  cameradf$DateTime <- strftime(cameradf$DateTime, usetz = TRUE)

  }

  return(cameradf)

}

#' ***
#' ### The "speciestotal" Function
#'
#' **Input:** A standard camera trap dataframe (i.e. camerdf), and the name of the species in quotations (e.g. "Horse")
#'
#' **What it Does:** This function adds up the number of individuals (of the same species) in each photo, taking into account that the species may be the 1st species detected in each photo, 2nd species detected in each photo, 3rd species detected in each photo, 4th species detected in each photo, or the 5th species detected in each photo in the case of multi-species photos.(Note: The species name is sensitive to case and spelling errors)
#'
#' **Output:** Returns a new column in the specified camera dataframe labled by the specified species.
## ------------------------------------------------------------------------
speciestotal <- function(cameradf, species) {
  count1 <- ifelse(cameradf$Count1Species %in% species, cameradf$Count1Total, 0)
  count2 <- ifelse(cameradf$Count2Species %in% species, cameradf$Count2Total, 0)
  count3 <- ifelse(cameradf$Count3Species %in% species, cameradf$Count3Total, 0)
  count4 <- ifelse(cameradf$Count4Species %in% species, cameradf$Count4Total, 0)
  count5 <- ifelse(cameradf$Count5Species %in% species, cameradf$Count5Total, 0)
  total <- (count1+count2+count3+count4+count5)
  return(total)
}

#' ***
#' ### The "allspecies" Function
#'
#' **Input:** A standard camera trap dataframe (i.e. camerdf).
#'
#' **What it Does:** This function uses the "speciestotal" function and applys it to all species in the dataframe.
#'
#' **Output:** It returns a new dataframe that has 24 new columns, each column of which contains the total number of individuals (of that species) from each photo.
## ------------------------------------------------------------------------
allspecies <- function(cameradf) {
  cameradf$ATV <- speciestotal(cameradf,  species = "ATV")
  cameradf$bear <- speciestotal(cameradf,  species = "Bear")
  cameradf$bobcat <- speciestotal(cameradf,  species = "Bobcat")
  cameradf$cottontail <- speciestotal(cameradf, species = "Cottontail")
  cameradf$cow <- speciestotal (cameradf, species = "Cow")
  cameradf$coyote <- speciestotal(cameradf, species = "Coyote")
  cameradf$dog <- speciestotal(cameradf, species = "Dog")
  cameradf$elk <- speciestotal (cameradf, species = "Elk")
  cameradf$greyfox <- speciestotal(cameradf, species = "Greyfox")
  cameradf$horse<- speciestotal (cameradf, species = "Horse")
  cameradf$horseback <- speciestotal (cameradf, species = "Horseback")
  cameradf$jackrabbit <- speciestotal (cameradf, species = "Jackrabbit")
  cameradf$deer <- speciestotal (cameradf, species = "Muledeer")
  cameradf$other <- speciestotal (cameradf, species = "Other")
  cameradf$human <- speciestotal (cameradf, species = "Person")
  cameradf$pronghorn <- speciestotal (cameradf, species = "Pronghorn")
  cameradf$raccoon <- speciestotal (cameradf, species = "Raccoon")
  cameradf$skunk <- speciestotal (cameradf, species = "Skunk")
  cameradf$truck <- speciestotal(cameradf, species = "Truck/SUV")
  cameradf$turkey <- speciestotal(cameradf, species = "Turkey")
  cameradf$ukncanine <- speciestotal(cameradf, species = "Unk Canine")
  cameradf$UTV <- speciestotal(cameradf, species = "UTV")
  cameradf$wolf <- speciestotal(cameradf, species = "Wolf")
  cameradf$na <- speciestotal(cameradf, species = "NA")
  return(cameradf)
}

#' ***
#' ### The "counts.df" Function
#'
#' **Input:** A camera trap dataframe (i.e. camerdf) with 24 new columns generated by the "allspecies" function.
#'
#' **What it Does:** This function sums up the total number of individuals for horses, cows and elk (more species will be added later) and stores these sums in a new data frame (i.e. cameradf.counts).
#'
#' **Output:** A new dataframe containing the cumulative sum of individuals for horses, cows, and elk.
## ------------------------------------------------------------------------
counts.df <- function(cameradf) {
  cameradf.counts <- data.frame(species = c("Horses", "Cattle", "Elk"),
             freq = (c(sum(cameradf$horse), sum(cameradf$cow), sum(cameradf$elk)
                       )
                     )
             )
  }

#' ***
#' ### The "group.df" Function
#' **Input:**
#'
#' **What it Does:**
#'
#' **Output:**
## ------------------------------------------------------------------------
group.df <- function (cameradf){

cameradf <- arrange(cameradf, DateTime)

lag_time_diff <- difftime(cameradf$DateTime, lag(cameradf$DateTime, default = cameradf$DateTime[1]), units = "mins")

cameradf$group <- cumsum(ifelse(lag_time_diff>10,1,0))
cameradf$group <- cameradf$group+1

return(cameradf)
}

#' ***
#' ### The "group.total"" Function
#'
#' **Input:**
#'
#' **What it Does:** This function abstracts the group detections for each site.
#'
#' **Output:**
## ------------------------------------------------------------------------
group.total <- function (cameradf){
cameradfhorses <- cameradf[cameradf$horse >0, ]
cameradfcows <- cameradf[cameradf$cow >0, ]
cameradfelk <- cameradf[cameradf$elk >0, ]

cameradfhorses <- arrange(cameradfhorses, DateTime)
lag_time_diff <- difftime(cameradfhorses$DateTime, lag(cameradfhorses$DateTime, default = cameradfhorses$DateTime[1]), units = "mins")
cameradfhorses$group <- cumsum(ifelse(lag_time_diff>10,1,0))
cameradfhorses$group <- cameradfhorses$group+1

cameradfcows <- arrange(cameradfcows, DateTime)
lag_time_diff <- difftime(cameradfcows$DateTime, lag(cameradfcows$DateTime, default = cameradfcows$DateTime[1]), units = "mins")
cameradfcows$group <- cumsum(ifelse(lag_time_diff>10,1,0))
cameradfcows$group <- cameradfcows$group+1

cameradfelk <- arrange(cameradfelk, DateTime)
lag_time_diff <- difftime(cameradfelk$DateTime, lag(cameradfelk$DateTime, default = cameradfelk$DateTime[1]), units = "mins")
cameradfelk$group <- cumsum(ifelse(lag_time_diff>10,1,0))
cameradfelk$group <- cameradfelk$group+1

horses <- if(length(tail(cameradfhorses$group, n = 1)) >0){
  tail(cameradfhorses$group, n = 1)
} else {
  0
}

cows <- if(length(tail(cameradfcows$group, n = 1)) >0){
  tail(cameradfcows$group, n = 1)
} else {
  0
}

elk <- if(length(tail(cameradfelk$group, n = 1)) >0){
  tail(cameradfelk$group, n = 1)
} else {
  0
}

return (cameradfGroups<- data.frame(species = c("horses", "cows", "elk"),
                         groups = (c(horses, cows, elk)
                                   )
                         )
        )
}

#' ***
#' ### The "sumbyhour" Function
#'
#' **Input:** A camera trap dataframe that has split so each species is in a separate dataframe and has also been processed by the hour() function (from the lubridate package).
#'
#' **What it Does:** This function takes the total number of individuals from each hourly interval (e.g., from 00:00:00 to 00:59:00) and puts each value into a temporary object (e.g., hour0). Each temporary object is then put into a data frame for organization.
#'
#' **Output:** Returns a dataframe that contains the hourly totalnumber of individuals (for the entire season).
## ------------------------------------------------------------------------
sumbyhour<- function (cameradf, species){

cameradf$hour<- hour(cameradf$DateTime)

hour0 <- sum(ifelse (cameradf$hour == 0, cameradf[,species], 0))
hour1 <- sum(ifelse (cameradf$hour == 1, cameradf[,species], 0))
hour2 <- sum(ifelse (cameradf$hour == 2, cameradf[,species], 0))
hour3 <- sum(ifelse (cameradf$hour == 3, cameradf[,species], 0))
hour4 <- sum(ifelse (cameradf$hour == 4, cameradf[,species], 0))
hour5 <- sum(ifelse (cameradf$hour == 5, cameradf[,species], 0))
hour6 <- sum(ifelse (cameradf$hour == 6, cameradf[,species], 0))
hour7 <- sum(ifelse (cameradf$hour == 7, cameradf[,species], 0))
hour8 <- sum(ifelse (cameradf$hour == 8, cameradf[,species], 0))
hour9 <- sum(ifelse (cameradf$hour == 9, cameradf[,species], 0))
hour10 <- sum(ifelse (cameradf$hour == 10, cameradf[,species], 0))
hour11 <- sum(ifelse (cameradf$hour == 11, cameradf[,species], 0))
hour12 <- sum(ifelse (cameradf$hour == 12, cameradf[,species], 0))
hour13 <- sum(ifelse (cameradf$hour == 13, cameradf[,species], 0))
hour14 <- sum(ifelse (cameradf$hour == 14, cameradf[,species], 0))
hour15 <- sum(ifelse (cameradf$hour == 15, cameradf[,species], 0))
hour16 <- sum(ifelse (cameradf$hour == 16, cameradf[,species], 0))
hour17 <- sum(ifelse (cameradf$hour == 17, cameradf[,species], 0))
hour18 <- sum(ifelse (cameradf$hour == 18, cameradf[,species], 0))
hour19 <- sum(ifelse (cameradf$hour == 19, cameradf[,species], 0))
hour20 <- sum(ifelse (cameradf$hour == 20, cameradf[,species], 0))
hour21 <- sum(ifelse (cameradf$hour == 21, cameradf[,species], 0))
hour22 <- sum(ifelse (cameradf$hour == 22, cameradf[,species], 0))
hour23 <- sum(ifelse (cameradf$hour == 23, cameradf[,species], 0))
df <- data.frame(hour = c(0:23), freq = c(hour0, hour1, hour2, hour3, hour4, hour5, hour6, hour7, hour8, hour9, hour10, hour11, hour12, hour13, hour14, hour15, hour16, hour17, hour18, hour19, hour20, hour21, hour22, hour23))
return(df)
}

#' ***
#' ### The "group.duration" Function
#'
#' **Input:** A camera trap data frame with only 1 species, such as BGW17horses.
#'
#' **What it Does:** This function calculates the amount of time each group spent at site (both in minutes and seconds). It does this by sequentially numbering each photo in a group. It then subracts the DateTime of the last photo from the DateTime of the first photo in each group sequence. It stores this value in a new object "total". If the total difference is less than 60 (seconds) such as when a single photo constitutes a group, we include an assumption that this single photo actually represents 60 seconds of site use.
#'
#' **Output:** Returns a numerical vector containing the number of minutes each group spent at that site.
## ------------------------------------------------------------------------
group.duration <- function(cameradfspecies) {
  if (length(cameradfspecies$group) < 1) {
    cameradfspecies <- 0 # this is for dataframes that had 0 species detections (e.g., BGX18horses)
    cameradfspecies$group_sequence <- 0
    groupduration <- (as.numeric(cameradfspecies$group))
  } else {
    cameradfspecies$group_sequence <- 1
    for (i in 2:(length(cameradfspecies$group))) {
      if (cameradfspecies[i,"group"] == cameradfspecies[(i-1),"group"]) {
        cameradfspecies[i,"group_sequence"] <-cameradfspecies[i-1,"group_sequence"]+1
      }
    }
    first_last <- cameradfspecies %>% arrange(group_sequence) %>% group_by(group) %>% slice(c(1,n()))
    first_last <- first_last %>% group_by(group) %>% mutate(Diff = DateTime - lag(DateTime))
    total <- first_last[!is.na(first_last$Diff),]
    total$Diff[total$Diff < 60] <- 60  # this assumes that if the time difference between the first and last photo is less than 0, then set it to 60 seconds. This value may be changed to 300 seconds (5 minutes) for sites that had 5 minute timelapse.
    groupduration <- (as.numeric(total$Diff))
#    groupduration <- remove_outliers(groupduration)
    duration.secs <- groupduration[!is.na(groupduration)]
    duration.mins <- (duration.secs/60) # ceiling() returns the smallest interger value that is not less than the input value (essentially it rounds up to the next highest interger value)
  }
}

#' ***
#' ### The "remove_outliers" Function
#'
#' **Input:** A numerical vector, can also be a column from a data frame if the column is numerical.
#'
#' **What it Does:** This function first computes a quantile (i.e. 1/4 of the data's spread) and then assigns any data values outside of 1.5 times the interquartile range as NA. This excludes these extreme data values from any later caculations. USE WITH CAUTION- be sure to detail whenever legitimate data points are removed from the dataset.
#'
#' **Output:** Returns a copy of the orginal data where the extreme values are NAs.
## ------------------------------------------------------------------------
remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

#' ***
#' ### The "group.size" Function
#'
#' **Input:**
#'
#' **What it Does:**
#'
#' **Output:**
## ------------------------------------------------------------------------
group.size <- function(cameradf, sitename) {
  horses <- cameradf[cameradf$horse >0, ]
  cattle <- cameradf[cameradf$cow >0, ]
  elk <- cameradf[cameradf$elk >0, ]
#  deer <- cameradf[cameradf$deer >0, ]

  horses <- arrange(horses, DateTime)
  cattle <- arrange(cattle, DateTime)
  elk <- arrange(elk, DateTime)
#  deer <- arrange(deer, DateTime)

  lag_time_diffh <- difftime(horses$DateTime, lag(horses$DateTime, default = horses$DateTime[1]), units = "mins")
  lag_time_diffc <- difftime(cattle$DateTime, lag(cattle$DateTime, default = cattle$DateTime[1]), units = "mins")
  lag_time_diffe <- difftime(elk$DateTime, lag(elk$DateTime, default = elk$DateTime[1]), units = "mins")
#  lag_time_diffd <- difftime(deer$DateTime, lag(deer$DateTime, default = deer$DateTime[1]), units = "mins")

  horses$group <- cumsum(ifelse(lag_time_diffh>10,1,0))
  cattle$group <- cumsum(ifelse(lag_time_diffc>10,1,0))
  elk$group <- cumsum(ifelse(lag_time_diffe>10,1,0))
#  deer$group <- cumsum(ifelse(lag_time_diffd>10,1,0))

  horses$group <- horses$group+1
  cattle$group <- cattle$group+1
  elk$group <- elk$group+1
#  deer$group <- deer$group+1

  horses %<>% group_by(group) %>% summarize(Species = "Horses", max = max(horse))
  cattle %<>% group_by(group) %>% summarize(Species = "Cattle", max = max(cow))
  elk %<>% group_by(group) %>% summarize(Species = "Elk", max = max(elk))
#  deer %<>% group_by(group) %>% summarize(Species = "Muledeer", max = max(deer))

  df <- data.frame(site = c(cameradf$SiteName[1:3]),
                        year = c(rep(unique(year(cameradf$DateTime)),3)),
                        species = c("Horse", "Cattle", "Elk"),
                        avg = c(round(mean(horses$max)), round(mean(cattle$max)), round(mean(elk$max))),
                        se = c(se(horses$max), se(cattle$max), se(elk$max)))

  is.nan.data.frame <- function(x)
    do.call(cbind, lapply(x, is.nan))
    df$avg[is.nan(df$avg)] <- 0

return(df)
}

#' ***
#' ### The "calculate.mode" Function
#'
#' **Input:**
#'
#' **What it Does:**
#'
#' **Output:**
## ------------------------------------------------------------------------
calculate.mode <-  function(x){
    ta = table(x)
    tam = max(ta)
    if (all(ta == tam))
         mod = NA
    else
         if(is.numeric(x))
    mod = as.numeric(names(ta)[ta == tam])
    else
         mod = names(ta)[ta == tam]
    return(mod)
}

#' ***
#' ### The "multi.inter" Function
#'
#' **Input:**
#'
#' **What it Does:**
#'
#' **Output:**
#'
## ------------------------------------------------------------------------
multi.inter <- function(cameradf){

cameradfhc.df <- cameradf[cameradf$horse > 0 & cameradf$cow > 0, ]
cameradfhc <- if (length(cameradfhc.df) > 0){
  cameradfhc_table <- count(cameradfhc.df, cameradfhc.df$multi)
  cameradfhc <- sum(cameradfhc_table$n)
} else {0}

cameradfhe.df <- cameradf[cameradf$horse > 0 & cameradf$elk > 0, ]
cameradfhe <- if (length(cameradfhe.df) > 0){
  cameradfhe_table <- count(cameradfhe.df, cameradfhe.df$multi)
  cameradfhe <- sum(cameradfhe_table$n)
} else {0}

cameradfce.df <- cameradf[cameradf$cow > 0 & cameradf$elk > 0, ]
cameradfce <- if (length(cameradfce.df) > 0){
  cameradfce_table <- count(cameradfce.df, cameradfce.df$multi)
  cameradfce <- sum(cameradfce_table$n)
} else {0}

cameradfhd.df <- cameradf[cameradf$horse > 0 & cameradf$deer > 0, ]
cameradfhd <- if (length(cameradfhd.df) > 0){
  cameradfhd_table <- count(cameradfhd.df, cameradfhd.df$multi)
  cameradfhd <- sum(cameradfhd_table$n)
} else {0}

cameradfed.df <- cameradf[cameradf$elk > 0 & cameradf$deer > 0, ]
cameradfed <- if (length(cameradfed.df) > 0){
  cameradfed_table <- count(cameradfed.df, cameradfed.df$multi)
  cameradfed <- sum(cameradfed_table$n)
} else {0}

cameradfep.df <- cameradf[cameradf$elk > 0 & cameradf$pronghorn > 0, ]
cameradfep <- if (length(cameradfep.df) > 0){
  cameradfep_table <- count(cameradfep.df, cameradfep.df$multi)
  cameradfep <- sum(cameradfep_table$n)
} else {0}

cameradfmulti <- data.frame(interaction = c("Horse/Cow", "Horse/Elk", "Cow/Elk", "Horse/Deer", "Elk/Deer", "Elk/Pronghorn"), freq = c(cameradfhc, cameradfhe, cameradfce, cameradfhd, cameradfed, cameradfep))

return(cameradfmulti)

}

#' ***
#' ### The "waterway" Function
#'
#' **Input:**
#'
#' **What it Does:**
#'
#' **Output:**
#'
## ------------------------------------------------------------------------
waterway <- function(cameradf){

cameradfwater.df <- cameradf[complete.cases(cameradf[ , 'water']),]

cameradfwater <- cameradfwater.df[cameradfwater.df$water == "Yes" & cameradfwater.df$multi == "No", ]

cameradfwater <- cameradfwater[cameradfwater$Count1Species == "Cow" | cameradfwater$Count1Species == "Horse" | cameradfwater$Count1Species == "Elk", ]

cameradfwater <- count(cameradfwater, cameradfwater$Count1Species)

na.exclude(cameradfwater)

x <- c("Horse", "Cow", "Elk") # custom order

cameradfwater <- cameradfwater %>% slice(match(x, cameradfwater$`cameradfwater$Count1Species`))

return(cameradfwater)
}

#'
## ------------------------------------------------------------------------
calc.behav <- function(cameradfspecies){
  cameradf_nomulti <- filter(cameradfspecies, multi == "No")

cameradf_forage <- na.omit(count(cameradf_nomulti, ConditionsB1))
cameradf_forage <- if (sum(is.na(cameradf_nomulti$ConditionsB1)) == nrow(cameradf_nomulti)) {
add_row(cameradf_forage, ConditionsB1 = "Forage", n = 0)
} else {na.omit(count(cameradf_nomulti, ConditionsB1))
  }

cameradf_drink <- na.omit(count(cameradf_nomulti, ConditionsB2))
cameradf_drink <- if (sum(is.na(cameradf_nomulti$ConditionsB2)) == nrow(cameradf_nomulti)) {
add_row(cameradf_drink, ConditionsB2 = "Drink", n = 0)
} else {na.omit(count(cameradf_nomulti, ConditionsB2))
}

cameradf_walkrun <- na.omit(count(cameradf_nomulti, ConditionsB3))
cameradf_walkrun <- if (sum(is.na(cameradf_nomulti$ConditionsB3)) == nrow(cameradf_nomulti)) {
add_row(cameradf_walkrun, ConditionsB3 = "Walk/Run", n = 0)
} else {na.omit(count(cameradf_nomulti, ConditionsB3))
  }

cameradf_bed <- na.omit(count(cameradf_nomulti, ConditionsB4))
cameradf_bed <- if (sum(is.na(cameradf_nomulti$ConditionsB4)) == nrow(cameradf_nomulti)) {
add_row(cameradf_bed, ConditionsB4 = "Bed", n = 0)
} else {na.omit(count(cameradf_nomulti, ConditionsB4))
  }

cameradf_stand <- na.omit(count(cameradf_nomulti, ConditionsB5))
cameradf_stand <- if (sum(is.na(cameradf_nomulti$ConditionsB5)) == nrow(cameradf_nomulti)) {
add_row(cameradf_stand, ConditionsB5 = "Stand", n = 0)
} else {na.omit(count(cameradf_nomulti, ConditionsB5))
  }

cameradf_unknown <- na.omit(count(cameradf_nomulti, ConditionsB6))
cameradf_unknown <- if (sum(is.na(cameradf_nomulti$ConditionsB6)) == nrow(cameradf_nomulti)) {
add_row(cameradf_unknown, ConditionsB6 = "Unknown", n = 0)
} else {na.omit(count(cameradf_nomulti, ConditionsB6))
  }

total <- sum(cameradf_forage$n, cameradf_drink$n, cameradf_walkrun$n, cameradf_bed$n, cameradf_stand$n, cameradf_unknown$n)

total <- if (total == 0) {total <- 1
} else {total}


cameradf_behav <- data.frame(behavior = c("Forage", "Drink", "Walk/Run", "Bedded", "Stand", "Unknown"),
                              count = c(cameradf_forage$n,
                                        cameradf_drink$n,
                                        cameradf_walkrun$n,
                                        cameradf_bed$n,
                                        cameradf_stand$n,
                                        cameradf_unknown$n),
                              percent = c(round(100*(cameradf_forage$n/total), digits = 2),
                                          round(100*(cameradf_drink$n/total), digits = 2),
                                          round(100*(cameradf_walkrun$n/total), digits = 2),
                                          round(100*(cameradf_bed$n/total), digits = 2),
                                          round(100*(cameradf_stand$n/total), digits = 2),
                                          round(100*(cameradf_unknown$n/total), digits = 2)))
return(cameradf_behav)
}

#'
## ------------------------------------------------------------------------
behav.matrix <- function(behav.dfhorses, behav.dfcattle, behav.dfelk ){
  cameradf_behav <- matrix(c(behav.dfhorses$percent[1],
                       behav.dfcattle$percent[1],
                       behav.dfelk$percent[1],
                       behav.dfhorses$percent[2],
                       behav.dfcattle$percent[2],
                       behav.dfelk$percent[2],
                       behav.dfhorses$percent[3],
                       behav.dfcattle$percent[3],
                       behav.dfelk$percent[3],
                       behav.dfhorses$percent[4],
                       behav.dfcattle$percent[4],
                       behav.dfelk$percent[4],
                       behav.dfhorses$percent[5],
                       behav.dfcattle$percent[5],
                       behav.dfelk$percent[5],
                       behav.dfhorses$percent[6],
                       behav.dfcattle$percent[6],
                       behav.dfelk$percent[6]), nrow = 3)
rownames(cameradf_behav) = c("Horses", "Cattle", "Elk")
colnames(cameradf_behav) = c("Foraging", "Drinking", "Moving", "Bedded", "Standing", "Unknown")
return(cameradf_behav)
}

#'
#'

#
# The "save.first.three.parts.of.strings" Function
#
# **Input:** Requires a character list generated by the str_split() function
#
# **What it Does:** Keeps the first three splits in each object and appends them together.
#
# **Output:** Returns the first three splits appended together from each object.
# ------------------------------------------------------------------------
save.first.three.parts.of.strings <- function(file_names_string_split){

  num_data_objects <- lengths(file_names_string_split)

  first_object <- rep(1, times = length(num_data_objects))

  second_object <- rep(2, times = length(num_data_objects))

  third_object <- rep(3, times = length(num_data_objects))

  keep_frist_three_splits <- NULL

  keep_first_object <- NULL

  keep_second_object <- NULL

  keep_third_object <- NULL

  for (i in 1:length(csv_file_names_string_split)) {

    keep_first_object[i] <- file_names_string_split[[i]][first_object[i]]

    keep_second_object[i] <- file_names_string_split[[i]][second_object[i]]

    keep_third_object[i] <- file_names_string_split[[i]][third_object[i]]

    keep_frist_three_splits[i] <- str_c(keep_first_object[i],
                                        keep_second_object[i],
                                        keep_third_object[i],
                                        sep = "_",
                                        collapse = "")
  }
  return(keep_frist_three_splits)
}

# The "recombine.chunks" Function
#
# **Input:**
# Requires a data frame of the list of csv files filtered by site.
# (i.e. there is a data frame for each site listing the csv files for that site)
#
# **What it Does:**
# Filters  by deployment date. Reads in csv data from each deployment,
# and then binds rows together.
#
# **Output:**
# Writes out a csv file that has all of the chunks recombined together, in order.

recombine.chunks <- function(site, path){

  deployments <- unique(site$deploydate)

  for (i in 1:length(deployments)) {

    site_filtered <- filter(site, deploydate == deployments[i])

    site_filtered_data <- file.path(path, site_filtered$relpath) %>% lapply(readr::read_csv) %>% dplyr::bind_rows()

    # create a file name string
    filename <- paste(unique(site_filtered$sitecode),
                      unique(site_filtered$deploydate),
                      unique(site_filtered$collectdate),
                      "subjects",
                      "all_chunks.csv",
                      sep = "_")

    # create a new directory to hold the recombined chunks
    if (dir.exists(file.path(path, "recombined")) == FALSE) {
      dir.create(file.path(path,"recombined"))
    } else {

    }

    # write out the data
    write_excel_csv(site_filtered_data, file.path(path, "recombined", filename))
  }
}

## the source() function executes all lines of code in the "mentioned" script (i.e. the pathway)
source_rmd <- function(file_path) {
  stopifnot(is.character(file_path) && length(file_path) == 1)
  .tmpfile <- tempfile(fileext = ".R")
  .con <- file(.tmpfile)
  on.exit(close(.con))
  full_rmd <- read_file(file_path)
  codes <- str_match_all(string = full_rmd, pattern = "```(?s)\\{r[^{}]*\\}\\s*\\n(.*?)```")
  stopifnot(length(codes) == 1 && ncol(codes[[1]]) == 2)
  codes <- paste(codes[[1]][, 2], collapse = "\n")
  writeLines(codes, .con)
  flush(.con)
  cat(sprintf("R code extracted to tempfile: %s\nSourcing tempfile...", .tmpfile))
  source(.tmpfile)
}

## The "cameratraps_path_constructor" Function.
#
# **Input**
# Requires a character vector of the collection folders in the "cameratraps" database.
# e.g., BKN_07022019_08132019
#
# **What it Does**
#
#
# **Output**
#
#
cameratraps_path_constructor <-
  function(folders_to_chunk) {
    # regex to construct a dataframe using the first three uppercase letters of the collection folder
    cameratraps_folders_to_chunk <-
      data.frame(
        "site" = stringr::str_extract(folders_to_chunk,
                                      pattern = "([[:upper:]][[:upper:]][[:upper:]]|[[:upper:]]\\d{2})"),
        "collection_folder" = folders_to_chunk
      )
    # matching on the first three letters to construct file paths
    for (i in 1:nrow(cameratraps_folders_to_chunk)) {
      if (cameratraps_folders_to_chunk$site[i] == "BRL") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "bear", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "BRT") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "bear", "trail")
      } else if (cameratraps_folders_to_chunk$site[i] == "BFD") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "bigfield", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "BKD") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "blackcanyon", "timelapsedam")
      } else if (cameratraps_folders_to_chunk$site[i] == "BKN") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "blackcanyon", "timelapsenorth")
      } else if (cameratraps_folders_to_chunk$site[i] == "BKS") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "blackcanyon", "timelapsesouth")
      } else if (cameratraps_folders_to_chunk$site[i] == "BKT") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "blackcanyon", "trail")
      } else if (cameratraps_folders_to_chunk$site[i] == "BGX") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "boggy", "exclosure")
      } else if (cameratraps_folders_to_chunk$site[i] == "BGW") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "boggy", "timelapse5min")
      } else if (cameratraps_folders_to_chunk$site[i] == "BGE") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "boggy", "timelapseeast")
      } else if (cameratraps_folders_to_chunk$site[i] == "BGW") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "boggy", "timelapsewest")
      } else if (cameratraps_folders_to_chunk$site[i] == "BGT") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "boggy", "trail")
      } else if (cameratraps_folders_to_chunk$site[i] == "EFK") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "eastfork", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "A51") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "fiftyone", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "FLO") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "firelookout", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "HWY") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "highway", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "HPL") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "holdingpasture", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "MAD") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "mauldin", "phenocam")
      } else if (cameratraps_folders_to_chunk$site[i] == "OPO") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "onlyponderosa", "timelapse")
      } else if (cameratraps_folders_to_chunk$site[i] == "WCX") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "wildcat", "exclosure")
      } else if (cameratraps_folders_to_chunk$site[i] == "WCS") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "wildcat", "timelapse5min")
      } else if (cameratraps_folders_to_chunk$site[i] == "WCN") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "wildcat", "timelapsenorth")
      } else if (cameratraps_folders_to_chunk$site[i] == "WCS") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "wildcat", "timelapsesouth")
      } else if (cameratraps_folders_to_chunk$site[i] == "WCT") {
        cameratraps_folders_to_chunk$relative_path[i] <-
          file.path("~", "cameratraps", "wildcat", "trail")
      } else {
        cameratraps_folders_to_chunk <- NULL
      }
    }
    cameratraps_folders_to_chunk$full_path <- file.path(
      cameratraps_folders_to_chunk$relative_path,
      cameratraps_folders_to_chunk$collection_folder)
    return(cameratraps_folders_to_chunk)
  }

# The "cameratraps2_path_constructor"
#
#
#
#
#
#
cameratraps2_path_constructor <-
  function(cameratraps2_folders_to_extract) {
    cameratraps2_folders_df <-
      data.frame(
        "site" = stringr::str_extract(cameratraps2_folders_to_extract,
                                      pattern = "[[:upper:]][[:upper:]][[:upper:]]\\d\\d"),
        "collection_folder" = cameratraps2_folders_to_extract
      )

    cameratraps2_folders_df$relative_path <-
      file.path("~", "cameratraps2", cameratraps2_folders_df$site)

    cameratraps2_folders_df$full_path <- file.path(
      cameratraps2_folders_df$relative_path,
      cameratraps2_folders_df$collection_folder
    )
    return(cameratraps2_folders_df)
  }


# TODO given the opportunity I would design this in a different way
# first, I would have the users enter the name of each site
# then I would either programitcally generate a site code from the site name (checking for collisions)
# or I would allow the user to enter in a site code for each site name
# I could store this data as a json file
# then I would use a function like this to match data
# you could rename the a site in by editing the json file and it should propogate to other files


sitecode_constructor <-
  function(sitecode_vector) {
    # regex to construct a dataframe using the first three uppercase letters of the collection folder
    # or 3 uppercase and 2 digits if a camertraps2 colllection folder
    regex <- "(?<=_).{3,5}(?=\\.csv)"

    reconstructed_site <-
      data.frame("sitecode" = stringr::str_extract(sitecode_vector,
                                                   pattern = regex)
      )
                 for (i in 1:nrow(reconstructed_site)) {
                   if (nchar(reconstructed_site$sitecode[i]) == 3) {
                     if (reconstructed_site$sitecode[i] == "BRL") {
                       reconstructed_site$site[i] <- "Bear Timelapse"
                     } else if (reconstructed_site$sitecode[i] == "BRT") {
                       reconstructed_site$site[i] <- "Bear Trail"
                     } else if (reconstructed_site$sitecode[i] == "BFD") {
                       reconstructed_site$site[i] <- "Big Field"
                     } else if (reconstructed_site$sitecode[i] == "BKD") {
                       reconstructed_site$site[i] <- "Black Canyon Dam"
                     } else if (reconstructed_site$sitecode[i] == "BKN") {
                       reconstructed_site$site[i] <- "Black Canyon North"
                     } else if (reconstructed_site$sitecode[i] == "BKS") {
                       reconstructed_site$site[i] <- "Black Canyon South"
                     } else if (reconstructed_site$sitecode[i] == "BKT") {
                       reconstructed_site$site[i] <- "Black Canyon Trail"
                     } else if (reconstructed_site$sitecode[i] == "BGX") {
                       reconstructed_site$site[i] <- "Boggy Exclosure"
                     } else if (reconstructed_site$sitecode[i] == "BGW") {
                       reconstructed_site$site[i] <- "Boggy West"
                     } else if (reconstructed_site$sitecode[i] == "BGE") {
                       reconstructed_site$site[i] <- "Boggy East"
                     } else if (reconstructed_site$sitecode[i] == "BGT") {
                       reconstructed_site$site[i] <- "Boggy Trail"
                     } else if (reconstructed_site$sitecode[i] == "EFK") {
                       reconstructed_site$site[i] <- "East Fork"
                     } else if (reconstructed_site$sitecode[i] == "A51") {
                       reconstructed_site$site[i] <- "Fifty One"
                     } else if (reconstructed_site$sitecode[i] == "FLO") {
                       reconstructed_site$site[i] <- "Fire Lookout"
                     } else if (reconstructed_site$sitecode[i] == "HWY") {
                       reconstructed_site$site[i] <- "Highway"
                     } else if (reconstructed_site$sitecode[i] == "HPL") {
                       reconstructed_site$site[i] <- "Holding Pasture"
                     } else if (reconstructed_site$sitecode[i] == "MAD") {
                       reconstructed_site$site[i] <- "Malden Phenocam"
                     } else if (reconstructed_site$sitecode[i] == "OPO") {
                       reconstructed_site$site[i] <- "Only Ponderosa"
                     } else if (reconstructed_site$sitecode[i] == "WCX") {
                       reconstructed_site$site[i] <- "Wildcat Exclosure"
                     } else if (reconstructed_site$sitecode[i] == "WCS") {
                       reconstructed_site$site[i] <- "Wildcat South"
                     } else if (reconstructed_site$sitecode[i] == "WCN") {
                       reconstructed_site$site[i] <- "Wildcat North"
                     } else if (reconstructed_site$sitecode[i] == "WCT") {
                       reconstructed_site$site[i] <- "Wildcat Trail"
                     }
                   } else if (nchar(reconstructed_site$sitecode[i]) == 5) {
                     if (reconstructed_site$sitecode[i] == "BUO01") {
                       reconstructed_site$site[i] <- "Bunger Off Territory 01"
                     } else if (reconstructed_site$sitecode[i] == "BUO07") {
                       reconstructed_site$site[i] <- "Bunger Off Territory 07"
                     } else if (reconstructed_site$sitecode[i] == "BUO23") {
                       reconstructed_site$site[i] <- "Bunger Off Territory 23"
                     } else if (reconstructed_site$sitecode[i] == "BUO29") {
                       reconstructed_site$site[i] <- "Bunger Off Territory 29"
                     } else if (reconstructed_site$sitecode[i] == "BUT12") {
                       reconstructed_site$site[i] <- "Bunger On Territory 12"
                     } else if (reconstructed_site$sitecode[i] == "BUT19") {
                       reconstructed_site$site[i] <- "Bunger On Territory 19"
                     } else if (reconstructed_site$sitecode[i] == "GEO02") {
                       reconstructed_site$site[i] <- "Gentry Off Territory 02"
                     } else if (reconstructed_site$sitecode[i] == "GEO30") {
                       reconstructed_site$site[i] <- "Gentry Off Territory 30"
                     } else if (reconstructed_site$sitecode[i] == "GEO32") {
                       reconstructed_site$site[i] <- "Gentry Off Territory 32"
                     } else if (reconstructed_site$sitecode[i] == "GET01") {
                       reconstructed_site$site[i] <- "Gentry On Territory 01"
                     } else if (reconstructed_site$sitecode[i] == "GET06") {
                       reconstructed_site$site[i] <- "Gentry On Territory 06"
                     } else if (reconstructed_site$sitecode[i] == "GET13") {
                       reconstructed_site$site[i] <- "Gentry On Territory 13"
                     } else if (reconstructed_site$sitecode[i] == "GET21") {
                       reconstructed_site$site[i] <- "Gentry On Territory 21"
                     } else if (reconstructed_site$sitecode[i] == "GEO22") {
                       reconstructed_site$site[i] <- "Gentry Off Territory 22"
                     } else if (reconstructed_site$sitecode[i] == "KPT14") {
                       reconstructed_site$site[i] <- "King Phillip On Territory 14"
                     } else if (reconstructed_site$sitecode[i] == "KPT16") {
                       reconstructed_site$site[i] <- "King Phillip On Territory 16"
                     } else if (reconstructed_site$sitecode[i] == "KPT27") {
                       reconstructed_site$site[i] <- "King Phillip On Territory 27"
                     } else if (reconstructed_site$sitecode[i] == "SHT11") {
                       reconstructed_site$site[i] <- "Sharp Hollow On Territory 11"
                     } else if (reconstructed_site$sitecode[i] == "SHT15") {
                       reconstructed_site$site[i] <- "Sharp Hollow On Territory 15"
                     } else if (reconstructed_site$sitecode[i] == "SHT18") {
                       reconstructed_site$site[i] <- "Sharp Hollow On Territory 18"
                     } else if (reconstructed_site$sitecode[i] == "SHT30") {
                       reconstructed_site$site[i] <- "Sharp Hollow On Territory 30"
                     } else if (reconstructed_site$sitecode[i] == "STO08") {
                       reconstructed_site$site[i] <- "Stermer Off Territory 08"
                     } else if (reconstructed_site$sitecode[i] == "STO09") {
                       reconstructed_site$site[i] <- "Stermer Off Territory 09"
                     } else if (reconstructed_site$sitecode[i] == "STO39") {
                       reconstructed_site$site[i] <- "Stermer Off Territory 39"
                     } else if (reconstructed_site$sitecode[i] == "STT29") {
                       reconstructed_site$site[i] <- "Stermer On Territory 29"
                     }
                   } else {
                     warning(paste("Site not a match!", reconstructed_site$sitecode[i]))
                   }
                 }
                 return(reconstructed_site)
  }

rename_water_column_to_TraitB2 <- function(cameradf) {

  column_search <- stringr::str_detect(colnames(cameradf), "multi")

  if (any(column_search) == TRUE) {

    cameradf <- dplyr::rename(cameradf, TraitB2 = multi)

  }
  return(cameradf)
}

rename_water_column_to_Trait4 <- function(cameradf) {

  column_search <- stringr::str_detect(colnames(cameradf), "water")

  if (any(column_search) == TRUE) {

    cameradf <- dplyr::rename(cameradf, Trait4 = water)

  }
  return(cameradf)
}


rename_measured_column_to_TraitB3 <- function(cameradf) {

  column_search <- stringr::str_detect(colnames(cameradf), "measured")

  if (any(column_search) == TRUE) {

    cameradf <- dplyr::rename(cameradf, TraitB3 = measured)

  }
  return(cameradf)
}


rename_elements_in_list_of_csv_files <- function(csv_files) {

  long_names <- names(csv_files)

  names(csv_files) <- basename(long_names)

  return(csv_files)

}


write_csv_purrr <- function(list_of_dataframes, file_names) {

  folder_path <- file.path(currentwd,
                           "data",
                           "photo",
                           "combined-by-site-year",
                           "processed")

  readr::write_csv(list_of_dataframes,
                   file.path(folder_path, file_names))

}

# TODO set the interval from the JSON setting

calc.grazing.time.unwtd <- function(cameradf) {

  sites_from_json <- jsonlite::fromJSON(
    file.path(currentwd, "data", "metadata", "cameratrap-sites.json"))

  # match the site name from sites_from_json to cameradf
  site_match <- dplyr::filter(sites_from_json, sites_from_json$Site == unique(cameradf$Site) &
                                sites_from_json$Year == unique(cameradf$Year))

  cameradf <- cameradf %>% dplyr::mutate(horse_grazing_unwtd = horse * site_match$Timelapse_Interval)

  cameradf <- cameradf %>% dplyr::mutate(cow_grazing_unwtd = cow * site_match$Timelapse_Interval)

  cameradf <- cameradf %>% dplyr::mutate(elk_grazing_unwtd = elk * site_match$Timelapse_Interval)

  return(cameradf)
}

calc.grazing.time.wtd <- function(cameradf) {

  sites_from_json <- jsonlite::fromJSON(
    file.path(currentwd, "data", "metadata", "cameratrap-sites.json"))

  # match the site name from sites_from_json to cameradf
  site_match <- dplyr::filter(sites_from_json, sites_from_json$Site == unique(cameradf$Site) &
                                sites_from_json$Year == unique(cameradf$Year))

  cameradf <- cameradf %>% dplyr::mutate(horse_grazing_wtd = horse * site_match$Timelapse_Interval * 1.1)

  cameradf <- cameradf %>% dplyr::mutate(cow_grazing_wtd = cow * site_match$Timelapse_Interval * 1)

  cameradf <- cameradf %>% dplyr::mutate(elk_grazing_wtd = elk * site_match$Timelapse_Interval * 0.7)

  return(cameradf)
}


summarize.unwtd.daily.totals <- function(cameradf) {

  cameradf_horses <- NULL
  cameradf_horses <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(daily_total_unwtd = sum(horse_grazing_unwtd))
  cameradf_horses <- cameradf_horses %>% mutate(Species = "Horse")

  cameradf_cows <- NULL
  cameradf_cows <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(daily_total_unwtd = sum(cow_grazing_unwtd))
  cameradf_cows <- cameradf_cows %>% mutate(Species = "Cow")

  cameradf_elk <- NULL
  cameradf_elk <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(daily_total_unwtd = sum(elk_grazing_unwtd))
  cameradf_elk <- cameradf_elk %>% mutate(Species = "Elk")

  cameradf_bind <- dplyr::bind_rows(cameradf_horses, cameradf_cows, cameradf_elk)

  cameradf_bind$Site <- NULL

  cameradf_bind$Site <- cameradf$Site[1]

  cameradf_bind$Year <- NULL

  cameradf_bind$Year <- cameradf$Year[1]

  return(cameradf_bind)
}


summarize.wtd.daily.totals <- function(cameradf) {

  cameradf_horses <- NULL
  cameradf_horses <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(daily_total_wtd = sum(horse_grazing_wtd))
  cameradf_horses <- cameradf_horses %>% mutate(Species = "Horse")

  cameradf_cows <- NULL
  cameradf_cows <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(daily_total_wtd = sum(cow_grazing_wtd))
  cameradf_cows <- cameradf_cows %>% mutate(Species = "Cow")

  cameradf_elk <- NULL
  cameradf_elk <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(daily_total_wtd = sum(elk_grazing_wtd))
  cameradf_elk <- cameradf_elk %>% mutate(Species = "Elk")

  cameradf_bind <- dplyr::bind_rows(cameradf_horses, cameradf_cows, cameradf_elk)

  cameradf_bind$Site <- NULL

  cameradf_bind$Site <- cameradf$Site[1]

  cameradf_bind$Year <- NULL

  cameradf_bind$Year <- cameradf$Year[1]

  return(cameradf_bind)

}


summarize_daily_totals <- function(cameradf) {

  cameradf_horses <- NULL

  cameradf_horses <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(across(c(horse_grazing_unwtd, horse_grazing_wtd), sum)) %>%
    dplyr::rename(daily_total_unwtd = horse_grazing_unwtd, daily_total_wtd = horse_grazing_wtd)

  cameradf_horses <- cameradf_horses %>% mutate(Species = "Horse")

  cameradf_cows <- NULL

  cameradf_cows <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(across(c(cow_grazing_unwtd, cow_grazing_wtd), sum)) %>%
    dplyr::rename(daily_total_unwtd = cow_grazing_unwtd, daily_total_wtd = cow_grazing_wtd)

  cameradf_cows <- cameradf_cows %>% mutate(Species = "Cow")

  cameradf_elk <- NULL

  cameradf_elk <- cameradf %>%
    dplyr::group_by(ImageDate) %>%
    dplyr::summarise(across(c(elk_grazing_unwtd, elk_grazing_wtd), sum)) %>%
    dplyr::rename(daily_total_unwtd = elk_grazing_unwtd, daily_total_wtd = elk_grazing_wtd)

  cameradf_elk <- cameradf_elk %>% mutate(Species = "Elk")

  cameradf_bind <- dplyr::bind_rows(cameradf_horses, cameradf_cows, cameradf_elk)

  cameradf_bind$Site <- NULL

  cameradf_bind$Site <- cameradf$Site[1]

  cameradf_bind$Year <- NULL

  cameradf_bind$Year <- cameradf$Year[1]

  return(cameradf_bind)

  }



set_timezone <- function(cameradf) {

  cameradf <- dplyr::mutate(cameradf, DateTime = lubridate::with_tz(DateTime, Sys.timezone()))

  return(cameradf)

}


calc.grazing.totals.unwtd <- function(site_summary){
  site_total <- site_summary %>%
    dplyr::group_by(Species) %>%
    dplyr::summarise(season_total = sum(daily_total_unwtd)) %>%
    dplyr::mutate(proportion = season_total/sum(season_total)) %>%
    dplyr::mutate(Site = site_summary$Site[1])

  return(site_total)
}



calc.grazing.totals.wtd <- function(site_summary){
  site_total <- site_summary %>%
    dplyr::group_by(Species) %>%
    dplyr::summarise(season_total = sum(daily_total_wtd)) %>%
    dplyr::mutate(proportion = season_total/sum(season_total)) %>%
    dplyr::mutate(Site = site_summary$Site[1])

  return(site_total)
}



reorder.factors.by.season.total <- function(sitetotal){
  sitetotal$Species <- sitetotal$Species %>% forcats::as_factor()
  sitetotal$Species <- forcats::fct_reorder(sitetotal$Species, sitetotal$season_total)

  return(sitetotal)
}

pull.species.percentage <- function(site_unwtd_total, species) {
  site_unwtd_percent_species <- site_unwtd_total %>%
    dplyr::filter(Species == species) %>%
    dplyr::pull(proportion)
  return(site_unwtd_percent_species)
}

calc_season_total <- function(site_summary) {

  # grab the summarized df from the list of summarized df
  site_summary %>%
    dplyr::group_by(Species) %>%

    # create two new summary columns containing the weighted and unweighted season totals for each species
    dplyr::summarise(across(c(daily_total_unwtd, daily_total_wtd), sum)) %>%

    # replace the default column names generated by across()
    dplyr::rename_with(~stringr::str_replace(pattern = "daily",
                                           replacement = "season", .),
                       .cols = starts_with("daily")) %>%

    # create a new column with the unweighted proportion for each species
    dplyr::mutate(proportion_unwtd =
                  season_total_unwtd/sum(season_total_unwtd)) %>%

    # create a new column with the weighted proportion for each speices
    dplyr::mutate(proportion_wtd =
                  season_total_wtd/sum(season_total_wtd)) %>%

    # add the site name back into the data frame to help keep track of where the data is from
    dplyr::mutate(Site = site_summary$Site[1],
                .before = Species)
}

# TODO this could be optimized to accept a string as input so users could change the input
manually_relevel_species_as_factors <- function(site_summary) {

  site_summary$Species <-
  site_summary$Species %>%
  forcats::as_factor() %>%
  forcats::fct_relevel(c("Elk", "Cow", "Horse"))

  site_summary$Site <-
    site_summary$Site %>%
    as.character()

  site_summary <-
    site_summary %>%
    dplyr::arrange(Site)

  site_summary$Site <-
    site_summary$Site %>%
    forcats::as_factor()

  site_summary <-
    site_summary %>%
    group_by(Site) %>%
    dplyr::arrange(Species, .by_group = TRUE)

  return(site_summary)
}

group_season_total_by_year <- function(list_of_season_totals) {

  names <- names(list_of_season_totals)

  name_matches <- stringr::str_extract(names, pattern = "\\d{4}")

  years <- unique(name_matches)

  list_of_grouped_season_totals <- NULL

  list_of_grouped_season_totals <- as.list(list_of_grouped_season_totals)

  for (i in 1:length(years)) {

    list_of_grouped_season_totals[[i]] <-
      list_of_season_totals[stringr::str_detect(names, years[i]) == TRUE] %>%
      purrr::imap_dfr(as_tibble)

  }

  # rename the elements in the list by the year
  names(list_of_grouped_season_totals) <- years

  return(list_of_grouped_season_totals)

  }


# create a data frame of positions

calc_scaling_factor <- function(season_total, weighted) {

  if (weighted == FALSE) {

    scaling_factor_tibble <-
      season_total %>%
      dplyr::group_by(Site) %>%
      dplyr::summarize(Total = sum(season_total_unwtd)) %>%
      dplyr::mutate(Scaling_Factor = max(Total) / Total)

  } else if (weighted == TRUE) {

    scaling_factor_tibble <-
      season_total %>%
      dplyr::group_by(Site) %>%
      dplyr::summarize(Total = sum(season_total_wtd)) %>%
      dplyr::mutate(Scaling_Factor = max(Total) / Total)
  }

  # match on the site and add a scaling factor column
  scaling_factor_tibble <- dplyr::left_join(season_total,
                                          scaling_factor_tibble,
                                          by = "Site")

  return(scaling_factor_tibble)

}


theme_grazer_daily <- function() {

  font <- "sans"   #assign font family up front

  theme() %+replace%    #replace elements we want to change

    theme(

      plot.title = element_text(
        family = font,
        size = 42,
        face = 'bold',
        margin = margin(t = 10, r = 0, b = 10, l = 0),
        hjust = 0.5),

      plot.subtitle = element_text(
        family = font,
        hjust = 0.5,
        margin = margin(t = 0, r = 0, b = 0, l = 0),
        face = 'italic',
        size = 32),

      plot.caption = element_text(
        family = font,
        size = 24,
        hjust = 1),

      axis.title = element_text(
        family = font,
        size = 32,
        face = 'bold'),

      axis.text = element_text(
        family = font,
        size = 24),

      axis.text.x = element_text(
        margin = margin(t = 10, r = 0, b = 10, l = 0)),

      axis.text.y = element_text(
        margin = margin(t = 10, r = 0, b = 10, l = 10)),

      legend.text = element_text(
        family = font,
        size = 24),

      legend.title = element_text(
        size = 32,
        face = 'bold'),

      strip.text = element_text(
        size = 24
      )


    )
}

theme_grazer_season <- function() {

  font <- "sans"   #assign font family up front

  theme() %+replace%    #replace elements we want to change

    theme(

      plot.title = element_text(
        family = font,
        size = 32,
        face = 'bold',
        margin = margin(t = 5, r = 0, b = 10, l = 0),
        hjust = 0.5),

      plot.subtitle = element_text(
        family = font,
        hjust = 0.5,
        margin = margin(t = 0, r = 0, b = 5, l = 0),
        face = 'italic',
        size = 24),

      plot.caption = element_text(
        family = font,
        size = 24,
        hjust = 1),

      axis.title = element_text(
        family = font,
        size = 24,
        face = 'bold'),

      axis.text = element_text(
        family = font,
        size = 18),

      axis.text.x = element_text(
        margin = margin(t = 10, r = 0, b = 10, l = 0)),

      axis.text.y = element_text(
        margin = margin(t = 10, r = 0, b = 10, l = 10)),

      legend.text = element_text(
        family = font,
        size = 24),

      legend.title = element_text(
        size = 24,
        face = 'bold'),

      strip.text = element_text(
        size = 24
      )


    )
}

round_percent <- function(x) {
  x <- x/sum(x)*100  # Standardize result
  res <- floor(x)    # Find integer bits
  rsum <- sum(res)   # Find out how much we are missing
  if(rsum<100) {
    # Distribute points based on remainders and a random tie breaker
    o <- order(x%%1, sample(length(x)), decreasing=TRUE)
    res[o[1:(100-rsum)]] <- res[o[1:(100-rsum)]]+1
  }
  res
}

create_annotations <- function(season_total, weighted) {

  if (weighted == FALSE) {

  season_total <-
  season_total %>%
  # calculate the scaling factor for each group
  calc_scaling_factor(weighted = FALSE) %>%
  # rename the season_total_unwtd to full height
  dplyr::rename(full_height = season_total_unwtd) %>%
  # add a new column with the half column height
  dplyr::mutate(half_height = full_height / 2, .after = full_height) %>%
  # remove the necessary columns for readability
  dplyr::select(-c("season_total_wtd", "proportion_wtd")) %>%
  # create a character label from the proportion column
  dplyr::rename(label = proportion_unwtd) %>%
  # TODO not happy with how this handles percentages
  # percentages do not equal 100
  dplyr::mutate(label = round(label, digits = 4)) %>%
  # convert the numeric proportion to character
  dplyr::mutate(label = scales::percent(label, accuracy = 0.01)) %>%
  # add an X coordinate based on grouping by Site
  # the "Site" must be a factor and then the factor is converted to integer
  dplyr::mutate(x = as.integer(Site), .after = Species) %>%
  # set horse position y to mid-point in the horse stacked bar
  dplyr::mutate(y = dplyr::if_else(Species == "Horse", half_height, 0, NA_real_), .after = x) %>%
  # set horse y position to 0 based on scaling factor
  dplyr::mutate(y = dplyr::if_else(Species == "Horse" & Scaling_Factor >= 4, 0, y, NA_real_)) %>%
  # create a new column that has the height of the horse column for each group
  dplyr::mutate(horse_height = dplyr::if_else(Species == "Horse", full_height, 0)) %>%
  # fill the 0s with the height of horse column for each group
  dplyr::mutate(horse_height = max(horse_height)) %>%
  # do the same for the cow column
  dplyr::mutate(cow_height = dplyr::if_else(Species == "Cow", full_height, 0)) %>%
  dplyr::mutate(cow_height = max(cow_height)) %>%
  # and the same for the elk column
  dplyr::mutate(elk_height = dplyr::if_else(Species == "Elk", full_height, 0)) %>%
  dplyr::mutate(elk_height = max(elk_height)) %>%
  # to center cow position y to mid-point in the cow stacked bar on top of the horse bar
  dplyr::mutate(y = dplyr::if_else(Species == "Cow", (cow_height/2 + horse_height), y)) %>%
  # adjust position of the cow to (horse full + cow full) if scaling factor >= 7
  dplyr::mutate(y = dplyr::if_else(Species == "Cow" & Scaling_Factor >= 7, (cow_height + horse_height), y, NA_real_)) %>%
  # center the elk position y in mid-point of elk column ontop of cow and horse bars
  dplyr::mutate(y = dplyr::if_else(Species == "Elk", elk_height/2 + cow_height + horse_height, y, NA_real_)) %>%
  # if the scaling factor is >= 4 put the elk label the same distance that the cow and horse labels are from each other
  dplyr::mutate(y = dplyr::if_else(Species == "Elk" & Scaling_Factor >= 4, ((cow_height/2 + horse_height) * 2), y, NA_real_)) %>%
  # if the sacling factor is >= 7 put the elk label equidistant from cow + horse
    dplyr::mutate(y = dplyr::if_else(Species == "Elk" & Scaling_Factor >= 7, ((cow_height + horse_height) * 2), y, NA_real_))

  } else if (weighted == TRUE) {

    season_total <-
      season_total %>%
      # calculate the scaling factor for each group
      calc_scaling_factor(weighted = TRUE) %>%
      # rename the season_total_wtd to full height
      dplyr::rename(full_height = season_total_wtd) %>%
      # add a new column with the half column height
      dplyr::mutate(half_height = full_height / 2, .after = full_height) %>%
      # remove the necessary columns for readability
      dplyr::select(-c("season_total_unwtd", "proportion_unwtd")) %>%
      # create a character label from the proportion column
      dplyr::rename(label = proportion_wtd) %>%
      # TODO not happy with how this handles percentages
      # percentages do not equal 100
      dplyr::mutate(label = round(label, digits = 4)) %>%
      # convert the numeric proportion to character
      dplyr::mutate(label = scales::percent(label, accuracy = 0.01)) %>%
      # add an X coordinate based on grouping by Site
      # the "Site" must be a factor and then the factor is converted to integer
      dplyr::mutate(x = as.integer(Site), .after = Species) %>%
      # set horse position y to mid-point in the horse stacked bar
      dplyr::mutate(y = dplyr::if_else(Species == "Horse", half_height, 0, NA_real_), .after = x) %>%
      # set horse y position to 0 based on scaling factor
      dplyr::mutate(y = dplyr::if_else(Species == "Horse" & Scaling_Factor >= 4, 0, y, NA_real_)) %>%
      # create a new column that has the height of the horse column for each group
      dplyr::mutate(horse_height = dplyr::if_else(Species == "Horse", full_height, 0)) %>%
      # fill the 0s with the height of horse column for each group
      dplyr::mutate(horse_height = max(horse_height)) %>%
      # do the same for the cow column
      dplyr::mutate(cow_height = dplyr::if_else(Species == "Cow", full_height, 0)) %>%
      dplyr::mutate(cow_height = max(cow_height)) %>%
      # and the same for the elk column
      dplyr::mutate(elk_height = dplyr::if_else(Species == "Elk", full_height, 0)) %>%
      dplyr::mutate(elk_height = max(elk_height)) %>%
      # to center cow position y to mid-point in the cow stacked bar on top of the horse bar
      dplyr::mutate(y = dplyr::if_else(Species == "Cow", (cow_height/2 + horse_height), y)) %>%
      # adjust position of the cow to (horse full + cow full) if scaling factor >= 7
      dplyr::mutate(y = dplyr::if_else(Species == "Cow" & Scaling_Factor >= 7, (cow_height + horse_height), y, NA_real_)) %>%
      # center the elk position y in mid-point of elk column ontop of cow and horse bars
      dplyr::mutate(y = dplyr::if_else(Species == "Elk", elk_height/2 + cow_height + horse_height, y, NA_real_)) %>%
      # if the scaling factor is >= 4 put the elk label the same distance that the cow and horse labels are from each other
      dplyr::mutate(y = dplyr::if_else(Species == "Elk" & Scaling_Factor >= 4, ((cow_height/2 + horse_height) * 2), y, NA_real_)) %>%
      # if the sacling factor is >= 7 put the elk label equidistant from cow + horse
      dplyr::mutate(y = dplyr::if_else(Species == "Elk" & Scaling_Factor >= 7, ((cow_height + horse_height) * 2), y, NA_real_))

  }

  return(season_total)

  }
