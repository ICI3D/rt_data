
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

${DATAPATH}/raw_deaths.csv: | ${DATAPATH}
	${WGET} ${JHUDEATHS}

${DATAPATH}/clean_cases.rds: clean_cases.R ${DATAPATH}/raw_cases.csv
	${R}

${DATAPATH}/clean_deaths.rds: clean_deaths.R ${DATAPATH}/raw_deaths.csv
	${R}

${DATAPATH}/rt_cases.rds: estimate_rt_cases.R ${DATAPATH}/clean_cases.rds
	${R}

${DATAPATH}/fig_rt_cases.png: plot_rt_cases.R ${DATAPATH}/clean_cases.rds ${DATAPATH}/rt_cases.rds
	${R}