# ---- paths bootstrap (paste at very top) ----
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

# читаем исходные CSV (учитываем коды пропусков IMDb)
basics  <- fread(file.path(DATA_DIR, "title.basics.csv"),  na.strings = c("\\N","N",""))
ratings <- fread(file.path(DATA_DIR, "title.ratings.csv"), na.strings = c("\\N","N",""))

# на всякий случай подчистим имена столбцов
setnames(basics,  names(basics),  trimws(names(basics)))
setnames(ratings, names(ratings), trimws(names(ratings)))

# очистка title.basics
basics_clean <- basics[
  , .(tconst, titleType, primaryTitle, originalTitle,
      isAdult, startYear, endYear, runtimeMinutes, genres)
]
basics_clean[, `:=`(
  startYear      = as.integer(startYear),
  runtimeMinutes = as.numeric(runtimeMinutes)
)]
setkey(basics_clean, tconst)
basics_clean <- unique(basics_clean, by = "tconst")

# очистка title.ratings
ratings_clean <- ratings[, .(tconst, averageRating, numVotes)]
ratings_clean[, `:=`(
  averageRating = as.numeric(averageRating),
  numVotes      = as.integer(numVotes)
)]
setkey(ratings_clean, tconst)
ratings_clean <- unique(ratings_clean, by = "tconst")

# запись файлов
fwrite(basics_clean,  file.path(TEMP_DIR, "title.basics_clean.csv"))
fwrite(ratings_clean, file.path(TEMP_DIR, "title.ratings_clean.csv"))
