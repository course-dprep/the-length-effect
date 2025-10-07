# Download files from IMDb
library(data.table)
## Data Loading
download_to_csv <- function(url, stem, out_dir = "../../data") {
  dt <- fread(url, na.strings = "\\N", showProgress = FALSE)
  fwrite(dt, file.path(out_dir, paste0(stem, ".csv")))
  message("Saved: ", file.path(out_dir, paste0(stem, ".csv")))
}

# URLs
url_basics  <- "https://datasets.imdbws.com/title.basics.tsv.gz"
url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"

# Save CSVs
download_to_csv(url_basics,"title.basics")
download_to_csv(url_ratings,"title.ratings")