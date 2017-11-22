# load packages



server <- function(input, output) {
	# load data from file
	BMI_data <- read_tsv("data/BMI_gapminder_2007.tsv")
	
	# filter data based on user input
	filtered_BMI_data <- reactive({
		BMI_data %>%
		filter(
			   # filter by population size in millions
			   pop >= (input$popIn[1] * 1000000),
			   pop <= (input$popIn[2]  * 1000000),
			   
			   #filter by continent
			   continent %in% input$typeIn_continent,
			   
			   #filter by sex
			   sex %in% input$typeIn_sex)
	})
	
	########### make the histogram with ggplot2 ##################
	output$Hist_BMI <- renderPlot({
		filtered_BMI_data() %>%  ### need to but brackets b/c are calling a function
			ggplot(aes(x = BMI)) +
		    geom_histogram(bins = 10, fill = input$col) +
		    ggtitle("BMI 2007 Histogram") +
			facet_wrap(~ sex) +
			geom_vline(aes(xintercept = mean(BMI)), 
					   colour = 2, 
					   size = 3) +
			theme(axis.title = element_text(size=20),
				 plot.title = element_text(hjust = 0.5, size=30),
				 axis.text.x = element_text(size=16, face = "bold"),
				 axis.text.y = element_text(size=16, face = "bold"),
				 strip.text = element_text(size = 20, face = "bold"),
				 plot.caption = element_text(size = 16)) +
			labs(x = "BMI (kg/m2)", 
				 y = "Number of countries",
				 caption = "Data modifed from Gapminder.\nThe red line indicates the mean.") 
			
	})
	
	# make interactive datatable using DT package
	output$table_head <- renderDataTable({
		filtered_BMI_data()
	}) 
	
	# Downloadable csv file of filtered dataset
	output$downloadData <- downloadHandler(
		filename = "Filtered_BMI_data.csv",
		content = function(file) {
			write.csv(filtered_BMI_data(), file, row.names = FALSE)
		}
	)
	
	# URL link to gapminder website (original datasource)
	url <- a("Gapminder Data", href="http://www.gapminder.org/data/")
	output$url_link <- renderUI({
		tagList("National BMI data provided by", url, "for the year 2007.")
	})
	
	#### title of the website
	output$title <- renderText({ "Body Mass Index (BMI) Explorer" })
	
	
    #### text for the 'about' tab
	url2 <- a("here", href="https://www.linkedin.com/in/sepehr-kamal-5b58b8a7/")
	output$about_text1 <- renderUI({ 
									tagList("This Shiny App was created by Sepehr Kamal for STAT 547 at 
                                             the University of British Columbia (UBC).
		                                     \nYou can find out more about Sepehr", url2)
		                           })
	output$about_text2 <- renderText({ "Please use the button below to download the BMI
		                                data with the current filtering settings. \n" })
	
	
	########## Loading screen #############
	# Simulate work being done for 1 second (for the loading screen)
	Sys.sleep(1)
	# Hide the loading message when the rest of the server function has executed
	hide(id = "loading-content", anim = TRUE, animType = "slide", time = 1 )    
	show("app-content")
	
	
	
}