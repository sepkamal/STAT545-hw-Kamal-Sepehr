


## can put common code here, so dont need to load libraries in both server.R and ui.R
library(shiny) 
library(tidyverse)
library(DT)



# Run the application 
shinyApp(ui = ui, server = server)
