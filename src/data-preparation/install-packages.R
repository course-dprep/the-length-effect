#instal packages
need_pkgs <- c(
  "tidyverse","data.table","readr","lubridate",
  "knitr","kableExtra","broom", "ggeffects"
)

# Optional (used only if you later add those features)
opt_pkgs <- c("ISOweek","zoo","janitor","gt")

missing <- setdiff(need_pkgs, rownames(installed.packages()))
if (length(missing)) {
  stop(
    sprintf("Please install missing packages before knitting: %s",
            paste(missing, collapse = ", "))
  )
}

invisible(lapply(need_pkgs, library, character.only = TRUE))

present_opt <- intersect(opt_pkgs, rownames(installed.packages()))
if (length(present_opt)) {
  invisible(lapply(present_opt, library, character.only = TRUE))
}