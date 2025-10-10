library(data.table)
library(dplyr)
library(checkmate)
library(ggplot2)  
library(gt)        
library(tibble)   
library(knitr)     
library(kableExtra)
install.packages(c("modelsummary", "sandwich", "lmtest", "broom"))
library(modelsummary)
library(sandwich)

# Load the dataset
model_1 <- read_csv("../../src/analysis/model_1.csv")
movies_final_clean <- read_csv("../../gen/output/movies_final_clean.csv")
out_dir <- "../../paper/output"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

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

ggplot(movies_final_clean, aes(x = runtime_minutes, y = average_rating)) +
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
ggsave(file.path(out_dir, "Linear vs Quadratic Fit.pdf"), p1, width = 7, height = 4, dpi = 180)

#Robustness Check - interaction with release year
model_2 <- lm(average_rating ~ runtime_minutes * start_year, data = movies_final_clean)
summary(model_2)

write_csv(model_2, "../../src/analysis/model_2.csv")