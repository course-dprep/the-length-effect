options(repos = c(CRAN = "https://cloud.r-project.org"))
library(data.table)
library(dplyr)
library(checkmate)
library(tidyverse)
library(ggplot2)  
library(gt)        
library(tibble)   
library(knitr)     
library(kableExtra)
install.packages(c("modelsummary", "sandwich", "lmtest", "broom"))
library(modelsummary)
library(sandwich)
install.packages("contrib.url")
install.packages("ggeffects")
library(ggeffects)


# Load the dataset
movies_final_clean <- read_csv("../../gen/output/movies_final_clean.csv")
out_dir <- "../../paper/output"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

## Regression Analysis

# OLS regression: runtime + release year (control)
model_1 <- lm(average_rating ~ runtime_minutes + start_year, data = movies_final_clean)
summary(model_1)

# Visualization of the relationship between runtime and IMDb rating
p1 <- ggplot(movies_final_clean, aes(x = runtime_minutes, y = average_rating)) +
  geom_point(alpha = 0.2, color = "#5DADE2") +
  geom_smooth(method = "lm", color = "#1A5276", se = FALSE, size = 1.2) +
  labs(
    title = "Relationship between Runtime and IMDb Rating",
    subtitle = "Controlling for release year",
    x = "Runtime (minutes)",
    y = "Average IMDb Rating") +
  theme_minimal(base_size = 13)
ggsave(
  filename = "Final_result_lm.pdf",
  plot     = p1,
  path     = out_dir,
  width    = 7,
  height   = 4,
  units    = "in",
  device   = "pdf"
)
# Predicted relationship (controlling for release year)
pred <- ggpredict(model_1, terms = "runtime_minutes [all]")

ggplot(pred, aes(x = x, y = predicted)) +
  geom_line(color = "#1A5276", size = 1.2) +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), fill = "#5DADE2", alpha = 0.2) +
  labs(
    title = "Predicted IMDb Rating vs Runtime",
    subtitle = "Controlling for release year",
    x = "Runtime (minutes)",
    y = "Predicted IMDb Rating"
  ) +
  theme_minimal(base_size = 13)
ggsave(file.path(out_dir, "Predicted_model.pdf"), p1, width = 7, height = 4, dpi = 180)


# Quadratic Model 
model_quad <- lm(average_rating ~ runtime_minutes + I(runtime_minutes^2) + start_year,
                 data = movies_final_clean)
summary(model_quad)


p2 <- ggplot(movies_final_clean, aes(x = runtime_minutes, y = average_rating)) +
  geom_point(alpha = 0.2, color = "#AED6F1") +
  geom_smooth(method = "lm", formula = y ~ x, color = "#1A5276", se = FALSE, size = 1.1) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), color = "#E74C3C", se = FALSE, size = 1.1) +
  coord_cartesian(xlim = c(40, 250), ylim = c(0, 10)) +
  labs(
    title = "Linear vs Quadratic Fit: Runtime and IMDb Rating",
    x = "Runtime (minutes)",
    y = "Average IMDb Rating",
    caption = "Blue = linear model; Red = quadratic model (within observed data range)") +
  theme_minimal(base_size =13)
ggsave(
  filename = "Linear_vs_Quadratic_Fit.pdf",
  plot     = p2,
  path     = out_dir,
  width    = 7,
  height   = 4,
  units    = "in",
  device   = "pdf"
)

#Robustness Check - interaction with release year
model_2 <- lm(average_rating ~ runtime_minutes * start_year, data = movies_final_clean)
summary(model_2)
