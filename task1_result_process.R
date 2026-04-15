library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

base_df <- read_csv("~/Desktop/CMML1/res/task1/base/L/allresult_processed.csv")
medium_df <- read_csv("~/Desktop/CMML1/res/task1/medium/L/allresult_processed.csv")
fast_df <- read_csv("~/Desktop/CMML1/res/task1/fast/L/allresult_processed.csv")

base_df$condition <- "base"
medium_df$condition <- "medium"
fast_df$condition <- "fast"

all_df <- bind_rows(base_df, medium_df, fast_df)

all_df$condition <- factor(all_df$condition, levels = c("base", "medium", "fast"))

# subject-level summary
subject_summary <- all_df %>%
  group_by(condition, Subject) %>%
  summarise(
    AC = mean(AC, na.rm = TRUE),
    Schema_RT = mean(Schema_RT, na.rm = TRUE),
    RT_1 = mean(RT_1, na.rm = TRUE),
    performance = mean(performance, na.rm = TRUE),
    schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

# table with mean and SE
result_table <- subject_summary %>%
  group_by(condition) %>%
  summarise(
    mean_AC = mean(AC, na.rm = TRUE),
    se_AC = sd(AC, na.rm = TRUE) / sqrt(n()),
    mean_Schema_RT = mean(Schema_RT, na.rm = TRUE),
    se_Schema_RT = sd(Schema_RT, na.rm = TRUE) / sqrt(n()),
    mean_RT1 = mean(RT_1, na.rm = TRUE),
    se_RT1 = sd(RT_1, na.rm = TRUE) / sqrt(n()),
    mean_performance = mean(performance, na.rm = TRUE),
    se_performance = sd(performance, na.rm = TRUE) / sqrt(n()),
    mean_schema_payoff = mean(schema_payoff, na.rm = TRUE),
    se_schema_payoff = sd(schema_payoff, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

print(result_table)

# plot data
plot_df <- result_table %>%
  select(
    condition,
    mean_AC, se_AC,
    mean_Schema_RT, se_Schema_RT,
    mean_schema_payoff, se_schema_payoff
  ) %>%
  pivot_longer(
    cols = -condition,
    names_to = c(".value", "metric"),
    names_pattern = "(mean|se)_(.*)"
  )

plot_df$metric <- recode(
  plot_df$metric,
  AC = "Accuracy (AC)",
  Schema_RT = "Schema RT",
  schema_payoff = "Schema Payoff"
)

ggplot(plot_df, aes(x = condition, y = mean, fill = condition)) +
  geom_col() +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2) +
  facet_wrap(~metric, scales = "free_y") +
  theme_minimal()