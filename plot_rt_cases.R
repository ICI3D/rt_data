library(data.table)
library(lubridate)

.debug <- "C:/Users/alice/Box/MMED/project"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/rt_agg_1.rds",
  "%s/rt_agg_2.rds",
  "%s/rt_agg_3.rds",
  "%s/rt_agg_4.rds",
  "%s/rt_init.rds",
  "%s/fig_rt_estimate.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

rt1 <- readRDS(.args[1])
rt2 <- readRDS(.args[2])
rt3 <- readRDS(.args[3])
rt4 <- readRDS(.args[4])
rti <- readRDS(.args[5])

rti$Scheme <- "Raw"
rt1$Scheme <- "Agg 1"
rt2$Scheme <- "Agg 2"
rt3$Scheme <- "Agg 3"
rt4$Scheme <- "Agg 4"

full.rt <- rbind(rti, rt1, rt2, rt3, rt4)
full.rt <- as.factor(full.rt$Scheme, levels = c("Raw", "Agg 1", "Agg 2", "Agg 3", "Agg 4"))

#' This script is to plot figures for Rt estimates dynamics 
p <- ggplot(full.rt)+
  geom_line(aes(x = date, y = rt, group = Scheme, color = Scheme))+
  geom_ribbon(aes(x = data, ymin = ci.low, ymax = ci.high, group = Scheme, color = Scheme), alpha = 0.3)+
  ggtitle(label = "Kenya Rt Estimates")

png(tail(.args, 1))
print(p)
dev.off()
