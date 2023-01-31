library(tidyverse)

path <- "ToxicologyProject/data/aggregateAquaticIntermediate.csv"
data <- read.csv(path) %>% as_tibble()

##  Separating relevant Endpoints by Regex patterns
mortalityDF <- data %>%
    filter(str_detect(Endpoint, pattern = "(L[CD].)|E[CD]."))
print(mortalityDF)

## When data-scraping, the automation script needed to be restarted manually
## a few times. As a result, some of the CSV's may have been duplicates. Hence,
## This pipeline here *should remove duplicates. From my Google search,
## it appears that unique() considers duplicates to be 2 observations with
## EXACTLY the same data. Hence, the usage here appears to be safe but
## just to be safe, I felt a more detailed documentation was required for
## future review/reference.
withoutDuplicates <- unique(mortalityDF)
# print(withoutDuplicates)

##  Preview categories of units available to determine possible unit conversions
## and the best unit to subset for largest dataframe
glimpseOfUnits <- withoutDuplicates %>%
    select(Conc.1.Units..Standardized.) %>%
    group_by(Conc.1.Units..Standardized.) %>%
    summarize(count_by_grp = n())
# print(glimpseOfUnits, n = 28)

## Assumption: Treating AI mg/L and mg/L the same
## Extracts units of AI mg/L and mg/L
mg_per_L_DF <- withoutDuplicates %>%
    filter(str_detect(Conc.1.Units..Standardized.,
    pattern = "(AI mg/L)|(mg/L)")) %>%
    filter(Conc.1.Units..Standardized. != "ae mg/L")
    # Not entirely sure what "ae" means. Removing just in case
# print(mg_per_L_DF)

write.csv(mg_per_L_DF,  file = "ToxicologyProject/data/mg_per_L_aquaticDataframe.csv",
row.names = FALSE)
