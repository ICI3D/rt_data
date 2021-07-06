
library(data.table)

.args <- if (interactive()) c(
  "something.csv", "anotherthing.rds"
) else commandArgs(trailingOnly = TRUE)

print(.args)

res <- data.table()

saveRDS(res, tail(.args, 1))