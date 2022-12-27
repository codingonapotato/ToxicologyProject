library(tidyverse)
library(readxl)
library(xlsx)
library(purrr)
library(mefa4)

path <- "ToxicologyProject/data/RawAggregatedToxicologyData.csv"
data <- read_csv(path) %>%
    as_tibble() %>%
    filter(organism != "organism") %>%
    filter(str_detect(dose, pattern = "mg/kg")) %>%
    mutate(dose = str_extract(dose, pattern = "[0-9]+")) %>%
    rename("dose_mg_per_kg"= dose) %>%
    select(-"...9") %>%
    mutate(dose_mg_per_kg = as.numeric(dose_mg_per_kg)) 
print(data)

# This csv is missing anything that isn't natively in units of 
# mg/kg at the moment
write.csv(data, file = "ToxicologyProject/data/CleanAggregatedToxData.csv",
    row.names = FALSE)