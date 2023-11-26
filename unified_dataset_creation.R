library(dplyr)
library(stringr)
library(testthat)
library(shiny)

# read in data sets
covid_df <- read.csv("WHO-COVID-19-global-data (1).csv") 
mental_health_df <- read.csv("Indicators_of_Anxiety_or_Depression_Based_on_Reported_Frequency_of_Symptoms_During_Last_7_Days.csv")

# trimming data sets 

# COVID data -------------------------------------------------------------------

  # removing the following columns, using index: 
    # 'Group'2, 'State'3, 'Subgroup'4, 'Phase'5, 'Time Period'6,'Time Period Label'7, 'Time Period Start Date'8, 'Low CI'11, 'High CI'12, 'Confidence Interval'13, 'Quartile Range'14
mental_health_df <- mental_health_df[, -c(2, 3, 4, 5, 6, 7, 8, 11, 12, 12, 13, 14)]

  # changing name of 'Time-Period-End-Date' column to 'Date'
colnames(mental_health_df)[2] <- "Date"

# MENTAL HEALTH data -----------------------------------------------------------

  # removing the following columns, using index: 
    # 'Country code'2, 'WHO region'4, 'New deaths'7, 'Cumulative deaths'8
covid_df <- covid_df[, -c(2, 4, 7, 8)]

  # changing name of 'Time-Period-End-Date' column to 'Date'
colnames(covid_df)[1] <- "Date"

  # remove all rows that do not pertain to the United States 
covid_df <- filter(covid_df, Country == "United States of America")

