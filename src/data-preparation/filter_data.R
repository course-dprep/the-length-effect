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

# читаем очищенные файлы с прошлого шага
basics_clean  <- fread(file.path(TEMP_DIR, "title.basics_clean.csv"),
                       na.strings = c("\\N","N",""))
ratings_clean <- fread(file.path(TEMP_DIR, "title.ratings_clean.csv"),
                       na.strings = c("\\N","N",""))

# 1) фильтр по типу и разумным диапазонам
basics_filtered <- basics_clean[
  titleType %in% c("movie","tvMovie") &
    !is.na(runtimeMinutes) & runtimeMinutes > 40 & runtimeMinutes <= 300 &
    !is.na(startYear) & startYear <= 2025
][
  , .(tconst,
      title           = as.character(primaryTitle),
      start_year      = as.integer(startYear),
      runtime_minutes = as.numeric(runtimeMinutes))
]

# 2) переименуем рейтинги
ratings_filtered <- ratings_clean[
  , .(tconst,
      average_rating = as.numeric(averageRating),
      votes          = as.integer(numVotes))
]

# 3) соединим (inner join по tconst)
setkey(basics_filtered,  tconst)
setkey(ratings_filtered, tconst)
merged <- ratings_filtered[basics_filtered, nomatch = 0]

# 4) удалим пропуски (на всякий случай)
merged <- merged[!is.na(average_rating) &
                   !is.na(votes) &
                   !is.na(runtime_minutes) &
                   !is.na(start_year)]

# 5) дедуп по (title, start_year, runtime_minutes) — берём запись с max votes
setorder(merged, title, start_year, runtime_minutes, -votes)
merged <- unique(merged, by = c("title","start_year","runtime_minutes"))

# 6) сохраняем артефакты шага
fwrite(basics_filtered, file.path(TEMP_DIR, "title.basics_filtered.csv"))
fwrite(merged,         file.path(TEMP_DIR, "merged_data.csv"))
