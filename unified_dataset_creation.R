library(dplyr)
library(stringr)
library(testthat)
library(shiny)

# read in data sets
covid_df <- read.csv("WHO-COVID-19-global-data (1).csv") 
mental_health_df <- read.csv("Indicators_of_Anxiety_or_Depression_
                             Based_on_Reported_Frequency_of_Symptoms_During_
                             Last_7_Days.csv")

# trimming data sets
