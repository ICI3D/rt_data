library(data.table)
library(lubridate)
library(ggplot2)
library(EpiNow2)

.debug <- "/Users/alicearcury-quandt/Documents/GitHub/rt_data//analysis/"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/rt_init.rds",
  "%s/fig_cases_rt_raw_estimate.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cd <- readRDS(.args[1])
est_case <- readRDS(.args[2])

cols <- c("date", "median")
est_case <- summary(est_case, type="parameters", "estimated_reported_cases")
est_case <- est_case[, ..cols]


cd[, date := as.Date(date)]
cd <- cd[between(date, as.Date("2020-11-01"), as.Date("2021-02-07"))]
cols <- c("date", "new_case")
cd <- cd[, ..cols]
# setnames(cd, c("date", "metric"))
# cd[, estimate := rep("Cases", nrow(cd))]

setnames(cd, c("date", "incidence"))
est_case[, est_case := est_case[, "median"]]

p <- ggplot(data = cd, aes(x = date))+
  geom_point(data = cd, aes(y = incidence), color = "#F8766D", size = 1.5) +
  geom_line(data = est_case, aes(y = frollmean(est_case, 7, align = "center")), color = "#6d79f8", lwd = 1) +
  ggtitle(label = "Kenya Raw and Estimated Cases") +
  scale_y_log10()+
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y") +
  coord_cartesian(expand = FALSE) +
  theme_minimal()
p
ggsave("overlay_raw_est_case.png", p, width = 16, height = 9)
