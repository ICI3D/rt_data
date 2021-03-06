library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/agg_4.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' reporting on first day of the month
#' 
#' 

clean <- cleaned.data[, agg := 0]

clean[, md := mday(date) ]
# roll to next 1st 
clean[, firstgrp := cumsum(md == 2) ]
clean[, agg := sum(new_case), by=firstgrp]
clean[md != 1, agg := 0 ]

res <- clean[, .(date, new_case = agg)]

saveRDS(res, tail(.args, 1))

