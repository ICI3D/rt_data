
-include local.makefile

DATAPATH ?= analysis

JHURL := https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series
JHUCASE := ${JHURL}/time_series_covid19_confirmed_global.csv
JHUDEATHS := ${JHURL}/time_series_covid19_deaths_global.csv

WGET = wget -c -O $@
R = Rscript $^ $@

${DATAPATH}:
	mkdir -p $@

setup: ${DATAPATH}/clean_cases.rds

${DATAPATH}/raw_cases.csv: | ${DATAPATH}
	${WGET} ${JHUCASE}

<<<<<<< Updated upstream
${DATAPATH}/raw_deaths.csv: | ${DATAPATH}
	${WGET} ${JHUDEATHS}
=======
${DATAPATH}/jhu-case_timeseries_clean.rds: clean_cases.R ${DATAPATH}/jhu-case_timeseries.csv
	${R}

###aggregatetest: ${DATAPATH}/agg_1.rds
>>>>>>> Stashed changes

${DATAPATH}/clean_cases.rds: clean_cases.R ${DATAPATH}/raw_cases.csv
	${R}

${DATAPATH}/clean_deaths.rds: clean_deaths.R ${DATAPATH}/raw_deaths.csv
	${R}

${DATAPATH}/agg_3.rds: agg_3.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

<<<<<<< Updated upstream
${DATAPATH}/fig_rt_cases.png: plot_rt_cases.R ${DATAPATH}/clean_cases.rds ${DATAPATH}/rt_cases.rds
=======
${DATAPATH}/agg_4.rds: agg_4.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

${DATAPATH}/rt_init.rds: estimate_rt.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

${DATAPATH}/rt_agg_1.rds: estimate_rt.R ${DATAPATH}/agg_1.rds
	${R}
	
${DATAPATH}/rt_agg_2.rds: estimate_rt.R ${DATAPATH}/agg_2.rds
	${R}

${DATAPATH}/rt_agg_3.rds: estimate_rt.R ${DATAPATH}/agg_3.rds
	${R}

${DATAPATH}/rt_agg_4.rds: estimate_rt.R ${DATAPATH}/agg_4.rds
	${R}

${DATAPATH}/fig_raw_cases.png: plot_raw_cases.R ${DATAPATH}/jhu-case_timeseries_clean.rds ${DATAPATH}/agg_1.rds ${DATAPATH}/agg_2.rds ${DATAPATH}/agg_3.rds ${DATAPATH}/agg_4.rds 
	${R}

${DATAPATH}/fig_rt_estimate.png: plot_rt_cases.R ${DATAPATH}/rt_init.rds ${DATAPATH}/rt_agg_1.rds ${DATAPATH}/rt_agg_2.rds ${DATAPATH}/rt_agg_3.rds ${DATAPATH}/rt_agg_4.rds
>>>>>>> Stashed changes
	${R}