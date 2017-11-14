all: plots/BMI_plot_canada.jpeg

clean:
	rm -f datatables/*.rds datatables/*.tsv
	rm -f plots/*.jpeg

# download gapminder BMI data from google sheet using gsheet
datatables/BMI_male.rds:
	Rscript -e 'saveRDS(gsheet::gsheet2tbl("http://docs.google.com/spreadsheet/pub?key=0ArfEDsV3bBwCdF9saE1pWUNYVkVsNU1FdW1Yem81Nmc&output=xlsx", sheetid = NULL), file = "$@")'

datatables/BMI_female.rds:
	Rscript -e 'saveRDS(gsheet::gsheet2tbl("http://docs.google.com/spreadsheet/pub?key=0ArfEDsV3bBwCdGt0elo2dzJMVVQ3WmFGSmdhc09LRlE&output=xlsx", sheetid = NULL), file = "$@")'
	
datatables/gapminder_data.tsv:
	Rscript -e 'download.file("https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv", destfile = "$@", quiet = TRUE)'

datatables/BMI_data.tsv datatables/BMI_gapminder_2007.tsv: BMI_data_wrangling.R datatables/BMI_male.rds datatables/BMI_female.rds datatables/gapminder_data.tsv
	Rscript $<

datatables/BMI_sex_differences.tsv datatables/continent_BMI_summary.tsv: BMI_statistical_analysis.R datatables/BMI_gapminder_2007.tsv
	Rscript $<

plots/BMI_plot_canada.jpeg plots/BMI_vs_gdpPercap_plot.jpeg plots/BMI_histogram.jpeg: BMI_plotting.R datatables/BMI_data.tsv datatables/BMI_gapminder_2007.tsv
	Rscript $<
														
									



	
