library(data.table)
library(dplyr)
library(checkmate)
library(ggplot2)  
library(gt)        
library(tibble)   
library(knitr)     
library(kableExtra)
title.basics <- readRDS("data/raw/title_basics.rds")
title.ratings <- readRDS("data/raw/title_ratings.rds")
title.basics_clean  <- readRDS("data/explore/title_basics_clean.rds")
title.ratings_clean <- readRDS("data/explore/title_ratings_clean.rds")

# Filter for movies only 
title.basics_clean <- title.basics %>%
  filter(titleType == "movie") %>%               
  select(tconst, primaryTitle, startYear, runtimeMinutes) %>%
  distinct(tconst, .keep_all = TRUE)

# Renaming
title.basics_clean <- title.basics_clean %>%
  rename(
    title           = primaryTitle,
    start_year      = startYear,
    runtime_minutes = runtimeMinutes)

title.ratings_clean <- title.ratings_clean %>%
  rename(
    average_rating  = averageRating,
    votes           = numVotes
  )

# Set filter data and movie duration 
title.basics_clean <- title.basics_clean %>%
  
  filter(runtime_minutes > 0,
         runtime_minutes <= 300) %>%
    filter(start_year <= 2025) 

# Merging datasets
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

# Checking the duplicated data
keys <- c("title", "start_year", "runtime_minutes")

movies_dup <- merged_data %>% as_tibble()

sum( duplicated(select(movies_dup, all_of(keys))) )

dups_rows <- movies_dup %>%
  mutate(.is_dup = duplicated(select(., all_of(keys))) |
           duplicated(select(., all_of(keys)), fromLast = TRUE)) %>%
  filter(.is_dup) %>%
  select(-.is_dup)

dup_groups <- movies_dup %>%
  count(across(all_of(keys)), sort = TRUE) %>%
  filter(n > 1)

dups_rows %>% slice_head(n = 80)
dup_groups %>% slice_head(n = 40)

# Dropping duplicated data
movies_final_clean <- movies_dup %>%  
  group_by(across(all_of(keys))) %>%
  slice_max(votes, with_ties = FALSE) %>%   
  ungroup()

# How many rows were removed?
dropped <- nrow(movies_dup) - nrow(movies_final_clean)
dropped

# Sanity check: no duplicates remain
stopifnot(!any(duplicated(select(movies_final_clean, all_of(keys)))))

# Handling missing data
movies_final_no_na <- movies_final_clean %>%
  filter(!is.na(runtime_minutes),
         !is.na(average_rating),
         !is.na(start_year),
         !is.na(title))

# drop NA in those columns 
movies_final_no_na <- tidyr::drop_na(movies_final_clean, runtime_minutes, average_rating, start_year, title)
# or
movies_final_no_na <- movies_final_clean %>%
  filter(!if_any(c(runtime_minutes, average_rating, start_year, title), is.na))

n_removed <- nrow(movies_final_clean) - nrow(movies_final_no_na)
n_removed

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
saveRDS(movies_final_clean, "data/processed/movies_prepared.rds")
