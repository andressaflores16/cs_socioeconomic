Data Cleaning and Exploratory Analysis
================
Andressa Flores Salvatierra
2024-07-01

## Basics

First we need to load the data that will be used. In the original
project 3 data sets were chosen: World Development Indicators (WDI),
Health Equity and Financial Protection Indicators (HEFPI) and Health
Nutrition and Population Statistics (HNPS).  
However, this totals to 2262 variables available, and considering that
there are many years of data available, it would all be too much to
handle. I’ve chosen to stick to WDI data set first, and see if I can
incorporate the other data sets later in the analysis, to gain further
insights.  
Below, a preview of the two data sets that will be merged to compose the
final input data set. They are in long format:

``` r
cs_section_rates_raw <- read_csv("BETRAN2018_dados_v2.csv", col_names = TRUE, show_col_types = FALSE)
glimpse(cs_section_rates_raw)
```

    ## Rows: 2,024
    ## Columns: 5
    ## $ `ISO Code`                   <chr> "AFG", "AFG", "AFG", "AFG", "ALB", "ALB",…
    ## $ Country                      <chr> "Afghanistan", "Afghanistan", "Afghanista…
    ## $ `Coverage start year`        <dbl> 2005, 2008, 2010, 2016, 1992, 1993, 1994,…
    ## $ `Coverage end year`          <dbl> 2010, 2011, 2015, 2018, 1992, 1993, 1994,…
    ## $ `Caesarean section rate (%)` <chr> "5", "3.6", "2.7", "6.6", "9.3", "9.8", "…

``` r
world_develop_indic_raw <- read_csv("dados/WDI_CSV/WDIData.csv", show_col_types = FALSE)
```

    ## New names:
    ## • `` -> `...68`

``` r
glimpse(world_develop_indic_raw)
```

    ## Rows: 395,276
    ## Columns: 68
    ## $ `Country Name`   <chr> "Africa Eastern and Southern", "Africa Eastern and So…
    ## $ `Country Code`   <chr> "AFE", "AFE", "AFE", "AFE", "AFE", "AFE", "AFE", "AFE…
    ## $ `Indicator Name` <chr> "Access to clean fuels and technologies for cooking (…
    ## $ `Indicator Code` <chr> "EG.CFT.ACCS.ZS", "EG.CFT.ACCS.RU.ZS", "EG.CFT.ACCS.U…
    ## $ `1960`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1961`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1962`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1963`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1964`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1965`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1966`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1967`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1968`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1969`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1970`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1971`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1972`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1973`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1974`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1975`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1976`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1977`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1978`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1979`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1980`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1981`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1982`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1983`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1984`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1985`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1986`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1987`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1988`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1989`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1990`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1991`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1992`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1993`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1994`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1995`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1996`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1997`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1998`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `1999`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ `2000`           <dbl> 11.580366, 3.546244, 32.604500, 19.957302, 8.623497, …
    ## $ `2001`           <dbl> 11.907943, 3.713752, 32.964159, 19.975365, NA, 53.235…
    ## $ `2002`           <dbl> 12.285175, 3.904902, 33.409617, 21.576500, NA, 55.340…
    ## $ `2003`           <dbl> 12.607641, 4.093657, 33.791497, 22.529265, 9.765491, …
    ## $ `2004`           <dbl> 12.990589, 4.312080, 34.220485, 23.749531, 10.910243,…
    ## $ `2005`           <dbl> 13.394404, 4.530435, 34.727444, 23.493013, 10.442796,…
    ## $ `2006`           <dbl> 13.835255, 4.759641, 35.159518, 25.191221, 12.518041,…
    ## $ `2007`           <dbl> 14.2571198, 5.0041450, 35.6949836, 26.8079371, 12.527…
    ## $ `2008`           <dbl> 14.687203, 5.237581, 36.102188, 25.943316, 12.986509,…
    ## $ `2009`           <dbl> 15.124112, 5.483481, 36.447583, 26.193895, 15.527791,…
    ## $ `2010`           <dbl> 15.545214, 5.733854, 36.849648, 27.400110, 14.462760,…
    ## $ `2011`           <dbl> 16.028677, 5.957514, 37.180314, 28.914348, 16.100904,…
    ## $ `2012`           <dbl> 16.4474987, 6.2242756, 37.5407488, 31.6669279, 19.375…
    ## $ `2013`           <dbl> 16.914625, 6.473301, 37.870347, 31.695183, 18.672306,…
    ## $ `2014`           <dbl> 17.392349, 6.720331, 38.184152, 31.859257, 17.623956,…
    ## $ `2015`           <dbl> 17.892005, 7.015917, 38.543180, 33.903515, 16.516633,…
    ## $ `2016`           <dbl> 18.359993, 7.281390, 38.801719, 38.851444, 24.594474,…
    ## $ `2017`           <dbl> 18.7951512, 7.5136731, 39.0390136, 40.1973319, 25.389…
    ## $ `2018`           <dbl> 19.2951759, 7.8095655, 39.3231864, 43.0283322, 27.041…
    ## $ `2019`           <dbl> 19.7881558, 8.0758886, 39.6438476, 44.3897728, 29.138…
    ## $ `2020`           <dbl> 20.2795988, 8.3660097, 39.8948302, 46.2686206, 30.998…
    ## $ `2021`           <dbl> 20.773627, 8.684137, 40.213891, 48.103609, 32.772690,…
    ## $ `2022`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ ...68            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…

We can see that the WDI data set has many NA values, so it probably has
a lot of empty columns/rows. We will remove them from both data sets and
check how many rows/cols are left:

``` r
# removing empty columns from cs section rate data (dependent variable)
cs_rates <- cs_section_rates_raw %>%
  purrr::discard(~ all(is.na(.)))
# removing empty rows
cs_rates <- cs_rates %>%
  filter(if_all(everything(), ~ !is.na(.))) # 
# getting the # of rows and cols to compare w/raw data
rows_cs <- nrow(cs_rates)
cols_cs <- ncol(cs_rates)

# same for wdi world bank data set (independent variables)
wdi <- world_develop_indic_raw %>%
  purrr::discard(~ all(is.na(.)))
# removing empty rows
wdi <- wdi %>%
  filter(if_all(everything(), ~ !is.na(.)))
# getting the of rows and cols to compare w/raw data
rows_wdi <- nrow(wdi)
cols_wdi <- ncol(wdi)
# output number of rows and cols of each data set
cat("# of rows cs_rates:", rows_cs, "\n# of columns cs_rates:", cols_cs, "\n")
```

    ## # of rows cs_rates: 2024 
    ## # of columns cs_rates: 5

``` r
cat("# of rows wdi:", rows_wdi, "\n# of columns wdi:", cols_wdi, "\n")
```

    ## # of rows wdi: 24357 
    ## # of columns wdi: 67

As we can see, this cs section rates data set does not have any empty
rows and columns, as the numbers didn’t change before and after the
first cleaning steps. In comparison, the wdi set changed a lot, as it
had more than 100,000 empty rows which where sucessfully removed. Only
one column was removed. We will later check the number of NAs remaining
in the non empty columns/rows.

Now we’ll rename the columns so they are easier to work with in the
code:

``` r
wdi <- wdi %>%
  dplyr::rename(country = 1,
         country_code = 2, 
         indicator_name = 3,
         indicator_code = 4)

cs_rates <- cs_rates %>%
  dplyr::rename(country_code = 1,
         country = 2,
         coverage_start_year = 3,
         coverage_end_year = 4,
         cs_section_rate = 5)

# reorder the columns
cs_rates <- cs_rates %>% relocate(country, .before = country_code)
```

Now let’s check if all the data types are correct, and make any final
tweaks the data set may need before processing:

``` r
sapply(cs_rates, class)
```

    ##             country        country_code coverage_start_year   coverage_end_year 
    ##         "character"         "character"           "numeric"           "numeric" 
    ##     cs_section_rate 
    ##         "character"

``` r
sapply(wdi, class)
```

    ##        country   country_code indicator_name indicator_code           1960 
    ##    "character"    "character"    "character"    "character"      "numeric" 
    ##           1961           1962           1963           1964           1965 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           1966           1967           1968           1969           1970 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           1971           1972           1973           1974           1975 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           1976           1977           1978           1979           1980 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           1981           1982           1983           1984           1985 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           1986           1987           1988           1989           1990 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           1991           1992           1993           1994           1995 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           1996           1997           1998           1999           2000 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           2001           2002           2003           2004           2005 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           2006           2007           2008           2009           2010 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           2011           2012           2013           2014           2015 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           2016           2017           2018           2019           2020 
    ##      "numeric"      "numeric"      "numeric"      "numeric"      "numeric" 
    ##           2021           2022 
    ##      "numeric"      "numeric"

It seems like we only need to change the column `cs_section_rate` to
`numeric`:

``` r
# cs_rates <- cs_rates %>% 
#  mutate(cs_section_rate = as.double(cs_section_rate))
table(cs_rates$cs_section_rate)
```

    ## 
    ## <1.0  0.3  0.4  0.5  0.6  0.7  0.8  0.9    1  1.1  1.2  1.3  1.4  1.5  1.6  1.7 
    ##    1    1    1    1    2    2    3    1    5    2    2    5    6    5    8    6 
    ##  1.8  1.9   10 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9   11 11.1 11.2 11.3 
    ##    5    9    9    6    4    3    3    7    4    3    5    4    6    6    6    5 
    ## 11.4 11.5 11.6 11.7 11.8 11.9   12 12.1 12.2 12.3 12.4 12.5 12.6 12.7 12.8 12.9 
    ##    5    5    6    3    4    3    3    3    4    8    9    7    7    8    7    6 
    ##   13 13.1 13.2 13.3 13.4 13.5 13.6 13.7 13.8 13.9   14 14.1 14.2 14.3 14.4 14.5 
    ##    8    6    2    1    9    8    7    5    7    7    5    6    8    1    5    3 
    ## 14.6 14.7 14.8 14.9   15 15.1 15.2 15.3 15.4 15.5 15.6 15.7 15.8 15.9   16 16.1 
    ##   11    9    4    4    8    6   10    6    4    6   10    6    7   12   20    7 
    ## 16.2 16.3 16.4 16.5 16.6 16.7 16.8 16.9   17 17.1 17.2 17.3 17.4 17.5 17.6 17.7 
    ##    8    9   14    7    9    7    7    8   14    7   10   10    9   10   10    6 
    ## 17.8 17.9   18 18.1 18.2 18.3 18.4 18.5 18.6 18.7 18.8 18.9   19 19.1 19.2 19.3 
    ##    8    4    8    3    4    8    4    8    4    8    4    9    6   10    7    7 
    ## 19.4 19.5 19.6 19.7 19.8 19.9    2  2.1  2.2  2.3  2.4  2.5  2.6  2.7  2.8  2.9 
    ##    6    9    6    7    7   10   13    7    2    3    6   11    5   12    4    3 
    ##   20 20.1 20.2 20.3 20.4 20.5 20.6 20.7 20.8 20.9   21 21.1 21.2 21.3 21.4 21.5 
    ##    7    7    5    6    7   10    9    3   10    9   10    6   13    7    4    5 
    ## 21.6 21.7 21.8 21.9   22 22.1 22.2 22.3 22.4 22.5 22.6 22.7 22.8 22.9   23 23.1 
    ##    4    4    5    7   12    7    2    5    5    3    4    9    3    6    5    4 
    ## 23.2 23.3 23.4 23.5 23.6 23.7 23.8 23.9   24 24.1 24.2 24.3 24.4 24.5 24.6 24.7 
    ##    6    3    6    3   13    3    5   10    5    6    3    3    8    5    5    4 
    ## 24.8 24.9   25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9   26 26.1 26.2 26.3 
    ##    3    8    6    3    4    8    2    4    2    5    7    5    5    4    7    3 
    ## 26.4 26.5 26.6 26.7 26.8 26.9   27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.9 
    ##    2    7    6    5    4    7    3    4    1    8    3    8    4    4    3    4 
    ##   28 28.1 28.2 28.4 28.5 28.6 28.7 28.8 28.9   29 29.1 29.2 29.3 29.4 29.5 29.6 
    ##    6    6    5    3    1    5    3    7    5    5    4    3    4    5    6    2 
    ## 29.7 29.8 29.9    3  3.1  3.2  3.3  3.4  3.5  3.6  3.7  3.8  3.9   30 30.1 30.2 
    ##    4    3    6    9   10    6    4    5    4    5    7    8    7    2    1    4 
    ## 30.3 30.4 30.5 30.6 30.7 30.8 30.9   31 31.1 31.2 31.3 31.4 31.5 31.6 31.7 31.8 
    ##    5    5    6    3    5    2    5    5    4    3    7    2    4    5    2    3 
    ## 31.9   32 32.1 32.2 32.3 32.4 32.5 32.6 32.7 32.8 32.9   33 33.1 33.2 33.3 33.4 
    ##    7    6    2    5    5    4    2    1    4    6    3    5    7    8    4    3 
    ## 33.5 33.6 33.7 33.8   34 34.1 34.2 34.3 34.4 34.5 34.6 34.7 34.8 34.9   35 35.1 
    ##    2    3    6    2    4    2    2    3    1    3    3    3    2    3    3    1 
    ## 35.2 35.3 35.4 35.6 35.7 35.8 35.9   36 36.1 36.2 36.3 36.4 36.7 36.9   37 37.2 
    ##    3    2    3    4    1    2    1    2    1    2    1    4    3    2    1    1 
    ## 37.3 37.4 37.5 37.6 37.7 37.8   38 38.1 38.3 38.6 38.9   39 39.1 39.2 39.4 39.5 
    ##    4    2    3    1    1    2    1    3    1    2    1    2    3    1    1    1 
    ## 39.6 39.8 39.9    4  4.1  4.2  4.3  4.4  4.5  4.6  4.7  4.8  4.9   40 40.1 40.2 
    ##    1    1    1    7    3    1    2    5    5   10    3    3    4    3    2    1 
    ## 40.4 40.7 40.8 40.9   41 41.1 41.4 41.6 41.8 41.9 42.8   43 43.1 43.2 43.6 43.7 
    ##    2    1    1    1    1    1    1    1    1    1    1    2    1    3    1    1 
    ## 43.8 43.9 44.4 44.5   45 45.3 45.5 45.6 45.8 45.9 46.1 46.2 46.3 46.4 46.5 46.6 
    ##    2    1    1    1    1    1    1    3    1    1    1    3    1    1    1    2 
    ## 46.7 46.9 47.1 47.3 47.7 47.8 48.1 48.3 48.4 48.5 48.7 48.8   49 49.2 49.3 49.6 
    ##    1    1    1    1    1    2    1    1    1    1    1    1    1    1    1    1 
    ##    5  5.1  5.2  5.3  5.4  5.5  5.6  5.7  5.8  5.9   50 50.4 50.6 50.7 50.8 50.9 
    ##    5   10    2    9    5    3    4    3    6    5    1    1    1    1    1    1 
    ## 51.8 52.2 52.3 52.5 53.3 53.4 53.7 55.3 55.4 55.5 55.6 55.7 56.4 56.6 56.9   57 
    ##    1    1    1    1    1    1    2    2    1    1    1    1    1    1    2    1 
    ## 58.1    6  6.1  6.2  6.3  6.4  6.5  6.6  6.7  6.8  6.9    7  7.1  7.2  7.3  7.4 
    ##    1    5    4    5    7    6    4    9    5    6    3    4    4    6    4    3 
    ##  7.5  7.6  7.7  7.8  7.9    8  8.1  8.2  8.3  8.4  8.5  8.6  8.7  8.8  8.9    9 
    ##    7    2    4    4    4    2    3    2    3    5    3   10    4    3    2    8 
    ##  9.1  9.2  9.3  9.4  9.5  9.6  9.7  9.8  9.9 
    ##    7    5   10    6    3   11    5    3    6
