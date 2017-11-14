suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(broom))
suppressPackageStartupMessages(library(modelr))
suppressPackageStartupMessages(library(reshape2))

# load BMI gapminder 2007 data
BMI_gapminder_2007 <- read_tsv("datatables/BMI_gapminder_2007.tsv")

############ summary statistics by continent #############
summary_data <- BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% 
	group_by(continent, sex) %>%
	summarise(mean_BMI = mean(BMI), 
						median_BMI = median(BMI),
						min_BMI = min(BMI),
						max_BMI = max(BMI))

# save the continent summary datatable
write_tsv(summary_data, "datatables/summary_data.tsv")

########### for each continent look at relationship between BMI and gdpPercap in 2007 ##########
fitted_models = BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% # not enough data points so remove oceania
	group_by(continent, sex) %>% 
	do(model = lm(BMI ~ log10(gdpPercap), data = .)) %>% 
	tidy(model) %>% 
	select(continent, sex, term, estimate) %>% 
	spread(key = term, value = estimate) %>% 
	mutate(intercept =`(Intercept)`, slope = `log10(gdpPercap)`) %>% 
	select(continent, sex, intercept, slope)

# save the continent linear regression datatable
write_tsv(fitted_models, "datatables/fitted_models.tsv")

############## FITTED MODEL AGAIN USING modelr PACKAGE #####################

# function using lm to make predictions on BMI vs gdpPercap
fitted_model_function <- function(continent_selection, sex_selection){
	BMI_gapminder_2007 %>%
		filter(continent != "Oceania") %>% # not enough data points so remove oceania
		filter(sex == sex_selection, continent == continent_selection) %>% 
		add_predictions(lm(BMI ~ log10(gdpPercap), data = .))  ## creates columnn with predicted y values
}

# call function for each continent and sex combination
Africa_m <- fitted_model_function("Africa", "male")
Americas_m <- fitted_model_function("Americas", "male")
Europe_m <- fitted_model_function("Europe", "male")
Asia_m <- fitted_model_function("Asia", "male")

Africa_f <- fitted_model_function("Africa", "female")
Americas_f <- fitted_model_function("Americas", "female")
Europe_f <- fitted_model_function("Europe", "female")
Asia_f <- fitted_model_function("Asia", "female")

# merge all continent and sex data together
fitted_models_modelr <- rbind.data.frame(Africa_m, Africa_f, Europe_m, Europe_f, Americas_m, Americas_f, Asia_m, Asia_f)

# save the modelr predictions datatable
write_tsv(fitted_models_modelr, "datatables/fitted_models_modelr.tsv")


######## find countries with large difference in male and female BMI ###########
BMI_sex_differences <- BMI_gapminder_2007 %>% 
	select(country, sex, BMI) %>% 
	spread(sex, BMI) %>% 
	mutate(BMI_sex_difference = male - female) %>%
	arrange(desc(BMI_sex_difference))

# save the sex differences datatable
write_tsv(BMI_sex_differences, "datatables/BMI_sex_differences.tsv")
