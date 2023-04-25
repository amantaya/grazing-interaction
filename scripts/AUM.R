# clear the enviroment
rm(list=ls(all=TRUE))

# 1 Animal Unit (AU) is based on 1000 pound cow or 1 cow with calf

# Most ruminants eat 1-3% (2% avg) of their body weight each day

# Horses eat about 5% of their body weight each day

# Animal Unit Equivalents

cow_aue <- 1 # 1000 lbs

sheep_aue <- (1/6) # 150 lbs

goat_aue <- (1/10) # 100 lbs

horse_aue <- 1.8 # 1200 lbs

elk_aue <- 0.7 # 700 lbs

# Animal Unit Months (AUMs)

# number of months
n_months <- 1

# number of cows
n_cows <- 1

# number of sheep
n_sheep <- 1

# number of goats
n_goats <- 1

# number of horses
n_horses <- 1

# number of elk
n_elk <- 2

# AUMs
cow_aum <- n_months * (n_cows*cow_aue)

sheep_aum <- n_months * (n_sheep*sheep_aue)

goat_aum <- n_months * (n_goats*goat_aue)

horse_aum <- n_months * (n_horses*horse_aue)

elk_aum <- n_months * (n_elk*elk_aue)

aum <- c(cow_aum, sheep_aum, goat_aum, horse_aum, elk_aum)

barplot(aum)
