suppressPackageStartupMessages({
  library(readr); library(dplyr); library(ggplot2)
  library(modelsummary); library(sandwich); library(lmtest); library(broom)
})

# paths (relative to src/analysis/)
out_dir <- "../../gen/output"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 1) data
movies_final_clean <- read_csv("../../gen/output/movies_final_no_na.csv" )

# 2) models
m_lin  <- lm(average_rating ~ runtime_minutes + start_year, data = movies_final_clean)
vcov_hc3 <- sandwich::vcovHC(m_lin, type = "HC3")

# 3) model table (HTML to gen/output)
msummary(
  m_lin,
  output = file.path(out_dir, "ols_runtime_year.html"),
  vcov   = vcov_hc3,
  stars  = TRUE,
  coef_map = c(
    "(Intercept)"     = "Intercept",
    "runtime_minutes" = "Runtime (minutes)",
    "start_year"      = "Release year"
  ),
  gof_omit = "IC|AIC|BIC",
  title = "OLS: Audience rating on runtime, controlling for release year (HC3 SE)"
)

# 4) plots
p1 <- ggplot(movies_final_clean, aes(x = runtime_minutes, y = average_rating)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ratings vs Runtime", x = "Runtime (minutes)", y = "Average rating") +
  theme_minimal(base_size = 12)
ggsave(file.path(out_dir, "ratings_vs_runtime.png"), p1, width = 7, height = 4, dpi = 180)

p2 <- ggplot(movies_final_clean, aes(x = start_year, y = average_rating)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ratings vs Release Year", x = "Release year", y = "Average rating") +
  theme_minimal(base_size = 12)
ggsave(file.path(out_dir, "ratings_vs_year.png"), p2, width = 7, height = 4, dpi = 180)

# 5) quick stats (saved as a txt artifact)
stats <- with(movies_final_clean, c(
  n_total     = length(runtime_minutes),
  n_lt100     = sum(runtime_minutes < 100, na.rm = TRUE),
  min_runtime = min(runtime_minutes, na.rm = TRUE),
  quantiles   = paste(quantile(runtime_minutes, c(.01,.1,.25,.5,.75,.9,.99), na.rm=TRUE), collapse=", ")
))
writeLines(capture.output(print(stats)), file.path(out_dir, "runtime_stats.txt"))
