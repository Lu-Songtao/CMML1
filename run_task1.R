library(dplyr)
library(tidyr)
library(readr)

source("~/Desktop/CMML1/model_functions.R")
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

# Base
res_base <- simulation(
  Param.df = Param.df,
  type = "L",
  exp_type = "painting",
  save = TRUE,
  save.confi = TRUE,
  savepath = "res/base",
  sim.mode = "whole",
  scale.confi.init = FALSE
)

print("=== BASE ===")

# Medium
Param_medium <- Param.df
Param_medium$thres_schema <- rep(35, subjectnum)
Param_medium$thres_item_inter <- rep(4.5, subjectnum)
Param_medium$thres_item_final <- rep(10.5, subjectnum)
Param_medium$decay_speed_thres <- rep(0.997, subjectnum)

res_medium <- simulation(
  Param.df = Param_medium,
  type = "L",
  exp_type = "painting",
  save = TRUE,
  save.confi = TRUE,
  savepath = "res/medium",
  sim.mode = "whole",
  scale.confi.init = FALSE
)

print("=== MEDIUM ===")

# Fast
Param_fast <- Param.df
Param_fast$thres_schema <- rep(20, subjectnum)
Param_fast$thres_item_inter <- rep(3, subjectnum)
Param_fast$thres_item_final <- rep(8, subjectnum)
Param_fast$decay_speed_thres <- rep(0.995, subjectnum)

res_fast <- simulation(
  Param.df = Param_fast,
  type = "L",
  exp_type = "painting",
  save = TRUE,
  save.confi = TRUE,
  savepath = "res/fast",
  sim.mode = "whole",
  scale.confi.init = FALSE
)

print("=== FAST ===")