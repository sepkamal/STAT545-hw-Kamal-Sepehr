hw10\_Data from the Web
================
	
**Homework10 folder for STAT 547.**

For this assignment, I scraped movie data from [imdb.com](http://www.imdb.com/?ref_=nv_home).

Please see my homework assignemnt here 
 
# Reflection

- [This site](https://stackoverflow.com/questions/2851015/convert-data-frame-columns-from-factors-to-characters) helped with converting columns from type factor to chr.

- I noticed I was referring back to my previous homework assignments quite a few times to check how to do little things like edit strings, specific ggplot2, etc.

- I struggled **A LOT** with extracting the Gross USA earnings per movie. Some of the issues included: finding the html item that contained the data,  data in the wrong format (factors), extracting numbers from a string of text, and dealing with movies that did not have a gross USA earnings listed. I solvd this last problem by using an if statement.

- [This site](https://stackoverflow.com/questions/14543627/extracting-numbers-from-vectors-of-strings) helped me figure out a way to extract the gross earnings from the string using `parse_number()`.
 

WOOHOOO!!!! STAT 547 is over!!!

![logo](https://i.pinimg.com/originals/79/74/6b/79746bf8ed9e5451bfe5b84067e642c4.jpg)