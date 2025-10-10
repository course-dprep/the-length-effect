# Download files from IMDb
library(data.table)
## Data Loading

# Load IMDb title.basics data
title.basics <- fread("https://datasets.imdbws.com/title.basics.tsv.gz")

# Load IMDb title.ratings data
title.ratings <- fread("https://datasets.imdbws.com/title.ratings.tsv.gz")

saveRDS(title.basics, file = "data/raw/title_basics.rds")
saveRDS(title.ratings, file = "data/raw/title_ratings.rds")
