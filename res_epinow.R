library(EpiNow2)

.debug <- "analysis"
.args <- if (interactive()) file.path(
  .debug[1], c(
    "jhu-case_timeseries_clean.rds",
    "base_rt.rds"
)) else commandArgs(trailingOnly = TRUE)

case.dt <- readRDS(.args[1])
filter.dt <- case.dt[
  order(date)
][
  -(1:(which.max(new_case > 0)-1))
][, .(date, confirm = new_case )]
#First of several items of bad form: I assume you have res somewhere. Sorry.

christmas <- filter.dt[between(date, "2020-11-01", "2021-01-31")]
# last180 <- filter.dt[(.N-180):.N]

#reporting delay: I accept this is a synthetic example,
#but I want the code to run so. 
reporting_delay <- list(
  mean = convert_to_logmean(2, 1), mean_sd = 0.1,
  sd = convert_to_logsd(2, 1), sd_sd = 0.1,
  max = 10
)

#Incubation and generation time straight from EpiNow2 github
generation_time <- get_generation_time(disease = "SARS-CoV-2", source = "ganyani")
incubation_period <- get_incubation_period(disease = "SARS-CoV-2", source = "lauer")

estimates <- epinow(
  reported_cases = christmas,
  generation_time = generation_time,
  delays = delay_opts(incubation_period, reporting_delay),
  rt = rt_opts(prior = list(mean = 2, sd = 0.2)),
  stan = stan_opts(cores = 4)
)

saveRDS(estimates, tail(.args, 1))