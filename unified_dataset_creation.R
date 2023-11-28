library(dplyr)
library(stringr)
library(testthat)
library(shiny)
#install.packages("lubridate")
library(lubridate)

covid_df <- read.csv("WHO-COVID-19-global-data (1).csv") 
mental_health_df <- read.csv("Indicators_of_Anxiety_or_Depression_Based_on_Reported_Frequency_of_Symptoms_During_Last_7_Days.csv")

# ------------------ TRIMMING / FORMATTING DATA SETS ------------------ #

# COVID data

  # removing the following columns, using index: 
    # 'Group' = 2, 'State' = 3, 'Subgroup' = 4, 'Phase' = 5, 'Time Period' = 6,
    # 'Time Period Label' = 7, 'Time Period Start Date' = 8, 'Low CI' = 11, 
    # 'High CI' = 12, 'Confidence Interval' = 13, 'Quartile Range' = 14
mental_health_df <- mental_health_df[, -c(2, 3, 4, 5, 6, 7, 8, 11, 12, 12, 13, 14)]

  # changing name of 'Time-Period-End-Date' column to 'Date'
colnames(mental_health_df)[2] <- "Date"

# MENTAL HEALTH data

  # removing the following columns, using index: 
    # 'Country code' = 2, 'WHO region' = 4, 'New deaths' = 7, 'Cumulative deaths' = 8
covid_df <- covid_df[, -c(2, 4, 7, 8)]

  # changing name of 'Time-Period-End-Date' column to 'Date'
colnames(covid_df)[1] <- "Date"

  # remove all rows that do not pertain to the United States 
covid_df <- filter(covid_df, Country == "United States of America")


# ------------------ TIME FRAME FOR DATA SETS ------------------ #

# only need data between April 2020 - September of 2023

# COVID data
  # convert Date column to Date class
covid_df$Date <- as.Date(covid_df$Date, format = "%Y-%m-%d")
  # keep data between April 2020 and October 2023 
covid_df <- covid_df[covid_df$Date >= as.Date("2020-06-01") & covid_df$Date <= as.Date("2023-09-30"), ]

# MENTAL HEALTH data
  # convert Date column to Date class
mental_health_df$Date <- as.Date(mental_health_df$Date, format = "%m/%d/%Y")
  # keep data between April 2020 and October 2023 
mental_health_df <- mental_health_df[mental_health_df$Date >= as.Date("2020-06-01") 
                                     & mental_health_df$Date <= as.Date("2023-09-30"), ]

# -------------- CREATE MONTH ONLY COLUMN --------------------------- #

# need to group data by month # NEW NUMERICAL COLUMN

# COVID data 
covid_df$date_column <- as.Date(covid_df$Date)  
covid_df$Month <- format(covid_df$date_column, "%m")


# MENTAL HEALTH data
mental_health_df$date_column <- as.Date(mental_health_df$Date)  
mental_health_df$Month <- format(mental_health_df$date_column, "%m")


# --------------- MERGE DATA --------------------------------------- #

# outer join/full join - using 'Date' value as matching condition
unified_df <- merge(x=covid_df, y=mental_health_df, by="Date", all = TRUE)

# -------------- CREATE RISK LEVEL COLUMN --------------------------- #

# for either condition, assess risk based on percentage value given # NEW CATEGORICAL COLUMN

unified_df$Risk <- cut(unified_df$Value, breaks = c(-Inf, 25, 50, Inf), 
                       labels = c("Low Risk", "Moderate Risk", "High Risk"), right = FALSE)
 

# -------------- CONDENSE DATA --------------------------- #

# find average of all data for each month

print(colnames(unified_df))

