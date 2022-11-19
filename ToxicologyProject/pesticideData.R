library(tidyverse)
library(readxl)
library(purrr)

annualData <- read.csv("ToxicologyProject/data/Top_Pesticide_Use_Annual.csv")
uniqueCompounds <- read.csv("ToxicologyProject/data/UniqueCompounds.csv")
collected <- read_excel("ToxicologyProject/data/NIH_Toxicology.xlsx")

# Convert to excel to tibble
collected_tibble <- as_tibble(collected)
# print(collected_tibble)

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

ld50 <- collected_tibble %>%
        pull("Rat_Oral_LD50(mg/kg)") 

WHO_automated <- new_vector <- c()    
for (e in ld50) {
    WHO_automated <- c(WHO_automated, ld50_to_who_class(e))
}


pesticideClasses <- collected_tibble %>%
    bind_cols(WHO_automated) %>%
    rename("WHOHazardClass" = ...5) %>%
    rename("Rat_Oral_LD50" = "Rat_Oral_LD50(mg/kg)") %>%
    rename("Compound" = "Pesticide/Compound") %>%
    mutate("WHOHazardClass" = as.factor(WHOHazardClass)) %>%
    arrange(Rat_Oral_LD50)

print(pesticideClasses)


pesticideBarGraph <- pesticideClasses %>%
                        ggplot(aes(x = AnnualUseKG, y = reorder(Compound, AnnualUseKG), fill = WHOHazardClass)) +
                        geom_bar(stat = "identity") +
                        labs(x = "Annual Use (KG)", y = "Pesticide", fill = "Hazard Class") +
                        ggtitle("Pesticide Hazard Classification with Sorted in Descending Order of Annual Use (Kg)") +
                        theme(text = element_text(size = 20))
                        
print(pesticideBarGraph)

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