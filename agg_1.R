
.args <- if (interactive()) c(
  "analysis/jhu-case_timeseries_clean.rds",
  "analysis/agg_1.rds"
) else commandArgs(trailingOnly = TRUE)

clean <- readRDS(.args[1])

# sunday = 1
clean[, wd := wday(date) ]
# roll to next 2 (monday)
clean[, mondaygrp := cumsum(wd == 3) ]
clean[, agg := sum(new_case), by=mondaygrp]
clean[wd != 2, agg := 0 ]

res <- clean[, .(date, new_case = agg)]

saveRDS(res, tail(.args, 1))
