library("tidyverse")
library("ggplot2")
library("infer")
library("repr")
url <- "https://gender-pay-gap.service.gov.uk/viewing/download-data/2022"

data <- read_csv("data/gender_gap_data.csv", show_col_types = FALSE)

data_names <- names(data)

no_NA <- data %>%
    drop_na()

data_sub <- no_NA %>%
    select(EmployerName, MaleTopQuartile, FemaleTopQuartile) %>%
    head(10)
# print(data_sub)

options(repr.plot.width = 10, repr.plot.height = 23)
options(vsc.use.httpgd = TRUE)
data_viz <- data_sub %>%
    ggplot(aes(x = reorder(EmployerName, MaleTopQuartile), y = MaleTopQuartile)) +
    coord_flip() +
    geom_bar(stat = "identity") +
    # geom_text(aes(label = EmployerName), vjust = 1.5, colour = "white", size = 3.5) +
    labs(y = "Company", x = "Top Quartile Male Salaries (in USD)") +
    ggtitle("Top Quartile Male Salaries of Companies (in USD)")
    print(data_viz)
