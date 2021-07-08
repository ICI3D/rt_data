library(EpiNow2)

#First of several items of bad form: I assume you have res somewhere. Sorry.

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

#apparently the reported_cases variable needs to be called confirm?
#1. Is there a way around this?
#2. I currently vote we assign confirm before each run.
res$confirm<-res$new_case

#We can only have confirm and the date for epinow() to run as best I can tell.
subs <- res[, c(2,5)]

##############################################################################
#DO ME FIRST
#test <- res[500:nrow(res), c(2,5)]
#test_est <- epinow(reported_cases = test,
#                   generation_time = generation_time,
#                   delays = delay_opts(incubation_period, reporting_delay),
#                   rt = rt_opts(prior = list(mean = 2, sd = 0.2)),
#                   stan = stan_opts(cores = 4)
#knitr::kable(summary(test_est))
#plot(test_est)
#############################################################################

estimates <- epinow(reported_cases = subs,
                    generation_time = generation_time,
                    delays = delay_opts(incubation_period, reporting_delay),
                    rt = rt_opts(prior = list(mean = 2, sd = 0.2)),
                    stan = stan_opts(cores = 4))

