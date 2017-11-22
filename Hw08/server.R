# Define server logic required to draw a histogram

# folder my_new_app and all datafiles is uploaded onto server
# so should put data in the project folder



library(tidyverse)
library(RColorBrewer)


server <- function(input, output) {
	BMI_data <- read_tsv("data/BMI_gapminder_2007.tsv")
	
	filtered_BMI_data <- reactive({
		BMI_data %>%
		filter(pop >= (input$popIn[1] * 1000000),
			   pop <= (input$popIn[2]  * 1000000),
			   continent %in% input$typeIn_continent,
			   sex %in% input$typeIn_sex)
	})
	
	output$Hist_BMI <- renderPlot({

		filtered_BMI_data() %>%  ### need to but brackets b/c are calling a function
			ggplot(aes(x = BMI)) +
		    geom_histogram(bins = 10, fill = 4) +
		    ggtitle("BMI 2007 Histogram") +
			facet_wrap(~ sex) +
			geom_vline(aes(xintercept = mean(BMI)), 
					   colour = 2, 
					   size = 3) +
			theme(axis.title = element_text(size=20),
				 plot.title = element_text(hjust = 0.5, size=30),
				 axis.text.x = element_text(size=16, face = "bold"),
				 axis.text.y = element_text(size=16, face = "bold"),
				 strip.text = element_text(size = 20, face = "bold")) +
			labs(x = "BMI (kg/m2)", y = "Number of countries") 
			#scale_fill_brewer(palette="Dark2")
			
	})
	
	output$table_head <- renderDataTable({
		filtered_BMI_data()
	}) 
	
	# Downloadable csv of selected dataset ----
	output$downloadData <- downloadHandler(
		filename = "Filtered_BMI_data.csv",
		content = function(file) {
			write.csv(filtered_BMI_data(), file, row.names = FALSE)
		}
	)
	
	#url
	url <- a("Gapminder Data", href="http://www.gapminder.org/data/")
	output$tab <- renderUI({
		tagList("National BMI data provided by", url)
	})
	
}