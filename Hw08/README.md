hw08\_Building Shiny apps
================
	
**Homework08 folder for STAT 547.**

Please see my website here: [Shiny App website](https://sepkamal.shinyapps.io/Body_Mass_Index_Explorer/). 

In this shiny app, I explore the BMI data in the expanded gapminder dataset for the year 2007. I previously used/created this datatable in [homework07](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/tree/master/Hw07). I based the intial framework of the shiny app off of the BC liquor data app we developed in class.

Here are the scripts that created my shiny app:
 - [server.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw08/server.R)
 - [ui.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw08/ui.R)
 - [app.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw08/app.R)
 
# Reflection

- I found debugging to be quite painful for this assignment, because we are running the entire app at once and so it is hard to isolate the bug. Sometimes the shiny app wouldn't load, and the error message didn't give much info about what the problem was. A few times it turned out to be due to a misplaced comma, which I figured out with help from [this site](https://stackoverflow.com/questions/22626412/error-in-rshiny-ui-r-argument-missing).

- [This site](https://gist.github.com/wch/9630481) helped me get the download button working.

- [This site](https://stackoverflow.com/questions/42047422/create-url-hyperlink-in-r-shiny) helped with inserting a link to the gapminder website.

- My Shiny app is definetely not perfect, and I would have liked to host it on my own shiny server, but I didn't want to pay for a website.

- I added a feature that shows a black screen while the shiny app is loading. I used the code from this [github page(https://github.com/daattali/advanced-shiny/tree/master/loading-screen)

- As I added more features, it quickly became clear how confusing the server.R and ur.R code can become. One way to make it cleaner would be using a separate CSS file in the `www` folder to store the formatting information. 

