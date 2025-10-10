# ---- paths bootstrap (must be at top) ----
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
root <- Sys.getenv("PROJECT_ROOT", unset = here::here())

DATA_DIR <- file.path(root, "data")
TEMP_DIR <- file.path(root, "gen", "temp")
OUT_DIR  <- file.path(root, "gen", "output")

dir.create(DATA_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(TEMP_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(OUT_DIR,  recursive = TRUE, showWarnings = FALSE)

# ---- script logic ----
library(data.table)

merged_path <- file.path(TEMP_DIR, "merged_data.csv")

# --- Preferred path: use merged_data.csv produced at previous step ---
if (file.exists(merged_path)) {
  merged <- fread(merged_path, na.strings = c("\\N","N",""))
  merged[, `:=`(
    start_year      = as.integer(start_year),
    runtime_minutes = as.numeric(runtime_minutes),
    average_rating  = as.numeric(average_rating),
    votes           = as.integer(votes)
  )]
} else {
  # --- Fallback: rebuild merge from filtered/clean files ---
  basics_filtered <- fread(file.path(TEMP_DIR, "title.basics_filtered.csv"),
                           na.strings = c("\\N","N",""))
  ratings_clean   <- fread(file.path(TEMP_DIR, "title.ratings_clean.csv"),
                           na.strings = c("\\N","N",""))
  
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
fwrite(movies_final_clean, file.path(OUT_DIR, "movies_final_clean.csv"))
