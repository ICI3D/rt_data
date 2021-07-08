library(data.table)
library(lubridate)

.debug <- "/Users/Pragati/Documents/GitHub/rt_data/analysis/"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/rt_init.rds",
  "%s/fig_cases_rt_raw_estimate.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cd <- readRDS(.args[1])
rt <- readRDS(.args[2])

cols <- c("date", "median")
rt <- summary(rt, type = "parameters", params = "R")
rt <- rt[, ..cols]
# setnames(rt, c("date", "metric"))
# rt[, estimate := rep("Rt", nrow(rt))]

cd[, date := as.Date(date)]
cd <- cd[between(date, as.Date("2020-11-01"), as.Date("2021-02-07"))]
cols <- c("date", "new_case")
cd <- cd[, ..cols]
# setnames(cd, c("date", "metric"))
# cd[, estimate := rep("Cases", nrow(cd))]

setnames(cd, c("date", "incidence"))
cd[, est_rt := rt[, "median"]]

p <- ggplot(data = cd, aes(x = date))+
  geom_point(aes(y = incidence), color = "#F8766D", size = 1.5) +
  geom_line(aes(y = est_rt), color = "#F8766D", lwd = 1.5) +
  ggtitle(label = "Kenya Raw Cases and Rt Estimate") +
  scale_y_log10()+
  # scale_y_continuous(name = "Incidence",
  #                    sec.axis = sec_axis(~.), name="Rt") +
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y") +
  coord_cartesian(expand = FALSE) +
  theme_minimal()
p
ggsave("overlay_raw.png", p, width = 16, height = 9)
