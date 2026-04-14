library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

base_df <- read_csv("res/base/L/allresult_processed.csv")
medium_df <- read_csv("res/medium/L/allresult_processed.csv")
fast_df <- read_csv("res/fast/L/allresult_processed.csv")

base_df$condition <- "base"
medium_df$condition <- "medium"
fast_df$condition <- "fast"

all_df <- bind_rows(base_df, medium_df, fast_df)

all_df$condition <- factor(all_df$condition, levels = c("base", "medium", "fast"))


#summary
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

#table
result_table <- subject_summary %>%
  group_by(condition) %>%
  summarise(
    mean_AC = mean(AC, na.rm = TRUE),
    mean_Schema_RT = mean(Schema_RT, na.rm = TRUE),
    mean_RT1 = mean(RT_1, na.rm = TRUE),
    mean_performance = mean(performance, na.rm = TRUE),
    mean_schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

print(result_table)

#Plot
plot_df <- result_table %>%
  pivot_longer(
    cols = c(mean_AC, mean_Schema_RT, mean_schema_payoff),
    names_to = "metric",
    values_to = "value"
  )

plot_df$metric <- recode(
  plot_df$metric,
  mean_AC = "Accuracy (AC)",
  mean_Schema_RT = "Schema RT",
  mean_schema_payoff = "Schema Payoff"
)

ggplot(plot_df, aes(x = condition, y = value, fill = condition)) +
  geom_col() +
  facet_wrap(~metric, scales = "free_y") +
  theme_minimal()