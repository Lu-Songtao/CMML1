library(dplyr)
library(tidyr)
library(readr)

source("~/Desktop/CMML1/model_modified.R")
set.seed(123)

# Baseline parameter set
subjectnum <- 20

Param.df <- data.frame(
  Subject = 1:subjectnum,
  a_schema = rep(0.2, subjectnum),
  h_schema = rep(1000, subjectnum),
  Beta_N = rep(0.2, subjectnum),
  Beta_Var = rep(0.3, subjectnum),
  a_generic = rep(0.1, subjectnum),
  h_generic = rep(1500, subjectnum),
  Beta_gN = rep(0.1, subjectnum),
  Beta_gVar = rep(0.2, subjectnum),
  w = rep(0.3, subjectnum),
  Phi = rep(20, subjectnum),
  decay_speed = rep(0.999, subjectnum),
  decay_speed_thres = rep(0.999, subjectnum),
  thres_item_inter = rep(6, subjectnum),
  thres_item_final = rep(13.75, subjectnum),
  thres_schema = rep(50, subjectnum),
  theta_shift = rep(3, subjectnum),
  timevar = rep(0.0001, subjectnum),
  modeltimestep = rep(0.061, subjectnum)
)
#Run four initialization conditions

# A. familiarity + same_rule
res_fam_same <- simulation(
  Param.df = Param.df,
  type = "L",
  exp_type = "painting",
  save = TRUE,
  save.confi = TRUE,
  savepath = "res/task3/fam_same",
  sim.mode = "whole",
  scale.confi.init = FALSE,
  init_mode = "familiarity",
  novel_init_mode = "same_rule"
)

# B. familiarity + low_specific
res_fam_low <- simulation(
  Param.df = Param.df,
  type = "L",
  exp_type = "painting",
  save = TRUE,
  save.confi = TRUE,
  savepath = "res/task3/fam_low",
  sim.mode = "whole",
  scale.confi.init = FALSE,
  init_mode = "familiarity",
  novel_init_mode = "low_specific"
)

# C. fixed + low_specific
res_fixed_low <- simulation(
  Param.df = Param.df,
  type = "L",
  exp_type = "painting",
  save = TRUE,
  save.confi = TRUE,
  savepath = "res/task3/fixed_low",
  sim.mode = "whole",
  scale.confi.init = FALSE,
  init_mode = "fixed",
  novel_init_mode = "low_specific"
)

# D. payoff + low_specific
res_payoff_low <- simulation(
  Param.df = Param.df,
  type = "L",
  exp_type = "painting",
  save = TRUE,
  save.confi = TRUE,
  savepath = "res/task3/payoff_low",
  sim.mode = "whole",
  scale.confi.init = FALSE,
  init_mode = "payoff",
  novel_init_mode = "low_specific"
)
