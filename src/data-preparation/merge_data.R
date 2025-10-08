library(readr)
library(dplyr)

title.basics_filtered <- read_csv("../../gen/temp/title.basics_filtered.csv")
title.ratings_clean <- read_csv("../../gen/temp/title.ratings_clean.csv")

merged_data <- title.basics_filtered %>%
  select(tconst, runtime_minutes, start_year, title) %>%
  mutate(
    runtime_minutes = (as.numeric(runtime_minutes)),
    start_year      = (as.integer(start_year)),
    title = (as.character(title))) %>%
  inner_join(
    title.ratings_clean %>% select(tconst, average_rating, votes),
    by = "tconst") %>%
  mutate(
    average_rating = as.numeric(average_rating), 
    votes= as.integer(votes)) 

write_csv(merged_data,"../../gen/temp/merged_data.csv")

# Drop duplicates -> highest votes per (title, year, runtime)
keys <- c("title","start_year","runtime_minutes")

dup_count <- sum(duplicated(select(merged_data, all_of(keys))))
dup_count

duplicated_movies <- merged_data %>%
  mutate(is_duplicate = duplicated(select(., all_of(keys))) |
           duplicated(select(., all_of(keys)), fromLast = TRUE)) %>%
  filter(is_duplicate) %>%
  select(title, start_year, runtime_minutes, average_rating, votes) %>%
  arrange(title, start_year, runtime_minutes)

# Count duplicate groups (titles that appear multiple times)
duplicate_summary <- merged_data %>%
  count(across(all_of(keys)), sort = TRUE) %>%
  filter(n > 1) %>% slice_head(n = 20)
duplicate_summary

movies_deduplicated <- merged_data %>%
  group_by(across(all_of(keys))) %>%
  slice_max(votes, with_ties = FALSE) %>%  
  ungroup()

colSums(is.na(movies_deduplicated[, c("runtime_minutes", "average_rating", "start_year", "title")]))
summary(movies_deduplicated)
movies_final_clean <- movies_deduplicated

write_csv(movies_final_clean, "../../gen/output/movies_final_clean.csv")