
library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/agg_1.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' describe aggregation scheme
#' 
#' 
#' 

res <- cleaned.data[, .(
  `Country/Region` = `Country/Region`[.N],
  date = date[.N],
  `case-count` = sum(`case-count`)
)]

saveRDS(res, tail(.args, 1))