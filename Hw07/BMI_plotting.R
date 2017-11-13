
#load BMI data
BMI_data <- read_tsv("datatables/BMI_data.tsv")

#plot a table of BMI over time for Canada, with males vs female trendlines
BMI_plot <- BMI_data %>% 
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

ggsave(filename = "plots/BMI_plot_canada.jpeg", plot = BMI_plot, device = "jpeg", width = 10)