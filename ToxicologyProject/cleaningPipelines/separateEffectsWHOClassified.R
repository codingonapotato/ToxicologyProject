library(tidyverse)
path <- "./ToxicologyProject/data/completed/whoClassifiedData.csv"
# More modular defining path as a variable
data <- read.csv(path) %>%
    as.tibble() # for readability (personal opinion)

effects_data <- data %>%
    filter(effect != "NULL")
    # Doesn't work well with the separate function with NULL

semicolon_delim_data <- data %>%
    separate(effect, into = c("Effects_1", "Effects_2", "Effects_3"), sep = ";")
    # Determine number of columns to use by grouping by column and doing summary
    # table (see below in "test_data" for workflow)
print(semicolon_delim_data)

destination <- "./ToxicologyProject/data/semicolon_effects_who.csv"
write.csv(semicolon_delim_data, destination, row.names = FALSE)

## Doing summary analysis for whatever file I write there watch me use
## single point of control with my path variables ;)
test_data <- read.csv(destination) %>%
    # Notice how I use the destination variable
    as.tibble() %>%
    group_by(Effects_3) %>%
    summarize(count = n())
print(test_data) # This confirms that Effects_3 is necessary

## Summary of the effects in each column:
summary_effects_1 <- read.csv(destination) %>%
    as.tibble() %>%
    group_by(Effects_1) %>%
    summarize(effects_1_overview = n())
print(summary_effects_1)

summary_effects_2 <- read.csv(destination) %>%
    as.tibble() %>%
    group_by(Effects_2) %>%
    summarize(effects_2_overview = n())
print(summary_effects_2)

summary_effects_3 <- read.csv(destination) %>%
    as.tibble() %>%
    group_by(Effects_3) %>%
    summarize(effects_3_overview = n())
print(summary_effects_3)