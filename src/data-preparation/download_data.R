# ---- paths bootstrap ----
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
root <- Sys.getenv("PROJECT_ROOT", unset = here::here())

DATA_DIR <- file.path(root, "data")
dir.create(DATA_DIR, recursive = TRUE, showWarnings = FALSE)

# ---- deps ----
suppressPackageStartupMessages({
  if (!requireNamespace("data.table", quietly = TRUE)) install.packages("data.table")
  if (!requireNamespace("curl", quietly = TRUE)) install.packages("curl")
})

library(data.table)
library(curl)

# Windows fread fix for pipes
if (tolower(Sys.info()[["sysname"]]) == "windows") {
  Sys.setenv(COMSPEC = "C:\\Windows\\System32\\cmd.exe")
}

options(timeout = max(600, getOption("timeout", 60L)))  # увеличить таймаут сети

dl_one <- function(url, stem, out_dir = DATA_DIR) {
  gz_path  <- file.path(out_dir, paste0(stem, ".tsv.gz"))
  csv_path <- file.path(out_dir, paste0(stem, ".csv"))
  
  message(">> Downloading: ", url)
  # curl_download не имеет progress=; используем quiet=FALSE (по умолчанию) и сообщим размер после
  curl_download(url, destfile = gz_path, mode = "wb")
  stopifnot(file.exists(gz_path), file.info(gz_path)$size > 0)
  message(".. downloaded to: ", gz_path, " (", round(file.info(gz_path)$size/1e6, 1), " MB)")
  
  message(">> Parsing (this may take a while): ", basename(gz_path))
  dt <- fread(gz_path, na.strings = "\\N", showProgress = TRUE)
  
  message(">> Writing CSV: ", csv_path)
  fwrite(dt, csv_path)
  
  message("✓ Done: ", csv_path, " (", nrow(dt), " rows)")
}

url_basics  <- "https://datasets.imdbws.com/title.basics.tsv.gz"
url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"

dl_one(url_basics,  "title.basics")
dl_one(url_ratings, "title.ratings")
