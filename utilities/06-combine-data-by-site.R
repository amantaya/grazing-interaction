# clear the R environment
rm(list=ls(all=TRUE))

source(paste0(getwd(), "/environment.R"))

print(currentwd)

# load in the required libraries
source(paste0(currentwd, "/packages.R"))
source(paste0(currentwd, "/functions.R"))

# set working directory to location of excel files
# file.path() is system agnostic (i.e. works on Mac/PC/Linux)
filepaths <- file.path("C:", "temp", "xlsm", "csv", "recombined")

csv_file_list <- list.files(filepaths, pattern = ".csv")

print(csv_file_list)

csv_files_df <- data.frame(csv_file_list)

names(csv_files_df)[names(csv_files_df) == "csv_file_list"] <- "path"

csv_files_df

csv_files_df_separated <- separate(csv_files_df, path, 
                                   into = c("sitecode",
                                            "deploydate",
                                            "collectdate",
                                            "subjects",
                                            "all",
                                            "chunks"),
                                   sep = "_", 
                                   remove = FALSE)

# View(csv_files_df_separated)

# print the site codes in console
unique(csv_files_df_separated$sitecode)

A51_files <- filter(csv_files_df_separated, sitecode == "A51")
BKD_files <- filter(csv_files_df_separated, sitecode == "BKD")
BKN_files <- filter(csv_files_df_separated, sitecode == "BKN")
BKS_files <- filter(csv_files_df_separated, sitecode == "BKS")
BRL_files <- filter(csv_files_df_separated, sitecode == "BRL")
BRT_files <- filter(csv_files_df_separated, sitecode == "BRT")

A51_data <- paste(currentwd, A51_files$path, sep = "/") %>% lapply(readr::read_csv) %>% bind_rows()
BKD_data <- paste(currentwd, BKD_files$path, sep = "/") %>% lapply(readr::read_csv) %>% bind_rows()
BKN_data <- paste(currentwd, BKN_files$path, sep = "/") %>% lapply(readr::read_csv) %>% bind_rows()
BKS_data <- paste(currentwd, BKS_files$path, sep = "/") %>% lapply(readr::read_csv) %>% bind_rows()
BRL_data <- paste(currentwd, BRL_files$path, sep = "/") %>% lapply(readr::read_csv) %>% bind_rows()
BRT_data <- paste(currentwd, BRT_files$path, sep = "/") %>% lapply(readr::read_csv) %>% bind_rows()

# view the data
View(A51_data)

# convert the DateTime column from the Excel DateTime format to the Lubridate format
A51_data$DateTime <- lubridate::ymd_hms(A51_data$DateTime)
BKD_data$DateTime <- lubridate::ymd_hms(BKD_data$DateTime)
BKN_data$DateTime <- lubridate::ymd_hms(BKN_data$DateTime)
BKS_data$DateTime <- lubridate::ymd_hms(BKS_data$DateTime)
BRL_data$DateTime <- lubridate::ymd_hms(BRL_data$DateTime)
BRT_data$DateTime <- lubridate::ymd_hms(BRT_data$DateTime)


A51_2019 <- filter(A51_data, year(A51_data$DateTime) == 2019)
A51_2020 <- filter(A51_data, year(A51_data$DateTime) == 2020)

BKD_2019 <- filter(BKD_data, year(BKD_data$DateTime) == 2019)
BKD_2020 <- filter(BKD_data, year(BKD_data$DateTime) == 2020)

BKN_2019 <- filter(BKN_data, year(BKN_data$DateTime) == 2019)
BKN_2020 <- filter(BKN_data, year(BKN_data$DateTime) == 2020)

BKS_2019 <- filter(BKS_data, year(BKS_data$DateTime) == 2019)
BKS_2020 <- filter(BKS_data, year(BKS_data$DateTime) == 2020)

BRL_2019 <- filter(BRL_data, year(BRL_data$DateTime) == 2019)
BRL_2020 <- filter(BRL_data, year(BRL_data$DateTime) == 2020)

BRT_2019 <- filter(BRT_data, year(BRT_data$DateTime) == 2019)
BRT_2020 <- filter(BRT_data, year(BRT_data$DateTime) == 2020)

sitecodes <- unique(csv_files_df_separated$sitecode)

filename_2019 <- paste("A51", "2019.csv", sep = "_")
filename_2020 <- paste("A51", "2020.csv", sep = "_")
write_excel_csv(A51_2019, paste(currentwd, filename_2019, sep = "/"))
write_excel_csv(A51_2020, paste(currentwd, filename_2020, sep = "/"))

filename_2019 <- paste("BKD", "2019.csv", sep = "_")
write_excel_csv(BKD_2019, paste(currentwd, filename_2019, sep = "/"))

filename_2019 <- paste("BKN", "2019.csv", sep = "_")
filename_2020 <- paste("BKN", "2020.csv", sep = "_")
write_excel_csv(BKN_2019, paste(currentwd, filename_2019, sep = "/"))
write_excel_csv(BKN_2020, paste(currentwd, filename_2020, sep = "/"))

filename_2019 <- paste("BKS", "2019.csv", sep = "_")
filename_2020 <- paste("BKS", "2020.csv", sep = "_")
write_excel_csv(BKS_2019, paste(currentwd, filename_2019, sep = "/"))
write_excel_csv(BKS_2020, paste(currentwd, filename_2020, sep = "/"))

filename_2019 <- paste("BRL", "2019.csv", sep = "_")
filename_2020 <- paste("BRL", "2020.csv", sep = "_")
write_excel_csv(BRL_2019, paste(currentwd, filename_2019, sep = "/"))
write_excel_csv(BRL_2020, paste(currentwd, filename_2020, sep = "/"))

filename_2019 <- paste("BRT", "2019.csv", sep = "_")
write_excel_csv(BRT_2019, paste(currentwd, filename_2019, sep = "/"))
