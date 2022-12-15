library(tidyverse)
library(readxl)
library(xlsx)
library(purrr)
library(mefa4)

path <- "ToxicologyProject/data/RawAggregatedToxicologyData.csv"
data <- read_csv(path) %>%
    as_tibble() %>%
    filter(organism != "organism") %>%
    mutate(dose = str_extract(dose, pattern = "[0-9]+")) %>%
    rename("dose_mg_per_kg"= dose) %>%
    mutate(dose_mg_per_kg = as.numeric(dose_mg_per_kg))
print(data)

write.csv(data, file = "ToxicologyProject/data/CleanedAggregatedToxData.csv",
    row.names = FALSE)