library(data.table)
library(lubridate)
library(ggplot2)
library(scales)

.debug <- "analysis"  ## remember to change this line to your local directory
.args <- if (interactive()) sprintf(c(
  "%s/jhu-case_timeseries_clean.rds",
  "%s/agg_1.rds",
  "%s/agg_2.rds",
  "%s/agg_3.rds",
  "%s/agg_4.rds",
  "%s/agg_5.rds",
  "%s/agg_6.rds",
  "%s/fig_raw_cases.png"
), .debug[1]) else commandArgs(trailingOnly = TRUE)

cleaned.data <- readRDS(.args[1])
cd1 <- readRDS(.args[2])
cd2 <- readRDS(.args[3])
cd3 <- readRDS(.args[4])
cd4 <- readRDS(.args[5])
cd5 <- readRDS(.args[6])
cd6 <- readRDS(.args[7])

cleaned.data[, Scheme := rep("Raw", nrow(cleaned.data))]
cd1[, Scheme := rep("1 week", nrow(cd1))]
cd2[, Scheme := rep("2 days", nrow(cd2))]
cd3[, Scheme := rep("MWF", nrow(cd3))]
cd4[, Scheme := rep("Monthly", nrow(cd4))]
cd5[, Scheme := rep("Bimonthly", nrow(cd5))]
cd6[, Scheme := rep("Every 500", nrow(cd6))]
cd6 <- cd6[, c("date", "new_case", "Scheme")]
  
cols <- names(cd1)
cleaned.data <- cleaned.data[,..cols]

full <- rbind(cleaned.data, cd1, cd2, cd3, cd4, cd5, cd6)
full$date <- as.Date(full$date)
full$Scheme <- factor(full$Scheme, levels = c("Raw", "1 week", "2 days", "MWF", 
                                              "Bimonthly", "Every 500", "Monthly"))

#' This script is to plot figures for incidence dynamics 
p <- ggplot(full[-(1:(which.max(new_case>0)-1))])+
  geom_line(data = full[-(1:(which.max(new_case>0)-1))][Scheme == factor("Raw")],
    aes(x = date, y = frollmean(new_case, 7, align = "center")),
    alpha = 0.5
  ) +
  geom_point(aes(x = date, y = new_case, color = Scheme, group = Scheme), stat = "identity", size = 1.5) +
  ggtitle(label = "Kenya: JHU CSSE Cases, log scale") +
  scale_y_log10("Incidence (log scale)") +
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y", limits = c(as.Date("2020-04-01"), as.Date("2021-07-31"))) +
  coord_cartesian(expand = FALSE) +
  theme_minimal()
p
ggsave(tail(.args, 1), p, width = 16, height = 9)



#' This script is to plot figures for incidence dynamics 
p <- ggplot(full[-(1:(which.max(new_case>0)-1))])+
  geom_line(data = full[-(1:(which.max(new_case>0)-1))][Scheme == factor("Raw")],
            aes(x = date, y = frollmean(new_case, 7, align = "center")),
            alpha = 0.5
  ) +
  geom_point(aes(x = date, y = new_case, color = Scheme, group = Scheme), stat = "identity", size = 1.5) +
  ggtitle(label = "Kenya: JHU CSSE Cases") +
  # scale_y_log10("Incidence (log scale)") +
  scale_x_date(name=NULL, date_breaks = "months", date_labels = "%b '%y", limits = c(as.Date("2020-04-01"), as.Date("2021-07-31"))) +
  coord_cartesian(expand = FALSE) +
  theme_minimal() 
p
