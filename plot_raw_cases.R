library(data.table)
library(lubridate)
library(ggplot2)

.debug <- "analysis"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/fig_raw_cases.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' This script is to plot figures for incidence dynamics 
p <- ggplot(cleaned.data[-(1:(which.max(new_case>0)-1))])+
  geom_line(
    aes(x = date, y = frollmean(new_case, 7, align = "center")),
    alpha = 0.5
  ) +
  geom_point(aes(x = date, y = new_case), stat = "identity", size = 0.5) +
  ggtitle(label = "Kenya Raw Cases") +
  scale_y_log10("Incidence") +
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y") +
  coord_cartesian(expand = FALSE) +
  theme_minimal()

ggsave(tail(.args, 1), p, width = 16, height = 9)