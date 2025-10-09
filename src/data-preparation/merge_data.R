# src/data-preparation/merge_data.R
library(data.table)

# ensure output dir
dir.create("../../gen/output", recursive = TRUE, showWarnings = FALSE)

# --- Preferred path: use merged_data.csv produced at previous step ---
if (file.exists("../../gen/temp/merged_data.csv")) {
  merged <- fread("../../gen/temp/merged_data.csv", na.strings = c("\\N","N",""))
  
  # enforce types
  merged[, `:=`(
    start_year      = as.integer(start_year),
    runtime_minutes = as.numeric(runtime_minutes),
    average_rating  = as.numeric(average_rating),
    votes           = as.integer(votes)
  )]
  
} else {
  # --- Fallback: rebuild merge from filtered/clean files ---
  basics_filtered <- fread("../../gen/temp/title.basics_filtered.csv",
                           na.strings = c("\\N","N",""))
  ratings_clean   <- fread("../../gen/temp/title.ratings_clean.csv",
                           na.strings = c("\\N","N",""))
  
  # align ratings column names
  ratings_filtered <- ratings_clean[
    , .(tconst,
        average_rating = as.numeric(averageRating),
        votes          = as.integer(numVotes))
  ]
  
  setkey(basics_filtered, tconst)
  setkey(ratings_filtered, tconst)
  merged <- ratings_filtered[basics_filtered, nomatch = 0]
  
  merged <- merged[!is.na(average_rating) &
                     !is.na(votes) &
                     !is.na(runtime_minutes) &
                     !is.na(start_year)]
}

# Deduplicate by (title, start_year, runtime_minutes): keep max votes
setorder(merged, title, start_year, runtime_minutes, -votes)
movies_final_clean <- unique(merged, by = c("title","start_year","runtime_minutes"))

# Write final dataset
fwrite(movies_final_clean, "../../gen/output/movies_final_clean.csv")
