hw07\_readme
================
	
Homework07 folder for STAT 545.

See [Hw07_automating_data_analysis_pipelines.md](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/8069721e2e6b2ffa9cd80d6f3c549d72471abe38/Hw07/Hw07_automating_data_analysis_pipelines.md) for my main assignment.

Here are the 3 scripts, in the order in which they are run:
 - [BMI_data_wrangling.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/BMI_data_wrangling.R)
 - [BMI_statistical_analysis.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/BMI_statistical_analysis.R)
 - [BMI_plotting.R](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/BMI_plotting.R)
 
 And the `Makefile` that downloads the data, runs the scripts, and renders the .md file:
 - [Makefile](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw07/Makefile)

# Reflection

- I found [this stackoverflow page](https://stackoverflow.com/questions/3220277/what-do-the-makefile-symbols-and-mean) useful for how to simplify my `Makefile` syntax.

- [This site](https://stackoverflow.com/questions/10357768/plotting-lines-and-the-group-aesthetic-in-ggplot2) was helpful for explaning why my `geom_smooth` wouldn't put a line on my graph until I specified `group = sex`. It has to do with the x-axis (year) being a factor.

- [This site](https://stackoverflow.com/questions/1169539/linear-regression-and-group-by-in-r) was helpful for my linear regression analysis.

- This was a surprisingly enjoyable assingment to put together, especially after [homework 06](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw06/HW6_Data_wrangling_wrap_up.md) became a bit of a nightmare.

- I found myself repeadtedly reffering to my previous HW assingments when trying to remember how to do something. This was especially true for ggplot. I have a feeling these assignments will be a great resource for myself beyond this class.

- In my make file, under `clean:` I used `*.tsv` or `*.md` to delete all the files to start fresh. This got me in trouble, however, as I accidentaly deleted this readme file! So I had to be more specific for the `.md` extension, but it was very convienent for the others.

- I found adding `clean` to my `all:` line in the makefile ensured `clean` ran everytime and so everything started fresh.

![logo](https://i.imgflip.com/1wj55o.jpg)
