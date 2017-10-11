Homework 04: Tidy data and joins
================

Load Packages:

``` r
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(gapminder))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(tidyverse))
```

Activity \#2
------------

Make a tibble with one row per year and columns for life expectancy for two or more countries. Use knitr::kable() to make this table look pretty in your rendered homework. Take advantage of this new data shape to scatterplot life expectancy for one country against that of another.

``` r
one_row_per_year <- gapminder %>%
  select(year, country, lifeExp) %>% 
  ### Filter down to two countries
  filter(country %in% c("Canada", "Iran")) %>% 
  ### create 2 columns with lifeExp values
  spread(key = country, value = lifeExp) %>%
  ## rename columns to indicate what values correspoind to 
  rename(Canada_lifeExp = Canada, Iran_lifeExp = Iran) %>%   
  arrange(year)


kable(one_row_per_year, align ="r", digit = 0)
```

|  year|  Canada\_lifeExp|  Iran\_lifeExp|
|-----:|----------------:|--------------:|
|  1952|               69|             45|
|  1957|               70|             47|
|  1962|               71|             49|
|  1967|               72|             52|
|  1972|               73|             55|
|  1977|               74|             58|
|  1982|               76|             60|
|  1987|               77|             63|
|  1992|               78|             66|
|  1997|               79|             68|
|  2002|               80|             69|
|  2007|               81|             71|

Now we can graph this as a scatterplot. I am taking the instructions literally, aka each axis is the lifeExp for one of the countries (x axis is not years).

``` r
one_row_per_year %>% 
  ggplot(aes(x = Iran_lifeExp, y = Canada_lifeExp, colour = factor(year) )) +
  geom_point(size = 4) +
  geom_smooth(colour = 1, method = 'lm', se = FALSE) +
  ggtitle("Life expectancy (in years) of Canada vs. Iran between 1952-2007 ") +
  scale_x_continuous(labels = as.character(seq(40, 75, 5)),
                     breaks = seq(40, 75, 5), 
                     limits = c(40, 75),
                     minor_breaks = NULL) +
  theme(legend.title = element_blank())
```

![](hw04-tidaydata_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-1.png)

I tried to get the legend title to read years instead of factor(years) but couldn't, so I just removed it. Anyways, we can see a strong linear relationship between the life expectancy increase of Iran and Canada over the years.

### Part 1 reflection

I was stuck on this for a while trying to use gather. Then I thought about trying to make to seperate tables and then joing the two tables together. Then realized a similar thing could actually work with spread! After that it was pretty easy, and I've gotten quite familiar with ggplot at this point (though it seems there's always more features that could be added to a plot).

Join, merge, look up
--------------------

Create a second data frame, complementary to Gapminder. Join this with (part of) Gapminder using a dplyr join function and make some observations about the process and result. Explore the different types of joins.

``` r
diabetes_rates <- read.csv("diabtes_ratesedit.csv") %>% 
  rename(country = Country_Name) ### so it has same column name as gapminder

head(diabetes_rates, 20)
```

    ##                 country Diabetes_prevalance_2015
    ## 1                 Aruba                 11.70000
    ## 2           Afghanistan                  8.80000
    ## 3                Angola                  4.10000
    ## 4               Albania                 10.30000
    ## 5               Andorra                  8.50000
    ## 6            Arab World                 11.91781
    ## 7  United Arab Emirates                 19.30000
    ## 8             Argentina                  6.00000
    ## 9               Armenia                  6.40000
    ## 10       American Samoa                       NA
    ## 11  Antigua and Barbuda                 13.60000
    ## 12            Australia                  5.10000
    ## 13              Austria                  6.90000
    ## 14           Azerbaijan                  6.50000
    ## 15              Burundi                  2.70000
    ## 16              Belgium                  5.10000
    ## 17                Benin                  0.80000
    ## 18         Burkina Faso                  2.20000
    ## 19           Bangladesh                  8.30000
    ## 20             Bulgaria                  5.90000

``` r
class(diabetes_rates)  ### check the format
```

    ## [1] "data.frame"

Found data from the world bank website on the % prevalence of of diabetes for each country, in 2015. Seemed like a cool idea since I work in diabetes research. I had to make a couple edits to the .csv file in excel so it would play nicely in R.

Filter our data down to make things easier to work with. Lets just look at countries in Asia, years 2002 and 2007, and only look at the columns country, lifeExp, and year.

``` r
gapminder_02_07 <- gapminder %>%
  filter(year == 2007 | year == 2002) %>% 
  filter(continent == "Asia") %>% 
  select(country, lifeExp, year)

gapminder_02_07
```

    ## # A tibble: 66 x 3
    ##        country lifeExp  year
    ##         <fctr>   <dbl> <int>
    ##  1 Afghanistan  42.129  2002
    ##  2 Afghanistan  43.828  2007
    ##  3     Bahrain  74.795  2002
    ##  4     Bahrain  75.635  2007
    ##  5  Bangladesh  62.013  2002
    ##  6  Bangladesh  64.062  2007
    ##  7    Cambodia  56.752  2002
    ##  8    Cambodia  59.723  2007
    ##  9       China  72.028  2002
    ## 10       China  72.961  2007
    ## # ... with 56 more rows

Try joining it with gapminder a few different ways:

``` r
left_join(gapminder_02_07, diabetes_rates)
```

    ## Joining, by = "country"

    ## Warning: Column `country` joining factors with different levels, coercing
    ## to character vector

    ## # A tibble: 66 x 4
    ##        country lifeExp  year Diabetes_prevalance_2015
    ##          <chr>   <dbl> <int>                    <dbl>
    ##  1 Afghanistan  42.129  2002                      8.8
    ##  2 Afghanistan  43.828  2007                      8.8
    ##  3     Bahrain  74.795  2002                     19.6
    ##  4     Bahrain  75.635  2007                     19.6
    ##  5  Bangladesh  62.013  2002                      8.3
    ##  6  Bangladesh  64.062  2007                      8.3
    ##  7    Cambodia  56.752  2002                      3.0
    ##  8    Cambodia  59.723  2007                      3.0
    ##  9       China  72.028  2002                      9.8
    ## 10       China  72.961  2007                      9.8
    ## # ... with 56 more rows

**Left\_join** takes everything from the gapminder data frame, and then adds columns for the diabetes data frame. If a country in gapminder is missing from diabetes\_rates, then it puts an 'NA' in the diabetes column. This join function is probably the most practical for real use based on my original idea.

``` r
right_join(gapminder_02_07, diabetes_rates)
```

    ## Joining, by = "country"

    ## Warning: Column `country` joining factors with different levels, coercing
    ## to character vector

    ## # A tibble: 292 x 4
    ##                 country lifeExp  year Diabetes_prevalance_2015
    ##                   <chr>   <dbl> <int>                    <dbl>
    ##  1                Aruba      NA    NA                 11.70000
    ##  2          Afghanistan  42.129  2002                  8.80000
    ##  3          Afghanistan  43.828  2007                  8.80000
    ##  4               Angola      NA    NA                  4.10000
    ##  5              Albania      NA    NA                 10.30000
    ##  6              Andorra      NA    NA                  8.50000
    ##  7           Arab World      NA    NA                 11.91781
    ##  8 United Arab Emirates      NA    NA                 19.30000
    ##  9            Argentina      NA    NA                  6.00000
    ## 10              Armenia      NA    NA                  6.40000
    ## # ... with 282 more rows

With **right\_join**, this does the opposite of left join. It takes countries from diabetes\_rates and adds columns for gapminder. Here we can see there are a lot of "NA" in lifeExp and year. This indicates diabetes\_rates has a lot more countries and our filtered gapminder (because gapminder was limited to just Asia here). Interestingly there are a couple countries that were listed in diabetes\_rates but did not have diabetes data, so all their columns are "NA". There are still 2 rows per country.

``` r
semi_join(gapminder_02_07, diabetes_rates)
```

    ## Joining, by = "country"

    ## Warning: Column `country` joining factors with different levels, coercing
    ## to character vector

    ## # A tibble: 56 x 3
    ##        country lifeExp  year
    ##         <fctr>   <dbl> <int>
    ##  1 Afghanistan  42.129  2002
    ##  2 Afghanistan  43.828  2007
    ##  3  Bangladesh  62.013  2002
    ##  4  Bangladesh  64.062  2007
    ##  5     Bahrain  74.795  2002
    ##  6     Bahrain  75.635  2007
    ##  7       China  72.028  2002
    ##  8       China  72.961  2007
    ##  9   Indonesia  68.588  2002
    ## 10   Indonesia  70.650  2007
    ## # ... with 46 more rows

**Semi\_join** did not add the diabetes\_prevalence column, but instead filtered down gapminder so that only countries that were also in diabetes\_rates were kept. About 10 rows were removed, these removed rows correspond to the rows in left\_join with "NA".

``` r
inner_join(gapminder_02_07, diabetes_rates)
```

    ## Joining, by = "country"

    ## Warning: Column `country` joining factors with different levels, coercing
    ## to character vector

    ## # A tibble: 56 x 4
    ##        country lifeExp  year Diabetes_prevalance_2015
    ##          <chr>   <dbl> <int>                    <dbl>
    ##  1 Afghanistan  42.129  2002                      8.8
    ##  2 Afghanistan  43.828  2007                      8.8
    ##  3     Bahrain  74.795  2002                     19.6
    ##  4     Bahrain  75.635  2007                     19.6
    ##  5  Bangladesh  62.013  2002                      8.3
    ##  6  Bangladesh  64.062  2007                      8.3
    ##  7    Cambodia  56.752  2002                      3.0
    ##  8    Cambodia  59.723  2007                      3.0
    ##  9       China  72.028  2002                      9.8
    ## 10       China  72.961  2007                      9.8
    ## # ... with 46 more rows

**Inner\_join** appears to be the same as semi\_join in how it filtered down the rows, except that it also added the diabetes\_prev column. So here there are no "NA"'s and we have all rows that match between both datasets.

``` r
anti_join(gapminder_02_07, diabetes_rates)
```

    ## Joining, by = "country"

    ## Warning: Column `country` joining factors with different levels, coercing
    ## to character vector

    ## # A tibble: 10 x 3
    ##             country lifeExp  year
    ##              <fctr>   <dbl> <int>
    ##  1             Iran  69.451  2002
    ##  2             Iran  70.964  2007
    ##  3 Korea, Dem. Rep.  66.662  2002
    ##  4 Korea, Dem. Rep.  67.297  2007
    ##  5 Hong Kong, China  81.495  2002
    ##  6 Hong Kong, China  82.208  2007
    ##  7           Taiwan  76.990  2002
    ##  8           Taiwan  78.400  2007
    ##  9            Syria  73.053  2002
    ## 10            Syria  74.143  2007

**Anti\_join** works similar to semi\_join, but instead of returning the 56 rows that matched, it reutrns the 10 rows from gapminder that were not in diabetes\_rates.

``` r
full_join(gapminder_02_07, diabetes_rates)
```

    ## Joining, by = "country"

    ## Warning: Column `country` joining factors with different levels, coercing
    ## to character vector

    ## # A tibble: 302 x 4
    ##        country lifeExp  year Diabetes_prevalance_2015
    ##          <chr>   <dbl> <int>                    <dbl>
    ##  1 Afghanistan  42.129  2002                      8.8
    ##  2 Afghanistan  43.828  2007                      8.8
    ##  3     Bahrain  74.795  2002                     19.6
    ##  4     Bahrain  75.635  2007                     19.6
    ##  5  Bangladesh  62.013  2002                      8.3
    ##  6  Bangladesh  64.062  2007                      8.3
    ##  7    Cambodia  56.752  2002                      3.0
    ##  8    Cambodia  59.723  2007                      3.0
    ##  9       China  72.028  2002                      9.8
    ## 10       China  72.961  2007                      9.8
    ## # ... with 292 more rows

Full Join keeps all countries present in either dataset. Therefore this creates a dataset with more rows than any of the above joins.

That's all the joins!!!

### Part 2 reflection

I'm glad I went through all the join functions individually because I now have a better understanding of what they each do. I can also see why they may all be useful in certain situations. It was also cool to pull data from the web, although perhaps in the future I can figure out how to clean up the .csv file in R so I don't need to open up excel. But for now this method worked easier than I expected, as it was my first time importing data into R. The hard part was actually finding the data on the web.

I like this assingment because I can see myself using very similar methods in the near future to get data related to my grad research from the web and play around with it.
