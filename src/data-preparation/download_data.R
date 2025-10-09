# Download files from IMDb
library(data.table)

# Make sure cmd.exe is available for fread on Windows
if (tolower(Sys.info()[["sysname"]]) == "windows") {
  Sys.setenv(COMSPEC = "C:\\Windows\\System32\\cmd.exe")
}

download_to_csv <- function(url, stem, out_dir = "../../data") {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  tmpfile <- file.path(out_dir, paste0(stem, ".tsv.gz"))
  download.file(url, destfile = tmpfile, mode = "wb")
  dt <- fread(tmpfile, na.strings = "\\N", showProgress = FALSE)
  fwrite(dt, file.path(out_dir, paste0(stem, ".csv")))
  message("Saved: ", file.path(out_dir, paste0(stem, ".csv")))
}

url_basics  <- "https://datasets.imdbws.com/title.basics.tsv.gz"
url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"

download_to_csv(url_basics,  "title.basics")
download_to_csv(url_ratings, "title.ratings")

