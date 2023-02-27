## Loading libraries and necessary raw data
library(tidyverse)
library(purrr)

path <- "ToxicologyProject/data/semicolon_effects_who.csv"
data <- read.csv(path) %>%
    as_tibble()

## Wrangling raw data
# values_fn = list argument necessary since values from Effects_1 to _3
# do not have unique values
pivotted_data <- data %>%
    pivot_wider(names_from = Effects_1,
    values_from = Effects_1,
    values_fn = list) %>%
    pivot_wider(names_from = Effects_2,
    values_from = Effects_2,
    values_fn = list) %>%
    pivot_wider(names_from = Effects_3,
    values_from = Effects_3,
    values_fn = list,
    names_repair = "unique") %>%
    select(-"NULL") %>% # Since retaining NULL effects is a lil redundant innit?
    mutate_all(~as.character(.)) # tilda specifies a formula to apply while the
                                 # like a lambda function :0 but more concise
                                 # period represents a column as a parameter

# Previewing data columns to figure out how to define reg-ex. Will target '...'
# to get rid of duplicate columns
pivotted_data_cols <- pivotted_data %>%
    colnames()
# print(pivotted_data_cols)

# Strategy to deal with wack select function going to use sets B)
duplicateNames <- c()

for (name in pivotted_data_cols) {
    myCondition <- str_detect(name, "\\.{3}") 
    if (myCondition) {
        temp <- c(name)
        duplicateNames <- append(duplicateNames, temp)
    }
}

# Getting rid of duplicates using the power of set complement. For some reason
# using select_if(~any(str_detect(., fixed("...", negate =  TRUE))))
# will not work

pivotted_data_cols_clean  <- pivotted_data %>%
    as_tibble() %>%
    select(-duplicateNames)

## Checking to see what unique values there are
binary_data_precheck <- pivotted_data_cols_clean %>%
    select(-(2:9)) %>%
    pivot_longer(cols = "BEHAVIORAL: SOMNOLENCE (GENERAL DEPRESSED ACTIVITY)":" VASCULAR: SHOCK", 
    names_to = "Effects",
    values_to = "Values") %>%
    group_by(Values) %>%
    summarize(enumerated_values = n()) %>%
    arrange(desc(enumerated_values))
# print(binary_data_precheck)

## Extracting a vector to use in function to make binary dataframe by checking for membership
binary_rowname_vector <- select(binary_data_precheck, Values) %>%
    as_vector()
binary_rowname_vector <- binary_rowname_vector[binary_rowname_vector != "NULL"]
# print(binary_rowname_vector)

## Simple tests for membership
# print("BEHAVIORAL: SOMNOLENCE (GENERAL DEPRESSED ACTIVITY)" %in% binary_rowname_vector)
# print("NULL" %in% binary_rowname_vector)

# Creating binary effects data
toBinaryData <- function(arg) {
    arg <- as_vector(arg)
    binary_rowname_vector <- as_vector(binary_rowname_vector)
    for (s in arg) {
        if (s %in% binary_rowname_vector) {
            return(1)
        } else if (s == "NULL" || is.na(s) || s == "NA") {
            return(0)
        } else {
            return(-1) # Just for some semantic error handling just in case
        }
    }
}
# Simple test case to verify that the function works
simpleTest <- c("NULL", NA, "NA", "simpleTest", "dummyData")
output <- c()
for (s in simpleTest) {
    if (s %in% binary_rowname_vector) {
        output <- append(output, toBinaryData(s, "simpleTest"))
    }
}
print(output)

# Making binary dataframe:

binary_data <- pivotted_data_cols_clean %>%
    mutate(across(.cols = (10:11), toBinaryData))
print(binary_data)

# Writing to file
dest <- "ToxicologyProject/data/test.csv"
write.csv(binary_data, dest, row.names = FALSE)
