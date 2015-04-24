DATA = data/data_with_selected_variables_and_map.RData data/clean_data.RData data/data-trans.RData
HTML = www/clean_data.html www/descriptives.html www/mixture_fitting.html \
       www/mixture_fitting-SEL01.html www/mixture_fitting-SEL02.html www/mixture_fitting-SEL03.html \
       www/piper_plots.html www/piper_alternative.html
all: $(DATA) $(HTML)

data/data_with_selected_variables_and_map.RData : script.R/load_data.R data/database_Antonella.csv
	Rscript $<

data/clean_data.RData : www/clean_data.html
	touch $@

data/data-trans.RData : www/descriptives.html
	touch $@

www/clean_data.html : script.Rmd/clean_data.Rmd data/data_with_selected_variables_and_map.RData
	Rscript -e 'ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/descriptives.html : script.Rmd/descriptives.Rmd data/clean_data.RData
	Rscript -e 'ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/piper_plots.html : script.Rmd/piper_plots.Rmd data/clean_data.RData
	Rscript -e 'ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/piper_alternative.html : script.Rmd/piper_alternative.Rmd data/clean_data.RData
	Rscript -e 'ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/mixture_fitting.html : script.Rmd/mixture_fitting.Rmd data/data-trans.RData
	Rscript -e 'ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/mixture_fitting-SEL01.html : script.Rmd/mixture_fitting.Rmd data/data-trans.RData
	Rscript -e 'SELECTION = "with(data, conduct <= 1000)"; ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/mixture_fitting-SEL02.html : script.Rmd/mixture_fitting.Rmd data/data-trans.RData
	Rscript -e 'SELECTION = "with(data, conduct > 1000)"; ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'

www/mixture_fitting-SEL03.html : script.Rmd/mixture_fitting.Rmd data/data-trans.RData
	Rscript -e 'SELECTION = "with(data, conduct > 1500)"; ROOT = "$(shell pwd)"; OUT = ".tmp/$@/$(@F)"; IN = "$<"; source("script.Rmd/run-knit2html.R")'
