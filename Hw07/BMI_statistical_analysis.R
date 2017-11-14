suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(broom))
suppressPackageStartupMessages(library(modelr))
suppressPackageStartupMessages(library(reshape2))

# load BMI gapminder 2007 data
BMI_gapminder_2007 <- read_tsv("datatables/BMI_gapminder_2007.tsv")

# summary statistics by continent
summary_data <- BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% 
	group_by(continent, sex) %>%
	summarise(mean_BMI = mean(BMI), 
						median_BMI = median(BMI),
						min_BMI = min(BMI),
						max_BMI = max(BMI))

# for each continent look at relationship between BMI and gdpPercap in 2007
fitted_models = BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% # not enough data points so remove oceania
	group_by(continent, sex) %>% 
	do(model = lm(BMI ~ log10(gdpPercap), data = .)) %>% 
	tidy(model) %>% 
	select(continent, sex, term, estimate) %>% 
	spread(key = term, value = estimate) %>% 
	mutate(intercept =`(Intercept)`, log10gdpPercap = `log10(gdpPercap)`) %>% 
	select(continent, sex, intercept, log10gdpPercap)

# save the continent summary datatable
write_tsv(summary_data, "datatables/summary_data.tsv")

# save the continent linear regression datatable
write_tsv(fitted_models, "datatables/fitted_models.tsv")

############## FITTED MODEL AGAIN USING modelr package #####################
# for each continent look at relationship between BMI and gdpPercap in 2007
fitted_models_modelr_male = BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% # not enough data points so remove oceania
	group_by(continent, sex) %>% 
	filter(sex == "male") %>% 
	add_predictions(lm(BMI ~ log10(gdpPercap), data = ., subset = sex == "male"))

fitted_models_modelr_female = BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% # not enough data points so remove oceania
		group_by(continent, sex) %>% 
	filter(sex == "female") %>% 
	add_predictions(lm(BMI ~ log10(gdpPercap), data = ., subset = sex == "female"))

fitted_model_subset <- function(continent1, sex1){
	BMI_gapminder_2007 %>%
		filter(continent != "Oceania") %>% # not enough data points so remove oceania
		filter(sex == sex1, continent == continent1) %>% 
		add_predictions(lm(BMI ~ log10(gdpPercap), data = .))
}

Africa_m <- fitted_model_subset("Africa", "male")
Americas_m <- fitted_model_subset("Americas", "male")
Europe_m <- fitted_model_subset("Europe", "male")
Asia_m <- fitted_model_subset("Asia", "male")
Africa_f <- fitted_model_subset("Africa", "female")
Americas_f <- fitted_model_subset("Americas", "female")
Europe_f <- fitted_model_subset("Europe", "female")
Asia_f <- fitted_model_subset("Asia", "female")

fitted_models_new <- rbind.data.frame(Africa_m, Africa_f, Europe_m, Europe_f, Americas_m, Americas_f, Asia_m, Asia_f)

View(fitted_models_new)

fitted_models_modelr_combine <-  rbind.data.frame(fitted_models_modelr_male, fitted_models_modelr_female)

View(fitted_models)

fitted_models_do = BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% # not enough data points so remove oceania
	group_by(continent, sex) %>% 
	do(add_predictions(lm(BMI ~ log10(gdpPercap), data = .)))

View(fitted_models_do$pred)

# save the continent linear regression datatable
write_tsv(fitted_models_new, "datatables/fitted_models_new.tsv")


# find countries with large difference in male and female BMI
BMI_sex_differences <- BMI_gapminder_2007 %>% 
	select(country, sex, BMI) %>% 
	spread(sex, BMI) %>% 
	mutate(BMI_sex_difference = male - female) %>%
	arrange(desc(BMI_sex_difference))

# save the sex differences datatable
write_tsv(BMI_sex_differences, "datatables/BMI_sex_differences.tsv")
