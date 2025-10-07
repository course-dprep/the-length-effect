library(data.table)
library(dplyr)
library(checkmate)
library(ggplot2)  
library(gt)        
library(tibble)   
library(knitr)     
library(kableExtra)
library(readr)
install.packages("checkmate")
library(checkmate)

title.basics  <- read_csv("../../data/title.basics")
title.ratings <- read_csv("../../data/title.ratings")
title.basics_clean <- read_csv("../../gen/temp/title.basics_clean.csv")
title.ratings_clean <- read_csv("../../gen/temp/title.ratings_clean.csv")
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

write_csv(summary_tb1, "gen/output/data_size_summary.csv")

# checking the variable type
str(title.basics)                 # compact overview
dplyr::glimpse(title.basics)      # tidyverse overview
sapply(title.basics, class)       # class of each column
sapply(title.basics, typeof)      # storage type of each column

str(title.ratings)                 # compact overview
dplyr::glimpse(title.ratings)      # tidyverse overview
sapply(title.ratings, class)       # class of each column
sapply(title.ratings, typeof)      # storage type of each column

## NOT SURE WHAT THAT IS: ndt <- readRDS("data/processed/movies_prepared.rds")

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

write_csv(var_dict, "../../gen/output/variable_dictionary.csv")
# checking outliers in averageRating - histogram
ratings_clean_plot <- filter(title.ratings_clean, !is.na(averageRating))
p <- ggplot(ratings_clean_plot, aes(x = averageRating)) +
  geom_histogram(binwidth = 0.25, color = "white", fill = "grey30", boundary = 0) +
  scale_x_continuous(limits = c(0, 10), breaks = 0:10) +
  labs(x = "Average rating", y = "Count", title = "Distribution of IMDb Ratings") +
  theme_minimal(base_size = 14)
ggsave("../../gen/output/ratings_histogram.png", p, width = 7, height = 4, dpi = 180)

# allow NAs, but every non-NA must be within [0, 10]
assert_numeric(
  title.ratings_clean$averageRating,
  lower = 0, upper = 10,
  any.missing = TRUE,  # NAs allowed
  all.missing = FALSE  # not all NA
)