library(readr)
library(dplyr)

title.basics_clean <- read_csv("../../gen/temp/title.basics_clean.csv", show_col_types = FALSE)
title.ratings_clean <- read_csv("../../gen/temp/title.ratings_clean.csv", show_col_types = FALSE)

title.basics_filtered <- title.basics_clean %>%
  filter(titleType %in% c("movie", "tvMovie"),
         runtimeMinutes > 40,
         runtimeMinutes <= 300,
         startYear <= 2025) %>%
  select(tconst, primaryTitle, startYear, runtimeMinutes) %>%
  distinct(tconst, .keep_all = TRUE)

# Final columns names
title.basics_filtered <- title.basics_filtered %>%
  rename(title = primaryTitle,
         start_year = startYear,
         runtime_minutes = runtimeMinutes)

title.ratings_clean <- title.ratings_clean %>%
  rename(average_rating = averageRating,
    votes = numVotes)

write_csv(title.basics_filtered, "../../gen/temp/title.basics_filtered.csv")
write.csv(title.ratings_clean, "../../gen/temp/title.ratings_clean.csv")

names(title.ratings_clean)
