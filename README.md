# CMML1
## Author: Lu Songtao

This repository contains the code, data, simulation outputs, processed results, and report files for a mini-project on schema-based learning and decision-making. The project uses an R computational model to examine two related questions: whether reduced decision thresholds can approximate a “give-up-on-bonus” strategy, and how different confidence initialization settings affect performance, especially for familiar versus novel schemas.

## Repository structure

- `CMML.docx`  
  Main written report.

- `data/`  
  Input data files used by the model. This folder includes files for both Task 1 and Task 3.

- `model_functions.R`  
  Original model functions.

- `model_modified.R`  
  Modified model used for the initialization analyses in Task 3.

- `run_task1.R`  
  Script for running Task 1 simulations under baseline, medium, and fast conditions.

- `run_task3.R`  
  Script for running Task 3 simulations under different initialization conditions.

- `task1_result_process.R`  
  Script for summarizing and plotting Task 1 results.

- `task3_result_process.R`  
  Script for summarizing and plotting Task 3 results.

- `res/`  
  Raw simulation outputs for both Task 1 and Task 3.

- `processed_res/`  
  Processed summaries, tables, and plots for both Task 1 and Task 3.

- `README.md`  
  Repository overview and usage notes.

## Project questions

### Task 1
Whether some participants may stop pursuing the schema-matching bonus and instead adopt a faster strategy. This was examined by reducing decision thresholds and comparing:
- `baseline`
- `medium`
- `fast`

### Task 3
How different initial confidence settings affect model performance, especially for familiar and novel schemas. This was examined by comparing:
- `familiarity_same`
- `familiarity_low`
- `fixed_low`
- `payoff_low`

## Requirements
	•   dplyr
	•	tidyr
	•	readr
	•	ggplot2


## Code modifications

Compared with the original `model_functions.R`, the main code changes were made for Task 3.

**Rows 76–87:**  
Added two new arguments to `simulation()`:
- `init_mode`
- `novel_init_mode`

**Rows 167–190:**  
Modified the initialization of familiar schemas:
- `familiarity`: starting confidence scaled from prior familiarity
- `fixed`: all familiar schemas assigned the same starting confidence
- `payoff`: starting confidence scaled from schema payoff

**Rows 285–312:**  
Modified the initialization of novel schemas after the break:
- `same_rule`: novel schemas follow the same rule as familiar schemas
- `low_specific`: novel schemas start with lower schema-specific confidence

Confidence variance (`conVar`) was recalculated after each new initialization.

For Task 1, the model structure was not changed. Only threshold-related parameters were adjusted in the run script to create the `baseline`, `medium`, and `fast` conditions:
- `thres_schema`
- `thres_item_inter`
- `thres_item_final`
- `decay_speed_thres`
