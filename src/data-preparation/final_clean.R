library(tidyverse)

# Load merged data
movies_final_clean <- read.csv("gen/temp/movies_final_clean.csv")

# Handling missing data
movies_final_no_na <- movies_final_clean %>%
  filter(!is.na(runtime_minutes),
         !is.na(average_rating),
         !is.na(start_year),
         !is.na(title))

# drop NA in those columns 
movies_final_no_na <- movies_final_clean %>%
  filter(!if_any(c(runtime_minutes, average_rating, start_year, title), is.na))

n_removed <- nrow(movies_final_clean) - nrow(movies_final_no_na)
n_removed

# Write new file with final output data
write_csv(movies_final_no_na ,file = "gen/output/movies_final_no_na.csv")
