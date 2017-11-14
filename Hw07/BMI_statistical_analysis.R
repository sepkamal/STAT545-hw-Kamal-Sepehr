suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(broom))

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
	filter(continent != "Oceania") %>% 
	group_by(continent, sex) %>% 
	do(model = lm(BMI ~ log10(gdpPercap), data = .))
	#tidy(model)


View(fitted_models$model)







# find countries with large difference in male and female BMI
BMI_sex_differences <- BMI_gapminder_2007 %>% 
	select(country, sex, BMI) %>% 
	spread(sex, BMI) %>% 
	mutate(BMI_sex_difference = male - female) %>%
	arrange(desc(BMI_sex_difference))

# save the table
write_tsv(BMI_sex_differences, "datatables/BMI_sex_differences.tsv")
