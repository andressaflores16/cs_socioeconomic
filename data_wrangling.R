### ___disabling scientific notation___###
options(scipen = 999)

### ___full list of indicators available in World Bank___###

indicators <- wb_indicators()

### ___import raw data from World Bank___###
cs_section_rates <- read_csv("BETRAN2018_dados_v2.csv", col_names = TRUE, show_col_types = FALSE)

health_equity_fpi_raw <- read_csv("dados/HEFPI_CSV/HEFPIData.csv")
health_equity_fpi_raw

health_nutrition_pop_stats_raw <- read_csv("dados/HNP_Stats_CSV/HNP_StatsData.csv")
health_nutrition_pop_stats_raw

world_develop_indic_raw <- read_csv("dados/WDI_CSV/WDIData.csv")
world_develop_indic_raw

# -------------------------------------------------------------------------------------------------------

### ___remove empty rows and columns using janitor package___###
health_equity_fpi <- remove_empty(health_equity_fpi_raw, which = c("rows", "cols"), cutoff = 1, quiet = FALSE)
# No empty rows to remove. Removing 6 empty columns of 42 columns total (Removed: 1982, 1983, 1984, 1985, 1989, ...42).


health_nutrition_pop_stats <- remove_empty(health_nutrition_pop_stats_raw, which = c("rows", "cols"), cutoff = 1, quiet = FALSE)
# No empty rows to remove. Removing 1 empty columns of 68 columns total (Removed: ...68).

world_develop_indic <- remove_empty(world_develop_indic_raw, which = c("rows", "cols"), cutoff = 1, quiet = FALSE)
# No empty rows to remove.Removing 1 empty columns of 68 columns total (Removed: ...68).

### ___changing WB and CS column names___###
health_equity_fpi <- health_equity_fpi %>%
  rename(
    country = 1,
    country_code = 2,
    indicator_name = 3,
    indicator_code = 4,
  )

health_nutrition_pop_stats <- health_nutrition_pop_stats %>%
  rename(
    country = 1,
    country_code = 2,
    indicator_name = 3,
    indicator_code = 4,
  )

world_develop_indic <- world_develop_indic %>%
  rename(
    country = 1,
    country_code = 2,
    indicator_name = 3,
    indicator_code = 4,
  )

cs_section_rates <- cs_section_rates %>%
  rename(
    country_code = 1,
    country = 2,
    coverage_start_year = 3,
    coverage_end_year = 4,
    cs_section_rate = 5,
  )

# -------------------------------------------------------------------------------------------------------
##### _____FILTERING DATABASES_____#####

# countries in (Betran, 2018) WHO study to filter WB data sets
countries_who <- unique(cs_section_rates[c("country_code", "country")])

# only multi-word country names in previous list
countries_who_multi <- grep(pattern = "[-()]", x = countries_who$country, value = TRUE)

# typo found in one of the country codes in WHO data (VEM instead of VEN, representing Venezuela), correction
cs_section_rates$country_code[cs_section_rates$country_code == "VEM"] <- "VEN"
# OBS: run 2 previous lines again to update wrong country code in other objects

# -------------------------------------------------------------------------------------------------------

# use countries_who to filter FIRST WB DATABASE: Health Equity and Financial Protection Indicators (HEFPI)
health_equity_countries_who <- health_equity_fpi %>% filter(health_equity_fpi$country_code %in% countries_who$country_code)

# countries represented in the filtered table
health_equity_filtered_countries <- unique(health_equity_countries_who[c("country_code", "country")])

# left join to combine data frames to check which countries from WHO data aren't present in the health_equity table
combined_health_equity <- left_join(countries_who, health_equity_filtered_countries, by = "country_code", suffix = c("_who", "_health_equity"))

# filter rows where content differs
health_equity_diff <- combined_health_equity %>%
  mutate(equal = mapply(identical, country_who, country_health_equity)) %>%
  filter(!equal)

# removing GBR observations from health_equity_countries_who as they are separated by regions of the UK in one data set whilst the other has data for the UK as a whole
health_equity_countries_who <- health_equity_countries_who %>%
  filter(country_code != "GBR")

# -------------------------------------------------------------------------------------------------------
# use countries_who to filter SECOND WB DATABASE: Health Nutrition And Population Statistics
health_nutrition_countries_who <- health_nutrition_pop_stats %>% filter(health_nutrition_pop_stats$country_code %in% countries_who$country_code)
health_nutrition_filtered_countries <- unique(health_nutrition_countries_who[c("country_code", "country")])

# left join to combine data frames to check which countries from WHO data aren't present in the health_nutrition table
combined_health_nutrition <- left_join(countries_who, health_nutrition_filtered_countries, by = "country_code", suffix = c("_who", "_health_nutrition"))

# filter rows where content differs
health_nutrition_diff <- combined_health_nutrition %>%
  mutate(equal = mapply(identical, country_who, country_health_nutrition)) %>%
  filter(!equal)
# observing health_nutrition_diff above, we can see that the 3 countries missing from health_nutrition are actually different regions of the UK, since WHO data has United Kingdom-England, United Kingdom-Northern Ireland, United Kingdom-Scotland & United Kingdom-Wales. since the join was done with the country code, all of the UK regions matched with GBR and United Kingdom from health_nutrition dataset. The UK observations will have to be deleted since no region is specified in the health_nutrition observations

# removing GBR observations from health_nutrition_who, same problem as previous database
health_nutrition_countries_who <- health_nutrition_countries_who %>%
  filter(country_code != "GBR")

# -------------------------------------------------------------------------------------------------------
# use countries_who to filter THIRD WB DATABASE: World Development Indicators
wdi_countries_who <- world_develop_indic %>% filter(world_develop_indic$country_code %in% countries_who$country_code)
wdi_filtered_countries <- unique(wdi_countries_who[c("country_code", "country")])

# left join to combine data frames to check which countries from WHO data aren't present in the health_nutrition table
combined_wdi <- left_join(countries_who, wdi_filtered_countries, by = "country_code", suffix = c("_who", "_wdi"))

# filter rows where content differs
wdi_diff <- combined_wdi %>%
  mutate(equal = mapply(identical, country_who, country_wdi)) %>%
  filter(!equal)

# removing GBR observations from wdi_countries_who, same problem as previous database
wdi_countries_who <- wdi_countries_who %>%
  filter(country_code != "GBR")

# -------------------------------------------------------------------------------------------------------
# remove GBR from cs_section_rates also, no corresponding data in WB data sets
cs_section_rates <- cs_section_rates %>%
  filter(country_code != "GBR")

# -------------------------------------------------------------------------------------------------------
# selecting only cs_section_rates observations with one year of coverage and editing cs_rates_one_year for future join
cs_rates_one_year <- cs_section_rates %>% filter(coverage_start_year == coverage_end_year) %>% rename(year = coverage_start_year) %>% select(-coverage_end_year)

# year list from WHO data set to filter WB data sets
cs_rates_one_year_list <- cs_rates_one_year %>% count(year) 

# filter columns from WB data sets according to years represented in cs_rates_one_year_list
# FIRST WB DATA SET: Health Equity and Financial Protection Indicators (HEFPI)
HEFPI_countries_who_one_year <- health_equity_countries_who %>% select(1:4, all_of(as.character(cs_rates_one_year_list$coverage_start_year)))

# SECOND WB DATA SET: Health Nutrition And Population Statistics (HNPS)
HNPS_countries_who_one_year <- health_nutrition_countries_who %>% select(1:4, all_of(as.character(cs_rates_one_year_list$coverage_start_year)))

# THIRD WB DATA SET: World Development Indicators (WDI)
wdi_countries_who_one_year <- wdi_countries_who %>% select(1:4, all_of(as.character(cs_rates_one_year_list$year)))

# -------------------------------------------------------------------------------------------------------
###___melting the WDI data set so it can be compatible with WHO data set___###
# see script wdi_data_cleaning_y.r which outputs wdi_wide_y

###___merging WHO data set with WB wdi data set___###
# changing year column type of WHO data set to factor w/29 levels
cs_rates_one_year$year <- as.factor(cs_rates_one_year$year)

# check duplicated rows in WHO data
cs_dupes <- cs_rates_one_year %>% filter(duplicated(cs_rates_one_year))
# -> returned 8 duplicated lines

# remove duplicated lines from cs_rates_one_year
cs_rates_one_year <- data_unique(cs_rates_one_year, select = c("country_code", "year"))

# WB wdi data, output of script wdi_data_cleaning_y (fast track version w/o duplicated lines)
wdi_wide_y <- read_csv("fast_track_wdi_wide.csv")

# changing year column to factor in WB WDI data set
wdi_wide_y$year <- as.factor(wdi_wide_y$year)

# inner join to merge the two data sets (WB WDI + WHO)
cs_wdi <- inner_join(wdi_wide_y, cs_rates_one_year, by = c("country_code" = "country_code", "year" = "year"))

# removing second country column and reorganizing columns
cs_wdi_org <- cs_wdi %>% select(-country.y) %>% rename(country = country.x) %>% 
  select(country, country_code, year, cs_section_rate, everything())

# -------------------------------------------------------------------------------------------------------
# checking which columns have more than 70% of NA values
#na_columns_wdi <- as.data.frame(colnames(wdi_wide_y)[colMeans(is.na(wdi_wide_y)) > 0.7])
library(dplyr)

na_proportion <- wdi_wide_y %>%
  summarise_all(funs(mean(is.na(.))))

# checking which lines have more than 70% of NA values
na_rows_wdi <- wdi_wide_y[apply(wdi_wide_y, 1, function(x) mean(is.na(x))) > 0.7, ]

# removing columns that have more than 70% of NA values
wdi_wide <- remove_empty(wdi_wide_y, which = "cols", cutoff = 0.8, quiet = FALSE)
