Hw07\_Automating Data-analysis Pipelines
================

The overall aim of this assignment is to **look for trends in the gapminder data using body mass index (BMI) as a measure of obesity**. I thought this would be an interesting idea as I work in a diabetes research lab. I was originally going to use diabetes prevalence as I did in [homework04](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw04/hw04-tidaydata.md), but then I found a nice BMI dataset on the [gapminder website](http://www.gapminder.org/data/), which references the MRC-HPA Centre for Environment and Health.

The BMI data is provided as a google sheet, so downloading it was a bit tricky. Luckily there is a package `gsheet` which helps download google sheets in R. The BMI data was provided separately for males and females, so I downloaded both files.

Here is a sample of the BMI data from the google sheet(after a bit of reformatting):

``` r
suppressMessages(library(tidyverse))
```

    ## Warning: package 'tidyverse' was built under R version 3.4.2

``` r
suppressMessages(knitr::kable(read_tsv("datatables/BMI_data.tsv.")
                                                            %>% head(5)))
```

| country     | sex  |  year|       BMI|
|:------------|:-----|-----:|---------:|
| Afghanistan | male |  1980|  21.48678|
| Albania     | male |  1980|  25.22533|
| Algeria     | male |  1980|  22.25703|
| Andorra     | male |  1980|  25.66652|
| Angola      | male |  1980|  20.94876|

![logo](https://raw.githubusercontent.com/sepkamal/STAT545-hw-Kamal-Sepehr/master/Hw07/plots/BMI_plot_canada.jpeg)

This plot shows the trend in BMI in Canada from 1980 to 2008. Male BMI is consistently higher than female BMI, and both trend upwards in a somewhat linear fashion. It would be very interesting to see how this has changed more recently (between 2008 and 2017).

I was curious how 'normal' this difference in BMI between males and females is. This table shows us the top 5 countries with male BMI higher than female BMI.

``` r
suppressMessages(knitr::kable(caption = "Countries with largest BMI difference between males and females",
                                                            x = read_tsv("datatables/BMI_sex_differences.tsv") %>%
                                                          head(5)))
```

| country     |    female|      male|  BMI\_sex\_difference|
|:------------|---------:|---------:|---------------------:|
| Switzerland |  24.06285|  26.13979|               2.07694|
| Italy       |  24.78988|  26.40849|               1.61861|
| Japan       |  21.88134|  23.44693|               1.56559|
| Belgium     |  25.14489|  26.67529|               1.53040|
| Germany     |  25.70588|  27.09050|               1.38462|

The difference for Canada was about 0.5, so compared to these other countries I guess it's not that extreme. Switzerland has the largest discrepancy between males and females.

I wasn't able to get the table caption to show up even after a fair bit of google searching so I gave up.

![logo](https://raw.githubusercontent.com/sepkamal/STAT545-hw-Kamal-Sepehr/master/Hw07/plots/BMI_histogram.jpeg)

This plot shows the distribution of body mass index in 2007 by country. Interestingly we can see that the distributions are not normal, especially for the male BMI which looks bi-modal. The mean values are indicated by the vertical line.

Next I combined the BMI data with the rest of the gapminder data. Here is a sample of the data:

``` r
suppressMessages(knitr::kable(read_tsv("datatables/BMI_gapminder_2007.tsv") %>% 
                                                         head(5)))
```

| country     | continent |  year|  lifeExp|       pop|  gdpPercap| sex    |       BMI|
|:------------|:----------|-----:|--------:|---------:|----------:|:-------|---------:|
| Afghanistan | Asia      |  2007|   43.828|  31889923|   974.5803| male   |  20.60246|
| Afghanistan | Asia      |  2007|   43.828|  31889923|   974.5803| female |  20.99060|
| Albania     | Europe    |  2007|   76.423|   3600523|  5937.0295| male   |  26.32753|
| Albania     | Europe    |  2007|   76.423|   3600523|  5937.0295| female |  25.59394|
| Algeria     | Africa    |  2007|   72.301|  33333216|  6223.3675| male   |  24.48846|

I wanted to look at each continent separately. Here we can see some summary statistics.

``` r
suppressMessages(knitr::kable(read_tsv("datatables/summary_data.tsv")))
```

| continent | sex    |  mean\_BMI|  median\_BMI|  min\_BMI|  max\_BMI|
|:----------|:-------|----------:|------------:|---------:|---------:|
| Africa    | female |   24.01483|     23.43311|  20.61484|  29.95573|
| Africa    | male   |   22.54820|     22.18523|  19.82910|  26.64671|
| Americas  | female |   27.01804|     26.93672|  23.16703|  30.08747|
| Americas  | male   |   25.95866|     25.90416|  23.58323|  28.37574|
| Asia      | female |   24.66674|     23.38390|  20.40963|  31.01442|
| Asia      | male   |   24.04743|     23.92079|  20.35493|  29.00300|
| Europe    | female |   25.68356|     25.60437|  24.06285|  28.18455|
| Europe    | male   |   26.57390|     26.49896|  25.28747|  27.57676|

I also performed a linear regression analysis for each country, with males and females separately:

``` r
suppressMessages(knitr::kable(read_tsv("datatables/fitted_models.tsv") %>% 
                                                                head(5)))
```

| continent | sex    |  intercept|     slope|
|:----------|:-------|----------:|---------:|
| Africa    | female |   12.00731|  3.698325|
| Africa    | male   |   14.20856|  2.568614|
| Americas  | female |   17.64769|  2.388128|
| Americas  | male   |   14.13017|  3.014611|
| Asia      | female |   14.84115|  2.588361|

I had **A LOT** of trouble getting the linear model to show on the graph. The challenge was because we don't have just one model, we have 8. And it needs to behave well with the faceting. Eventually I got it working using the `add_predictions()` function from the `modelr` package. The only way it would run correctly was to run it 8 separate times, once for each continent and sex pair. Here is the table, the `pred` column contains the predictions made by `add_predictions()`.

``` r
suppressMessages(knitr::kable(read_tsv("datatables/fitted_models_modelr.tsv") %>% 
                                                                head(5)))
```

| country      | continent |  year|  lifeExp|       pop|  gdpPercap| sex  |       BMI|      pred|
|:-------------|:----------|-----:|--------:|---------:|----------:|:-----|---------:|---------:|
| Algeria      | Africa    |  2007|   72.301|  33333216|   6223.367| male |  24.48846|  23.95395|
| Angola       | Africa    |  2007|   42.731|  12420476|   4797.231| male |  22.08962|  23.66361|
| Benin        | Africa    |  2007|   56.728|   8078314|   1441.285| male |  22.33366|  22.32217|
| Botswana     | Africa    |  2007|   50.728|   1639131|  12569.852| male |  21.98606|  24.73816|
| Burkina Faso | Africa    |  2007|   52.295|  14326203|   1217.033| male |  21.18575|  22.13352|

Next I plotted this with my linear models displaying correctly:

![logo](https://raw.githubusercontent.com/sepkamal/STAT545-hw-Kamal-Sepehr/master/Hw07/plots/BMI_vs_gdpPercap_plot.jpeg)

This plot was my main goal of the assignment. Here we are analyzing whether there is a relationship between BMI and per capital GDP. As I expected, it seems there is a positive linear correlation between BMI and log10 per capita GDP. I guess this could be summed up by saying...the richer you are, the fatter you are :thumbsup:

The relationship is present in 3 of the 4 continents (Oceania was not analyzed due to insufficient data). Europe seems to be the exception, and here there may even be a slight negative correlation for females. This is something that public health officials should note and try to figure out what the Europeans are doing better than the rest of us.

Males seem to have a higher BMI than females in Europe, but females are higher in the other 3 continents.
