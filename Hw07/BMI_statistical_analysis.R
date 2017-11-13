suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(broom))

# load BMI gapminder 2007 data
BMI_gapminder_2007 <- read_tsv("datatables/BMI_gapminder_2007.tsv")

BMI_gapminder_2007


# for each continent look at relationship between BMI and gdpPercap in 2007
linear_model_func <- function(continent_choose){
	BMI_gapminder_2007 %>% 
		filter(continent == continent_choose) %>% 
	  lm(BMI ~ log10(gdpPercap), BMI_gapminder_2007)

}

summary_data <- BMI_gapminder_2007 %>% 
	filter(sex == "male") %>% 
	group_by(continent) %>%
	summarise(mean_BMI = mean(BMI), 
						median_BMI = median(BMI))

fitted_models = BMI_gapminder_2007 %>%
	group_by(continent, sex) %>% 
	do(model = lm(BMI ~ log10(gdpPercap), data = .))

linear_model_tidy <- tidy(linear_model)

fitted_models %>% tidy(model)

View(fitted_models)


# make histogram of BMI in 2007
BMI_gapminder_2007 %>% 
	
	

# for each country fit linear model of change in BMI over time
BMI_data