library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/fig_rt_estimate.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' This script is to plot figures for Rt estimates dynamics 
#' 
#' 
#' 