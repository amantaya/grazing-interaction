# TODO I need a file that contains the site name, site code, camera settings (such as timelapse interval)

# 2017 Sites --------------------------------------------------------------

sites_2017 <- c("Boggy West", # 2017-2020
           "Boggy East", # 2017
           "Wildcat South", # 2017-2020
           "Wildcat North", # 2017
           "Big Field", # 2017-2018
           "Highway", # 2017-2018
           "Black Canyon South", # 2017-2021
           "Bear Timelapse", # 2017-2021
           "East Fork", # 2017-2020
           "Boggy Trail", # 2017-2019
           "Wildcat Trail", # 2017-2019
           "Bear Trail") # 2017-2019

sitecodes_2017 <- c("BGW",
               "BGE",
               "WCS",
               "WCN",
               "BFD",
               "HWY",
               "BKS",
               "BRL",
               "EFK",
               "BGT",
               "WCT",
               "BRT")

year_2017 <- rep("2017", times = length(sites_2017))

timelapse_interval_2017 <- dplyr::if_else(str_detect(sites_2017, pattern = "Trail") == TRUE, NA_real_, 1)


sites_2017_df <- data.frame(Site = sites_2017,
                            Sitecode = sitecodes_2017,
                            Year = year_2017,
                            Timelapse_Interval = timelapse_interval_2017)


# 2018 Sites --------------------------------------------------------------

sites_2018 <- c("Boggy West", # 2017-2020
                "Wildcat South", # 2017-2020
                "Boggy Exclosure", # 2018-2020
                "Wildcat Exclosure", # 2018-2020
                "Big Field", # 2017-2018
                "Highway", # 2017-2018
                "Black Canyon South", # 2017-2021
                "Bear Timelapse", # 2017-2021
                "East Fork", # 2017-2020
                "Boggy Trail", # 2017-2019
                "Wildcat Trail", # 2017-2019
                "Bear Trail") # 2017-2019

sitecodes_2018 <- c("BGW",
               "WCS",
               "BGX",
               "WCX",
               "BFD",
               "HWY",
               "BKS",
               "BRL",
               "EFK",
               "BGT",
               "WCT",
               "BRT")

year_2018 <- rep("2018", times = length(sites_2018))

timelapse_interval_2018 <- dplyr::if_else(str_detect(sites_2018, pattern = "Trail") == TRUE, NA_real_, 1)


sites_2018_df <- data.frame(Site = sites_2018,
                            Sitecode = sitecodes_2018,
                            Year = year_2018,
                            Timelapse_Interval = timelapse_interval_2018)

# 2019 Sites --------------------------------------------------------------

# sites in 2019

sites_2019 <- c("Boggy West", # 2017-2020
                "Wildcat South", # 2017-2020
                "Boggy Exclosure", # 2018-2020
                "Wildcat Exclosure", # 2018-2020
                "Black Canyon South", # 2017-2021
                "Bear Timelapse", # 2017-2021
                "Fifty One", # 2019-2021
                "Black Canyon Dam", # 2019
                "Black Canyon North", # 2019-2020
                "East Fork", # 2017-2020
                "Wildcat South 5 Min", # 2019-2020
                "Boggy West 5 Min", # 2019-2020
                "Boggy Trail", # 2017-2019
                "Wildcat Trail", # 2017-2019
                "Bear Trail") # 2017-2019

sitecodes_2019 <- c("BGW",
               "WCS",
               "BGX",
               "WCX",
               "BKS",
               "BRL",
               "A51",
               "BKD",
               "BKN",
               "EFK",
               "WCS_5min",
               "BGW_5min",
               "BGT",
               "WCT",
               "BRT")

year_2019 <- rep("2019", times = length(sites_2019))

timelapse_interval_2019 <- dplyr::if_else(str_detect(sites_2019,
                                                     pattern =
                                                       "Black Canyon South|Bear Timelapse|Fifty One|Black Canyon Dam|Black Canyon North|Wildcat South 5 Min|Boggy West 5 Min") == TRUE,
                                          5,
                                          1)

sites_2019_df <- data.frame(Site = sites_2019,
                            Sitecode = sitecodes_2019,
                            Year = year_2019,
                            Timelapse_Interval = timelapse_interval_2019)

# 2020 Sites --------------------------------------------------------------

sites_2020 <- c("Boggy West", # 2017-2020
                "Wildcat South", # 2017-2020
                "Boggy Exclosure", # 2018-2020
                "Wildcat Exclosure", # 2018-2020
                "Black Canyon South", # 2017-2021
                "Bear Timelapse", # 2017-2021
                "Fifty One", # 2019-2021
                "Black Canyon North", # 2019-2020
                "East Fork", # 2017-2020
                "Wildcat South 5 Min", # 2019-2020
                "Boggy West 5 Min" # 2019-2020
                )

sitecodes_2020 <- c("BGW",
                    "WCS",
                    "BGX",
                    "WCX",
                    "BKS",
                    "BRL",
                    "A51",
                    "BKN",
                    "EFK",
                    "WCS_5min",
                    "BGW_5min"
                    )

year_2020 <- rep("2020", times = length(sites_2020))

timelapse_interval_2020 <- dplyr::if_else(str_detect(sites_2020,
                                                     pattern =
                                                       "Black Canyon South|Bear Timelapse|Fifty One|Black Canyon Dam|Black Canyon North|Wildcat South 5 Min|Boggy West 5 Min") == TRUE,
                                          5,
                                          1)

sites_2020_df <- data.frame(Site = sites_2020,
                            Sitecode = sitecodes_2020,
                            Year = year_2020,
                            Timelapse_Interval = timelapse_interval_2020)


# 2021 Sites --------------------------------------------------------------

# sites in 2021

sites_2021 <- c("Black Canyon South", # 2017-2021
           "Bear Timelapse", # 2017-2021
           "Fifty One", # 2019-2021
           "Fire Lookout", # 2021
           "Holding Pasture", # 2021
           "Only Ponderosa" # 2021
           )

sitecodes_2021 <- c("BKS",
                    "BRL",
                    "A51",
                    "FLO",
                    "HPL",
                    "OPO")

# Need to create multiple entries for each year because the deployment changed from year to year
year_2021 <- rep("2021", times = length(sites_2021))

timelapse_interval_2021 <- dplyr::if_else(str_detect(sites_2021,
                                                     pattern =
                                                       "Black Canyon South|Bear Timelapse|Fifty One|Holding Pasture|Only Ponderosa") == TRUE,
                                          5,
                                          1)

sites_2021_df <- data.frame(Site = sites_2021,
                            Sitecode = sitecodes_2021,
                            Year = year_2021,
                            Timelapse_Interval = timelapse_interval_2021)

# Combine into Single DataFrame -------------------------------------------

all_sites_years_df <- dplyr::bind_rows(sites_2017_df,
                                       sites_2018_df,
                                       sites_2019_df,
                                       sites_2020_df,
                                       sites_2021_df)

jsonlite::write_json(all_sites_years_df, file.path(currentwd, "data", "metadata", "cameratrap-sites.json"))
