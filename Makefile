
-include local.makefile

DATAPATH ?= analysis

JHURL := https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series
JHUCASE := ${JHURL}/time_series_covid19_confirmed_global.csv
JHUDEATHS := ${JHURL}/time_series_covid19_deaths_global.csv

WGET = wget -c -O $@
R = Rscript $^ $@

${DATAPATH}:
	mkdir -p $@

setup: ${DATAPATH}/jhu-case_timeseries_clean.rds

${DATAPATH}/jhu-case_timeseries.csv: | ${DATAPATH}
	${WGET} ${JHUCASE}

${DATAPATH}/jhu-case_timeseries_clean.rds: clean_cases.R ${DATAPATH}/jhu-case_timeseries.csv
	${R}

aggregatetest: ${DATAPATH}/agg_1.rds

${DATAPATH}/agg_1.rds: agg_1.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

${DATAPATH}/agg_2.rds: agg_2.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

${DATAPATH}/rt_cases.rds: estimate_rt_cases.R ${DATAPATH}/clean_cases.rds
	${R}

${DATAPATH}/fig_raw_cases.png: plot_raw_cases.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

${DATAPATH}/fig_agg_1.png: plot_rt_cases.R ${DATAPATH}/clean_cases.rds ${DATAPATH}/rt_cases.rds
	${R}