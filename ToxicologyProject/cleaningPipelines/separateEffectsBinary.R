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

dest <- "ToxicologyProject/data/testReference.csv"
write.csv(pivotted_data, dest, row.names = FALSE)

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
    mutate(Values = str_trim(Values)) %>% # Call to str_trim here to
    as_vector()                           # remove whitespace flanking string

binary_rowname_vector <- binary_rowname_vector[binary_rowname_vector != "NULL"]
# print(binary_rowname_vector)

## Simple tests for membership
# print("BEHAVIORAL: SOMNOLENCE (GENERAL DEPRESSED ACTIVITY)" %in% binary_rowname_vector)
# print("NULL" %in% binary_rowname_vector)

# Creating binary effects data
toBinaryData <- function(arg) {
    resultVector <- c() # R is pass-by-value which makes this more difficult
    for (s in arg) {
        s <- str_trim(s)
        if (s %in% binary_rowname_vector) {
            resultVector <- append(resultVector, 1)
        } else if (s == "NULL" || is.na(s) || s == "NA") {
            resultVector <- append(resultVector, 0)
        } else {
            resultVector <- append(resultVector, -1) # Just for some semantic error handling just in case
        }
    }
    return (resultVector)
}
# Simple test case to verify that the function works
simpleTest <- c("NULL", NA, "NA", "simpleTest", "dummyData", "BEHAVIORAL: MUSCLE WEAKNESS")
output <- c()
for (s in simpleTest) {
    s <- str_trim(s)
    cat(s, "\n")
    if (s %in% binary_rowname_vector) {
        output <- append(output, toBinaryData(s))
    }
}
# print(output) # Note that there is 1 element and it's a 1 which confirms that test passed

# Making binary dataframe:
for (col in names(pivotted_data_cols_clean[10:ncol(pivotted_data_cols_clean)])) {
    resultVector <- toBinaryData(pivotted_data_cols_clean[[col]])
    pivotted_data_cols_clean[[col]] <- resultVector
}
print(ncol(pivotted_data_cols_clean))
# Writing to file
# dest <- "ToxicologyProject/data/test.csv"
# write.csv(pivotted_data_cols_clean, dest, row.names = FALSE)
