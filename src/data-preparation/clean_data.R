library(data.table)

# каталог для вывода
dir.create("../../gen/temp", recursive = TRUE, showWarnings = FALSE)

# читаем исходные CSV (учитываем коды пропусков IMDb)
basics  <- fread("../../data/title.basics.csv",  na.strings = c("\\N","N",""))
ratings <- fread("../../data/title.ratings.csv", na.strings = c("\\N","N",""))

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
fwrite(basics_clean,  "../../gen/temp/title.basics_clean.csv")
fwrite(ratings_clean, "../../gen/temp/title.ratings_clean.csv")
