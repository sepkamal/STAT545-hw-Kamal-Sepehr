HW6 - Data wrangling wrap up
================

``` r
suppressPackageStartupMessages(library(tidyverse))
```

    ## Warning: package 'tidyverse' was built under R version 3.4.2

``` r
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(leaflet))
```

    ## Warning: package 'leaflet' was built under R version 3.4.2

``` r
suppressPackageStartupMessages(library(singer))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(ggmap))
suppressPackageStartupMessages(library(stringi))
```

1. Character Data
=================

Read and work the exercises in the [Strings chapter](http://r4ds.had.co.nz/strings.html) of R for Data Science:

### 14.2.5 Exercises

**1. In code that doesn’t use stringr, you’ll often see paste() and paste0(). What’s the difference between the two functions? What stringr function are they equivalent to? How do the functions differ in their handling of NA?**

They are both used to join strings together. The difference is in the seperator. In `paste()` you can specify the seperator, for example with `sep = ", "`. It defaults to `sep = " "`.

``` r
paste("I love coding", "SO MUCH", "it's true")
```

    ## [1] "I love coding SO MUCH it's true"

``` r
paste0("I love coding", "SO MUCH", "it's true")
```

    ## [1] "I love codingSO MUCHit's true"

`str_c()` is similar to `paste0`.

``` r
str_c("I love coding", "SO MUCH", "it's true")
```

    ## [1] "I love codingSO MUCHit's true"

`paste()` converts `NA` to `"NA"`, while `str_c` just returns `NA` and no string.

``` r
str_c("I love coding", "SO MUCH", NA)
```

    ## [1] NA

``` r
paste("I love coding", "SO MUCH", NA)
```

    ## [1] "I love coding SO MUCH NA"

**2. In your own words, describe the difference between the sep and collapse arguments to str\_c()**

``` r
str_c("I love coding", "SO MUCH", "it's true", sep = "-")
```

    ## [1] "I love coding-SO MUCH-it's true"

``` r
str_c("I love coding", "SO MUCH", "it's true", collapse = "-")
```

    ## [1] "I love codingSO MUCHit's true"

`sep` is used to seperate the individual strings, while collapse is used to collapse the individual strings into a single string.

### 14.3.1.1 Exercises

**1. Explain why each of these strings don’t match a : "", "\\", "\\".**

`\` is a special symbol, known as the escape symbol. It is used before another symbol as an indicator so that R knows the symbol following `\` is supposed to be displayed as a string.

``` r
str_c("I love coding", "\\", "SO MUCH")
```

    ## [1] "I love coding\\SO MUCH"

``` r
str_c("I love coding", "\\", "SO MUCH") %>% 
  writeLines()
```

    ## I love coding\SO MUCH

``` r
str_c("I love coding", "\"", "SO MUCH") %>% 
    writeLines()
```

    ## I love coding"SO MUCH

**2. How would you match the sequence "'?**

Just need to use a few escapes.`?` didn't need one as it is not a special symbol.

``` r
str_c("\"\'\\?") %>% 
    writeLines()
```

    ## "'\?

### 14.3.2.1 Exercises

**1. How would you match the literal string "$^$"?**

``` r
str_c("\"$^$\"") %>% 
    writeLines()
```

    ## "$^$"

\*\* 2. Given the corpus of common words in stringr::words, create regular expressions that find all words that:\*\*

**Start with “y”.**

``` r
str_subset(words, "^y")
```

    ## [1] "year"      "yes"       "yesterday" "yet"       "you"       "young"

**End with “x**

``` r
str_subset(words, "x$")
```

    ## [1] "box" "sex" "six" "tax"

**Are exactly three letters long. (Don’t cheat by using str\_length()!)**

``` r
str_subset(words, "^...$") %>% 
    head(10)
```

    ##  [1] "act" "add" "age" "ago" "air" "all" "and" "any" "arm" "art"

**Have seven letters or more.**

``` r
str_subset(words, "^.......") %>% 
    head(10)
```

    ##  [1] "absolute"  "account"   "achieve"   "address"   "advertise"
    ##  [6] "afternoon" "against"   "already"   "alright"   "although"

### 14.3.3.1 Exercises

**1. Create regular expressions to find all words that:**

**Start with a vowel.**

counting y as a vowel :thumbsup:

``` r
str_subset(words, "^[aeiouy]") %>% 
    head(10)
```

    ##  [1] "a"        "able"     "about"    "absolute" "accept"   "account" 
    ##  [7] "achieve"  "across"   "act"      "active"

**That only contain consonants. (Hint: thinking about matching “not”-vowels.)**

Need to put a `^` inside it too.

``` r
str_subset(words, "^[^aeiouy]") %>% 
    head(10)
```

    ##  [1] "baby"    "back"    "bad"     "bag"     "balance" "ball"    "bank"   
    ##  [8] "bar"     "base"    "basis"

This didn't quite work, as it only made sure they don't start with that letter.

**End with ed, but not with eed.**

``` r
str_subset(words, "[^e]ed$") %>% 
    head(10)
```

    ## [1] "bed"     "hundred" "red"

**End with ing or ise.**

``` r
ing <- str_subset(words, "ing$")
ise <- str_subset(words, "ise$")
c(ing, ise)
```

    ##  [1] "bring"     "during"    "evening"   "king"      "meaning"  
    ##  [6] "morning"   "ring"      "sing"      "thing"     "advertise"
    ## [11] "exercise"  "otherwise" "practise"  "raise"     "realise"  
    ## [16] "rise"      "surprise"

\*\* 3. Is “q” always followed by a “u”?\*\*

``` r
str_subset(words, "q") %>% 
    length()
```

    ## [1] 10

``` r
str_subset(words, "qu") %>% 
    length()
```

    ## [1] 10

Yes, it is always followed by a `u` in `words`.

### 14.3.5.1 Exercises

**Describe, in words, what these expressions will match:**

`(.)\1\1`

A string containing 3 of the same characters in a row. For example `aaad`.

`"(.)(.)\\2\\1"`

A string containing a 2 character flipped repeat. For example `adda`.

`(..)\1`

This is similar to the previous one, except here it is not flipped. For example `adad`.

`"(.).\\1.\\1"`

Finds two non identical characters, followed the first one again, then a 3rd wildcard, and then the first one a third time.

``` r
str_subset("adaca", "(.).\\1.\\1")
```

    ## [1] "adaca"

`"(.)(.)(.).*\\3\\2\\1"`

Finds 3 wildcard characters, followed by something in the middle, and then the same 3 wildcards again in reverse order.

``` r
str_subset("abcFFFFFcba", "(.)(.)(.).*\\3\\2\\1")
```

    ## [1] "abcFFFFFcba"

### 14.4.2 Exercises

**2. What word has the highest number of vowels? What word has the highest proportion of vowels? (Hint: what is the denominator?)**

``` r
str_count(words, "[aeiouy]") %>% 
    sort() %>% 
    tail(1)
```

    ## [1] 5

``` r
### the most any of them has is 5

words[str_count(words, "[aeiouy]") == 5]
```

    ##  [1] "appropriate" "associate"   "authority"   "available"   "colleague"  
    ##  [6] "encourage"   "experience"  "individual"  "opportunity" "television" 
    ## [11] "university"  "yesterday"

### 14.4.5.1 Exercises

**Replace all forward slashes in a string with backslashes.**

``` r
str_replace_all("AAA/BBB", "/", "\\\\") %>% 
    writeLines()
```

    ## AAA\BBB

**Implement a simple version of str\_to\_lower() using replace\_all().**

``` r
str_replace_all(sentences, ".", tolower) %>%
  head(5)
```

    ## [1] "the birch canoe slid on the smooth planks." 
    ## [2] "glue the sheet to the dark blue background."
    ## [3] "it's easy to tell the depth of a well."     
    ## [4] "these days a chicken leg is a rare dish."   
    ## [5] "rice is often served in round bowls."

### 14.4.6.1 Exercises

**Split up a string like "apples, pears, and bananas" into individual components.**

``` r
str_split("apples, pears, and bananas", boundary("word") )
```

    ## [[1]]
    ## [1] "apples"  "pears"   "and"     "bananas"

**Why is it better to split up by boundary("word") than " "?**

``` r
str_split("apples, pears, and bananas", pattern = " " )
```

    ## [[1]]
    ## [1] "apples," "pears,"  "and"     "bananas"

Because using pattern can lead to problems depending on how the words are separated. For examples with commas, as we see above.

### 14.5.1 Exercises

**What are the five most common words in sentences?**

``` r
sentences %>% 
    str_split(boundary("word")) %>% 
  unlist() %>% 
    str_to_lower() %>% 
    enframe() %>%
    group_by(value) %>% 
    count() %>% 
  arrange(desc(n)) %>% 
    head(5)
```

    ## # A tibble: 5 x 2
    ## # Groups:   value [5]
    ##   value     n
    ##   <chr> <int>
    ## 1   the   751
    ## 2     a   202
    ## 3    of   132
    ## 4    to   123
    ## 5   and   118

### 14.7.1 Exercises

**1. Find the stringi functions that:?**

**1. Count the number of words.**

``` r
stri_count_words("ONE TWO THREE FOUR")
```

    ## [1] 4

4. Work with the singer data
============================

**1. Use purrr to map latitude and longitude into human readable information **

``` r
# revgeocode function
possibly_func <- possibly(~ revgeocode(c(.x, .y), output = "more") , NA_character_, quiet = TRUE)

# compute first 2500 rows of singer_locations
locations_1sthalf <- singer_locations %>% 
  filter(!is.na(longitude) & !is.na(latitude)) %>% ## remove entries without longitute and latitude
    head(2500) %>% ### just the first 2500 rows (revgeocode's limit)
    mutate(locs = map2(longitude, latitude, possibly_func))
```

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.99471,-77.60454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.20034,-119.18044

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.7323,7.10169

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=19.59009,-155.43414

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.5725,-74.154

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.51179,-122.67563

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.50172,12.88512

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.43831,-79.99745

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.27188,-119.27023

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.11278"reverse geocode failed - bad location?
    ## location = "8.4177"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.23742"reverse geocode failed - bad location?
    ## location = "47.38028"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.24055"reverse geocode failed - bad location?
    ## location = "53.41961"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-83.7336"reverse geocode failed - bad location?
    ## location = "42.32807"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.10679"reverse geocode failed - bad location?
    ## location = "57.15382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.66429"reverse geocode failed - bad location?
    ## location = "40.36033"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.38311,-1.46454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.9742,-91.52382

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.48869,-120.66906

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-35.30654,149.12656

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.8695,-122.2705

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.26069,-95.93995

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.51607,13.37698

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.16778,-86.77836

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-61.41389"reverse geocode failed - bad location?
    ## location = "10.63239"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "45.03352"reverse geocode failed - bad location?
    ## location = "12.80095"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "20.26078"reverse geocode failed - bad location?
    ## location = "63.82525"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.05661"reverse geocode failed - bad location?
    ## location = "35.91463"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.32986"reverse geocode failed - bad location?
    ## location = "52.1082"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "29.88987"reverse geocode failed - bad location?
    ## location = "31.19224"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.59143"reverse geocode failed - bad location?
    ## location = "51.45366"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.32278"reverse geocode failed - bad location?
    ## location = "43.02809"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.08317"reverse geocode failed - bad location?
    ## location = "40.94757"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.51179,-122.67563

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.13641,11.57752

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.55943,-97.84835

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.20916,-76.86731

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.51607,13.37698

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.79449,-1.54658

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31781,-72.63238

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31256,-71.08868

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.32547"reverse geocode failed - bad location?
    ## location = "27.94017"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.65859"reverse geocode failed - bad location?
    ## location = "39.90685"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.97874"reverse geocode failed - bad location?
    ## location = "35.83073"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-102.4102"reverse geocode failed - bad location?
    ## location = "34.23294"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.53626"reverse geocode failed - bad location?
    ## location = "41.65381"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.59334"reverse geocode failed - bad location?
    ## location = "42.73383"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "23.1362"reverse geocode failed - bad location?
    ## location = "63.8313"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.47753"reverse geocode failed - bad location?
    ## location = "38.03213"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.00335,-79.77127

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.04981,20.91079

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.7038,-73.83168

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.66122,-71.55587

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-37.0907,-63.58481

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=13.05939,80.24567

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.8578,-4.24251

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.3893,35.36124

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.88356,-1.97406

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.9454"reverse geocode failed - bad location?
    ## location = "40.8079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.90684"reverse geocode failed - bad location?
    ## location = "43.04181"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.19951"reverse geocode failed - bad location?
    ## location = "38.62774"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "172.6373"reverse geocode failed - bad location?
    ## location = "-43.53131"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.96689"reverse geocode failed - bad location?
    ## location = "57.70133"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.62758"reverse geocode failed - bad location?
    ## location = "32.83968"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.17192"reverse geocode failed - bad location?
    ## location = "48.76767"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.49407"reverse geocode failed - bad location?
    ## location = "64.46794"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.29504"reverse geocode failed - bad location?
    ## location = "40.23447"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.9086"reverse geocode failed - bad location?
    ## location = "52.47859"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.92381"reverse geocode failed - bad location?
    ## location = "38.8235"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.41383,0.56012

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-0.91754,119.85946

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.44663,-0.32823

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.83073,-85.97874

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.73926,-89.50409

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.16116,19.50496

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.43773,-122.71242

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-106.48749"reverse geocode failed - bad location?
    ## location = "31.75916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.00702"reverse geocode failed - bad location?
    ## location = "55.77143"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.50293"reverse geocode failed - bad location?
    ## location = "33.46797"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.51444,4.42508

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.80506,-122.27302

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.54243,-90.53727

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.23974,-0.88576

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.02078,-80.38483

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.38311,-1.46454

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.24055"reverse geocode failed - bad location?
    ## location = "53.41961"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.85678"reverse geocode failed - bad location?
    ## location = "40.85715"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-99.28445"reverse geocode failed - bad location?
    ## location = "34.1532"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.14392"reverse geocode failed - bad location?
    ## location = "52.94922"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.10158"reverse geocode failed - bad location?
    ## location = "30.08615"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.9086"reverse geocode failed - bad location?
    ## location = "52.47859"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.63166"reverse geocode failed - bad location?
    ## location = "31.30757"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.69559,10.64121

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.44826,-112.07577

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.14323,-74.72671

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=23.62574,-101.95625

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.55792,-7.84481

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.01574,-105.27924

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=23.73606,-103.99279

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.66122,-71.55587

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "127.85017"reverse geocode failed - bad location?
    ## location = "36.44815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.66947"reverse geocode failed - bad location?
    ## location = "40.19033"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.02743"reverse geocode failed - bad location?
    ## location = "55.72261"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.14783"reverse geocode failed - bad location?
    ## location = "52.45419"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.22886"reverse geocode failed - bad location?
    ## location = "40.92926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.18067"reverse geocode failed - bad location?
    ## location = "51.48126"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.53444"reverse geocode failed - bad location?
    ## location = "54.48303"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.17898"reverse geocode failed - bad location?
    ## location = "51.27562"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.13449"reverse geocode failed - bad location?
    ## location = "50.82821"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.67118"reverse geocode failed - bad location?
    ## location = "39.04928"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.29504"reverse geocode failed - bad location?
    ## location = "40.23447"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.29005"reverse geocode failed - bad location?
    ## location = "48.69173"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.36586"reverse geocode failed - bad location?
    ## location = "46.44231"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-105.27924"reverse geocode failed - bad location?
    ## location = "40.01574"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.26493"reverse geocode failed - bad location?
    ## location = "44.97903"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.18049"reverse geocode failed - bad location?
    ## location = "32.29869"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "6.95505"reverse geocode failed - bad location?
    ## location = "50.94165"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-83.7826"reverse geocode failed - bad location?
    ## location = "43.0026"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.45927"reverse geocode failed - bad location?
    ## location = "27.94653"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.98086,2.81874

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.60356,-122.32944

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.75911,-84.19444

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.62774,-90.19951

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.97402,-122.03095

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-34.60852,-58.37354

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.08615,-94.10158

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=59.91228,10.74998

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.97567"reverse geocode failed - bad location?
    ## location = "41.68676"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.97874"reverse geocode failed - bad location?
    ## location = "35.83073"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.21323"reverse geocode failed - bad location?
    ## location = "44.47592"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-91.52382"reverse geocode failed - bad location?
    ## location = "30.9742"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.93609"reverse geocode failed - bad location?
    ## location = "46.08914"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.67869"reverse geocode failed - bad location?
    ## location = "40.10216"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.81531"reverse geocode failed - bad location?
    ## location = "52.50524"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "113.9378"reverse geocode failed - bad location?
    ## location = "22.25769"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.53877"reverse geocode failed - bad location?
    ## location = "38.26443"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.1305,-106.65931

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.42558,-94.04825

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31256,-71.08868

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.73872,-69.0844

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.27358,-88.40858

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.95369,-90.07771

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31256,-71.08868

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.25949"reverse geocode failed - bad location?
    ## location = "51.7562"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-110.96975"reverse geocode failed - bad location?
    ## location = "32.22155"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "6.21109"reverse geocode failed - bad location?
    ## location = "62.42305"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.43365"reverse geocode failed - bad location?
    ## location = "37.5407"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.45724"reverse geocode failed - bad location?
    ## location = "38.29187"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-102.64505"reverse geocode failed - bad location?
    ## location = "32.72662"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-75.7486"reverse geocode failed - bad location?
    ## location = "39.9833"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.00093"reverse geocode failed - bad location?
    ## location = "50.87566"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.14074"reverse geocode failed - bad location?
    ## location = "49.89942"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.41853"reverse geocode failed - bad location?
    ## location = "40.67856"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.17258"reverse geocode failed - bad location?
    ## location = "41.66017"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-79.9316"reverse geocode failed - bad location?
    ## location = "32.78115"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.00157"reverse geocode failed - bad location?
    ## location = "33.67889"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.25804,-1.90965

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.4456,-76.74368

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.03922,-122.89143

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=27.9758,-81.54106

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.22626,-80.41058

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.97903,-93.26493

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=62.19845,17.55142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.45644,-2.63265

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.47859,-1.9086

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.88356,-1.97406

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.06162"reverse geocode failed - bad location?
    ## location = "37.90118"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.00298"reverse geocode failed - bad location?
    ## location = "39.96196"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.24922"reverse geocode failed - bad location?
    ## location = "40.72023"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.99883"reverse geocode failed - bad location?
    ## location = "17.57975"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.19547"reverse geocode failed - bad location?
    ## location = "39.12026"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.93258"reverse geocode failed - bad location?
    ## location = "60.17116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.03764"reverse geocode failed - bad location?
    ## location = "42.11306"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-55.92844"reverse geocode failed - bad location?
    ## location = "-12.69524"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "14.17739"reverse geocode failed - bad location?
    ## location = "57.77972"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=62.19845,17.55142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-14.24292,-54.38783

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.16778,-86.77836

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.08419,-81.51406

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.62666,-88.94561

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.51607,13.37698

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.46797,-82.50293

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=60.17116,24.93258

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.47122"reverse geocode failed - bad location?
    ## location = "48.75235"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.28065"reverse geocode failed - bad location?
    ## location = "30.43977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-104.99226"reverse geocode failed - bad location?
    ## location = "39.74001"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.11779"reverse geocode failed - bad location?
    ## location = "4.65637"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "6.08849"reverse geocode failed - bad location?
    ## location = "50.77813"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.79731"reverse geocode failed - bad location?
    ## location = "18.01571"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.38533"reverse geocode failed - bad location?
    ## location = "43.64856"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.75627"reverse geocode failed - bad location?
    ## location = "49.38426"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.22395"reverse geocode failed - bad location?
    ## location = "46.8132"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.41984"reverse geocode failed - bad location?
    ## location = "55.84291"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-71.3055"reverse geocode failed - bad location?
    ## location = "41.48628"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.79731"reverse geocode failed - bad location?
    ## location = "18.01571"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.24953"reverse geocode failed - bad location?
    ## location = "53.34376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.00157"reverse geocode failed - bad location?
    ## location = "33.67889"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-111.03318"reverse geocode failed - bad location?
    ## location = "45.67932"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.6562"reverse geocode failed - bad location?
    ## location = "60.20624"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.62774,-90.19951

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=21.14836,-100.91879

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.04702,8.62929

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.71568,-117.16172

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.41982,-82.44537

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.14723,-118.14426

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.37485,-84.80047

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.02743"reverse geocode failed - bad location?
    ## location = "55.72261"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.4164"reverse geocode failed - bad location?
    ## location = "34.26624"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.69887"reverse geocode failed - bad location?
    ## location = "34.41925"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.49576"reverse geocode failed - bad location?
    ## location = "41.90311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.83829"reverse geocode failed - bad location?
    ## location = "37.4876"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.58306"reverse geocode failed - bad location?
    ## location = "39.10295"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.65016"reverse geocode failed - bad location?
    ## location = "49.87269"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.51484"reverse geocode failed - bad location?
    ## location = "44.11559"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=19.48498,-99.18169

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.29533,-94.80786

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=62.19845,17.55142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.47859,-1.9086

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.95369,-90.07771

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.97903,-93.26493

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.6621,-122.96462

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "19.1343"reverse geocode failed - bad location?
    ## location = "51.91892"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-105.27924"reverse geocode failed - bad location?
    ## location = "40.01574"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.65284"reverse geocode failed - bad location?
    ## location = "28.02688"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.39535"reverse geocode failed - bad location?
    ## location = "51.27172"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-70.25665"reverse geocode failed - bad location?
    ## location = "43.65914"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-155.43414"reverse geocode failed - bad location?
    ## location = "19.59009"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "31.25536"reverse geocode failed - bad location?
    ## location = "30.08374"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.26493"reverse geocode failed - bad location?
    ## location = "44.97903"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.91629"reverse geocode failed - bad location?
    ## location = "57.04935"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.13649"reverse geocode failed - bad location?
    ## location = "42.65356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.08854"reverse geocode failed - bad location?
    ## location = "44.04992"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-86.8115"reverse geocode failed - bad location?
    ## location = "33.52029"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.37698"reverse geocode failed - bad location?
    ## location = "52.51607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.36692"reverse geocode failed - bad location?
    ## location = "18.3902"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.10158"reverse geocode failed - bad location?
    ## location = "30.08615"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "15.21751"reverse geocode failed - bad location?
    ## location = "59.27074"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.59279"reverse geocode failed - bad location?
    ## location = "50.36079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-105.27924"reverse geocode failed - bad location?
    ## location = "40.01574"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.80032"reverse geocode failed - bad location?
    ## location = "45.28303"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=25.72898,-80.23742

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.47326,-119.05505

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.91253,12.90542

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.64856,-79.38533

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.60356,-122.32944

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.57196,-1.78644

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=59.91228,10.74998

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.75342,21.22327

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "69.86799"reverse geocode failed - bad location?
    ## location = "37.59791"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.51484"reverse geocode failed - bad location?
    ## location = "44.11559"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-115.13997"reverse geocode failed - bad location?
    ## location = "36.17191"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.31388"reverse geocode failed - bad location?
    ## location = "52.0953"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.50261"reverse geocode failed - bad location?
    ## location = "48.68081"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.04185"reverse geocode failed - bad location?
    ## location = "40.81469"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.79731"reverse geocode failed - bad location?
    ## location = "18.01571"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.59012"reverse geocode failed - bad location?
    ## location = "42.99671"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.90994,-1.40732

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=60.17116,24.93258

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.57196,-1.78644

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.7174,-74.04323

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31392,-2.23218

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.57347"reverse geocode failed - bad location?
    ## location = "42.50382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.49576"reverse geocode failed - bad location?
    ## location = "41.90311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "69.86799"reverse geocode failed - bad location?
    ## location = "37.59791"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.39111"reverse geocode failed - bad location?
    ## location = "33.74831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.2949"reverse geocode failed - bad location?
    ## location = "52.62249"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.14496"reverse geocode failed - bad location?
    ## location = "34.00336"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.64208"reverse geocode failed - bad location?
    ## location = "34.30138"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-92.78236"reverse geocode failed - bad location?
    ## location = "38.65555"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.9086"reverse geocode failed - bad location?
    ## location = "52.47859"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.7868"reverse geocode failed - bad location?
    ## location = "40.9197"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.41199"reverse geocode failed - bad location?
    ## location = "41.82387"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "6.95505"reverse geocode failed - bad location?
    ## location = "50.94165"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.85678"reverse geocode failed - bad location?
    ## location = "40.85715"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.36586"reverse geocode failed - bad location?
    ## location = "46.44231"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.38533"reverse geocode failed - bad location?
    ## location = "43.64856"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-34.60852,-58.37354

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.22208,4.39771

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.16778,-86.77836

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.84802,-82.40022

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.58608,-86.28641

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.18419,-71.71818

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.60356,-122.32944

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.33847,-121.88579

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.24953"reverse geocode failed - bad location?
    ## location = "53.34376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "69.86799"reverse geocode failed - bad location?
    ## location = "37.59791"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.57518"reverse geocode failed - bad location?
    ## location = "51.43558"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.72684"reverse geocode failed - bad location?
    ## location = "41.20633"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.75753"reverse geocode failed - bad location?
    ## location = "41.51776"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.23742"reverse geocode failed - bad location?
    ## location = "25.72898"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.93405"reverse geocode failed - bad location?
    ## location = "44.64308"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.24953"reverse geocode failed - bad location?
    ## location = "53.34376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.81341"reverse geocode failed - bad location?
    ## location = "39.52739"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94512"reverse geocode failed - bad location?
    ## location = "40.79195"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-82.7603"reverse geocode failed - bad location?
    ## location = "22.81751"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.35139,-82.21628

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.07272,-0.77304

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-20.86721,55.45676

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.62861,-90.60738

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.2676,-97.74298

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=23.1168,-82.38859

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.90012,-1.40848

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.9454"reverse geocode failed - bad location?
    ## location = "40.8079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-121.77312"reverse geocode failed - bad location?
    ## location = "38.67843"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-86.8115"reverse geocode failed - bad location?
    ## location = "33.52029"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.83829"reverse geocode failed - bad location?
    ## location = "37.4876"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.49664"reverse geocode failed - bad location?
    ## location = "40.8272"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.29717"reverse geocode failed - bad location?
    ## location = "33.84005"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.79731"reverse geocode failed - bad location?
    ## location = "18.01571"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.88153"reverse geocode failed - bad location?
    ## location = "32.35006"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.18998"reverse geocode failed - bad location?
    ## location = "54.50125"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.9513"reverse geocode failed - bad location?
    ## location = "46.00297"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.02258"reverse geocode failed - bad location?
    ## location = "38.50205"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.33715"reverse geocode failed - bad location?
    ## location = "41.60299"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.58094"reverse geocode failed - bad location?
    ## location = "30.58814"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.37325"reverse geocode failed - bad location?
    ## location = "33.95813"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.95244,-90.05202

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.54187,10.78142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=23.62574,-101.95625

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=49.01037,8.4092

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.85692,2.34121

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.59233,-101.85587

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.73197,-74.17418

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.60356,-122.32944

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.67631,12.56935

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.16338,-73.86084

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.70853"reverse geocode failed - bad location?
    ## location = "46.91008"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-46.65466"reverse geocode failed - bad location?
    ## location = "-23.56287"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.57347"reverse geocode failed - bad location?
    ## location = "42.50382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "16.9382"reverse geocode failed - bad location?
    ## location = "52.409"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-81.6558"reverse geocode failed - bad location?
    ## location = "30.33138"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.1229"reverse geocode failed - bad location?
    ## location = "39.0812"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.47122"reverse geocode failed - bad location?
    ## location = "48.75235"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.27332"reverse geocode failed - bad location?
    ## location = "42.79033"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.66351"reverse geocode failed - bad location?
    ## location = "46.5735"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.93258"reverse geocode failed - bad location?
    ## location = "60.17116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-121.42164"reverse geocode failed - bad location?
    ## location = "38.42068"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.41984"reverse geocode failed - bad location?
    ## location = "55.84291"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.823502,-75.923813

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.40977,-2.97848

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-12.97002,-38.50456

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.0503,-8.23194

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.73569,0.47791

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.51711,-90.18043

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.73383,-84.59334

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.99275"reverse geocode failed - bad location?
    ## location = "51.00883"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-106.64864"reverse geocode failed - bad location?
    ## location = "35.08418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-38.50456"reverse geocode failed - bad location?
    ## location = "-12.97002"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-99.28445"reverse geocode failed - bad location?
    ## location = "34.1532"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.74998"reverse geocode failed - bad location?
    ## location = "59.91228"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.77496"reverse geocode failed - bad location?
    ## location = "37.64598"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.56967"reverse geocode failed - bad location?
    ## location = "32.46222"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.80032"reverse geocode failed - bad location?
    ## location = "45.28303"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-107.48486"reverse geocode failed - bad location?
    ## location = "28.55019"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.36692"reverse geocode failed - bad location?
    ## location = "18.3902"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.11774"reverse geocode failed - bad location?
    ## location = "32.7716"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.40022"reverse geocode failed - bad location?
    ## location = "34.84802"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.99603"reverse geocode failed - bad location?
    ## location = "51.45238"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.73391,-93.89419

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.43539,-3.18447

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.61442,-86.4421

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.57182,-97.1495

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.85715,-73.85678

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-36.35484,146.32611

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=21.7866,82.79476

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.27752"reverse geocode failed - bad location?
    ## location = "33.52306"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.63261"reverse geocode failed - bad location?
    ## location = "52.66097"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.24055"reverse geocode failed - bad location?
    ## location = "53.41961"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.74092"reverse geocode failed - bad location?
    ## location = "35.67048"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.2705"reverse geocode failed - bad location?
    ## location = "37.8695"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.54508"reverse geocode failed - bad location?
    ## location = "54.97938"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.2705"reverse geocode failed - bad location?
    ## location = "37.8695"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.51877"reverse geocode failed - bad location?
    ## location = "34.36401"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.92496"reverse geocode failed - bad location?
    ## location = "41.30711"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.00181"reverse geocode failed - bad location?
    ## location = "37.38769"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=21.7866,82.79476

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.85549,-104.20258

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.76099,-74.20991

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.76194,1.83784

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.55334,9.99245

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.19224,29.88987

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.65286,-3.99667

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31407,-2.23001

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.41199"reverse geocode failed - bad location?
    ## location = "41.82387"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.29014"reverse geocode failed - bad location?
    ## location = "36.34253"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.30063"reverse geocode failed - bad location?
    ## location = "32.38012"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.48633"reverse geocode failed - bad location?
    ## location = "48.80216"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.46935"reverse geocode failed - bad location?
    ## location = "35.66693"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "29.33181"reverse geocode failed - bad location?
    ## location = "63.22945"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.87846"reverse geocode failed - bad location?
    ## location = "42.88544"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-102.33417"reverse geocode failed - bad location?
    ## location = "33.91736"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.25969"reverse geocode failed - bad location?
    ## location = "51.55615"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.18049"reverse geocode failed - bad location?
    ## location = "32.29869"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.9257"reverse geocode failed - bad location?
    ## location = "51.32413"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.48218"reverse geocode failed - bad location?
    ## location = "48.82922"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.07691"reverse geocode failed - bad location?
    ## location = "34.96578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.17815"reverse geocode failed - bad location?
    ## location = "41.4682"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-37.0907,-63.58481

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.90685,-76.65859

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.58507,-89.87374

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.40977,-2.97848

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.3902,-77.36692

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.37011,-8.39646

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.50018,-70.86521

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.77045,0.64255

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-121.74477"reverse geocode failed - bad location?
    ## location = "38.54666"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.32986"reverse geocode failed - bad location?
    ## location = "52.1082"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.14392"reverse geocode failed - bad location?
    ## location = "52.94922"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.02743"reverse geocode failed - bad location?
    ## location = "55.72261"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.01486"reverse geocode failed - bad location?
    ## location = "34.49948"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.02258"reverse geocode failed - bad location?
    ## location = "38.50205"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.39981"reverse geocode failed - bad location?
    ## location = "34.07292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.32823"reverse geocode failed - bad location?
    ## location = "51.44663"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "14.43322"reverse geocode failed - bad location?
    ## location = "50.07908"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "37.6151"reverse geocode failed - bad location?
    ## location = "55.75687"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-43.19508"reverse geocode failed - bad location?
    ## location = "-22.97673"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.36451"reverse geocode failed - bad location?
    ## location = "48.42831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.01955"reverse geocode failed - bad location?
    ## location = "35.21962"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.65016"reverse geocode failed - bad location?
    ## location = "49.87269"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "82.79476"reverse geocode failed - bad location?
    ## location = "21.7866"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.2676,-97.74298

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.98538,-122.91227

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.84838,4.34968

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.69173,2.29005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.25486,-85.7664

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.45207"reverse geocode failed - bad location?
    ## location = "39.31936"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "69.86799"reverse geocode failed - bad location?
    ## location = "37.59791"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.66538"reverse geocode failed - bad location?
    ## location = "64.55653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.51984"reverse geocode failed - bad location?
    ## location = "42.37522"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-66.42889"reverse geocode failed - bad location?
    ## location = "18.22328"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.75627"reverse geocode failed - bad location?
    ## location = "49.38426"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.52033"reverse geocode failed - bad location?
    ## location = "35.472"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "26.06739"reverse geocode failed - bad location?
    ## location = "64.95014"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-58.37354"reverse geocode failed - bad location?
    ## location = "-34.60852"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.38348"reverse geocode failed - bad location?
    ## location = "42.28474"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.67464"reverse geocode failed - bad location?
    ## location = "56.42465"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "135.50323"reverse geocode failed - bad location?
    ## location = "34.67747"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.45927"reverse geocode failed - bad location?
    ## location = "27.94653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=28.53823,-81.37739

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.14323,-74.72671

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.57347"reverse geocode failed - bad location?
    ## location = "42.50382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.11278"reverse geocode failed - bad location?
    ## location = "8.4177"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.74727"reverse geocode failed - bad location?
    ## location = "32.51461"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.95086"reverse geocode failed - bad location?
    ## location = "34.02011"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-69.46854"reverse geocode failed - bad location?
    ## location = "16.85576"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.98512"reverse geocode failed - bad location?
    ## location = "52.40445"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.11913"reverse geocode failed - bad location?
    ## location = "39.94525"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-111.54732"reverse geocode failed - bad location?
    ## location = "39.49974"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.31388"reverse geocode failed - bad location?
    ## location = "52.0953"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-90.5651"reverse geocode failed - bad location?
    ## location = "34.19451"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.39111"reverse geocode failed - bad location?
    ## location = "33.74831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-82.4167"reverse geocode failed - bad location?
    ## location = "23.0833"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-99.13285"reverse geocode failed - bad location?
    ## location = "19.4319"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-58.93826"reverse geocode failed - bad location?
    ## location = "4.86632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.61551"reverse geocode failed - bad location?
    ## location = "50.72744"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "144.96715"reverse geocode failed - bad location?
    ## location = "-37.81753"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.64267"reverse geocode failed - bad location?
    ## location = "35.78551"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.06808"reverse geocode failed - bad location?
    ## location = "40.75244"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.67631,12.56935

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.95369,-90.07771

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.20703,-90.14988

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.54456,-80.24787

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31392,-2.23218

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.91905"reverse geocode failed - bad location?
    ## location = "39.89233"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.18067"reverse geocode failed - bad location?
    ## location = "51.48126"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.05661"reverse geocode failed - bad location?
    ## location = "35.91463"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.36451"reverse geocode failed - bad location?
    ## location = "48.42831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.93258"reverse geocode failed - bad location?
    ## location = "60.17116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.08854"reverse geocode failed - bad location?
    ## location = "44.04992"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-88.7493"reverse geocode failed - bad location?
    ## location = "41.9293"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.62569"reverse geocode failed - bad location?
    ## location = "47.565"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-86.8115"reverse geocode failed - bad location?
    ## location = "33.52029"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.11403"reverse geocode failed - bad location?
    ## location = "49.26044"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.33275"reverse geocode failed - bad location?
    ## location = "60.3907"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "16.77851"reverse geocode failed - bad location?
    ## location = "41.08336"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.30897"reverse geocode failed - bad location?
    ## location = "56.95468"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.73647,-114.04027

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.95415,-3.20277

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.21787,-74.7594

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.76045,-95.36978

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.85715,-73.85678

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=59.33217,18.06243

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.40698,-1.50776

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.53444"reverse geocode failed - bad location?
    ## location = "54.48303"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.11403"reverse geocode failed - bad location?
    ## location = "49.26044"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.03825"reverse geocode failed - bad location?
    ## location = "37.37161"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.06162"reverse geocode failed - bad location?
    ## location = "37.90118"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.75801"reverse geocode failed - bad location?
    ## location = "33.99604"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-102.64505"reverse geocode failed - bad location?
    ## location = "32.72662"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.57347"reverse geocode failed - bad location?
    ## location = "42.50382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-111.83146"reverse geocode failed - bad location?
    ## location = "33.41704"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-38.50456"reverse geocode failed - bad location?
    ## location = "-12.97002"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.3108,-105.59032

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=59.56465,9.26773

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.97402,-122.03095

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.10644,-84.50469

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.7666,-94.85607

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.01571,-76.79731

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.51228,-73.55439

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.50471,-81.69074

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "19.06482"reverse geocode failed - bad location?
    ## location = "47.50622"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "151.20695"reverse geocode failed - bad location?
    ## location = "-33.86963"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.38533"reverse geocode failed - bad location?
    ## location = "43.64856"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.11403"reverse geocode failed - bad location?
    ## location = "49.26044"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.43001"reverse geocode failed - bad location?
    ## location = "39.90348"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.20449"reverse geocode failed - bad location?
    ## location = "40.11727"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.04779"reverse geocode failed - bad location?
    ## location = "52.27252"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.50293"reverse geocode failed - bad location?
    ## location = "33.46797"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.74727"reverse geocode failed - bad location?
    ## location = "32.51461"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "25.4735"reverse geocode failed - bad location?
    ## location = "65.0103"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.27348"reverse geocode failed - bad location?
    ## location = "18.11526"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-104.99226"reverse geocode failed - bad location?
    ## location = "39.74001"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.89774"reverse geocode failed - bad location?
    ## location = "31.30627"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.27023"reverse geocode failed - bad location?
    ## location = "31.96305"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.74568,-74.25778

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.20835,6.1427

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.15398,-95.99277

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.80105,-89.6436

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.74865,-92.27449

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.09834,-118.32674

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.22236,-111.97046

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.61603"reverse geocode failed - bad location?
    ## location = "43.1555"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-105.55096"reverse geocode failed - bad location?
    ## location = "38.99792"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.54508"reverse geocode failed - bad location?
    ## location = "54.97938"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.02648"reverse geocode failed - bad location?
    ## location = "35.94833"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.99603"reverse geocode failed - bad location?
    ## location = "51.45238"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.75627"reverse geocode failed - bad location?
    ## location = "49.38426"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.49462"reverse geocode failed - bad location?
    ## location = "29.42449"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "144.69832"reverse geocode failed - bad location?
    ## location = "-36.36003"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.57176"reverse geocode failed - bad location?
    ## location = "45.45902"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.06243"reverse geocode failed - bad location?
    ## location = "59.33217"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.71568,-117.16172

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.65286,-3.99667

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.1555,-77.61603

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.20034,-119.18044

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.50471,-81.69074

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.15398,-94.08553

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.2676,-97.74298

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.1142,-88.2435

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.53424"reverse geocode failed - bad location?
    ## location = "39.16659"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.64405"reverse geocode failed - bad location?
    ## location = "59.85845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.09332"reverse geocode failed - bad location?
    ## location = "44.94382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "20.26078"reverse geocode failed - bad location?
    ## location = "63.82525"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "34.76971"reverse geocode failed - bad location?
    ## location = "32.0451"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-7.529"reverse geocode failed - bad location?
    ## location = "54.155"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.37698"reverse geocode failed - bad location?
    ## location = "52.51607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.59143"reverse geocode failed - bad location?
    ## location = "51.45366"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-76.6096"reverse geocode failed - bad location?
    ## location = "39.29055"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "29.92039"reverse geocode failed - bad location?
    ## location = "-3.38791"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.08854"reverse geocode failed - bad location?
    ## location = "44.04992"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-43.19508"reverse geocode failed - bad location?
    ## location = "-22.97673"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "14.79938"reverse geocode failed - bad location?
    ## location = "56.87968"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "19.50496"reverse geocode failed - bad location?
    ## location = "47.16116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.94599"reverse geocode failed - bad location?
    ## location = "34.23497"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "4.89319"reverse geocode failed - bad location?
    ## location = "52.37312"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-81.6558"reverse geocode failed - bad location?
    ## location = "30.33138"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.50382,12.57347

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.10125,-72.58929

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.47859,-1.9086

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.94382,-93.09332

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.41961,-8.24055

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.10295,-94.58306

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.9197,-73.7868

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.45081,-90.645

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.79449,-1.54658

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.38533"reverse geocode failed - bad location?
    ## location = "43.64856"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "23.73641"reverse geocode failed - bad location?
    ## location = "37.97615"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.11774"reverse geocode failed - bad location?
    ## location = "32.7716"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-66.42889"reverse geocode failed - bad location?
    ## location = "18.22328"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "103.82771"reverse geocode failed - bad location?
    ## location = "1.36558"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.17418"reverse geocode failed - bad location?
    ## location = "40.73197"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.45914"reverse geocode failed - bad location?
    ## location = "38.30089"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.22886"reverse geocode failed - bad location?
    ## location = "40.92926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.37698"reverse geocode failed - bad location?
    ## location = "52.51607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.39981"reverse geocode failed - bad location?
    ## location = "34.07292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.49816"reverse geocode failed - bad location?
    ## location = "43.11092"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.56096,-0.23443

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=64.55653,12.66538

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.77045,0.64255

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.18419,-71.71818

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.9293,-88.7493

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.73197,-74.17418

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.78644"reverse geocode failed - bad location?
    ## location = "51.57196"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.89373"reverse geocode failed - bad location?
    ## location = "53.19729"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.99745"reverse geocode failed - bad location?
    ## location = "40.43831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "16.3688"reverse geocode failed - bad location?
    ## location = "48.20254"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.74298"reverse geocode failed - bad location?
    ## location = "30.2676"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.45014"reverse geocode failed - bad location?
    ## location = "33.64132"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "29.88987"reverse geocode failed - bad location?
    ## location = "31.19224"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.61603"reverse geocode failed - bad location?
    ## location = "43.1555"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.9086"reverse geocode failed - bad location?
    ## location = "52.47859"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.34344"reverse geocode failed - bad location?
    ## location = "7.36529"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.42105"reverse geocode failed - bad location?
    ## location = "34.74929"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-106.64864"reverse geocode failed - bad location?
    ## location = "35.08418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.3584"reverse geocode failed - bad location?
    ## location = "43.21183"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.99603"reverse geocode failed - bad location?
    ## location = "51.45238"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.50965,-92.11905

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=59.33217,18.06243

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.72261,13.02743

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.04999,-76.14739

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8962,-121.07887

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=27.94653,-82.45927

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.50471,-81.69074

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.20987,0.11156

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-155.43414"reverse geocode failed - bad location?
    ## location = "19.59009"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.52899"reverse geocode failed - bad location?
    ## location = "34.6978"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.66379"reverse geocode failed - bad location?
    ## location = "51.42721"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.18103"reverse geocode failed - bad location?
    ## location = "45.46894"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.74727"reverse geocode failed - bad location?
    ## location = "32.51461"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.56935"reverse geocode failed - bad location?
    ## location = "55.67631"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.23285"reverse geocode failed - bad location?
    ## location = "49.41944"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-113.49037"reverse geocode failed - bad location?
    ## location = "53.54622"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.27302"reverse geocode failed - bad location?
    ## location = "37.80506"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.92803"reverse geocode failed - bad location?
    ## location = "42.78668"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.8079,-73.9454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.5725,-74.154

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.95063,-89.61809

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-33.86963,151.20695

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.65065,13.76709

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.5735,11.66351

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.73716,-74.03097

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.16172"reverse geocode failed - bad location?
    ## location = "32.71568"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.86029"reverse geocode failed - bad location?
    ## location = "42.30837"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.11403"reverse geocode failed - bad location?
    ## location = "49.26044"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-106.02612"reverse geocode failed - bad location?
    ## location = "34.16612"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.74998"reverse geocode failed - bad location?
    ## location = "59.91228"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-74.154"reverse geocode failed - bad location?
    ## location = "40.5725"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.02258"reverse geocode failed - bad location?
    ## location = "38.50205"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.36586"reverse geocode failed - bad location?
    ## location = "46.44231"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.9454"reverse geocode failed - bad location?
    ## location = "40.8079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.37388"reverse geocode failed - bad location?
    ## location = "33.98163"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-99.28445"reverse geocode failed - bad location?
    ## location = "34.1532"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.13585"reverse geocode failed - bad location?
    ## location = "40.85251"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-56.16544"reverse geocode failed - bad location?
    ## location = "-34.8809"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.90684"reverse geocode failed - bad location?
    ## location = "43.04181"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.01955"reverse geocode failed - bad location?
    ## location = "35.21962"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-36.88411,174.77042

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.20987,0.11156

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.14323,-74.72671

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.42831,-123.36451

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.86121,-2.56483

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.19034,-82.63713

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.74595,-89.53176

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.80489"reverse geocode failed - bad location?
    ## location = "35.32689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-104.99226"reverse geocode failed - bad location?
    ## location = "39.74001"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.64647"reverse geocode failed - bad location?
    ## location = "50.94224"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.95574"reverse geocode failed - bad location?
    ## location = "69.65102"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.24953"reverse geocode failed - bad location?
    ## location = "53.34376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-54.38783"reverse geocode failed - bad location?
    ## location = "-14.24292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.51858"reverse geocode failed - bad location?
    ## location = "36.19524"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.36978"reverse geocode failed - bad location?
    ## location = "29.76045"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.39535"reverse geocode failed - bad location?
    ## location = "33.86404"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.09579"reverse geocode failed - bad location?
    ## location = "53.71673"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.60916"reverse geocode failed - bad location?
    ## location = "33.63604"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.63078"reverse geocode failed - bad location?
    ## location = "40.86395"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=57.71993,12.94439

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.99792,-105.55096

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-34.60852,-58.37354

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=62.19845,17.55142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.74831,-84.39111

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.04992,-123.08854

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-111.9307"reverse geocode failed - bad location?
    ## location = "34.16788"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.42105"reverse geocode failed - bad location?
    ## location = "34.74929"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.89033"reverse geocode failed - bad location?
    ## location = "39.83011"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-71.6342"reverse geocode failed - bad location?
    ## location = "44.00118"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.71818"reverse geocode failed - bad location?
    ## location = "42.18419"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.39646"reverse geocode failed - bad location?
    ## location = "43.37011"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.74298"reverse geocode failed - bad location?
    ## location = "30.2676"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-7.84481"reverse geocode failed - bad location?
    ## location = "39.55792"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-66.89828"reverse geocode failed - bad location?
    ## location = "10.49605"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.14426"reverse geocode failed - bad location?
    ## location = "34.14723"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "82.79476"reverse geocode failed - bad location?
    ## location = "21.7866"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23001"reverse geocode failed - bad location?
    ## location = "54.31407"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.83168"reverse geocode failed - bad location?
    ## location = "40.7038"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.73143,-73.99658

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.50482,11.34516

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.37312,4.89319

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.41961,-8.24055

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.64856,-79.38533

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.01571,-76.79731

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.71464,-2.76267

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.13585"reverse geocode failed - bad location?
    ## location = "40.85251"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.51534"reverse geocode failed - bad location?
    ## location = "50.72076"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.05406"reverse geocode failed - bad location?
    ## location = "35.03466"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.99726"reverse geocode failed - bad location?
    ## location = "34.82353"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.14392"reverse geocode failed - bad location?
    ## location = "52.94922"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-46.71173"reverse geocode failed - bad location?
    ## location = "-23.6361"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.21612"reverse geocode failed - bad location?
    ## location = "40.81741"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.44165"reverse geocode failed - bad location?
    ## location = "47.25513"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-88.8194"reverse geocode failed - bad location?
    ## location = "35.6139"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "26.06739"reverse geocode failed - bad location?
    ## location = "64.95014"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.23742"reverse geocode failed - bad location?
    ## location = "25.72898"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.49462"reverse geocode failed - bad location?
    ## location = "29.42449"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.6333"reverse geocode failed - bad location?
    ## location = "52.3833"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.38556"reverse geocode failed - bad location?
    ## location = "39.35103"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.91629"reverse geocode failed - bad location?
    ## location = "57.04935"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.55379,-90.10785

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.5909,130.65604

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.45902,-73.57176

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=64.95014,26.06739

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-41.28054,174.76714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.20475,5.73796

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.94922,-1.14392

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.71067,1.71819

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.7868"reverse geocode failed - bad location?
    ## location = "40.9197"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.16079"reverse geocode failed - bad location?
    ## location = "37.44466"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.66947"reverse geocode failed - bad location?
    ## location = "40.19033"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.74298"reverse geocode failed - bad location?
    ## location = "30.2676"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.22395"reverse geocode failed - bad location?
    ## location = "46.8132"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.32925"reverse geocode failed - bad location?
    ## location = "32.74863"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.10776"reverse geocode failed - bad location?
    ## location = "44.63548"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.60454"reverse geocode failed - bad location?
    ## location = "40.99471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.67563"reverse geocode failed - bad location?
    ## location = "45.51179"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.23742"reverse geocode failed - bad location?
    ## location = "25.72898"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.32986"reverse geocode failed - bad location?
    ## location = "52.1082"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.99745"reverse geocode failed - bad location?
    ## location = "40.43831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.55439"reverse geocode failed - bad location?
    ## location = "45.51228"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.97874"reverse geocode failed - bad location?
    ## location = "35.83073"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.44231,-93.36586

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.95813,-83.37325

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.50101,4.47684

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.16778,-86.77836

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.30837,-87.86029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.29368,5.37249

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.55503,-0.17348

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.20449"reverse geocode failed - bad location?
    ## location = "40.11727"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.74727"reverse geocode failed - bad location?
    ## location = "32.51461"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.04868"reverse geocode failed - bad location?
    ## location = "34.96265"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.38989"reverse geocode failed - bad location?
    ## location = "41.93825"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.01644"reverse geocode failed - bad location?
    ## location = "42.7989"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.34516"reverse geocode failed - bad location?
    ## location = "44.50482"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.05202"reverse geocode failed - bad location?
    ## location = "29.95244"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.66538"reverse geocode failed - bad location?
    ## location = "64.55653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "15.9676"reverse geocode failed - bad location?
    ## location = "45.80726"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.40848"reverse geocode failed - bad location?
    ## location = "54.90012"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.27332"reverse geocode failed - bad location?
    ## location = "42.79033"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.39981"reverse geocode failed - bad location?
    ## location = "34.07292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.88845"reverse geocode failed - bad location?
    ## location = "43.26099"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23001"reverse geocode failed - bad location?
    ## location = "54.31407"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.31849"reverse geocode failed - bad location?
    ## location = "45.43825"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.50482,11.34516

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.83073,-85.97874

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.55792,-7.84481

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.20897,-93.29156

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.11559,-120.51484

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=25.72898,-80.23742

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.43773,-122.71242

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.95369,-90.07771

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.27348"reverse geocode failed - bad location?
    ## location = "18.11526"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.44291"reverse geocode failed - bad location?
    ## location = "56.07043"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.13468"reverse geocode failed - bad location?
    ## location = "53.26265"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.67563"reverse geocode failed - bad location?
    ## location = "45.51179"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.68073"reverse geocode failed - bad location?
    ## location = "32.61436"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.57347"reverse geocode failed - bad location?
    ## location = "42.50382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.43365"reverse geocode failed - bad location?
    ## location = "37.5407"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "115.85724"reverse geocode failed - bad location?
    ## location = "-31.95302"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-115.13997"reverse geocode failed - bad location?
    ## location = "36.17191"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.14392"reverse geocode failed - bad location?
    ## location = "52.94922"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.61603"reverse geocode failed - bad location?
    ## location = "43.1555"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-9.15037"reverse geocode failed - bad location?
    ## location = "38.72567"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-81.2708"reverse geocode failed - bad location?
    ## location = "33.35424"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.63265"reverse geocode failed - bad location?
    ## location = "53.45644"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.20788"reverse geocode failed - bad location?
    ## location = "53.93063"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.83754"reverse geocode failed - bad location?
    ## location = "35.2225"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.29504"reverse geocode failed - bad location?
    ## location = "40.23447"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.88356,-1.97406

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.77507,-96.67869

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.73569,0.47791

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.11204,8.68342

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.17303,-122.59802

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.62861,-90.60738

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.14323,-74.72671

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.51058"reverse geocode failed - bad location?
    ## location = "36.23703"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.29156"reverse geocode failed - bad location?
    ## location = "37.20897"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-58.37354"reverse geocode failed - bad location?
    ## location = "-34.60852"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.67469"reverse geocode failed - bad location?
    ## location = "50.55356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.69091"reverse geocode failed - bad location?
    ## location = "37.82245"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23001"reverse geocode failed - bad location?
    ## location = "54.31407"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.07328"reverse geocode failed - bad location?
    ## location = "33.98897"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.61551"reverse geocode failed - bad location?
    ## location = "50.72744"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-90.5651"reverse geocode failed - bad location?
    ## location = "34.19451"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "23.76226"reverse geocode failed - bad location?
    ## location = "61.49781"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "4.89319"reverse geocode failed - bad location?
    ## location = "52.37312"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.06243"reverse geocode failed - bad location?
    ## location = "59.33217"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-5.93494"reverse geocode failed - bad location?
    ## location = "54.5958"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.85251,-73.13585

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.96301,7.61781

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=49.84769,-99.96201

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.80901,-2.47755

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.52328,-0.21346

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=49.38426,-84.75627

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "153.02283"reverse geocode failed - bad location?
    ## location = "-27.46888"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "78.30813"reverse geocode failed - bad location?
    ## location = "27.57452"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.72684"reverse geocode failed - bad location?
    ## location = "41.20633"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.18782"reverse geocode failed - bad location?
    ## location = "35.30774"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.01955"reverse geocode failed - bad location?
    ## location = "35.21962"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.61566"reverse geocode failed - bad location?
    ## location = "41.58979"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "144.96715"reverse geocode failed - bad location?
    ## location = "-37.81753"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.08854"reverse geocode failed - bad location?
    ## location = "44.04992"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.57518"reverse geocode failed - bad location?
    ## location = "51.43558"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-97.1495"reverse geocode failed - bad location?
    ## location = "31.57182"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-76.6096"reverse geocode failed - bad location?
    ## location = "39.29055"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.78644"reverse geocode failed - bad location?
    ## location = "51.57196"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.67563"reverse geocode failed - bad location?
    ## location = "45.51179"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.39535"reverse geocode failed - bad location?
    ## location = "33.86404"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.9086"reverse geocode failed - bad location?
    ## location = "52.47859"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.04323"reverse geocode failed - bad location?
    ## location = "40.7174"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "20.46414"reverse geocode failed - bad location?
    ## location = "44.81187"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.09962,-80.24109

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.20254,16.3688

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=58.97083,5.73079

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.14465,-89.10827

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.51695"reverse geocode failed - bad location?
    ## location = "56.27609"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.19951"reverse geocode failed - bad location?
    ## location = "38.62774"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-86.4421"reverse geocode failed - bad location?
    ## location = "36.61442"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.71818"reverse geocode failed - bad location?
    ## location = "42.18419"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.04892"reverse geocode failed - bad location?
    ## location = "35.14968"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.26773"reverse geocode failed - bad location?
    ## location = "59.56465"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.36978"reverse geocode failed - bad location?
    ## location = "29.76045"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.92496"reverse geocode failed - bad location?
    ## location = "41.30711"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.37739"reverse geocode failed - bad location?
    ## location = "28.53823"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.41199"reverse geocode failed - bad location?
    ## location = "41.82387"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.45927"reverse geocode failed - bad location?
    ## location = "27.94653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.25025"reverse geocode failed - bad location?
    ## location = "33.17156"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.40022"reverse geocode failed - bad location?
    ## location = "34.84802"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "3.72856"reverse geocode failed - bad location?
    ## location = "51.05563"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.64616,-63.57392

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.69651,13.34577

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.83073,-85.97874

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.42449,-98.49462

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.27188,-119.27023

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.86029"reverse geocode failed - bad location?
    ## location = "42.30837"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.27302"reverse geocode failed - bad location?
    ## location = "37.80506"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-105.27924"reverse geocode failed - bad location?
    ## location = "40.01574"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.04892"reverse geocode failed - bad location?
    ## location = "35.14968"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.39111"reverse geocode failed - bad location?
    ## location = "33.74831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.30897"reverse geocode failed - bad location?
    ## location = "56.95468"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-54.38783"reverse geocode failed - bad location?
    ## location = "-14.24292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.55439"reverse geocode failed - bad location?
    ## location = "45.51228"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.65859"reverse geocode failed - bad location?
    ## location = "39.90685"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.93918"reverse geocode failed - bad location?
    ## location = "34.07215"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.03237"reverse geocode failed - bad location?
    ## location = "42.39376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.38533"reverse geocode failed - bad location?
    ## location = "43.64856"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.75801"reverse geocode failed - bad location?
    ## location = "33.99604"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-80.9474"reverse geocode failed - bad location?
    ## location = "33.62646"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.54658"reverse geocode failed - bad location?
    ## location = "53.79449"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-52.33033"reverse geocode failed - bad location?
    ## location = "4.93461"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.90963"reverse geocode failed - bad location?
    ## location = "49.20639"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.16172"reverse geocode failed - bad location?
    ## location = "32.71568"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.19444"reverse geocode failed - bad location?
    ## location = "39.75911"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.00181"reverse geocode failed - bad location?
    ## location = "37.38769"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.45238,-0.99603

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.11526,-77.27348

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.8586,18.4295

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=4.86632,-58.93826

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.73926,-89.50409

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.003,-71.51346

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.52328,-0.21346

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.23871"reverse geocode failed - bad location?
    ## location = "-10.40633"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.76505"reverse geocode failed - bad location?
    ## location = "33.6671"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.47933"reverse geocode failed - bad location?
    ## location = "44.23153"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.70703"reverse geocode failed - bad location?
    ## location = "35.52608"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-99.13285"reverse geocode failed - bad location?
    ## location = "19.4319"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.24499"reverse geocode failed - bad location?
    ## location = "45.49919"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.74092"reverse geocode failed - bad location?
    ## location = "35.67048"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.37739"reverse geocode failed - bad location?
    ## location = "28.53823"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.37517"reverse geocode failed - bad location?
    ## location = "38.91391"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.11403"reverse geocode failed - bad location?
    ## location = "49.26044"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.51858"reverse geocode failed - bad location?
    ## location = "36.19524"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.20788"reverse geocode failed - bad location?
    ## location = "53.93063"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.39111"reverse geocode failed - bad location?
    ## location = "33.74831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.74988"reverse geocode failed - bad location?
    ## location = "41.19993"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.88576"reverse geocode failed - bad location?
    ## location = "52.23974"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=14.63554,-61.02281

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.85147,-101.04893

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.8079,-73.9454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=25.72898,-80.23742

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-36.88411,174.77042

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.04977,-92.90802

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.88314,2.62879

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.50243"reverse geocode failed - bad location?
    ## location = "34.03142"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.25949"reverse geocode failed - bad location?
    ## location = "51.7562"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "6.08849"reverse geocode failed - bad location?
    ## location = "50.77813"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-111.9307"reverse geocode failed - bad location?
    ## location = "34.16788"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.92496"reverse geocode failed - bad location?
    ## location = "41.30711"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.59012"reverse geocode failed - bad location?
    ## location = "42.99671"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-9.15037"reverse geocode failed - bad location?
    ## location = "38.72567"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.6562"reverse geocode failed - bad location?
    ## location = "60.20624"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.08342"reverse geocode failed - bad location?
    ## location = "53.95333"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "147.31906"reverse geocode failed - bad location?
    ## location = "-32.83102"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.97874"reverse geocode failed - bad location?
    ## location = "35.83073"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-21.90248"reverse geocode failed - bad location?
    ## location = "64.13738"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.40529"reverse geocode failed - bad location?
    ## location = "39.33737"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.58306"reverse geocode failed - bad location?
    ## location = "39.10295"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.4203,-3.70577

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.03922,-122.89143

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.35644,-72.09647

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.71568,-117.16172

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=62.19845,17.55142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.8132,8.22395

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-27.65294,-51.15045

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.88356,-1.97406

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.95071"reverse geocode failed - bad location?
    ## location = "39.09551"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "26.06739"reverse geocode failed - bad location?
    ## location = "64.95014"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-99.13285"reverse geocode failed - bad location?
    ## location = "19.4319"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "19.1343"reverse geocode failed - bad location?
    ## location = "51.91892"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.60454"reverse geocode failed - bad location?
    ## location = "40.99471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "28.98618"reverse geocode failed - bad location?
    ## location = "41.04085"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.77127"reverse geocode failed - bad location?
    ## location = "38.00335"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.74298"reverse geocode failed - bad location?
    ## location = "30.2676"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.95196"reverse geocode failed - bad location?
    ## location = "40.36583"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.79731"reverse geocode failed - bad location?
    ## location = "18.01571"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12359"reverse geocode failed - bad location?
    ## location = "51.53487"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.86674"reverse geocode failed - bad location?
    ## location = "30.06677"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-102.4102"reverse geocode failed - bad location?
    ## location = "34.23294"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "15.21751"reverse geocode failed - bad location?
    ## location = "59.27074"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.8578,-4.24251

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.63328,-3.00365

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=69.65102,18.95574

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.83073,-85.97874

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.01571,-76.79731

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.60356,-122.32944

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.21962,-80.01955

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31256,-71.08868

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.17258"reverse geocode failed - bad location?
    ## location = "41.66017"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "106.82782"reverse geocode failed - bad location?
    ## location = "-6.17144"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.53176"reverse geocode failed - bad location?
    ## location = "35.74595"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.25306"reverse geocode failed - bad location?
    ## location = "26.27249"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.33942"reverse geocode failed - bad location?
    ## location = "34.03674"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.93986"reverse geocode failed - bad location?
    ## location = "50.44332"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.56935"reverse geocode failed - bad location?
    ## location = "55.67631"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-90.5651"reverse geocode failed - bad location?
    ## location = "34.19451"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.62682"reverse geocode failed - bad location?
    ## location = "39.11338"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.01955"reverse geocode failed - bad location?
    ## location = "35.21962"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.52033"reverse geocode failed - bad location?
    ## location = "35.472"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.18998"reverse geocode failed - bad location?
    ## location = "54.50125"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "20.26078"reverse geocode failed - bad location?
    ## location = "63.82525"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.24055"reverse geocode failed - bad location?
    ## location = "53.41961"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.84005,-0.2751

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.19767,-101.69814

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.29533,-94.80786

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=49.26044,-123.11403

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=62.19845,17.55142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.83968,-83.62758

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.90342"reverse geocode failed - bad location?
    ## location = "33.66388"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-105.55096"reverse geocode failed - bad location?
    ## location = "38.99792"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "149.12656"reverse geocode failed - bad location?
    ## location = "-35.30654"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.45927"reverse geocode failed - bad location?
    ## location = "27.94653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.06243"reverse geocode failed - bad location?
    ## location = "59.33217"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.13585"reverse geocode failed - bad location?
    ## location = "40.85251"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-99.13285"reverse geocode failed - bad location?
    ## location = "19.4319"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.82365"reverse geocode failed - bad location?
    ## location = "42.58807"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.19338"reverse geocode failed - bad location?
    ## location = "51.6134"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.59012"reverse geocode failed - bad location?
    ## location = "42.99671"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.99245"reverse geocode failed - bad location?
    ## location = "53.55334"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.01571,-76.79731

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.55379,-90.10785

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.50382,12.57347

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-37.81753,144.96715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=29.95369,-90.07771

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=58.97083,5.73079

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.5313,9.93802

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.28848,-121.94486

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.00157"reverse geocode failed - bad location?
    ## location = "33.67889"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-5.93494"reverse geocode failed - bad location?
    ## location = "54.5958"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.32023"reverse geocode failed - bad location?
    ## location = "38.49809"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.26746"reverse geocode failed - bad location?
    ## location = "51.51324"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.06243"reverse geocode failed - bad location?
    ## location = "59.33217"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.95535"reverse geocode failed - bad location?
    ## location = "33.90698"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.27585"reverse geocode failed - bad location?
    ## location = "34.35919"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "144.96715"reverse geocode failed - bad location?
    ## location = "-37.81753"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.96689"reverse geocode failed - bad location?
    ## location = "57.70133"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.22295"reverse geocode failed - bad location?
    ## location = "32.67828"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "19.46801"reverse geocode failed - bad location?
    ## location = "51.76174"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.93986"reverse geocode failed - bad location?
    ## location = "50.44332"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.66538"reverse geocode failed - bad location?
    ## location = "64.55653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.10602"reverse geocode failed - bad location?
    ## location = "42.36679"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.22208,4.39771

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.26299,-71.80235

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.75836,-71.46421

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.11526,-77.27348

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.22328,-66.42889

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.87869,-121.94345

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.82245,-85.69091

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.85607"reverse geocode failed - bad location?
    ## location = "39.7666"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.61658"reverse geocode failed - bad location?
    ## location = "42.2148"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.40848"reverse geocode failed - bad location?
    ## location = "54.90012"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.55439"reverse geocode failed - bad location?
    ## location = "45.51228"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.84567"reverse geocode failed - bad location?
    ## location = "33.67098"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.13444"reverse geocode failed - bad location?
    ## location = "49.35392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.24922"reverse geocode failed - bad location?
    ## location = "40.72023"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.06243"reverse geocode failed - bad location?
    ## location = "59.33217"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.47995"reverse geocode failed - bad location?
    ## location = "40.82624"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "21.84556"reverse geocode failed - bad location?
    ## location = "39.07245"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.14996"reverse geocode failed - bad location?
    ## location = "39.76691"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.59143"reverse geocode failed - bad location?
    ## location = "51.45366"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-92.41952"reverse geocode failed - bad location?
    ## location = "30.62981"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "144.96715"reverse geocode failed - bad location?
    ## location = "-37.81753"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.60356,-122.32944

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.40547,-79.82416

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-12.97002,-38.50456

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.47859,-1.9086

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.7272,-90.10126

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31256,-71.08868

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.99703,-120.54872

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.18703"reverse geocode failed - bad location?
    ## location = "51.11655"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-5.93494"reverse geocode failed - bad location?
    ## location = "54.5958"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "151.20695"reverse geocode failed - bad location?
    ## location = "-33.86963"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.37698"reverse geocode failed - bad location?
    ## location = "52.51607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.76505"reverse geocode failed - bad location?
    ## location = "33.6671"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.87988"reverse geocode failed - bad location?
    ## location = "32.90573"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.74298"reverse geocode failed - bad location?
    ## location = "30.2676"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "14.43322"reverse geocode failed - bad location?
    ## location = "50.07908"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-60.21303"reverse geocode failed - bad location?
    ## location = "45.98005"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-69.94049"reverse geocode failed - bad location?
    ## location = "18.4867"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.71925"reverse geocode failed - bad location?
    ## location = "50.72805"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.24953"reverse geocode failed - bad location?
    ## location = "53.34376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.21914"reverse geocode failed - bad location?
    ## location = "33.9814"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.39535"reverse geocode failed - bad location?
    ## location = "51.27172"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.38311,-1.46454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-24.9162,133.39311

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.82812,12.07305

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.52328,-0.21346

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.29055,-76.6096

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "28.18759"reverse geocode failed - bad location?
    ## location = "-25.7458"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.47277"reverse geocode failed - bad location?
    ## location = "51.89834"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.34516"reverse geocode failed - bad location?
    ## location = "44.50482"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.38533"reverse geocode failed - bad location?
    ## location = "43.64856"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.00181"reverse geocode failed - bad location?
    ## location = "37.38769"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.93258"reverse geocode failed - bad location?
    ## location = "60.17116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.36289"reverse geocode failed - bad location?
    ## location = "36.13702"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "27.11819"reverse geocode failed - bad location?
    ## location = "63.58939"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.6075"reverse geocode failed - bad location?
    ## location = "56.87546"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.16172"reverse geocode failed - bad location?
    ## location = "32.71568"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.99883"reverse geocode failed - bad location?
    ## location = "17.57975"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.77815,-96.7954

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.14632,-118.24802

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.28946,-118.71766

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=65.0103,25.4735

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=49.87269,8.65016

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.97768,11.02307

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.46137,-2.96761

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.78115,-79.9316

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.3758,-4.13689

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.6671,-117.76505

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "174.76714"reverse geocode failed - bad location?
    ## location = "-41.28054"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.54658"reverse geocode failed - bad location?
    ## location = "53.79449"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=19.59009,-155.43414

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.95813,-83.37325

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31392,-2.23218

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.84396,-85.18093

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.57306,-0.77619

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.85692,2.34121

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.83168"reverse geocode failed - bad location?
    ## location = "40.7038"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.88091"reverse geocode failed - bad location?
    ## location = "50.7204"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.46694"reverse geocode failed - bad location?
    ## location = "51.57198"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-54.38783"reverse geocode failed - bad location?
    ## location = "-14.24292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.14127"reverse geocode failed - bad location?
    ## location = "51.47288"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.79959"reverse geocode failed - bad location?
    ## location = "54.03728"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-91.18847"reverse geocode failed - bad location?
    ## location = "34.86738"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.56935"reverse geocode failed - bad location?
    ## location = "55.67631"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.76192"reverse geocode failed - bad location?
    ## location = "35.27958"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "16.3688"reverse geocode failed - bad location?
    ## location = "48.20254"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.36586"reverse geocode failed - bad location?
    ## location = "46.44231"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.9742,-91.52382

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.1142,-88.2435

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005
    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.8132,8.22395

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.19451,-90.5651

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.65286,-3.99667

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-86.8115"reverse geocode failed - bad location?
    ## location = "33.52029"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.69091"reverse geocode failed - bad location?
    ## location = "37.82245"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "4.39771"reverse geocode failed - bad location?
    ## location = "51.22208"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.80047"reverse geocode failed - bad location?
    ## location = "33.37485"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-90.5651"reverse geocode failed - bad location?
    ## location = "34.19451"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "4.34968"reverse geocode failed - bad location?
    ## location = "50.84838"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-63.58481"reverse geocode failed - bad location?
    ## location = "-37.0907"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.51484"reverse geocode failed - bad location?
    ## location = "44.11559"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.1779"reverse geocode failed - bad location?
    ## location = "37.45469"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.20449"reverse geocode failed - bad location?
    ## location = "40.11727"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.13649"reverse geocode failed - bad location?
    ## location = "42.65356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-97.1495"reverse geocode failed - bad location?
    ## location = "31.57182"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.13468"reverse geocode failed - bad location?
    ## location = "53.26265"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.05097"reverse geocode failed - bad location?
    ## location = "37.28731"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.34169"reverse geocode failed - bad location?
    ## location = "46.58057"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.32904,-111.78976

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.06546,-71.24891

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.4788,-0.62466

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.98117,-77.12648

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.95813,-83.37325

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.63196,139.43394

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.50243"reverse geocode failed - bad location?
    ## location = "34.03142"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.83019"reverse geocode failed - bad location?
    ## location = "49.10516"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-121.49101"reverse geocode failed - bad location?
    ## location = "38.57906"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.28092"reverse geocode failed - bad location?
    ## location = "30.83472"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.50469"reverse geocode failed - bad location?
    ## location = "39.10644"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-105.27924"reverse geocode failed - bad location?
    ## location = "40.01574"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.98512"reverse geocode failed - bad location?
    ## location = "52.40445"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.21346"reverse geocode failed - bad location?
    ## location = "51.52328"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.03095"reverse geocode failed - bad location?
    ## location = "36.97402"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.72567,-9.15037

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.38825,7.54836

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.88356,-1.97406

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.46894,9.18103

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.90094,-84.279

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.53492,-82.68448

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.99471,-77.60454

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.36978"reverse geocode failed - bad location?
    ## location = "29.76045"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.32986"reverse geocode failed - bad location?
    ## location = "52.1082"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.59028"reverse geocode failed - bad location?
    ## location = "6.23651"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.09332"reverse geocode failed - bad location?
    ## location = "44.94382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.96107"reverse geocode failed - bad location?
    ## location = "34.61932"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.10602"reverse geocode failed - bad location?
    ## location = "42.36679"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.36917"reverse geocode failed - bad location?
    ## location = "35.74812"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.80506,-122.27302

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.11559,-120.51484

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.60356,-122.32944

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71793,-73.59354

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.04859,-84.50032

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714
    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31407,-2.23001

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.14466"reverse geocode failed - bad location?
    ## location = "47.83888"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.99745"reverse geocode failed - bad location?
    ## location = "40.43831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-7.84481"reverse geocode failed - bad location?
    ## location = "39.55792"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.01955"reverse geocode failed - bad location?
    ## location = "35.21962"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.87846"reverse geocode failed - bad location?
    ## location = "42.88544"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.23871"reverse geocode failed - bad location?
    ## location = "-10.40633"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.52899"reverse geocode failed - bad location?
    ## location = "34.6978"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.79416"reverse geocode failed - bad location?
    ## location = "63.41131"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.88356,-1.97406

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=63.22945,29.33181

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.11526,-77.27348

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31256,-71.08868

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.6671,-117.76505

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=47.39038,0.68971

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.7038,-73.83168

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12193"reverse geocode failed - bad location?
    ## location = "51.45236"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.22395"reverse geocode failed - bad location?
    ## location = "46.8132"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "4.47684"reverse geocode failed - bad location?
    ## location = "50.50101"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.71242"reverse geocode failed - bad location?
    ## location = "38.43773"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.67481"reverse geocode failed - bad location?
    ## location = "6.82323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.08854"reverse geocode failed - bad location?
    ## location = "44.04992"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-70.70719"reverse geocode failed - bad location?
    ## location = "19.45565"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.70577"reverse geocode failed - bad location?
    ## location = "40.4203"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "152.83826"reverse geocode failed - bad location?
    ## location = "-25.28766"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.54836"reverse geocode failed - bad location?
    ## location = "44.38825"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.69091"reverse geocode failed - bad location?
    ## location = "37.82245"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.02078,-80.38483

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.56096,-0.23443

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.62774,-90.19951

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.07292,-118.39981

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.50408,-92.12783

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.67631,12.56935

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.0953,1.31388

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.24953"reverse geocode failed - bad location?
    ## location = "53.34376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.75627"reverse geocode failed - bad location?
    ## location = "49.38426"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.95196"reverse geocode failed - bad location?
    ## location = "40.36583"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.51484"reverse geocode failed - bad location?
    ## location = "44.11559"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.92381"reverse geocode failed - bad location?
    ## location = "38.8235"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.65859"reverse geocode failed - bad location?
    ## location = "39.90685"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.54658"reverse geocode failed - bad location?
    ## location = "53.79449"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.99221"reverse geocode failed - bad location?
    ## location = "40.57607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.67469"reverse geocode failed - bad location?
    ## location = "50.55356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.39023,-4.48622

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029
    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.27188,-119.27023

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.8132,8.22395

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.14323,-74.72671

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.7038,-73.83168

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31407,-2.23001

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.3893,35.36124

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.06071"reverse geocode failed - bad location?
    ## location = "35.87713"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-96.7954"reverse geocode failed - bad location?
    ## location = "32.77815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.67563"reverse geocode failed - bad location?
    ## location = "45.51179"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.14392"reverse geocode failed - bad location?
    ## location = "52.94922"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.71242"reverse geocode failed - bad location?
    ## location = "38.43773"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.10126"reverse geocode failed - bad location?
    ## location = "44.7272"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23001"reverse geocode failed - bad location?
    ## location = "54.31407"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.85678"reverse geocode failed - bad location?
    ## location = "40.85715"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.35131"reverse geocode failed - bad location?
    ## location = "26.65037"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-93.19547"reverse geocode failed - bad location?
    ## location = "39.12026"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.54658"reverse geocode failed - bad location?
    ## location = "53.79449"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-106.02612"reverse geocode failed - bad location?
    ## location = "34.16612"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.24953"reverse geocode failed - bad location?
    ## location = "53.34376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.34109"reverse geocode failed - bad location?
    ## location = "-35.70522"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.62879"reverse geocode failed - bad location?
    ## location = "48.88314"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.4518,7.01062

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.76102,-0.23396

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.80506,-122.27302

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.4203,-3.70577

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.06474,-89.59026

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=62.19845,17.55142

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "20.26078"reverse geocode failed - bad location?
    ## location = "63.82525"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.44345"reverse geocode failed - bad location?
    ## location = "42.10286"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.54316"reverse geocode failed - bad location?
    ## location = "40.29924"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.83829"reverse geocode failed - bad location?
    ## location = "37.4876"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-54.38783"reverse geocode failed - bad location?
    ## location = "-14.24292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.64255"reverse geocode failed - bad location?
    ## location = "51.77045"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.57347"reverse geocode failed - bad location?
    ## location = "42.50382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.89601"reverse geocode failed - bad location?
    ## location = "35.99527"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.22295"reverse geocode failed - bad location?
    ## location = "32.67828"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.45927"reverse geocode failed - bad location?
    ## location = "27.94653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.43001"reverse geocode failed - bad location?
    ## location = "39.90348"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-123.11403"reverse geocode failed - bad location?
    ## location = "49.26044"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-115.13997"reverse geocode failed - bad location?
    ## location = "36.17191"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.60257,-75.4702

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.45366,-2.59143

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.7427,-84.62167

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.10216,-85.67869

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31407,-2.23001

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.51607,13.37698

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.04181,-87.90684

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.76216"reverse geocode failed - bad location?
    ## location = "38.28496"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.38596"reverse geocode failed - bad location?
    ## location = "42.54843"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.98423"reverse geocode failed - bad location?
    ## location = "38.51213"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "4.47684"reverse geocode failed - bad location?
    ## location = "50.50101"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.83754"reverse geocode failed - bad location?
    ## location = "35.2225"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.35885"reverse geocode failed - bad location?
    ## location = "46.22809"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.99603"reverse geocode failed - bad location?
    ## location = "51.45238"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.67563"reverse geocode failed - bad location?
    ## location = "45.51179"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.08342"reverse geocode failed - bad location?
    ## location = "53.95333"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.4456,-76.74368

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-25.28766,152.83826

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.65863,126.7378

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.91463,-79.05661

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.65286,-3.99667

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.71568,-117.16172

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31392,-2.23218

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.16612,-106.02612

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.38311,-1.46454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=20.68759,-103.35108

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.42945"reverse geocode failed - bad location?
    ## location = "53.50807"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.83829"reverse geocode failed - bad location?
    ## location = "37.4876"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.10679"reverse geocode failed - bad location?
    ## location = "57.15382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-101.95625"reverse geocode failed - bad location?
    ## location = "23.62574"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.59143"reverse geocode failed - bad location?
    ## location = "51.45366"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.32674"reverse geocode failed - bad location?
    ## location = "34.09834"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.9454"reverse geocode failed - bad location?
    ## location = "40.8079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.58923"reverse geocode failed - bad location?
    ## location = "42.34334"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.70847"reverse geocode failed - bad location?
    ## location = "52.30554"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.32463"reverse geocode failed - bad location?
    ## location = "45.34481"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.42945"reverse geocode failed - bad location?
    ## location = "53.50807"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.54658"reverse geocode failed - bad location?
    ## location = "53.79449"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.82773,-89.54034

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.46137,-2.96761

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.11306,-88.03764

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.4876,139.83829

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.00118,-71.6342

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.85692,2.34121

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.62774,-90.19951

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.28946,-118.71766

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.41228"reverse geocode failed - bad location?
    ## location = "47.65726"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.06243"reverse geocode failed - bad location?
    ## location = "59.33217"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.32925"reverse geocode failed - bad location?
    ## location = "32.74863"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.61603"reverse geocode failed - bad location?
    ## location = "43.1555"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "16.9382"reverse geocode failed - bad location?
    ## location = "52.409"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.02075"reverse geocode failed - bad location?
    ## location = "53.82507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-93.6202"reverse geocode failed - bad location?
    ## location = "42.02534"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.14996"reverse geocode failed - bad location?
    ## location = "39.76691"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.85678"reverse geocode failed - bad location?
    ## location = "40.85715"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=28.02232,-81.73295

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.85715,-73.85678

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.69173,2.29005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.82646,-2.80175

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.19451,-90.5651

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.4203,-3.70577

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.82812,12.07305

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.27172,-0.39535

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.24055"reverse geocode failed - bad location?
    ## location = "53.41961"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.85678"reverse geocode failed - bad location?
    ## location = "40.85715"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.04892"reverse geocode failed - bad location?
    ## location = "35.14968"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-114.06317"reverse geocode failed - bad location?
    ## location = "51.04521"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.49576"reverse geocode failed - bad location?
    ## location = "41.90311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.86029"reverse geocode failed - bad location?
    ## location = "42.30837"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.77496"reverse geocode failed - bad location?
    ## location = "37.64598"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.48622"reverse geocode failed - bad location?
    ## location = "48.39023"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.74998"reverse geocode failed - bad location?
    ## location = "59.91228"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-71.6342"reverse geocode failed - bad location?
    ## location = "44.00118"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.13449"reverse geocode failed - bad location?
    ## location = "50.82821"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.7174,-74.04323

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=26.71438,-80.05269

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=1.32026,103.78871

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-69.46854"reverse geocode failed - bad location?
    ## location = "16.85576"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.43977,-84.28065

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.76691,-86.14996

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=57.70133,11.96689

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.77916,-122.42005

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-37.0907,-63.58481

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=46.5735,11.66351

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "16.3688"reverse geocode failed - bad location?
    ## location = "48.20254"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.14392"reverse geocode failed - bad location?
    ## location = "52.94922"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.37388"reverse geocode failed - bad location?
    ## location = "33.98163"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.07771"reverse geocode failed - bad location?
    ## location = "29.95369"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-97.74298"reverse geocode failed - bad location?
    ## location = "30.2676"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.37238"reverse geocode failed - bad location?
    ## location = "48.24159"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.37157"reverse geocode failed - bad location?
    ## location = "40.79781"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.7054"reverse geocode failed - bad location?
    ## location = "45.06951"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.53424"reverse geocode failed - bad location?
    ## location = "39.16659"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=55.70622,13.1876

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.70991,-73.62279

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.74319,-0.34592

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.77815,-96.7954

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=27.9758,-81.54106

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.87713,-96.06071

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=49.38426,-84.75627

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.46894,9.18103

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.97615,23.73641

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.37698"reverse geocode failed - bad location?
    ## location = "52.51607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-98.49462"reverse geocode failed - bad location?
    ## location = "29.42449"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-58.93826"reverse geocode failed - bad location?
    ## location = "4.86632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.30571"reverse geocode failed - bad location?
    ## location = "23.05599"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.51346"reverse geocode failed - bad location?
    ## location = "50.81877"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.04892"reverse geocode failed - bad location?
    ## location = "35.14968"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.38533"reverse geocode failed - bad location?
    ## location = "43.64856"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.51858"reverse geocode failed - bad location?
    ## location = "36.19524"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.06243"reverse geocode failed - bad location?
    ## location = "59.33217"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.74831,-84.39111

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.27188,-119.27023

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.6418,-90.36791

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.80506,-122.27302

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.85692,2.34121

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.46797,-82.50293

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.8079,-73.9454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.06951,7.7054

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.33168,-83.04792

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-92.84883"reverse geocode failed - bad location?
    ## location = "30.48657"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.04792"reverse geocode failed - bad location?
    ## location = "42.33168"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.16172"reverse geocode failed - bad location?
    ## location = "32.71568"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.51484"reverse geocode failed - bad location?
    ## location = "44.11559"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "25.75129"reverse geocode failed - bad location?
    ## location = "62.24049"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "174.76714"reverse geocode failed - bad location?
    ## location = "-41.28054"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.11156"reverse geocode failed - bad location?
    ## location = "52.20987"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.49229"reverse geocode failed - bad location?
    ## location = "34.01156"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "35.36124"reverse geocode failed - bad location?
    ## location = "31.3893"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.27348"reverse geocode failed - bad location?
    ## location = "18.11526"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=45.51179,-122.67563

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.64856,-79.38533

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.67828,-83.22295

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.1689,-100.07715

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.96196,-83.00298

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.27188,-119.27023

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.9742,-91.52382

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.57607,-73.99221

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.27188,-119.27023

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.65507,-73.94888

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.97874"reverse geocode failed - bad location?
    ## location = "35.83073"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.67563"reverse geocode failed - bad location?
    ## location = "45.51179"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.23396"reverse geocode failed - bad location?
    ## location = "51.76102"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-91.52382"reverse geocode failed - bad location?
    ## location = "30.9742"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.84502"reverse geocode failed - bad location?
    ## location = "37.16793"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "18.04511"reverse geocode failed - bad location?
    ## location = "40.43322"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.6333"reverse geocode failed - bad location?
    ## location = "52.3833"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.38556"reverse geocode failed - bad location?
    ## location = "39.35103"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-76.48023"reverse geocode failed - bad location?
    ## location = "37.08288"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.27302"reverse geocode failed - bad location?
    ## location = "37.80506"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.38815,-96.0878

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.31256,-71.08868

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=30.2676,-97.74298

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=4.93461,-52.33033

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.8991,-77.029

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.39023,-4.48622

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.74319,-0.34592

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-119.27023"reverse geocode failed - bad location?
    ## location = "37.27188"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.39535"reverse geocode failed - bad location?
    ## location = "51.27172"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.61781"reverse geocode failed - bad location?
    ## location = "51.96301"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.66771"reverse geocode failed - bad location?
    ## location = "34.74243"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.68827"reverse geocode failed - bad location?
    ## location = "50.84983"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.60454"reverse geocode failed - bad location?
    ## location = "40.99471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.59143"reverse geocode failed - bad location?
    ## location = "51.45366"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "82.79476"reverse geocode failed - bad location?
    ## location = "21.7866"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "126.7378"reverse geocode failed - bad location?
    ## location = "37.65863"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-54.54294"reverse geocode failed - bad location?
    ## location = "-20.61711"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.62833"reverse geocode failed - bad location?
    ## location = "54.22128"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.68342"reverse geocode failed - bad location?
    ## location = "50.11204"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.18067"reverse geocode failed - bad location?
    ## location = "51.48126"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.92381"reverse geocode failed - bad location?
    ## location = "38.8235"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.30063"reverse geocode failed - bad location?
    ## location = "32.38012"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.83957"reverse geocode failed - bad location?
    ## location = "55.66107"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.74267"reverse geocode failed - bad location?
    ## location = "51.19871"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.27302"reverse geocode failed - bad location?
    ## location = "37.80506"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23218"reverse geocode failed - bad location?
    ## location = "54.31392"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.00298"reverse geocode failed - bad location?
    ## location = "39.96196"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.53626"reverse geocode failed - bad location?
    ## location = "41.65381"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.51607,13.37698

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=28.55019,-107.48486

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=31.57182,-97.1495

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.74001,-104.99226

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.49615,-0.22942

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.88356,-1.97406

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.04521,-114.06317

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.02809,-83.32278

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.99745"reverse geocode failed - bad location?
    ## location = "40.43831"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "26.06739"reverse geocode failed - bad location?
    ## location = "64.95014"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.92496"reverse geocode failed - bad location?
    ## location = "41.30711"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-79.05661"reverse geocode failed - bad location?
    ## location = "35.91463"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.32986"reverse geocode failed - bad location?
    ## location = "52.1082"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.19951"reverse geocode failed - bad location?
    ## location = "38.62774"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.20941"reverse geocode failed - bad location?
    ## location = "17.15199"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.68659"reverse geocode failed - bad location?
    ## location = "42.05665"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.93995"reverse geocode failed - bad location?
    ## location = "41.26069"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-83.7336"reverse geocode failed - bad location?
    ## location = "42.32807"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.19951"reverse geocode failed - bad location?
    ## location = "38.62774"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-90.5651"reverse geocode failed - bad location?
    ## location = "34.19451"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-77.27348"reverse geocode failed - bad location?
    ## location = "18.11526"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-83.7826"reverse geocode failed - bad location?
    ## location = "43.0026"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-79.4172"reverse geocode failed - bad location?
    ## location = "36.58598"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.05665,-87.68659

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=18.01571,-76.79731

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.33112,-90.60536

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.33227,-89.15311

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.00336,-84.14496

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-33.86963,151.20695

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.0026,-83.7826

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-19.02116"reverse geocode failed - bad location?
    ## location = "64.96394"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.512"reverse geocode failed - bad location?
    ## location = "53.26047"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.04323"reverse geocode failed - bad location?
    ## location = "40.7174"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.78142"reverse geocode failed - bad location?
    ## location = "44.54187"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-40.77105"reverse geocode failed - bad location?
    ## location = "-19.59634"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.13058"reverse geocode failed - bad location?
    ## location = "51.63319"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.923813"reverse geocode failed - bad location?
    ## location = "38.823502"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.9454"reverse geocode failed - bad location?
    ## location = "40.8079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.64267"reverse geocode failed - bad location?
    ## location = "35.78551"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.13487"reverse geocode failed - bad location?
    ## location = "36.69094"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-82.66947"reverse geocode failed - bad location?
    ## location = "40.19033"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "151.20695"reverse geocode failed - bad location?
    ## location = "-33.86963"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.24055"reverse geocode failed - bad location?
    ## location = "53.41961"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "7.01325"reverse geocode failed - bad location?
    ## location = "43.55326"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.6075"reverse geocode failed - bad location?
    ## location = "56.87546"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.36802"reverse geocode failed - bad location?
    ## location = "35.83589"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.56116"reverse geocode failed - bad location?
    ## location = "33.10576"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.90684"reverse geocode failed - bad location?
    ## location = "43.04181"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.39535"reverse geocode failed - bad location?
    ## location = "51.27172"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.57196,-1.78644

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.5407,-77.43365

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=64.55653,12.66538

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=38.53492,-82.68448

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.7272,-90.10126

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=10.1833,-61.55

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.55792,-7.84481

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.98689,-81.24621

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-70.25665"reverse geocode failed - bad location?
    ## location = "43.65914"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.93258"reverse geocode failed - bad location?
    ## location = "60.17116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-90.645"reverse geocode failed - bad location?
    ## location = "33.45081"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-61.55"reverse geocode failed - bad location?
    ## location = "10.1833"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "145.469"reverse geocode failed - bad location?
    ## location = "-36.55865"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-84.48378"reverse geocode failed - bad location?
    ## location = "42.7375"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-101.85587"reverse geocode failed - bad location?
    ## location = "33.59233"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "147.31906"reverse geocode failed - bad location?
    ## location = "-32.83102"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-111.66851"reverse geocode failed - bad location?
    ## location = "40.23376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.95071"reverse geocode failed - bad location?
    ## location = "39.09551"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.9454"reverse geocode failed - bad location?
    ## location = "40.8079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.00093"reverse geocode failed - bad location?
    ## location = "50.87566"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.58929"reverse geocode failed - bad location?
    ## location = "42.10125"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-110.96975"reverse geocode failed - bad location?
    ## location = "32.22155"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-88.20449"reverse geocode failed - bad location?
    ## location = "40.11727"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.09072"reverse geocode failed - bad location?
    ## location = "32.08078"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.23001"reverse geocode failed - bad location?
    ## location = "54.31407"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-80.089"reverse geocode failed - bad location?
    ## location = "26.35049"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "135.70743"reverse geocode failed - bad location?
    ## location = "35.00476"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.04215"reverse geocode failed - bad location?
    ## location = "51.16166"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.59026"reverse geocode failed - bad location?
    ## location = "33.06474"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.71568,-117.16172

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.19993,-90.74988

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.76691,-86.14996

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.73569,0.47791

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.4796,-2.24881

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.24489,-85.16679

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.95227,-75.16237

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.04181,-87.90684

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=33.76672,-118.1924

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.61442,-86.4421

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.9454"reverse geocode failed - bad location?
    ## location = "40.8079"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "14.12208"reverse geocode failed - bad location?
    ## location = "40.82186"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.71819"reverse geocode failed - bad location?
    ## location = "46.71067"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.18447"reverse geocode failed - bad location?
    ## location = "51.43539"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.93995"reverse geocode failed - bad location?
    ## location = "41.26069"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.51695"reverse geocode failed - bad location?
    ## location = "56.27609"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.00054"reverse geocode failed - bad location?
    ## location = "46.73237"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-111.66851"reverse geocode failed - bad location?
    ## location = "40.23376"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-4.24251"reverse geocode failed - bad location?
    ## location = "55.8578"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.23742"reverse geocode failed - bad location?
    ## location = "25.72898"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.39535"reverse geocode failed - bad location?
    ## location = "33.86404"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.1924"reverse geocode failed - bad location?
    ## location = "33.76672"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "25.62326"reverse geocode failed - bad location?
    ## location = "-33.96243"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.94888"reverse geocode failed - bad location?
    ## location = "40.65507"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.32986"reverse geocode failed - bad location?
    ## location = "52.1082"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.46454"reverse geocode failed - bad location?
    ## location = "53.38311"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "106.82782"reverse geocode failed - bad location?
    ## location = "-6.17144"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.13585"reverse geocode failed - bad location?
    ## location = "40.85251"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.68775,-7.92415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=48.85692,2.34121

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.86121,-2.56483

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=63.82525,20.26078

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.16778,-86.77836

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.38311,-1.46454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.29368,5.37249

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.50075,-99.68095

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.37698"reverse geocode failed - bad location?
    ## location = "52.51607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.3584"reverse geocode failed - bad location?
    ## location = "43.21183"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.19951"reverse geocode failed - bad location?
    ## location = "38.62774"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-96.84842"reverse geocode failed - bad location?
    ## location = "32.38612"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-38.50456"reverse geocode failed - bad location?
    ## location = "-12.97002"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.63716"reverse geocode failed - bad location?
    ## location = "40.36959"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "144.96715"reverse geocode failed - bad location?
    ## location = "-37.81753"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.01955"reverse geocode failed - bad location?
    ## location = "35.21962"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.71747"reverse geocode failed - bad location?
    ## location = "37.99696"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.62021"reverse geocode failed - bad location?
    ## location = "36.30486"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "5.91344"reverse geocode failed - bad location?
    ## location = "52.1278"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.65016"reverse geocode failed - bad location?
    ## location = "49.87269"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-89.6436"reverse geocode failed - bad location?
    ## location = "39.80105"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-98.1607"reverse geocode failed - bad location?
    ## location = "26.30116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.55439"reverse geocode failed - bad location?
    ## location = "45.51228"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.41664"reverse geocode failed - bad location?
    ## location = "43.34348"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.08868"reverse geocode failed - bad location?
    ## location = "42.31256"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.45366,-2.59143

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.72744,1.61551

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.97903,-93.26493

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.95063,-89.61809

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.82812,12.07305

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.97903,-93.26493

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=42.98689,-81.24621

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.77815,-96.7954

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=43.64856,-79.38533

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.05033"reverse geocode failed - bad location?
    ## location = "50.79283"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.17418"reverse geocode failed - bad location?
    ## location = "40.73197"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.83829"reverse geocode failed - bad location?
    ## location = "37.4876"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-91.15625"reverse geocode failed - bad location?
    ## location = "30.64839"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.20277"reverse geocode failed - bad location?
    ## location = "55.95415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-90.36791"reverse geocode failed - bad location?
    ## location = "32.6418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "26.06739"reverse geocode failed - bad location?
    ## location = "64.95014"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-85.97874"reverse geocode failed - bad location?
    ## location = "35.83073"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.96689"reverse geocode failed - bad location?
    ## location = "57.70133"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.42005"reverse geocode failed - bad location?
    ## location = "37.77916"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.66538"reverse geocode failed - bad location?
    ## location = "64.55653"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.04215"reverse geocode failed - bad location?
    ## location = "51.16166"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.54106"reverse geocode failed - bad location?
    ## location = "27.9758"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-3.53444"reverse geocode failed - bad location?
    ## location = "54.48303"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-89.50409"reverse geocode failed - bad location?
    ## location = "39.73926"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "26.06739"reverse geocode failed - bad location?
    ## location = "64.95014"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "6.1427"reverse geocode failed - bad location?
    ## location = "46.20835"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.97406"reverse geocode failed - bad location?
    ## location = "52.88356"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.38311,-1.46454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=54.31392,-2.23218

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=34.05349,-118.24532

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.14968,-90.04892

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=35.30914,-98.52102

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-6.17144,106.82782

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.16778,-86.77836

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.79449,-1.54658

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=-37.90019,145.08084

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "144.96715"reverse geocode failed - bad location?
    ## location = "-37.81753"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.69074"reverse geocode failed - bad location?
    ## location = "41.50471"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "133.39311"reverse geocode failed - bad location?
    ## location = "-24.9162"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.49407"reverse geocode failed - bad location?
    ## location = "64.46794"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "24.93258"reverse geocode failed - bad location?
    ## location = "60.17116"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.51622"reverse geocode failed - bad location?
    ## location = "53.49815"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.34121"reverse geocode failed - bad location?
    ## location = "48.85692"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.72671"reverse geocode failed - bad location?
    ## location = "40.14323"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "1.61707"reverse geocode failed - bad location?
    ## location = "41.57953"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-78.87846"reverse geocode failed - bad location?
    ## location = "42.88544"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "9.67469"reverse geocode failed - bad location?
    ## location = "50.55356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.77836"reverse geocode failed - bad location?
    ## location = "36.16778"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-122.32944"reverse geocode failed - bad location?
    ## location = "47.60356"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.03889"reverse geocode failed - bad location?
    ## location = "43.88979"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-104.99226"reverse geocode failed - bad location?
    ## location = "39.74001"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-54.38783"reverse geocode failed - bad location?
    ## location = "-14.24292"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.24881"reverse geocode failed - bad location?
    ## location = "53.4796"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-120.54872"reverse geocode failed - bad location?
    ## location = "46.99703"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.2843"reverse geocode failed - bad location?
    ## location = "53.48973"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-100.07715"reverse geocode failed - bad location?
    ## location = "31.1689"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=44.7272,-90.10126

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=32.61436,-86.68073

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=50.77813,6.08849

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=56.65286,-3.99667

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.71455,-74.00712

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=36.97402,-122.03095

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.16418,10.45415

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=37.16793,-95.84502

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "2.30472"reverse geocode failed - bad location?
    ## location = "48.96924"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "13.37698"reverse geocode failed - bad location?
    ## location = "52.51607"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-77.029"reverse geocode failed - bad location?
    ## location = "38.8991"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.92496"reverse geocode failed - bad location?
    ## location = "41.30711"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-115.13997"reverse geocode failed - bad location?
    ## location = "36.17191"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-83.7826"reverse geocode failed - bad location?
    ## location = "43.0026"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-81.37739"reverse geocode failed - bad location?
    ## location = "28.53823"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "14.52689"reverse geocode failed - bad location?
    ## location = "40.75"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-75.16237"reverse geocode failed - bad location?
    ## location = "39.95227"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-97.1495"reverse geocode failed - bad location?
    ## location = "31.57182"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-117.41228"reverse geocode failed - bad location?
    ## location = "47.65726"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "8.22395"reverse geocode failed - bad location?
    ## location = "46.8132"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "11.96689"reverse geocode failed - bad location?
    ## location = "57.70133"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-91.52382"reverse geocode failed - bad location?
    ## location = "30.9742"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-6.00181"reverse geocode failed - bad location?
    ## location = "37.38769"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.22442"reverse geocode failed - bad location?
    ## location = "63.96027"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-73.7868"reverse geocode failed - bad location?
    ## location = "40.9197"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-81.6558"reverse geocode failed - bad location?
    ## location = "30.33138"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "12.57347"reverse geocode failed - bad location?
    ## location = "42.50382"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "26.06739"reverse geocode failed - bad location?
    ## location = "64.95014"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-95.24921"reverse geocode failed - bad location?
    ## location = "35.79798"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "10.45415"reverse geocode failed - bad location?
    ## location = "51.16418"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.00934"reverse geocode failed - bad location?
    ## location = "51.61779"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "174.77042"reverse geocode failed - bad location?
    ## location = "-36.88411"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-81.2708"reverse geocode failed - bad location?
    ## location = "33.35424"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-87.63241"reverse geocode failed - bad location?
    ## location = "41.88415"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-8.42945"reverse geocode failed - bad location?
    ## location = "53.50807"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.10602"reverse geocode failed - bad location?
    ## location = "42.36679"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.14323,-74.72671

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.74139,-73.71186

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=51.50632,-0.12714

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=40.92926,-74.22886

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.50471,-81.69074

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=53.38311,-1.46454

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=41.88415,-87.63241

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=26.71438,-80.05269

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=49.26044,-123.11403

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=39.75213,-105.05326

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "0.46694"reverse geocode failed - bad location?
    ## location = "51.57198"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "135.70743"reverse geocode failed - bad location?
    ## location = "35.00476"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-79.7947"reverse geocode failed - bad location?
    ## location = "36.06899"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12193"reverse geocode failed - bad location?
    ## location = "51.45236"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "29.88987"reverse geocode failed - bad location?
    ## location = "31.19224"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "139.74092"reverse geocode failed - bad location?
    ## location = "35.67048"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.13449"reverse geocode failed - bad location?
    ## location = "50.82821"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "17.55142"reverse geocode failed - bad location?
    ## location = "62.19845"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-2.97848"reverse geocode failed - bad location?
    ## location = "53.40977"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-73.72684"reverse geocode failed - bad location?
    ## location = "41.20633"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-1.50951"reverse geocode failed - bad location?
    ## location = "53.67763"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-83.61658"reverse geocode failed - bad location?
    ## location = "42.2148"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-72.45165"reverse geocode failed - bad location?
    ## location = "43.87165"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-71.41199"reverse geocode failed - bad location?
    ## location = "41.82387"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-118.24532"reverse geocode failed - bad location?
    ## location = "34.05349"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "146.32611"reverse geocode failed - bad location?
    ## location = "-36.35484"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed
    ## - bad location? location = "-0.12714"reverse geocode failed - bad location?
    ## location = "51.50632"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-86.68073"reverse geocode failed - bad location?
    ## location = "32.61436"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-80.83754"reverse geocode failed - bad location?
    ## location = "35.2225"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-74.00712"reverse geocode failed - bad location?
    ## location = "40.71455"

    ## Warning in revgeocode(c(.x, .y), output = "more"): reverse geocode failed -
    ## bad location? location = "-94.02978"reverse geocode failed - bad location?
    ## location = "34.31109"

    ## Information from URL : https://maps.googleapis.com/maps/api/geocode/json?latlng=52.1305,-106.65931

``` r
# store number of rows in filtered dataset
singer_filtered_rows <- singer_locations %>% 
  filter(!is.na(longitude) & !is.na(latitude))

# compute the rest of singer_locations
locations_2ndhalf <- singer_locations %>% 
  filter(!is.na(longitude) & !is.na(latitude)) %>% 
    tail(nrow(singer_filtered_rows) - 2500) %>% ### just the remaining rows
    mutate(locs = map2(longitude, latitude, possibly_func))
```

    ## query max exceeded, see ?geocode.  current total = 2500

    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500
    ## query max exceeded, see ?geocode.  current total = 2500

``` r
# merge the two data tables
locations_combined <- rbind.data.frame(locations_1sthalf, locations_2ndhalf)

# take a peek
# shows we have a nested dataframe
locations_combined %>% 
  head()
```

    ## # A tibble: 6 x 15
    ##             track_id                 title            song_id
    ##                <chr>                 <chr>              <chr>
    ## 1 TRXJANY128F42246FC         Lonely Island SODESQP12A6D4F98EF
    ## 2 TRIKPCA128F424A553 Here's That Rainy Day SOQUYQD12A8C131619
    ## 3 TRBYYXH128F4264585                 Games SOPIOCP12A8C13A322
    ## 4 TRKFFKR128F9303AE3            More Pipes SOHQSPY12AB0181325
    ## 5 TRWKTVW12903CE5ACF           Indian Deli SOGYBYQ12AB0188586
    ## 6 TRUWFXF128E0795D22         Miss Gorgeous SOTEIQB12A6702048D
    ## # ... with 12 more variables: release <chr>, artist_id <chr>,
    ## #   artist_name <chr>, year <int>, duration <dbl>,
    ## #   artist_hotttnesss <dbl>, artist_familiarity <dbl>, latitude <dbl>,
    ## #   longitude <dbl>, name <chr>, city <chr>, locs <list>

``` r
# shows the format of the locs data frame
locations_combined[["locs"]] %>% 
  head(1)
```

    ## [[1]]
    ##                                                address street_number
    ## 1 123-135 North LaSalle Street, Chicago, IL 60602, USA       123-135
    ##                  route neighborhood locality administrative_area_level_2
    ## 1 North LaSalle Street Chicago Loop  Chicago                 Cook County
    ##   administrative_area_level_1       country postal_code
    ## 1                    Illinois United States       60602

This code above took a lot of time to figure out. In the end we are using both the `map2` function and `possibly` (we call on `possibly` from within `map2`). `Possibly` is used here because some of the longtitude/latitude combinations fail to obtain a match and throw an error in which interferes with `revgeocode`.

It seems the Google Maps API limits to 2500 queries a day. As we have around 4000 rows, let's run just the first 2500 rows, and then the rest seperately.

We now have a nested data frame. We can use the "locality column" in the locs dataframe and compare it to the "dirty" variable city.

**2. Try to check wether the place in city corresponds to the information you retrieved:**

``` r
locations_combined %>% 
    mutate(match = .$city)
```

    ## # A tibble: 4,132 x 16
    ##              track_id                            title            song_id
    ##                 <chr>                            <chr>              <chr>
    ##  1 TRXJANY128F42246FC                    Lonely Island SODESQP12A6D4F98EF
    ##  2 TRIKPCA128F424A553            Here's That Rainy Day SOQUYQD12A8C131619
    ##  3 TRBYYXH128F4264585                            Games SOPIOCP12A8C13A322
    ##  4 TRKFFKR128F9303AE3                       More Pipes SOHQSPY12AB0181325
    ##  5 TRWKTVW12903CE5ACF                      Indian Deli SOGYBYQ12AB0188586
    ##  6 TRUWFXF128E0795D22                    Miss Gorgeous SOTEIQB12A6702048D
    ##  7 TRYKVFW128F4243264                      Lahainaluna SOUZVTG12A8C1308FB
    ##  8 TRUNSOU12903CC52BD         The Ingenue (LP Version) SOJESNI12AB0186408
    ##  9 TRBNFTT128F92FB599 The Unquiet Grave (Child No. 78) SOTSNHW12AB0182A9D
    ## 10 TREGTHP128F4286994                       The Breaks SORKAVQ12A8C137E9C
    ## # ... with 4,122 more rows, and 13 more variables: release <chr>,
    ## #   artist_id <chr>, artist_name <chr>, year <int>, duration <dbl>,
    ## #   artist_hotttnesss <dbl>, artist_familiarity <dbl>, latitude <dbl>,
    ## #   longitude <dbl>, name <chr>, city <chr>, locs <list>, match <chr>

``` r
locations_combined[["locs"]] %>%
        head(10) %>%
    map("locality") %>% 
        lapply(as.character) %>% ## convert factor to list
      unlist() %>%  ## convert list to character
      str() ## shows the output format
```

    ##  chr [1:8] "Chicago" "New York" "Detroit" "Howard" "Oxnard" "Bonn" ...

``` r
#locations_combined[["locs"]] %>%
#   head(10) %>%
#   mutate(locality_unnested =  map("locality") %>%
#                           lapply(as.character) %>%
#                   unlist())


### Didn't get to run this code because the above failed
#locations_combined %>%
#   head(5) %>% 
#   lapply(, str_to_lower)
#   mutate(match = as.lower(city))
```

I struggled a lot here. I did figured out the problem, the output from map is a factor as opposed to a character. Attempts to use `as.character()` failed at first, until I used it with `lapply()`.

We learned about this problem in [class a few lectures ago](http://stat545.com/block029_factors.html) (described as the **stealth factor!**)

**3. If you still have time, you can go visual: give a look to the library leaflet and plot some information about the bands:**

``` r
locations_map <- locations_combined %>%  
  leaflet()  %>%   
  addTiles() %>%  
  addCircles(popup = ~artist_name)
```

    ## Assuming 'longitude' and 'latitude' are longitude and latitude, respectively

``` r
htmlwidgets::saveWidget(locations_map, "locations_map.html")
```

![logo](https://github.com/sepkamal/STAT545-hw-Kamal-Sepehr/blob/master/Hw06/locations_map_pic.PNG)
