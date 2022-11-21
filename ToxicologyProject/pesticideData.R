library(tidyverse)
library(readxl)
library(xlsx)
library(purrr)
library(ggpubr)

annualData <- read.csv("./data/Top_Pesticide_Use_Annual.csv")
uniqueCompounds <- read.csv("./data/UniqueCompounds.csv")
collected <- read_excel("./data/NIH_Toxicology.xlsx")
# full_data <- read.csv("ToxicologyProject/data/Pesticidedata_Full.csv")

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
    mutate("Proportion_of_Total_Use" = Rat_Oral_LD50 / sum(AnnualUseKG)) %>%
    arrange(Rat_Oral_LD50)

print(pesticideClasses)


pesticideBarGraph <- pesticideClasses %>%
                        ggplot(aes(x = AnnualUseKG, y = reorder(Compound, AnnualUseKG), fill = WHOHazardClass)) +
                        geom_bar(stat = "identity") +
                        labs(x = "Annual Use (KG)", y = "Pesticide", fill = "WHO Hazard Class") +
                        theme(text = element_text(size = 20)) +
                        ggtitle("Annual Pesticide Usage (Kg) in Descending Order by WHO Hazard Class")
print(pesticideBarGraph)

pesticideBarGraphClassII <- pesticideClasses %>%
                        filter(WHOHazardClass == "II") %>%
                        ggplot(aes(x = AnnualUseKG, y = reorder(Compound, AnnualUseKG), fill = Compound)) +
                        geom_bar(stat = "identity") +
                        labs(x = "Annual Use (KG)", y = "Pesticide", fill = "Compound") +
                        theme(text = element_text(size = 20))
                        
# print(pesticideBarGraphClassII)

pesticideBarGraphClassIII <- pesticideClasses %>%
                        filter(WHOHazardClass == "III") %>%
                        ggplot(aes(x = AnnualUseKG, y = reorder(Compound, AnnualUseKG), fill = Compound)) +
                        geom_bar(stat = "identity") +
                        labs(x = "Annual Use (KG)", y = "", fill = "Compound") +
                        theme(text = element_text(size = 20))
                        
# print(pesticideBarGraphClassIII)

BothClass <- ggarrange(pesticideBarGraphClassII, pesticideBarGraphClassIII, ncol = 2, nrow = 1, legend = "bottom") %>%
    annotate_figure(top = text_grob("Annual Pesticide Usage (Kg) in Descending Order for WHO Hazard Class II and III (U-omitted)", color = 'red', face = "bold", size = 20))

proportion_bar <- pesticideClasses %>%
    group_by(WHOHazardClass) %>%
    ggplot(aes(y = AnnualUseKG, x = WHOHazardClass, fill = Compound)) +
    geom_bar(position = "stack", stat = "identity") +
    facet_grid(~ WHOHazardClass, scale = "free") +
    theme(text = element_text(size = 30)) +
    ggtitle("Average Relative Proportion of Pesticide Compound Used By WHO Hazard Class")

# print(proportion_bar)

# ggsave("Proportion_Bar.jpeg", 
#         plot = proportion_bar,
#         device = "jpeg",
#         width = 20,
#         height = 18,
#         path = "./")

ggsave("PesticideClassGraph.jpeg", 
        plot = pesticideBarGraph,
        device = "jpeg",
        width = 20,
        height = 18,
        path = "./")

# Can write this to file for quicker/easier access
# full_2017 <- full_data %>%
#     filter(YEAR == 2017) %>%
#     group_by(COMPOUND) %>%
#     summarize("Average_High_KG" = mean(EPEST_HIGH_KG)) %>%
#     arrange(desc(Average_High_KG)) %>%
#     head(20)
# print(full_2017)

## TO DO:

## Excel: Pesticide name, Data, Species, Link to paper/Pseudo-citation
## Web-scraping for the all pesticides possible(?)
## Figure out share of annual pesticide use as percentage of the whole 
## Set arbitrary threshold