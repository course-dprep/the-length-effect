# Replace "\N" and "" with NA
to_na <- function(x) {
  y <- as.character(x)
  y[y %in% c("\\N", "N", "")] <- NA_character_
  y
}

# Cleaning the titile.basics dataset
title.basics_clean <- title.basics %>%
  mutate(across(c(titleType, primaryTitle, startYear, runtimeMinutes), to_na)) %>%
  mutate(startYear = suppressWarnings(as.integer(startYear)),
         runtimeMinutes = suppressWarnings(as.numeric(runtimeMinutes))) %>%
  select(tconst, titleType, primaryTitle, originalTitle, isAdult,
         startYear, endYear, runtimeMinutes, genres) %>%
  distinct(tconst, .keep_all = TRUE)

# Cleaning the title.ratings dataset
title.ratings_clean <- title.ratings %>%
  mutate(across(c(averageRating, numVotes), to_na)) %>%
  mutate(averageRating = as.numeric(averageRating),
         numVotes = as.integer(numVotes)) %>%
  select(tconst, averageRating, numVotes) %>%
  distinct(tconst, .keep_all = TRUE)