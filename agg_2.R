library(data.table)
library(lubridate)

.debug <- "/Users/Pragati/Documents/GitHub/rt_data"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/agg_2.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])
clean <- cleaned.data[, agg := 0]
#' describe aggregation scheme 2
clean[, secndday := fifelse(.I %% 2 == 0, 0, 1) ]
clean[, twodygrp := cumsum(secndday == 1) ]
clean[, agg := sum(new_case), by=twodygrp]
clean[secndday %in% c(1), agg := 0 ]

res <- clean[, .(date, new_case = agg)]
saveRDS(res, tail(.args, 1))

