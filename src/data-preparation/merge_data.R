library(readr)
library(dplyr)

title.basics_filtered <- read_csv("gen/temp/title.basics_filtered.csv")
title.ratings_clean <- read_csv("gen/temp/title.ratings_clean.csv")

merged_data <- title.basics_filtered %>%
  inner_join(title.ratings_clean %>%
      rename(average_rating = averageRating,
             votes= numVotes) %>%
      select(tconst, average_rating, votes),
      by = "tconst") %>%
  mutate(runtime_minutes = as.numeric(runtime_minutes),
    start_year= as.integer(start_year),
    average_rating= as.numeric(average_rating),
    votes= as.integer(votes),
    title= as.character(title)
  )

write_csv(merged_data,"gen/temp/merged_data.csv")

# Drop duplicates -> highest votes per (title, year, runtime)
keys <- c("title","start_year","runtime_minutes")
movies_final_clean <- merged_data %>%
  group_by(across(all_of(keys))) %>%
  slice_max(votes, with_ties = FALSE) %>%
  ungroup()

write_csv(movies_final_clean, "gen/temp/movies_final_clean.csv")