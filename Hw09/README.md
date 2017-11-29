hw08\_Building your own R package
================
	
**Homework09 folder for STAT 547.**

Please see my **[powers repo]**(https://github.com/sepkamal/powers) for my R package.

I worked off of the powers package we developed in class. I added a couple new features:
- ability to handle non-numeric values ex. `"5"`
- ability to drop `NA`'s and display a warning message.
- a new function which stores the results in a dataframe, and provides a nice plot
 
 
# Reflection

- Initially to push my package to github, I tried the method suggested by Vincenzo using "New" on the github website. Even after managing to open a linux shell on my PC this method still led to errors. Therefore I followed the `devtools::use_github()` method and was successful. This involved creating an `.Renviron` file.

- I woulnd't say this assignment was too hard, but it was confusing at times, as there are numerous similar elements (vignettes, readme, package document...) that felt redundant. It is my understanding that these would be much more important for a large/functional package, but for the purposes of this assignment was overkill.

- One thing that was tricky was using `%>%`. It turns out this pipe function is not part of dplyr. Dplyr itself load the package from magrittr, therefore we need to do this too. Also due to its special characters, in order to use it I first had to load it like this ``%>%` <- magrittr::`%>%``.