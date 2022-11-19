library(tidyverse)
library(readxl)

annualData <- read.csv("ToxicologyProject/data/Top_Pesticide_Use_Annual.csv")
uniqueCompounds <- read.csv("ToxicologyProject/data/UniqueCompounds.csv")
collected <- read_excel("ToxicologyProject/data/Toxicology.xlsx")

# Convert to excel to tibble
collected_tibble <- as_tibble(collected)

data2015 <- annualData %>%
    filter(YEAR == 2017)

## EFFECTS: returns a vector of equal size containing the WHO_Classification for a consumed vector
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

ld50 <- collected_tibble %>%
        select("Rat_Oral_LD50(mg/kg)") 
print(ld50)


# WHO_classification <- c("III", "III", "III", NA, "III", "II", "III", NA, "II", NA)

# pesticideClasses <- data2015 %>%
#     bind_cols(WHO_classification) %>%
#     rename("WHOHazardClass" = ...4) %>%
#     mutate("WHOHazardClass" = as.factor(WHOHazardClass))

# print(pesticideClasses)


# pesticideBarGraph <- pesticideClasses %>%
#                         ggplot(aes(x = AnnualUseKG, y = reorder(COMPOUND, AnnualUseKG), fill = WHOHazardClass)) +
#                         geom_bar(stat = "identity") +
#                         labs(x = "Annual Use (KG)", y = "Pesticide", fill = "Hazard Class") +
#                         ggtitle("Pesticide Hazard Classification with Sorted in Descending Order of Annual Use (Kg)") +
#                         theme(text = element_text(size = 20))
                        
# print(pesticideBarGraph)

# ggsave("PesticideClassGraph.jpeg", 
#         plot = pesticideBarGraph,
#         device = "jpeg",
#         width = 50,
#         height = 10,
#         path = "./")


## TO DO:

## Excel: Pesticide name, Data, Species, Link to paper/Pseudo-citation
## Web-scraping for the all pesticides possible(?)
## Figure out share of annual pesticide use as percentage of the whole 
## Set arbitrary threshold 