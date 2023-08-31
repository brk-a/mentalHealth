#!/usr/bin/env Rscript

#load data
dataset <- read.csv("./shamiri_imputed_dataset.csv", sep=",", header=T)

#see if data loaded
head(dataset)
tail(dataset)

#tidyverse
#call `tidyverse`
if (!require(tidyverse)) install.packages("tidyverse", repos='http://cran.us.r-project.org', dependencies=T)
library(tidyverse)

#get relevant columns
dataset <- dataset %>%
    dataset <- dataset %>%
    select(1, 10, 11, 12, 13, 14, 15, 16, 29, 30, 32, 33)

#see if data loaded
head(dataset)
tail(dataset)

#GAD score for each participant
sw_0 <- dataset %>%
  select(1, 2, 3, 4, 5, 6, 7, 8, everything()) %>%
  mutate(TotalGAD = rowSums(sw_0[2:8], na.rm=TRUE)) %>%
  mutate(Severity = case_when (
          TotalGAD < 5 ~ "Minimal",
          TotalGAD < 10 ~ "Mild",
          TotalGAD < 15 ~ "Moderate",
          TotalGAD >= 15 ~ "Severe",
          TRUE ~ NA_character_
        ))

#see if data loaded and find avg GAD score
head(sw_0)
tail(sw_0)
pop_GAD_mean <- mean(sw_0$TotalGAD) # 8.11 -> Mild

#looking at severity
sw_1 <- sw_0 %>%
  select(everything()) %>%
  group_by(Severity) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_1

# looking at school resources
sw_2 <- sw_0 %>%
  select(everything()) %>%
  group_by(School_Resources) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_2

#looking at age
sw_3 <- sw_0 %>%
  select(everything()) %>%
  group_by(Age) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_3 # why is there age 20.5? is that age significant in GAD analysis? age 14-19 inc a/cs for 88% of respondents

# looking at gender
sw_4 <- sw_0 %>%
  select(everything()) %>%
  group_by(Gender) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_4 # 48.6% of respondents -> M, 51.4% -> F

#looking at tribe
sw_5 <- sw_0 %>%
  select(everything()) %>%
  group_by(Tribe) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_5 # 34.5% -> majority. does that make sense statistically? was the study heavy on minority tribes?

#looking at severity and school resources
sw_6 <- sw_0 %>%
  select(everything()) %>%
  group_by(Severity, School_Resources) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_6

#looking at severity and age
sw_7 <- sw_0 %>%
  select(everything()) %>%
  group_by(Severity, Age) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_7

#looking at severity and gender
sw_8 <- sw_0 %>%
  select(everything()) %>%
  group_by(Severity, Gender) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_8

#looking at severity and tribe
sw_9 <- sw_0 %>%
  select(everything()) %>%
  group_by(Severity, Tribe) %>%
  summarise(Freq = n()) %>%
  mutate(Percentage = Freq / sum(Freq) * 100)

sw_9

# ** prepare numerical variables and factor variable
#numerical and factor variables
data <- dataset[2:8] # Numerical variables
groups <- dataset[9:12] #Factor variables

#see if each loaded
head(data)
head(groups)

#create a correlogram of GAD scores
pairs(data,                     # Data frame of variables
      labels = colnames(data),  # Variable names
      pch = 22,                 # Pch symbol
      bg = rainbow(length(5),   # Background colour of the symbol (pch 21 to 25)
      col = rainbow(5),  # Border colour of the symbol
      main = "GAD scores",      # Title of the plot
      row1attop = TRUE,         # If FALSE, changes the direction of the diagonal
      gap = 1,                  # Distance between subplots
      cex.labels = NULL,        # Size of the diagonal text
      font.labels = 1)          # Font style of the diagonal text
