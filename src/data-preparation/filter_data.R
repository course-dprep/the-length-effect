library(tidyverse)

title.basics <- readRDS("../../data/raw/title_basics.rds")
title.ratings <- readRDS("../../data/raw/title_ratings.rds")


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

# Generate new csv file filtered on movies
write_csv(title.basics_clean, '../../gen/temp/title.basics_clean.csv')
write_csv(title.raitings_clean, '../../gen/temp/title.raitings_clean.csv')
