
# load packages
library(shinythemes)
library(shinyjs)



# loading screen app
appCSS <- "
#loading-content {
  position: absolute;
  background: #FFFF00;
  opacity: 0.9;
  z-index: 100;
  left: 0;
  right: 0;
  height: 100%;
  text-align: center;
  color: #FFFFFF;
}
"


ui <- fluidPage(
	
	# run the loading screen 
	useShinyjs(),
	inlineCSS(appCSS),
	
	# Loading message for the loading screen
	div(
		id = "loading-content",
		h2("Loading...")
	),
	
	# apply shinytheme to format style of website
	theme = shinytheme("journal"),
	
	# large title for website
	textOutput('title'),
	tags$head(tags$style("#title{color: blue;
                                 font-size: 80px;
                                 font-style: bold;
                                 text-align:center;
															   background-color: yellow;
                                 }")
	),
	
	# make sidebar
	sidebarPanel(
		
		     h3("Please use the options below to filter the data"),
				
				 # slider to filter countries based on population size
				 sliderInput("popIn", 
				 			"Population Size (in millions)", 
				 			min = 0, 
				 			max = 1500, 
				 			value =  c(0,1500), 
				 			post = " million"),
				 
				 # select which continents to display
				 checkboxGroupInput("typeIn_continent", 
				 		     "Which Continent?", 
				 			 choices = c("Africa", "Americas", "Asia", "Europe", "Oceania"),
				 			 selected = c("Africa", "Americas", "Asia", "Europe", "Oceania")),
				 
			   # select which sex to display
				 checkboxGroupInput("typeIn_sex", "Which Sex?",
			     			 choices = c("male", "female"),
			     			 selected = c("male", "female")),
				 
				 # select colour to use in the histogram
				 colourInput("col", "Select histogram colour", "blue"),
				 
				 # text displaying the number of entries that meet the input parameters
				 textOutput('sidebar_text')
				 
	),
	
	mainPanel(
		# use tabsetPanel to show each item on seperate tabs      
		tabsetPanel(
		      	          tabPanel("BMI histogram", plotOutput("Hist_BMI")),
		      	          tabPanel("BMI table", dataTableOutput("table_head")),
		      	          tabPanel("About",
				      	          		 
				      	          		 # initial block of text with author info
		      	          				 uiOutput('about_text1'),
		      	          				 tags$head(tags$style("#about_text1{color: black;
                                 font-size: 18px;
                                 text-align:left;
                                 }")
		      	          				 ),
		      	          				 
		      	          				
				      	          		 
		      	          				 # section header
		      	          				 h1("Data Source and Download"),
		      	          				 
		      	          				 # text to link to the gapminder website
		      	          				 uiOutput("url_link"),
		      	          				 tags$head(tags$style("#url_link{color: black;
                                 font-size: 18px;
                                 text-align:left;
                                 }")
		      	          				 ),
		      	          				 
		      	          				 # text describing data and download info
		      	          				 textOutput('about_text2'),
		      	          				 tags$head(tags$style("#about_text2{color: black;
                                 font-size: 18px;
                                 text-align:left;
                                 }")
		      	          				 ),
				      		 
				      	          		 # clickable button to download the filtered dataset
				      	          		 downloadButton("downloadData", 'Download Filtered BMI Data'),

				      	          		 # cat picture showing importance of BMI
				      	          		 img(src = "kitten.png", width = "100%"))
						  )
))
