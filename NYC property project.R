## IMPORT PACKAGES
install.packages("tidyverse")
install.packages("visdat")
install.packages("naniar")

library(tidyverse)
library(readxl)
library(visdat)
library(naniar)
library(magrittr)


## IMPORT DATA
setwd("~/Downloads")
brooklyn <- read_excel("rollingsales_brooklyn.xlsx", skip = 4) #import brooklyn dataset
bronx <- read_excel("rollingsales_bronx.xlsx", skip = 4) #import bronx dataset
manhattan <- read_excel("rollingsales_manhattan.xlsx", skip = 4) #import manhattan dataset
queens <- read_excel("rollingsales_queens.xlsx", skip = 4)
statenisland <- read_excel("rollingsales_statenisland.xlsx", skip = 4)

## DATA CLEANING AND MANIPULATION 

# Bind all dataframes into one
NYC_property_sales <- bind_rows(brooklyn, bronx, manhattan, queens, statenisland)
NYC_property_sales <- NYC_property_sales %>%
  select(- `EASEMENT`, - `APARTMENT NUMBER`) # the first 4 variables contain all missing values while the last one contains nealry 80% of NAs

# Update colnames in the datasest
colnames(NYC_property_sales) %<>% str_replace_all("\\s", "_") %<>% tolower()
glimpse(NYC_property_sales)

## DEALING WITH MISSING VALUES 
# Are there any missing values?
n_miss(NYC_property_sales) #the number of missing values is quite high: 138235
pct_miss(NYC_property_sales) #about 10% of data are missing

# Visualize missing values on the dataset
downsampled_data <- NYC_property_sales %>%
  slice_sample(prop = 0.1) %>%
  vis_miss()
downsampled_data

# Use naniar package
miss_var_summary(NYC_property_sales)
miss_case_summary(NYC_property_sales)

NYC_property_sales %>%
  group_by(borough) %>%
  miss_var_summary()

gg_miss_var(NYC_property_sales, facet = borough) #borough 1 has the most missing values, while borough 2 and 5 have the least.
gg_miss_case(NYC_property_sales) #shall delete, not really useful 



## EXPLORATORY DATA ANALYSIS 
#Create a histogram to view Brooklyn house price over Time 
ggplot(brooklyn, aes(x = `SALE DATE`)) +
  geom_histogram(binwidth = 2000000) 



