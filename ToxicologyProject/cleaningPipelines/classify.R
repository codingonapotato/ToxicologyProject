library(tidyverse)

## REQUIRES: input is a toxicity value who's value is numerical
## EFFECTS: returns the WHO class based on a toxicity value. Else, return NA
## NA if the element == NA
ld50_to_who_class <- function(tox) {
    if (tox > 5000) {
        a <- "U"
    } else if (tox > 2000) {
       a <- "III"
    } else if (tox >= 50) {
       a <- "II"
    } else if (tox >= 5) {
       a <- "Ib"
    } else if (tox < 5) {
        a <- "Ia"
    } else {
        a <- NA
    }
    a
}

path <- "ToxicologyProject/data/categorizedNoGram.csv"
data <- read.csv(path) %>% as_tibble() %>% select(-X)

## Just moved the unit mg/kg to the column header so I can treat the dose 
## as a numeric 
dose_vector <- data %>%
    mutate("dose_mg_kg" = str_extract(dose, pattern = "[0-9]+")) %>%
    mutate("dose_mg_kg" = as.numeric(dose_mg_kg)) %>%
    select(dose_mg_kg) %>%
    as_vector()

## To generate WHO classifier vector in lock-step
who_hazard_class <- c()
for (d in dose_vector) {
    result <- ld50_to_who_class(d)
    who_hazard_class <- append(who_hazard_class, result) # Preserves order
}
# print(who_hazard_class)

## To combine back to dataframe:
who_classified_data <- data %>% cbind(who_hazard_class) %>%
    as_tibble()
print(who_classified_data)

write.csv(who_classified_data,
file = "ToxicologyProject/data/completed/whoClassifiedData.csv",
row.names = FALSE)