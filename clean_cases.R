
library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries.csv",
  "%s/jhu-case_timeseries_clean.rds"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

res <- fread(.args[1])

#Select only Kenya
setkey(res, Country/Region)
res <- res["Kenya"]

#Remove extraneous variables
res <- res[, `:=` (`Province/State` = NULL, Lat = NULL, Long = NULL)]

#Long format
res<- melt(res, id.vars = "Country/Region", variable.name = "date", value.name = "case-count")

#reformating date from mdy to ymd
res$date <- mdy(res$date)

saveRDS(res, tail(.args, 1))