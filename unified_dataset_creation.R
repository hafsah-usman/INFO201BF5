library(dplyr)
library(stringr)
library(testthat)
library(shiny)

covid_df <- read.csv("WHO-COVID-19-global-data.csv") #WHO-COVID-19-global-data.csv
mental_health_df <- read.csv("Indicators_of_Anxiety_or_Depression_Based_on_Reported_Frequency_of_Symptoms_During_Last_7_Days.csv")
