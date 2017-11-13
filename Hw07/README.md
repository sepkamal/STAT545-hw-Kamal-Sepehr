hw07\_readme
================

Homework07 folder for STAT 545.

See the  file []() for my assignment.

# Reflection

The BMI data was taken from the [gapminder website](http://www.gapminder.org/data/), which references the MRC-HPA Centre for Environment and Health. The data is provided as a google sheet, so downloading it was a bit tricky. Luckily there is a package `gsheet` which helps download google sheets in R.

The BMI data was provided seperately for males and females, so I downloaded both files.

I found [this stackoverflow page](https://stackoverflow.com/questions/3220277/what-do-the-makefile-symbols-and-mean) useful for how to simplify my `Makefile` syntax.

[This site](https://stackoverflow.com/questions/10357768/plotting-lines-and-the-group-aesthetic-in-ggplot2) was helpful for explaning why my `geom_smooth` wouldn't put a line on my graph until I specified `group = sex`. It has to do with the x-axis being a factor.



