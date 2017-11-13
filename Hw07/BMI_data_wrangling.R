# Exploratory analysis


suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(reshape2))

# load male data
BMI_male <- readRDS("datatables/BMI_male.rds") 

# display initial format
BMI_male %>% 
	head()

# tidy data using reshape2
BMI_male <- BMI_male %>% 
	mutate(sex = "male") %>% # so we can distinguish male and female after joining the dataframes
	melt() # rshape columns into rows 

# load female data and tidy
BMI_female <- readRDS("datatables/BMI_female.rds")%>% 
	mutate(sex = "female") %>% 
	melt()


str(BMI_female)

str(BMI_male)

## confirms the two dataframes are identical in size and format

# merge the male and female dataframes
# I had some trouble renaming the columns,
# so I found it easier to make new columns and then drop the old ones

BMI_data <- rbind.data.frame(BMI_male, BMI_female) %>% 
	mutate(country = Country, 
				 sex = sex, 
				 year = variable, 
				 BMI = value) %>% 
	select(country, sex, year, BMI)

write_tsv(BMI_data, "datatables/BMI_data.tsv")



# load main gapminder data & select just data from 2007
gapminder_2007 <- read_tsv("datatables/gapminder_data.tsv") %>% 
	filter(year == 2007)

# filter BMI data to just 2007 and remove the column year
BMI_data_2007 <- BMI_data %>% 
	filter(year == 2007) %>% 
	select(country, sex, BMI)

# join main gapminder with BMI data for 2007
BMI_gapminder_2007 <- inner_join(gapminder_2007, BMI_data_2007, by = "country")

# save the data table
write_tsv(BMI_gapminder_2007, "datatables/BMI_gapminder_2007.tsv")
	




