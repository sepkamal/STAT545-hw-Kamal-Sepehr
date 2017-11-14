all: clean Hw07_automating_data_analysis_pipelines.md

# delete old datatables and plots so can start fresh
clean:
	Rscript -e 'setwd(setwd("~/UBC/STAT 545/STAT545-hw-Kamal-Sepehr/Hw07"))' # set working directory
	rm -f datatables/*.rds datatables/*.tsv       #### delete all datatables
	rm -f plots/*.jpeg     ### delete all plot images
	rm -f Hw07_automating_data_analysis_pipelines.md

# download gapminder male BMI data from google sheet using gsheet
datatables/BMI_male.rds:
	Rscript -e 'saveRDS(gsheet::gsheet2tbl("http://docs.google.com/spreadsheet/pub?key=0ArfEDsV3bBwCdF9saE1pWUNYVkVsNU1FdW1Yem81Nmc&output=xlsx", sheetid = NULL), file = "$@")'

# download gapminder female BMI data too
datatables/BMI_female.rds:
	Rscript -e 'saveRDS(gsheet::gsheet2tbl("http://docs.google.com/spreadsheet/pub?key=0ArfEDsV3bBwCdGt0elo2dzJMVVQ3WmFGSmdhc09LRlE&output=xlsx", sheetid = NULL), file = "$@")'

# download main gapminder data
datatables/gapminder_data.tsv:
	Rscript -e 'download.file("https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv", destfile = "$@", quiet = TRUE)'

# datawrangling script
datatables/BMI_data.tsv datatables/BMI_gapminder_2007.tsv: BMI_data_wrangling.R datatables/BMI_male.rds datatables/BMI_female.rds datatables/gapminder_data.tsv
	Rscript $<

# statistical analysis script
datatables/BMI_sex_differences.tsv datatables/fitted_models.tsv datatables/summary_data.tsv datatables/fitted_models_modelr.tsv: BMI_statistical_analysis.R datatables/BMI_gapminder_2007.tsv
	Rscript $<

# plotting script
plots/BMI_plot_canada.jpeg plots/BMI_vs_gdpPercap_plot.jpeg plots/BMI_histogram.jpeg: BMI_plotting.R datatables/BMI_data.tsv datatables/BMI_gapminder_2007.tsv datatables/fitted_models_modelr.tsv
	Rscript $<
	
# render markdown file
Hw07_automating_data_analysis_pipelines.md: Hw07_automating_data_analysis_pipelines.Rmd plots/BMI_plot_canada.jpeg plots/BMI_vs_gdpPercap_plot.jpeg plots/BMI_histogram.jpeg datatables/summary_data.tsv datatables/fitted_models.tsv datatables/fitted_models_modelr.tsv datatables/BMI_data.tsv datatables/BMI_sex_differences.tsv datatables/BMI_gapminder_2007.tsv	
	Rscript -e 'rmarkdown::render("$<")'
	rm -f Hw07_automating_data_analysis_pipelines.html



	
