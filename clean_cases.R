
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
res<- melt(res, id.vars = "Country/Region", variable.name = "date", value.name = "cum_case")

#reformating date from mdy to ymd
res$date <- mdy(res$date)

#creating incidence variable "new_case"
res$new_case[1] <- 0
res$new_case[2:nrow(res)] <- diff(res$cum_case)

saveRDS(res, tail(.args, 1))