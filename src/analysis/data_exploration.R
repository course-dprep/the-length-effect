library(data.table)
library(dplyr)
library(checkmate)
library(ggplot2)  
library(gt)        
library(tibble)   
library(knitr)     
library(kableExtra)

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

# changing character for numerical and change \N for NA
to_na <- function(x) {
  y <- as.character(x)
  y[y %in% c("\\N", "N", "")] <- NA_character_
  y
}

#Cleaning the titile.basics
title.basics_clean <- title.basics %>%
  mutate(
    titleType      = to_na(titleType),
    primaryTitle   = to_na(primaryTitle),
    startYear      = to_na(startYear),
    runtimeMinutes = to_na(runtimeMinutes)) %>% 
  mutate(
    startYear      = suppressWarnings(as.integer(startYear)),
    runtimeMinutes = suppressWarnings(as.numeric(runtimeMinutes))) %>%
  select(tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes, genres) %>%
  distinct(tconst, .keep_all = TRUE)


#Cleaning the title.ratings
title.ratings_clean <- title.ratings %>%
  mutate(
    averageRating = to_na(averageRating),
    numVotes      = to_na(numVotes)) %>%
  mutate(averageRating = as.numeric(averageRating),
         numVotes      = as.integer(numVotes)) %>%
  select(tconst, averageRating, numVotes) %>%
  distinct(tconst, .keep_all = TRUE)

# Checking again the variable type correct
str(title.basics_clean)                 # compact overview
dplyr::glimpse(title.basics_clean)      # tidyverse overview
sapply(title.basics_clean, class)       # class of each column
sapply(title.basics_clean, typeof)

# Variable table:
var_dict <- tribble(
  ~Variable,        ~Date_Class,      ~Definition,                                                        ~Role,
  "runtimeMinutes", "numeric",  "Duration of the movie in minutes",                                 "Independent variable",
  "averageRating",  "numeric",   "Average IMDb user rating (0–10 scale, aggregated from user votes)", "Dependent variable",
  "startYear",      "numeric",  "Year the movie was released",                                      "Control variable")

var_dict %>%
  gt() %>%
  tab_header(title = "Table 1. Variable Explanation") %>%
  tab_options(column_labels.font.weight = "bold")

# checking outliers in averageRating - histogram

ratings_clean <- dplyr::filter(title.ratings, !is.na(averageRating))

ggplot(ratings_clean, aes(x = averageRating)) +
  geom_histogram(binwidth = 0.25, color = "white", fill = "grey30", boundary = 0) +
  scale_x_continuous(limits = c(0, 10), breaks = 0:10) +
  labs(x = "Average rating", y = "Count", title = "Average Rating IMDb") +
  theme_minimal(base_size = 14)

# allow NAs, but every non-NA must be within [0, 10]
assert_numeric(
  title.ratings$averageRating,
  lower = 0, upper = 10,
  any.missing = TRUE,  # NAs allowed
  all.missing = FALSE  # not all NA
)

dir.create("data/explore", recursive = TRUE, showWarnings = FALSE)
saveRDS(title.basics_clean, file = "data/explore/title_basics_clean.rds")
saveRDS(title.ratings_clean, file = "data/explore/title_ratings_clean.rds")