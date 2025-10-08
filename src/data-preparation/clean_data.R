library(readr)
library(dplyr)

dir.create("../../gen/temp", recursive = TRUE, showWarnings = FALSE)

to_na <- function(x) {
  y <- as.character(x)
  y[y %in% c("\\N", "N", "")] <- NA_character_
  y
}

title.basics  <- read_csv("../../data/title.basics.csv")
title.ratings <- read_csv("../../data/title.ratings.csv")

title.basics_clean <- title.basics %>%
  select(tconst, titleType, primaryTitle, originalTitle,
         isAdult, startYear, endYear, runtimeMinutes, genres) %>%
  mutate(startYear= as.integer(startYear),
    runtimeMinutes = as.numeric(runtimeMinutes)) %>%
    distinct(tconst, .keep_all = TRUE)

title.ratings_clean <- title.ratings %>%
  select(tconst, averageRating, numVotes) %>%
  mutate(averageRating = as.numeric(averageRating),
    numVotes= as.integer(numVotes)) %>%
    distinct(tconst, .keep_all = TRUE)

write_csv(title.basics_clean,"../../gen/temp/title.basics_clean.csv")
write_csv(title.ratings_clean,"../../gen/temp/title.ratings_clean.csv")