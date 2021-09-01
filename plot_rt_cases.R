library(data.table)
library(lubridate)

.debug <- "/Users/Pragati/Documents/GitHub/rt_data/analysis/"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/rt_agg_1.rds",
  "%s/rt_agg_2.rds",
  "%s/rt_agg_3.rds",
  "%s/rt_agg_4.rds",
  "%s/rt_agg_5.rds",
  "%s/rt_agg_6.rds",
  "%s/rt_init.rds",
  "%s/fig_rt_estimate.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

rt1 <- readRDS(.args[1])
rt2 <- readRDS(.args[2])
rt3 <- readRDS(.args[3])
rt4 <- readRDS(.args[4])
rt5 <- readRDS(.args[5])
rt6 <- readRDS(.args[6])
rti <- readRDS(.args[7])

rti <- summary(rti, type = "parameters", params = "R")
rt1 <- summary(rt1, type = "parameters", params = "R")
rt2 <- summary(rt2, type = "parameters", params = "R")
rt3 <- summary(rt3, type = "parameters", params = "R")
rt4 <- summary(rt4, type = "parameters", params = "R")
rt5 <- summary(rt5, type = "parameters", params = "R")
rt6 <- summary(rt6, type = "parameters", params = "R")
rti[, Scheme := rep("Raw", nrow(rti))]
rt1[, Scheme := rep("1 week", nrow(rt1))]
rt2[, Scheme := rep("2 days", nrow(rt2))]
rt3[, Scheme := rep("MWF", nrow(rt3))]
rt4[, Scheme := rep("Monthly", nrow(rt4))]
rt5[, Scheme := rep("Bimonthly", nrow(rt5))]
rt6[, Scheme := rep("Every 500", nrow(rt6))]

full.rt <- rbind(rti, rt1, rt2, rt3, rt4, rt5, rt6)
full.rt$date <- as.Date(full.rt$date)
full.rt$Scheme <- factor(full.rt$Scheme, levels = c("Raw", "1 week", "2 days", "MWF", 
                                             "Bimonthly", "Every 500", "Monthly"))
#' This script is to plot figures for Rt estimates dynamics 
p <- ggplot(full.rt)+
  geom_line(aes(x = date, y = median, group = Scheme, color = Scheme), lwd = 1.5)+
  geom_ribbon(aes(x = date, ymin = lower_90, ymax = upper_90, fill = Scheme, color = Scheme), 
              alpha = 0.2, linetype = 0)+
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y", limits = c(as.Date("2020-04-01"), as.Date("2021-07-31"))) +
  ggtitle(label = "Kenya Rt Estimates")+
  theme_minimal()+
  xlab("Time-varying Reproduction Number")+
  ylab("Date")+
  geom_hline(yintercept = 1.0)

ggsave(tail(.args, 1), p, width = 16, height = 9)

#' This script is to plot figures for Rt estimates dynamics 
p <- ggplot(full.rt[Scheme == "Raw"])+
  geom_line(aes(x = date, y = median, group = Scheme, color = Scheme), lwd = 1.5)+
  geom_ribbon(aes(x = date, ymin = lower_90, ymax = upper_90, fill = Scheme, color = Scheme), 
              alpha = 0.3, linetype = 0)+
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y", limits = c(as.Date("2020-04-01"), as.Date("2021-07-31"))) +
  ggtitle(label = "Kenya Rt Estimates - Raw")+
  theme_minimal()+
  ylim(0.6, 1.6)+
  xlab("Time-varying Reproduction Number")+
  ylab("Date")+
  geom_hline(yintercept = 1.0)
p

ggsave("analysis/justraw.png", p, width = 16, height = 9)

mypal <- hue_pal()(7)

#' This script is to plot figures for Rt estimates dynamics 
p <- ggplot(full.rt[Scheme != "Monthly"])+
  geom_line(aes(x = date, y = median, group = Scheme, color = Scheme), lwd = 1.5)+
  geom_ribbon(aes(x = date, ymin = lower_90, ymax = upper_90, fill = Scheme, color = Scheme), 
  alpha = 0.3, linetype = 0)+
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y", limits = c(as.Date("2020-04-01"), as.Date("2021-07-31"))) +
  ggtitle(label = "Kenya Rt Estimates - Minus Monthly")+
theme_minimal()+
  xlab("Time-varying Reproduction Number")+
  ylab("Date")+
  geom_hline(yintercept = 1.0)+
  scale_color_manual(values = mypal[1:6]) +
  scale_fill_manual(values = mypal[1:6])
p

ggsave("analysis/minusmonthly.png", p, width = 16, height = 9)

