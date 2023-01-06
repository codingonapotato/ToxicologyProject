library(tidyverse)
library(readxl)
library(xlsx)
library(purrr)
library(mefa4)

path <- "ToxicologyProject/data/RawAggregatedToxicologyData.csv"

data <- read_csv(path) %>%
    as_tibble() %>%
    filter(organism != "organism") %>%
    filter(str_detect(dose, pattern = "[0-9]+.")) %>%
    mutate(dose = str_extract(dose, pattern = "[0-9]+.*")) %>%
    mutate(dose = str_extract(dose, pattern = "[0-9]+.*/.*")) %>%
    filter(str_detect(dose, pattern = "(mg/kg)|(gm/kg)|(ug/kg[^/])|
    (gm/kg[^/])|(mg/kg[^/])"))
print(select(data, dose))

gramToMGData <- data %>%
    filter(str_detect(dose, pattern = "(gm/kg)")) %>%
    mutate(dose = str_extract(dose, pattern="[0-9]+")) %>%
    mutate(dose = as.double(dose)*1000) %>% # Conversion factor from g to mg 
    mutate(dose = paste(dose,"mg/kg"))

data <- data %>%
    filter(str_detect(dose, pattern = "(gm/kg)", 
    negate = TRUE)) %>% # remove outdated rows
    rows_insert(gramToMGData, conflict="ignore")
print(select(data,dose))
print(summarize(data, number_of_observations = n()))
print(summarize(gramToMGData, number_of_observations_g = n()))
