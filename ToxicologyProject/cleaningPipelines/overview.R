library(tidyverse)
library(ggplot2)

## Loading source files:
who_path <- "./data/completed/whoClassifiedData.csv"
aquatic_path <- "./data/completed/mg_per_L_aquaticDataframe.csv" # nolint
who_df <- read.csv(who_path) %>%
    as.tibble()
# print(who_df) # nolint
aquatic_df <- read.csv(aquatic_path) %>%
    as_tibble()

## Calculating who dataframe basic statistics:
# In-place operation to coerce type of dose_mg_per_kg to appropriate type for analysis # nolint
who_df <- who_df %>%
    mutate(dose_mg_per_kg = as.numeric(dose_mg_per_kg)) %>%
    select(dose_mg_per_kg)
who_dose_sorted <- sort(who_df$dose_mg_per_kg)

who_df_mean <- mean(who_df$dose_mg_per_kg)

who_df_var <- var(who_df$dose_mg_per_kg)

who_df_IQR <- IQR(who_df$dose_mg_per_kg) #nolint

who_df_sd <- sd(who_df$dose_mg_per_kg)

who_df_quantile <- quantile(who_df$dose_mg_per_kg, prob = c(.25, .5, .75)) %>%
    as_tibble() %>%
    mutate(names = c("Q1", "Q2", "Q3")) %>%
    pivot_wider(names_from = names,
    values_from = value)

who_df_median <- median(who_dose_sorted)
# (...) after computing all the statistics
who_stats <- data.frame(Mean = who_df_mean,
    Median = who_df_median,
    Variance = who_df_var,
    Standard_Deviation = who_df_sd,
    IQR = who_df_IQR) %>%
    bind_cols(who_df_quantile) %>%
    as_tibble()
print(who_stats)

## Calculating aquatic dataframe mean:
# Coercing to numeric for further computations
aquatic_df <- aquatic_df %>%
    group_by(Conc.1.Units..Standardized.) %>% #nolint
    mutate(Conc.1.Mean..Standardized. = as.numeric(Conc.1.Mean..Standardized.)) %>% #nolint
    filter(!is.na(Conc.1.Mean..Standardized.)) %>%
    mutate(Conc.1.Mean..Standardized. = sort(Conc.1.Mean..Standardized.)) %>%
    as.tibble()

aquatic_df_mean <- aquatic_df %>%
    group_by(Conc.1.Units..Standardized.) %>%
    summarize(Mean = mean(Conc.1.Mean..Standardized.))

aquatic_df_median <- aquatic_df %>%
    group_by(Conc.1.Units..Standardized.) %>%
    summarize(Median = median(Conc.1.Mean..Standardized.)) %>%
    select(-Conc.1.Units..Standardized.)

aquatic_df_var <- aquatic_df %>%
    group_by(Conc.1.Units..Standardized.) %>%
    summarize(Variance = var(Conc.1.Mean..Standardized.)) %>%
    select(-Conc.1.Units..Standardized.)

aquatic_df_IQR <- aquatic_df %>% #nolint
    group_by(Conc.1.Units..Standardized.) %>%
    summarize(IQR = IQR(Conc.1.Mean..Standardized.)) %>%
    select(-Conc.1.Units..Standardized.)

aquatic_df_sd <- aquatic_df %>% #nolint
    group_by(Conc.1.Units..Standardized.) %>%
    summarize(Standard_Deviation = sd(Conc.1.Mean..Standardized.)) %>%
    select(-Conc.1.Units..Standardized.)

aquatic_df_AI <- aquatic_df %>% #nolint
    filter(Conc.1.Units..Standardized. == "AI mg/L")
aquatic_df_mg <- aquatic_df %>%
    filter(Conc.1.Units..Standardized. == "mg/L")

aquatic_df_AI_quantile <- quantile(aquatic_df_AI$Conc.1.Mean..Standardized., prob = c(.25, .5, .75)) #nolint
aquatic_df_mg_quantile <- quantile(aquatic_df_mg$Conc.1.Mean..Standardized., prob = c(.25, .5, .75)) #nolint
aquatic_quantile <- bind_rows(aquatic_df_AI_quantile, aquatic_df_mg_quantile)
# (...) after computing all the statistics
aquatic_stats <- bind_cols(aquatic_df_mean,
    aquatic_df_median,
    aquatic_df_var,
    aquatic_df_sd,
    aquatic_df_IQR,
    aquatic_quantile)
print(aquatic_stats)

dest_path <- "./visualizations/2023_03_22"
## Now time for some scatter plot visualization
who_histogram <- ggplot(who_df, aes(x = dose_mg_per_kg)) +
    geom_histogram(aes(y=..density..)) +
    geom_density(alpha = .3, fill = "#FF6666") +
    labs(x = "Dose (mg/kg)", y = "Enumeration") +
    ggtitle("Distribution of Data Points in WHO Classified Dataframe") + 
    theme(text = element_text(size = 15))

aquatic_histogram <- ggplot(aquatic_df, aes(x = Conc.1.Mean..Standardized.)) +
    geom_histogram(aes(y = ..density..)) +
    geom_density(alpha = .3, fill = "#3c9cbc") +
    labs(x = "Dose (mg/kg)", y = "Enumeration") + 
    ggtitle("Distribution of Data Points in Aquatic Dataframe") + 
    theme(text = element_text(size = 15))

who_boxplot <- ggplot(who_df, aes(x = factor(0), y = dose_mg_per_kg)) +
    geom_boxplot() +
    labs(y = "Dose (mg/kg)", x = "") +
    ggtitle("WHO Dataframe Dose (mg/kg) Boxplot (Outliers Included)") +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 15))

who_lower_bound <- as.numeric(who_df_quantile[1] - 1.5 * who_df_IQR)
who_upper_bound <- as.numeric(who_df_quantile[3] + 1.5 * who_df_IQR)

who_df_outlier_free <- subset(who_df, who_df$dose_mg_per_kg > who_lower_bound & who_df$dose_mg_per_kg < who_upper_bound) #nolint

who_boxplot_outlier_free <- ggplot(who_df_outlier_free, aes(x = factor(0), y = dose_mg_per_kg)) + #nolint
    geom_boxplot() +
    labs(y = "Dose (mg/kg)", x = "") +
    ggtitle("WHO Dataframe Dose (mg/kg) Boxplot (Outliers Removed)") +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 15))

aquatic_boxplot <- ggplot(aquatic_df, aes(x = Conc.1.Units..Standardized., y=Conc.1.Mean..Standardized.)) + #nolint
    geom_boxplot() +
    labs(y = "Dose Mean", x = "Dose Type") +
    ggtitle("Aquatic Dataframe Dose Concentration Mean Boxplot (Outliers Included)") + #nolint
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 15))

aquatic_AI_lower_bound <- as.numeric(aquatic_df_AI_quantile[1] - 1.5 * who_df_IQR) #nolint
aquatic_AI_upper_bound <- as.numeric(aquatic_df_AI_quantile[1] + 1.5 * who_df_IQR) #nolint
aquatic_mg_lower_bound <- as.numeric(aquatic_df_mg_quantile[1] - 1.5 * who_df_IQR) #nolint
aquatic_mg_upper_bound <- as.numeric(aquatic_df_mg_quantile[1] + 1.5 * who_df_IQR) #nolint

aquatic_AI_outlier_free <- filter(aquatic_df, Conc.1.Units..Standardized. == "AI mg/L" #nolint
    & Conc.1.Mean..Standardized. > aquatic_AI_lower_bound #nolint
    & Conc.1.Mean..Standardized. < aquatic_AI_upper_bound) #nolint

aquatic_mg_outlier_free <- filter(aquatic_df, Conc.1.Units..Standardized. == "mg/L" #nolint
    & Conc.1.Mean..Standardized. > aquatic_mg_lower_bound #nolint
    & Conc.1.Mean..Standardized. < aquatic_mg_upper_bound) #nolint

aquatic_AI_boxplot_outlier_free <- ggplot(aquatic_AI_outlier_free, aes(x = Conc.1.Units..Standardized., y=Conc.1.Mean..Standardized.)) + #nolint
    geom_boxplot() +
    labs(y = "Dose Mean", x = "Dose Type") +
    ggtitle("Aquatic Dataframe Dose Concentration Mean Boxplot(Outliers Excluded)") + #nolint
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 15))

aquatic_mg_boxplot_outlier_free <- ggplot(aquatic_mg_outlier_free, aes(x = Conc.1.Units..Standardized., y=Conc.1.Mean..Standardized.)) + #nolint
    geom_boxplot() +
    labs(y = "Dose Mean", x = "Dose Type") +
    ggtitle("Aquatic Dataframe Dose Concentration Mean Boxplot (Outliers Excluded)") + #nolint
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 15))

# ggsave("WHO histogram.png", who_histogram, path = dest_path)
# ggsave("Aquatic histogram.png", aquatic_histogram, path = dest_path)
# ggsave("WHO boxplot (outliers).png", who_boxplot, path = dest_path)
# ggsave("WHO boxplot (outliers removed).png", who_boxplot_outlier_free, path = dest_path) #nolint
# ggsave("Aquatic boxplot (outliers).png", aquatic_boxplot, path = dest_path)
# ggsave("Aquatic AI boxplot (outliers removed).png", aquatic_AI_boxplot_outlier_free, path = dest_path) #nolint
# ggsave("Aquatic mg boxplot (outliers removed).png", aquatic_mg_boxplot_outlier_free, path = dest_path) #nolint