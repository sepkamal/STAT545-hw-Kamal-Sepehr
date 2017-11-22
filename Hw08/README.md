hw08\_readme
================
	
Homework08 folder for STAT 545.

Please see [Shiny App website](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/Hw07_automating_data_analysis_pipelines.md) for my main assignment. In this shiny app, I explore the BMI data in the expanded gapminder dataset for the year 2007. I previously used/created this datatable in [homework07](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/tree/master/Hw07).

I based the intial framework of the shiny app off of the BC liquor data app we developed in class.

Here are the scripts that created my shiny app:
 - [server.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/BMI_data_wrangling.R)
 - [ui.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/BMI_statistical_analysis.R)
 - [app.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/BMI_plotting.R)
 
# Reflection

- I found debugging to be quite painful for this assignment, because we are running the entire app at once and so it is hard to isolate the bug. Sometimes the shiny app wouldn't load, and the error message didn't give much info about what the problem was. A few times it turned out to be due to a misplaced comma, which I figured out with help from [this site](https://stackoverflow.com/questions/22626412/error-in-rshiny-ui-r-argument-missing).

- [This site](https://gist.github.com/wch/9630481) helped me get the download button working.


