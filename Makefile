DATA = data/data_with_selected_variables_and_map.RData data/clean_data.RData

all: $(DATA)

data/data_with_selected_variables_and_map.RData : script.R/load_data.R data/database_Antonella.csv
	Rscript $<

data/clean_data.RData : www/clean_data.html
	touch data/clean_data.RData

www/clean_data.html : script.R/clean_data.R data/data_with_selected_variables_and_map.RData
	Rscript -e 'ROOT = "$(shell pwd)"; rmarkdown::render("$<", output_file="$(shell pwd)/$@")'
