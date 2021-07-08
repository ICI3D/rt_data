library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/rt_init.rds",
  "%s/fig_raw_cases.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])

#' This script is to plot figures for incidence dynamics 
p <- ggplot(cleaned.data)+
  geom_bar(aes(x = date, y = inc_case, stat = "identity"))+
  ggtitle(label = "Kenya Raw Cases")

png(tail(.args, 1))
print(p)
dev.off()