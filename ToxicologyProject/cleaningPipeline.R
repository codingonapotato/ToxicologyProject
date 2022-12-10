library(tidyverse)
library(readxl)
library(xlsx)
library(purrr)

full_data <- read.csv("ToxicologyProject/data/Pesticidedata_Full.csv")

full_2017 <- full_data %>%
    filter(YEAR == 2017) %>%
    group_by(COMPOUND) %>%
    summarize("AVG_EPEST_HIGH_KG" = mean(EPEST_HIGH_KG)) %>%
    write.csv(file = "ToxicologyProject/data/2017_AVG_EPEST_HIGH", 
    row.names = FALSE)

data_2017 <- read.csv("ToxicologyProject/data/2017_AVG_EPEST_HIGH")

print(data_2017)