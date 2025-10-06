# Download files from IMDb
library(data.table)
# Load IMDb title.basics data
title.basics <- fread("https://datasets.imdbws.com/title.basics.tsv.gz", sep="\t", quote="")
str(title.basics)
# Load IMDb title.ratings data
title.ratings <- fread("https://datasets.imdbws.com/title.ratings.tsv.gz", sep="\t", quote="")
str(title.ratings)

saveRDS(title.basics, file = "data/raw/title_basics.rds")
saveRDS(title.ratings, file = "data/raw/title_ratings.rds")
