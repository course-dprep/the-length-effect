library(data.table)

# каталоги
dir.create("../../gen/temp", recursive = TRUE, showWarnings = FALSE)

# читаем очищенные файлы с прошлого шага
basics_clean  <- fread("../../gen/temp/title.basics_clean.csv",
                       na.strings = c("\\N","N",""))
ratings_clean <- fread("../../gen/temp/title.ratings_clean.csv",
                       na.strings = c("\\N","N",""))

# ожидемые имена:
# basics_clean: tconst, titleType, primaryTitle, originalTitle, isAdult,
#               startYear, endYear, runtimeMinutes, genres
# ratings_clean: tconst, averageRating, numVotes

# 1) фильтр по типу и разумным диапазонам
basics_filtered <- basics_clean[
  titleType %in% c("movie","tvMovie") &
    !is.na(runtimeMinutes) & runtimeMinutes > 40 & runtimeMinutes <= 300 &
    !is.na(startYear) & startYear <= 2025
][
  , .(tconst,
      title        = as.character(primaryTitle),
      start_year   = as.integer(startYear),
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

# 6) если по пайплайну ещё нужен отдельный basics_filtered — сохраним его;
#    иначе можно сразу писать merged. Здесь сохраним оба.
fwrite(basics_filtered, "../../gen/temp/title.basics_filtered.csv")
fwrite(merged,        "../../gen/temp/merged_data.csv")
