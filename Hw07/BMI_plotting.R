suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(RColorBrewer))

#load BMI data
BMI_data <- read_tsv("datatables/BMI_data.tsv")

#plot a table of BMI over time for Canada, with males vs female trendlines
BMI_plot <- BMI_data %>% 
	filter(country == "Canada") %>% 
	ggplot(aes(x = year, y = BMI, colour = sex)) +
	geom_point(size = 3) + 
	geom_smooth((aes(group = sex)), method = "lm", se = FALSE) + # specifying group is neccessary b/c x-axis is a factor
	ggtitle("Mean Body Mass Index in Canada") +
	labs(y = "BMI (kg/m2)", x = "Year") +
	theme(axis.text.x=element_text(angle=45,hjust=1)) +
	theme(axis.title = element_text(size=14),
				plot.title = element_text(hjust = 0.5, size=18),
				axis.text.x = element_text(size=12),
				axis.text.y = element_text(size=12)) +
	scale_x_continuous(breaks = seq(1980, 2010, 5),
										 labels = as.character(seq(1980, 2010, 5)),
										 limits = c(1980, 2010),
										 minor_breaks = NULL) +
	scale_colour_brewer(palette="Set2")


# save the canada BMI plot
ggsave(filename = "plots/BMI_plot_canada.jpeg", 
			 plot = BMI_plot, 
			 device = "jpeg", 
			 width = 8, 
			 height = 4)


# load BMI gapminder 2007 data
BMI_gapminder_2007 <- read_tsv("datatables/BMI_gapminder_2007.tsv")

# plot BMI vs gdpPercap by continent
BMI_vs_gdpPercap_plot <- BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% # not enough data points so remove oceania
	ggplot(aes(x = gdpPercap, y = BMI, colour = sex)) +
	geom_point(size = 1) +
#	geom_point(y = predict.lm()) + 				## couldn't get this working :(
	geom_smooth(method = "lm", se = FALSE) +
	scale_x_log10() +
	facet_wrap(~ continent) +
	scale_colour_brewer(palette="Dark2") +
	theme(axis.title = element_text(size=14),
				plot.title = element_text(hjust = 0.5, size=18),
				axis.text.x = element_text(size=12),
				axis.text.y = element_text(size=12),
				strip.text = element_text(size = 12, face = "bold")) +
	labs(x = "GDP Per Capita", y = "BMI (kg/m2)") +
	ggtitle("Body Mass Index vs GDP per Capita by Country (2007)")

# save the gdpPercap vs BMI plot
ggsave(filename = "plots/BMI_vs_gdpPercap_plot.jpeg", 
			 plot = BMI_vs_gdpPercap_plot, 
			 device = "jpeg", 
			 width = 9, 
			 height = 4)

####### PLOT BMI vs gdpPERCAP AGAIN USING modelr

# load datatable with fitted model
fitted_models_new <- read_tsv("datatables/fitted_models_new.tsv")

View(fitted_models_modelr)

# plot BMI vs gdpPercap by continent
BMI_vs_gdpPercap_plot <- 
	
BMI_gapminder_2007 %>%
	filter(continent != "Oceania") %>% # not enough data points so remove oceania
	ggplot(aes(x = gdpPercap, y = BMI, colour = sex)) +
	geom_point(size = 1) +
	scale_x_log10() +
	geom_line(data = fitted_models_new, aes(y = pred, colour = sex), size = 1) +
	facet_wrap(~ continent) +
	scale_colour_brewer(palette="Dark2") +
	theme(axis.title = element_text(size=14),
				plot.title = element_text(hjust = 0.5, size=18),
				axis.text.x = element_text(size=12),
				axis.text.y = element_text(size=12),
				strip.text = element_text(size = 12, face = "bold")) +
	labs(x = "GDP Per Capita", y = "BMI (kg/m2)") +
	ggtitle("Body Mass Index vs GDP per Capita by Country (2007)")

# save the gdpPercap vs BMI plot
ggsave(filename = "plots/BMI_vs_gdpPercap_plot.jpeg", 
			 plot = BMI_vs_gdpPercap_plot, 
			 device = "jpeg", 
			 width = 9, 
			 height = 4)


# make histogram of BMI in 2007
BMI_histogram <- BMI_gapminder_2007 %>% 
	ggplot(aes(BMI, fill = sex)) +
	facet_wrap(~ sex) +
	geom_histogram(bins = 25) +
	geom_vline(aes(xintercept = mean(BMI)), 
								 colour = 1, 
								 size = 3) +
	theme(legend.position = "none") +
	theme(axis.title = element_text(size=14),
				plot.title = element_text(hjust = 0.5, size=18),
				axis.text.x = element_text(size=12),
				axis.text.y = element_text(size=12),
				strip.text = element_text(size = 12, face = "bold")) +
	labs(x = "BMI (kg/m2)", y = "number of countries") +
	ggtitle("Distribution of Body Mass Index by Country (2007)") +
	scale_fill_brewer(palette="Dark2")

# save the histogram
ggsave(filename = "plots/BMI_histogram.jpeg", 
			 plot = BMI_histogram, 
			 device = "jpeg", 
			 width = 8, 
			 height = 4)





