library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)

fam_same_df   <- read_csv("~/Desktop/CMML1/res/task3/fam_same/L_familiarity_same_rule/allresult_processed.csv")
fam_low_df    <- read_csv("~/Desktop/CMML1/res/task3/fam_low/L_familiarity_low_specific/allresult_processed.csv")
fixed_low_df  <- read_csv("~/Desktop/CMML1/res/task3/fixed_low/L_fixed_low_specific/allresult_processed.csv")
payoff_low_df <- read_csv("~/Desktop/CMML1/res/task3/payoff_low/L_payoff_low_specific/allresult_processed.csv")

fam_same_df$condition   <- "familiarity_same"
fam_low_df$condition    <- "familiarity_low"
fixed_low_df$condition  <- "fixed_low"
payoff_low_df$condition <- "payoff_low"

all_df <- bind_rows(fam_same_df, fam_low_df, fixed_low_df, payoff_low_df)

all_df$condition <- factor(
  all_df$condition,
  levels = c("familiarity_same", "familiarity_low", "fixed_low", "payoff_low")
)

overall_subject_summary <- all_df %>%
  group_by(condition, Subject) %>%
  summarise(
    AC = mean(AC, na.rm = TRUE),
    Schema_RT = mean(Schema_RT, na.rm = TRUE),
    RT_1 = mean(RT_1, na.rm = TRUE),
    performance = mean(performance, na.rm = TRUE),
    schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

overall_summary <- overall_subject_summary %>%
  group_by(condition) %>%
  summarise(
    mean_AC = mean(AC, na.rm = TRUE),
    mean_Schema_RT = mean(Schema_RT, na.rm = TRUE),
    mean_RT1 = mean(RT_1, na.rm = TRUE),
    mean_performance = mean(performance, na.rm = TRUE),
    mean_schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

print(overall_summary)

early_subject_summary <- all_df %>%
  filter(Round <= 3) %>%
  group_by(condition, Subject) %>%
  summarise(
    AC = mean(AC, na.rm = TRUE),
    Schema_RT = mean(Schema_RT, na.rm = TRUE),
    RT_1 = mean(RT_1, na.rm = TRUE),
    performance = mean(performance, na.rm = TRUE),
    schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

early_summary <- early_subject_summary %>%
  group_by(condition) %>%
  summarise(
    mean_AC = mean(AC, na.rm = TRUE),
    mean_Schema_RT = mean(Schema_RT, na.rm = TRUE),
    mean_RT1 = mean(RT_1, na.rm = TRUE),
    mean_performance = mean(performance, na.rm = TRUE),
    mean_schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

print(early_summary)

postbreak_subject_summary <- all_df %>%
  filter(afterbreak == 1, Round <= 8) %>%
  group_by(condition, Subject) %>%
  summarise(
    AC = mean(AC, na.rm = TRUE),
    Schema_RT = mean(Schema_RT, na.rm = TRUE),
    RT_1 = mean(RT_1, na.rm = TRUE),
    performance = mean(performance, na.rm = TRUE),
    schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

postbreak_summary <- postbreak_subject_summary %>%
  group_by(condition) %>%
  summarise(
    mean_AC = mean(AC, na.rm = TRUE),
    mean_Schema_RT = mean(Schema_RT, na.rm = TRUE),
    mean_RT1 = mean(RT_1, na.rm = TRUE),
    mean_performance = mean(performance, na.rm = TRUE),
    mean_schema_payoff = mean(schema_payoff, na.rm = TRUE),
    .groups = "drop"
  )

print(postbreak_summary)

ac_distribution <- all_df %>%
  group_by(condition, AC) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(condition) %>%
  mutate(prop = n / sum(n))

print(ac_distribution)

early_plot_df <- early_summary %>%
  pivot_longer(
    cols = c(mean_AC, mean_Schema_RT, mean_performance, mean_schema_payoff),
    names_to = "metric",
    values_to = "value"
  )

early_plot_df$metric <- recode(
  early_plot_df$metric,
  mean_AC = "Accuracy (AC)",
  mean_Schema_RT = "Schema RT",
  mean_performance = "Performance",
  mean_schema_payoff = "Schema Payoff"
)

p_early <- ggplot(early_plot_df, aes(x = condition, y = value, fill = condition)) +
  geom_col() +
  facet_wrap(~metric, scales = "free_y") +
  labs(
    title = "Early rounds comparison across initialization conditions",
    x = "Condition",
    y = "Mean value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

print(p_early)

postbreak_plot_df <- postbreak_summary %>%
  pivot_longer(
    cols = c(mean_AC, mean_Schema_RT, mean_performance, mean_schema_payoff),
    names_to = "metric",
    values_to = "value"
  )

postbreak_plot_df$metric <- recode(
  postbreak_plot_df$metric,
  mean_AC = "Accuracy (AC)",
  mean_Schema_RT = "Schema RT",
  mean_performance = "Performance",
  mean_schema_payoff = "Schema Payoff"
)

p_postbreak <- ggplot(postbreak_plot_df, aes(x = condition, y = value, fill = condition)) +
  geom_col() +
  facet_wrap(~metric, scales = "free_y") +
  labs(
    title = "Post-break early rounds comparison across initialization conditions",
    x = "Condition",
    y = "Mean value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

print(p_postbreak)

dir.create("analysis_task3", showWarnings = FALSE)

write_csv(overall_summary,   "analysis_task3/overall_summary.csv")
write_csv(early_summary,     "analysis_task3/early_summary.csv")
write_csv(postbreak_summary, "analysis_task3/postbreak_summary.csv")
write_csv(ac_distribution,   "analysis_task3/ac_distribution.csv")

ggsave("analysis_task3/early_rounds_plot.png", p_early, width = 10, height = 6, dpi = 300)
ggsave("analysis_task3/postbreak_plot.png", p_postbreak, width = 10, height = 6, dpi = 300)