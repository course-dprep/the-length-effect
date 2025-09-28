library(data.table)
title.basics <- readRDS("data/raw/title_basics.rds")
title.ratings <- readRDS("data/raw/title_ratings.rds")

# Summary of title.basics

dim(title.basics)     
nrow(title.basics)      
ncol(title.basics)       
colnames(title.basics) 
str(title.basics)      
summary(title.basics)   
head(title.basics, 10)

# Summary of title.ratings
dim(title.ratings)     
nrow(title.ratings)      
ncol(title.ratings)       
colnames(title.ratings) 
str(title.ratings)      
summary(title.ratings)   
head(title.ratings, 10)

# Complete summary title.basics & title.ratings
summary_tb1 <- tibble::tibble(
  dataset = c("title.basics","title.ratings"),
  n_rows  = c(nrow(title.basics), nrow(title.ratings)),
  n_cols  = c(ncol(title.basics), ncol(title.ratings)))

knitr::kable(summary_tb1, caption = "Data size summary") |>
  kableExtra::kable_styling(full_width = FALSE,
                            bootstrap_options = c("striped","hover","condensed"))

# checking the variable type
str(title.basics)                 # compact overview
dplyr::glimpse(title.basics)      # tidyverse overview
sapply(title.basics, class)       # class of each column
sapply(title.basics, typeof)      # storage type of each column

str(title.ratings)                 # compact overview
dplyr::glimpse(title.ratings)      # tidyverse overview
sapply(title.ratings, class)       # class of each column
sapply(title.ratings, typeof)      # storage type of each column


dir.create("data/intermediate", recursive = TRUE, showWarnings = FALSE)
saveRDS(dt, "data/intermediate/movies_joined.rds")
