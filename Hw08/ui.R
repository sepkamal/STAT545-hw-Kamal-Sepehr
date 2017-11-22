

# Define UI for application that draws a histogram


ui <- fluidPage(
	
	# Application title
	titlePanel("Body Mass Index (BMI) Explorer"),
	
	sidebarPanel("Please use the options below to filter the data",
				
				 sliderInput("popIn", 
				 			"Population Size (million)", 
				 			min = 0, 
				 			max = 1500, 
				 			value =  c(0,1500), 
				 			post = " million"),
				 
				 checkboxGroupInput("typeIn_continent", 
				 		     "Which Continent?", 
				 			 choices = c("Africa", "Americas", "Asia", "Europe", "Oceania"),
				 			 selected = c("Africa", "Americas", "Asia", "Europe", "Oceania")),
				 
			     checkboxGroupInput("typeIn_sex", "Which Sex?",
			     			 choices = c("male", "female"),
			     			 selected = c("male", "female")),
				 
				 
				 uiOutput("tab"),
				 
				 "Please use the button below to download the filtered dataset",
				 
				 downloadButton("downloadData", 'Download Filtered BMI Data'),
				 
				 
				 
				 
				 img(src = "kitten.png", width = "100%")
				 
				 
	),
	
	mainPanel(
		      tabsetPanel(
		      	          tabPanel("BMI histogram", plotOutput("Hist_BMI")),
		      	          tabPanel(br(),br()),
		      	          tabPanel("BMI table", dataTableOutput("table_head"))
						  )
))


#img(src = "BMI_histogram.jpeg", width = "100%"),
#img(src = "BMI_plot_canada.jpeg", width = "100%")