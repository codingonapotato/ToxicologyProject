library(tidyverse)
library(repr)
# Loaded libraries

annualData <- read.csv("./data/Top_Pesticide_Use_Annual.csv")

data2015 <- annualData %>%
    filter(YEAR == 2017)

WHO_classification <- c("III", "III", "III", NA, "III", "II", "III", NA, "II", NA)
# Data attribution: The WHO Recommended Classification of Pesticides by Hazard
# and Guides to Classification 2019
# For data I could not find, I used NA values as placeholders

## TODO: ASK IF I SHOULD TRY AND LOOK AT ONLINE DATABASES LIKE ECOTOX TO TRY
## AND CLASSIFY USING WHO GUIDELINES USING ORAL LD50 DATA

## TODO2: PETROLEUM IS A PESTICIDE?

## TODO3: HOW TO AGGREGATE DATA IF MODEL ORGANISMS NOT-STANDARDIZED?
## Citation manager to keep track of all the sources if need to aggregate multiple sources?

pesticideClasses <- data2015 %>%
    bind_cols(WHO_classification) %>%
    rename("WHOHazardClass" = ...4) %>%
    mutate("WHOHazardClass" = as.factor(WHOHazardClass))

print(pesticideClasses)

options(repr.plot.width = 20, repr.plot.height = 10)
pesticideBarGraph <- pesticideClasses %>%
                        ggplot(aes(x = AnnualUseKG, y = reorder(COMPOUND, AnnualUseKG), fill = WHOHazardClass)) +
                        geom_bar(stat = "identity") +
                        labs(x = "Annual Use (KG)", y = "Pesticide", fill = "Hazard Class") +
                        ggtitle("Pesticide Hazard Classification with Sorted in Descending Order of Annual Use (Kg)") 

ggsave("PesticideClassGraph.jpeg", 
        plot = pesticideBarGraph,
        device = "jpeg",
        width = 10,
        height = 10,
        path = "./")

## TODO4: ASK ABOUT HOW TO CHANGE PLOT SCALE AND STUFF ON VSCODE