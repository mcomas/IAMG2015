DATA = data/data_with_selected_variables_and_map.RData data/clean_data.RData
HTML = www/clean_data.html www/descriptives.html
all: $(DATA) $(HTML)

data/data_with_selected_variables_and_map.RData : script.R/load_data.R data/database_Antonella.csv
	Rscript $<

data/clean_data.RData : www/clean_data.html
	touch data/clean_data.RData

www/clean_data.html : script.Rmd/clean_data.Rmd data/data_with_selected_variables_and_map.RData
	Rscript -e 'ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/descriptives.html : script.Rmd/descriptives.Rmd data/clean_data.RData
	Rscript -e 'ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'