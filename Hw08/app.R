#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


## can put common code here, so dont need to load libraries in both server.R and ui.R
library(shiny) 
library(tidyverse)
library(DT)


# Run the application 
shinyApp(ui = ui, server = server)

