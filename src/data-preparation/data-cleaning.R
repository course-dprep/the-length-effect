library(tidyverse)

# Load merged data
merged_data<-read_csv("../../gen/temp/merged_data.csv")

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

# Write new file with final output data
write_csv(movies_final_no_na ,file = "../../gen/output/movies_final_no_na.csv")
# preparing/cleaning your data.