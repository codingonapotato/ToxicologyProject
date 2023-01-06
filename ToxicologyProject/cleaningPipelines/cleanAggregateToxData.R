library(tidyverse)
library(readxl)
library(xlsx)
library(purrr)

path <- "data/RawAggregatedToxicologyData.csv"

# Effects: Used to filter for data that is either in mg/kg, gm/kg,
# or ug/kg since those are convertable to each other
data <- read_csv(path) %>%
    as_tibble() %>%
    filter(organism != "organism") %>%
    filter(str_detect(dose, pattern = "[0-9]+.")) %>%
    mutate(dose = str_extract(dose, pattern = "[0-9]+.*")) %>%
    mutate(dose = str_extract(dose, pattern = "[0-9]+.*/.*")) %>%
    filter(str_detect(dose, pattern = "(mg/kg)|(gm/kg)|(ug/kg[^/])|
    (gm/kg[^/])|(mg/kg[^/])"))

# Effects: Used to filter the data specifically for data in units of "gm/kg"
# so that they can be pivoted into mg/kg
gramToMGData <- data %>%
    filter(str_detect(dose, pattern = "(gm/kg)")) %>%
    mutate(dose = str_extract(dose, pattern="[0-9]+")) %>%
    mutate(dose = as.double(dose)*1000) %>% # Conversion factor from g to mg
    mutate(dose = paste(dose,"mg/kg"))
# Effects: Filters for all data not accepted by gramToMGData pipeline
# (to effectively create a negative) and then rows with updated data in
# gramToMgData is appended to the tail of the dataframe
data <- data %>%
    filter(str_detect(dose, pattern = "(gm/kg)", 
    negate = TRUE)) %>% # remove outdated rows
    rows_insert(gramToMGData, conflict="ignore")

print(select(data,dose))
print(summarize(data, number_of_observations = n()))
print(summarize(gramToMGData, number_of_observations_g = n()))

# Effects: Takes the dataframe that only has data in mg/kg
# and extracts a string with only the numerical digits,
# updates the type of the column to double and updates with descriptive title  
cleanData <- data %>%
    mutate(dose = as.double(str_extract(dose, pattern="[0-9]+"))) %>%
    rename(dose_mg_per_kg = dose) %>%
    select(-"...9")

# Effects: Writes the cleanData to file
write.csv(cleanData, file = "data/cleanAggregatedToxicologyData.csv", 
row.names = FALSE)
