library(readr)

getwd()

setwd("J:/cameratraps/aguachiquita/barbed/ACB_03272019_05102019")

ACB <- read.csv("ACB_03272019_05102019.csv")
View(ACB)

subjects<- read_lines("ACB_03272019_05102019_100EK113_subjects.txt")
View(subjects)
head(subjects)

#subjects <- str_replace(subjects, pattern = "//", "\\1")

#vec  <- rep(expression("/"), 23)

                        
                        