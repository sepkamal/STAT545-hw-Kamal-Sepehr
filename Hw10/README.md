hw09\_Building your own R package
================
	
**Homework09 folder for STAT 547.**

Please see my [powers repo](https://github.com/sepkamal/powers) for my R package.

I worked off of the powers package we developed in class. I added a few new features:
- ability to handle non-numeric values ex. `"5"`
- ability to drop `NA`'s and display a warning message.
- a new function which stores the results in a dataframe, and provides a nice plot

In addition, I also added more documentation to explain things thoroughly, and tests to ensure everything was working.
 
 
# Reflection

- Initially to push my package to github, I tried the method suggested by Vincenzo using "New repo" on the github website. Even after managing to open a linux shell on my PC this method still led to errors. Therefore I followed the `devtools::use_github()` method and was successful. This involved creating an `.Renviron` file.

- This assignment was confusing at times, as there are numerous similar elements (vignettes, readme, package document...) that felt redundant. It is my understanding that these would be much more important for a large/functional package, but for the purposes of this assignment felt like overkill.

- One thing that was tricky was using `%>%`. It turns out the pipe function is not part of dplyr. dplyr itself loads the package from magrittr, therefore we need to do this too. Also due to its special characters, in order to use it I first had to load it like this ``%>%` <- magrittr::`%>%``. [This site](https://stackoverflow.com/questions/27386694/using-operator-from-dplyr-without-loading-dplyr-in-r) helped.

- I ran into a major issue where I kept getting errors saying function `data_frame()` cannot be found. This was likely as this function is from `dplyr`. The problem was I removed this function from my code a while back and replaced it with `data.frame()`, which is from base R. Yet the error message persisted and in my effort to fix it, I broke numerous other things...but it worked in the end.