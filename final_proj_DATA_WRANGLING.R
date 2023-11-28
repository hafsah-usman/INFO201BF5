# INFO 201 AUT2023: B/BF
# GROUP: BF5
# HAFSAH USMAN, FAIZA IMRAN, ANUUJIN CHADRAA
# Prof. Julia Deeb-Swihart

# libraries
library(dplyr)
library(stringr)
library(testthat)
library(shiny)
library(lubridate)

# ------------------------ READ IN DATA SETS --------------------------------- #

covid_df <- read.csv("WHO-COVID-19-global-data (1).csv") 
mental_health_df <- read.csv("Indicators_of_Anxiety_or_Depression_Based_on_Reported_Frequency_of_Symptoms_During_Last_7_Days.csv")

# -------------------- TRIMMING / FORMATTING DATA SETS ----------------------- #

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
    # 'Country code' = 2, 'WHO region' = 4, 'New deaths' = 7, 
    # 'Cumulative deaths' = 8
covid_df <- covid_df[, -c(2, 4, 7, 8)]
  # changing name of 'Time-Period-End-Date' column to 'Date'
colnames(covid_df)[1] <- "Date"


  # retain only rows  
covid_df <- filter(covid_df, Country == "United States of America")


# ---------------------- TIME FRAME FOR DATA SETS ---------------------------- #

# only need data between April 2020 - September of 2023

# COVID data
  # convert Date column to Date class
covid_df$Date <- as.Date(covid_df$Date, format = "%Y-%m-%d")
  # keep data between April 2020 and October 2023 
covid_df <- covid_df[covid_df$Date >= as.Date("2020-06-01") & 
                       covid_df$Date <= as.Date("2023-09-30"), ]

# MENTAL HEALTH data
  # convert Date column to Date class
mental_health_df$Date <- as.Date(mental_health_df$Date, format = "%m/%d/%Y")
  # keep data between April 2020 and October 2023 
mental_health_df <- mental_health_df[mental_health_df$Date >= as.Date("2020-06-01") 
                                     & mental_health_df$Date <= as.Date("2023-09-30"), ]

# --------------------- CREATE MONTH ONLY COLUMN ----------------------------- #

# COVID data 
  # convert Date column to Date class
covid_df$date_column <- as.Date(covid_df$Date)  
covid_df$Month <- format(covid_df$date_column, "%m")

# MENTAL HEALTH data
  # convert Date column to Date class
mental_health_df$date_column <- as.Date(mental_health_df$Date)  
mental_health_df$Month <- format(mental_health_df$date_column, "%m")


# --------------------------- MERGE DATA ------------------------------------- #

# outer join/full join - using 'Date' value as matching condition
unified_df <- merge(x=covid_df, y=mental_health_df, by="Date", all = TRUE)

# -------------- CREATE RISK LEVEL AND YEAR MONTH COLUMN --------------------- #

# for any condition, assess risk based on percentage value given # NEW CATEGORICAL COLUMN
unified_df$Risk <- cut(unified_df$Value, breaks = c(-Inf, 25, 50, Inf), 
                       labels = c("Low Risk", "Moderate Risk", "High Risk"), right = FALSE)

# add column to organize data by year/month # NEW NUMERICAL COLUMN
unified_df$MonthYear <- format(unified_df$Date, "%Y-%m")

# ----------------------------- CONDENSE DATA -------------------------------- #

# GROUP AND SUMMARIZE DATA
# per each month between April 2020 and September 2023: 
# - average number of new COVID cases
# - total number of cumulative cases by end of month 
# - average percentage of 'Symptoms of Depressive Disorder'
# - average percentage of 'Symptoms of Anxiety Disorder'
# - average percentage of 'Symptoms of Anxiety Disorder or Depressive Disorder'
final_df <- summarise(group_by(unified_df, MonthYear, Indicator), 
                    Average_Percentage_per_Condition = mean(Value, na.rm = TRUE),
                    Average_New_Cases = mean(New_cases, na.rm = TRUE),
                    Cumulative_Cases_EndOfMonth = last(Cumulative_cases))

# --------------------------------- REFINE ----------------------------------- #

# filter out rows with missing values for all columns
final_df <- final_df[complete.cases(final_df), ]

# ------------------------- SAVE DF AS CSV FILE ------------------------------ #
write.csv(final_df, "unified_and_cleaned_data.csv", row.names = FALSE)