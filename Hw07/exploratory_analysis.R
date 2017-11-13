# Exploratory analysis


suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(reshape2))

# load male data
BMI_male <- readRDS("BMI_male.rds") 

# display initial format
BMI_male %>% 
	head()

# tidy data and load female data too
BMI_male <- BMI_male %>% 
	mutate(sex = "male") %>% # so we can distinguish male and female after joining the dataframes
	melt() # rshape columns into rows 

BMI_female <- readRDS("BMI_female.rds")%>% 
	mutate(sex = "female") %>% 
	melt()


str(BMI_female)

str(BMI_male)

## confirms the two dataframes are identical in size and format




BMI_data <- rbind.data.frame(BMI_male, BMI_female) %>% 
	mutate(country = Country, 
				 sex = sex, 
				 year = variable, 
				 BMI = value) %>% 
	select(country, sex, year, BMI)

# I had some trouble renameing the columns, so I found it easier to make new columns and then drop the old ones

head(BMI_data)

BMI_data %>% 
	filter(country == "Canada") %>% 
	ggplot(aes(x = year, y = BMI, colour = sex)) +
  geom_point(size = 2) + 
	geom_smooth((aes(group = sex)), method = "lm") + # specifying group is neccessary b/c x-axis is a factor
	ggtitle("Mean Body Mass Index in Canada") +
	labs(y = "BMI (kg/m2)", x = "Year") +
	theme(axis.text.x=element_text(angle=45,hjust=1)) +
	theme(axis.title = element_text(size=14),
				plot.title = element_text(hjust = 0.5, size=18),
				axis.text.x = element_text(size=12),
				axis.text.y = element_text(size=12))
	
	
