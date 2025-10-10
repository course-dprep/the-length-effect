options(repos = c(CRAN = "https://cloud.r-project.org"))
pkgs <- c(
  "data.table","dplyr","readr","httr","jsonlite","tidyverse","ggplot2",
  "checkmate","gt","tibble","knitr","kableExtra","modelsummary","sandwich",
  "lmtest","broom"
)
to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install)) install.packages(to_install)