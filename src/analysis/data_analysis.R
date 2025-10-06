library(data.table)
library(dplyr)
library(checkmate)
library(ggplot2)  
library(gt)        
library(tibble)   
library(knitr)     
library(kableExtra)
install.packages("contrib.url")

movies_final_clean <- readRDS("data/processed/movies_prepared.rds")

# Analysis, linear regression

LR1 <- lm(average_rating ~ runtime_minutes + start_year, data = movies_final_clean)
summary(LR1)

install.packages(c("modelsummary", "sandwich", "lmtest", "broom"))
m_lin <- lm(average_rating ~ runtime_minutes + start_year, data = movies_final_clean)
VHC3 <- sandwich::vcovHC(m_lin, type = "HC3")

msummary(
  m_lin,
  vcov = VHC3,
  stars = TRUE,
  coef_map = c(
    "(Intercept)"    = "Intercept",
    "runtime_minutes" = "Runtime (minutes)",
    "start_year"      = "Release year"
  ),
  gof_omit = "IC|AIC|BIC",
  title = "OLS: Audience rating on runtime, controlling for release year (HC3 SE)"
)

p1 <- ggplot(movies_final_clean, aes(x = runtime_minutes, y = average_rating)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ratings vs Runtime", x = "Runtime (minutes)", y = "Average rating") +
  theme_minimal(base_size = 12)
p1

p2 <- ggplot(movies_final_clean, aes(x = start_year, y = average_rating)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ratings vs Release Year", x = "Release year", y = "Average rating") +
  theme_minimal(base_size = 12)
p2

# On the exact data you used for the plot:
with(movies_final_clean, c(
  n_total = length(runtime_minutes),
  n_lt100 = sum(runtime_minutes < 100, na.rm = TRUE),
  min_runtime = min(runtime_minutes, na.rm = TRUE),
  quantiles = paste(quantile(runtime_minutes, c(.01,.1,.25,.5,.75,.9,.99), na.rm=TRUE), collapse=", ")
))

dir.create("data/analysis", recursive = TRUE, showWarnings = FALSE)