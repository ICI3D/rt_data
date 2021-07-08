library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/agg_1.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' Reporting on Monday (Tue-Mon)

clean <- cleaned.data[, agg := 0]

# sunday = 1
clean[, wd := wday(date) ]
# roll to next 2 (monday)
clean[, mondaygrp := cumsum(wd == 3) ]
clean[, agg := sum(new_case), by=mondaygrp]
clean[wd != 2, agg := 0 ]

res <- clean[, .(date, new_case = agg)]

saveRDS(res, tail(.args, 1))

