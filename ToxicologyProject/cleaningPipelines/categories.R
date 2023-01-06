library(tidyverse)

## Loading data
data <- read.csv("ToxicologyProject/data/NoGram.csv") %>%
    as.tibble()

## Preview dataset seeing the number of datapoints per category
summarizeByOrganism <- data %>%
    group_by(organism) %>%
    summarize(data_points = n())

## Extracting the organism column and storing in a vector to use later
organisms <- summarizeByOrganism %>%
    select(organism) %>%
    as_vector()

## Separating terrestrials into a vector
terrestrials <- organisms[!organisms %in% c("frog", "duck")]

## Separating aquatics into a vector
aquatics <- organisms[! organisms %in% terrestrials]

## Function to use when mutating the dataframe
categorizeOrganism <- function(organism) {
    if (organism %in% terrestrials) {
        category <- "Terrestrial"
        category
    } else if (organism %in% aquatics) {
        category <- "Aquatic"
        category
    } else {
        category <- "Unclassified"
        category
    }
}

## Generating a new column "category"  that is either terrestrial, aquatic, or unclassified
organismsColumn <- data %>%
    select(organism) %>%
    as_vector()

categorizedData <- c()

for (organism in organismsColumn) {
    categorizedData <- append(categorizedData, categorizeOrganism(organism))
}

categorizedDataFrame <- bind_cols(data, category=categorizedData) %>%
    select(-"...9")
print(categorizedDataFrame)

# Verifying classification
summarizedAquatic <- categorizedDataFrame %>%
    filter(category == "Aquatic") %>%
    summarize(aquatic_count = n())

summarizedTerrestrial <- categorizedDataFrame %>%
    filter(category == "Terrestrial") %>%
    summarize(terrestrial_count = n())

summarizedUnmodifiedTerrestrial <- data %>%
    filter(organism %in% terrestrials) %>%
    summarize(unmodified_terrestrial_count = n())

summarizedUnmodifiedAquatic <- data %>%
    filter(organism %in% aquatics) %>%
    summarize(unmodified_aquatic_count = n())

full_summary <-  bind_cols(summarizedAquatic,
    summarizedUnmodifiedAquatic,
    summarizedTerrestrial, 
    summarizedUnmodifiedTerrestrial)
print(full_summary)

## Writing To File:
write.csv(categorizedDataFrame, "ToxicologyProject/data/categorizedNoGram.csv")