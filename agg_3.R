library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/agg_3.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' Reporting M-W-F

clean <- cleaned.data[, agg := 0]

# sunday = 1
clean[, wd := wday(date) ]
# roll to next mwf
clean[, mwfgrp := cumsum(wd == 3 | wd == 5 | wd == 7) ]
clean[, agg := sum(new_case), by=mwfgrp]
clean[wd %in% c(1,3,5,7), agg := 0 ]

res <- clean[, .(date, new_case = agg)]

saveRDS(res, tail(.args, 1))
