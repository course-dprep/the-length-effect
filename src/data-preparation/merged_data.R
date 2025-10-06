library(tidyverse)

# Read filtered csv
title.basics_clean <- readRDS('../../gen/temp/title.basics_clean.csv')
title.ratings_clean <- readRDS('../../gen/temp/title.basics_clean.csv')

# Merging the two datasets
merged_data <- title.basics_clean %>%
  select(tconst, runtime_minutes, start_year, title) %>%
  mutate(
    runtime_minutes = suppressWarnings(as.numeric(runtime_minutes)),
    start_year      = suppressWarnings(as.integer(start_year)),
    title = suppressWarnings(as.character(title))
  ) %>%
  
  inner_join(
    title.ratings_clean %>% select(tconst, average_rating, votes),
    by = "tconst"
  ) %>%
  mutate(
    average_rating = as.numeric(average_rating), 
    votes= as.integer(votes)
  ) 

merged_data <- merged_data %>%
  
  filter(runtime_minutes > 0,
         runtime_minutes <= 300) %>%
  filter(start_year <= 2025) 

descriptives <- tibble(
  Variable = c("runtime_minutes","average_rating","start_year"),
  N        = c(sum(!is.na(merged_data$runtime_minutes)),
               sum(!is.na(merged_data$average_rating)),
               sum(!is.na(merged_data$start_year))),
  Missing  = c(sum(is.na(merged_data$runtime_minutes)),
               sum(is.na(merged_data$average_rating)),
               sum(is.na(merged_data$start_year))),
  Mean     = c(mean(merged_data$runtime_minutes, na.rm = TRUE),
               mean(merged_data$average_rating,  na.rm = TRUE),
               mean(merged_data$start_year,      na.rm = TRUE)),
  SD       = c(sd(merged_data$runtime_minutes, na.rm = TRUE),
               sd(merged_data$average_rating,  na.rm = TRUE),
               sd(merged_data$start_year,      na.rm = TRUE)),
  Min      = c(min(merged_data$runtime_minutes, na.rm = TRUE),
               min(merged_data$average_rating,  na.rm = TRUE),
               min(merged_data$start_year,      na.rm = TRUE)),
  Max      = c(max(merged_data$runtime_minutes, na.rm = TRUE),
               max(merged_data$average_rating,  na.rm = TRUE),
               max(merged_data$start_year,      na.rm = TRUE)))
descriptives %>%
  gt() %>%
  tab_header(title = "Table 2. Descriptive Statistics") %>%
  tab_options(column_labels.font.weight="bold")

# Save the dataset
write_csv(merged_data, file = "../../gen/temp/merged_data.csv")