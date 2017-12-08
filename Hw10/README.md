hw10\_Data from the Web
================
	
**Homework10 folder for STAT 547.**

For this assignment, I scraped movie data from [imdb.com](http://www.imdb.com/?ref_=nv_home).

Please see my homework assignment [HW10_Scraping_data_from_web.md](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw10/HW10_Scraping_data_from_web.md)
 
# Reflection

- [This site](https://stackoverflow.com/questions/2851015/convert-data-frame-columns-from-factors-to-characters) helped with converting columns from type factor to chr.

- I noticed I was referring back to my previous homework assignments quite a few times to check how to do little things like edit strings, specific ggplot2, etc.

- I struggled **A LOT** with extracting the Gross USA earnings per movie. Some of the issues included: finding the html item that contained the data,  data in the wrong format (factors), extracting numbers from a string of text, and dealing with movies that did not have a gross USA earnings listed. I solved this last problem by using an if statement.

- [This site](https://stackoverflow.com/questions/14543627/extracting-numbers-from-vectors-of-strings) helped me figure out a way to extract the gross earnings from the string using `parse_number()`.

- While my code was working well in RStudio, During knitting I started to get an endless stream of errors. I turned out there were 2 reasons. One is due to poor code that appears to work, but actually doesn't work if you clear your environment. The other reason is that the website changed since the morning, so I had to make subtle changes in my code in order to pull extract the write items from the html.
 

- I think it was a bad idea to perform this assignemnt in a .Rmd. It would have been better to use several R scripts and automate the process. This would allow running entire code chunks fresh, and also would be a way to avoid having to rerun chunks of code that take a very long time to process (due to needing to query 250 websites...)

WOOHOOO!!!! STAT 547 is over!!!

![logo](https://i.pinimg.com/originals/79/74/6b/79746bf8ed9e5451bfe5b84067e642c4.jpg)