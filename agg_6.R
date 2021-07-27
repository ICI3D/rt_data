library(data.table)
library(lubridate)

.debug <- "~/Documents/GitHub/rt_data"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/analysis/jhu-case_timeseries_clean.rds",
  "%s/agg_6.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' reporting every 500 cases
#' 
#' 

clean <- cleaned.data[, agg := 0]
current.sum <- 0
for (c in 1:nrow(clean)) {
  current.sum <- current.sum + clean[c, new_case]
  clean[c, cum_100 := current.sum] 
  if (current.sum >= 500) {
    clean[c, keep := 1]
    current.sum <- 0
  }
}

res <- clean[keep == 1]
res[, new_case := cum_100]

saveRDS(res, tail(.args, 1))

