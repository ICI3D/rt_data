library(data.table)
library(lubridate)

.debug <- "/Users/alicearcury-quandt/Documents/GitHub/rt_data"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/agg_5.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' reporting on first or 15th day of the month
#' 
#' 

clean <- cleaned.data[, agg := 0]

clean[, md := mday(date) ]
# roll to next 1st or 15th
clean[, bimonthgrp := cumsum(md == 2 | md == 16) ]
clean[, agg := sum(new_case), by=bimonthgrp]
clean[!(md %in% c(1,15)), agg := 0 ]

res <- clean[, .(date, new_case = agg)]

saveRDS(res, tail(.args, 1))

