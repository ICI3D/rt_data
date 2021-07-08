
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

ALLAGG := $(subst .R,.rds,$(shell agg_*.R))
allagg: ${ALLAGG}

${DATAPATH}/agg_%.rds: agg_%.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

${DATAPATH}/rt_agg_%.rds: res_epinow.R ${DATAPATH}/agg_%.rds
	${R}

${DATAPATH}/rt_init.rds: res_epinow.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

${DATAPATH}/fig_agg_%.png: plot_agg.R ${DATAPATH}/jhu-case_timeseries_clean.rds ${DATAPATH}/rt_init.rds ${DATAPATH}/agg_%.rds ${DATAPATH}/rt_agg_%.rds
	${R}

${DATAPATH}/fig_raw_cases.png ${DATAPATH}/fig_raw_cases.tiff: plot_raw_cases.R ${DATAPATH}/jhu-case_timeseries_clean.rds
	${R}

figs: ${DATAPATH}/fig_raw_cases.png

#${DATAPATH}/fig_raw_cases.png: plot_raw_cases.R ${DATAPATH}/jhu-case_timeseries_clean.rds
#	${R}