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

# ** GAD

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

#looking at severity (percentage severity of pop per severity level)
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


# ** create a correlation heatmap of severity and demographic characteristics
#turn factor vars to numeric
sw_10 <- sw_0 %>%
  select(9,10, 11,12, 14 ) %>%
  mutate(Gender = recode(Gender, M = 1, F = 0)) %>%
  mutate(Tribe = recode(Tribe, Majority = 1, Minority = 0)) %>%
  mutate(School_Resources = recode(School_Resources, Poor = 2, Medium = 1, Rich = 0)) %>%
  mutate(Severity = recode(Severity, Minimal = 0, Mild = 1, Moderate = 2, Severe = 3)) %>%
  mutate_if(is.character, as.numeric)

head(sw_10)

# calculate the correlation matrix
cor_matrix <- cor(sw_10)

# create a basic correlation heatmap using corrplot
if (!require(corrplot)) install.packages("corrplot", repos='http://cran.us.r-project.org', dependencies=T)
library(corrplot)
corrplot(cor_matrix, method="color", order='hclust', addrect=2, addCoef.col = 'black', tl.pos = 'd',
         cl.pos = 'r', col = COL2('RdYlBu'))


# ** PHQ

#get relevant columns
dataset_phq <- dataset %>%
  select(1, 2, 3, 4, 5, 6, 7, 8, 9, 29, 30, 32, 33)

head(dataset_phq)

#score for each participant 
sw_11 <- dataset_phq %>%
  select(1, 2, 3, 4, 5, 6, 7, 8, 9, everything()) %>%
  mutate(TotalPHQ = rowSums(dataset_phq[2:9], na.rm=TRUE)) %>%
  mutate(Severity = case_when (
    TotalPHQ < 5 ~ "Mild",
    TotalPHQ < 10 ~ "Moderate",
    TotalPHQ < 15 ~ "Moderate-severe",
    TotalPHQ >= 15 ~ "Severe",
    TRUE ~ NA_character_
  ))

head(sw_11)
tail(sw_11)

# mean by groups

#pop mean
pop_PHQ_mean <- mean(sw_11$TotalPHQ) # 9.23 -> Moderate

pop_PHQ_mean

#mean by severity (average severity of pop per severity level)
sw_12 <- sw_11 %>%
  select(everything()) %>%
  group_by(Severity) %>%
  summarise(Mean = mean(TotalPHQ))

sw_12

#mean by school resources
sw_13 <- sw_11 %>%
  select(everything()) %>%
  group_by(School_Resources) %>%
  summarise(Mean = mean(TotalPHQ))

sw_13

#mean by age
sw_14 <- sw_11 %>%
  select(everything()) %>%
  group_by(Age) %>%
  summarise(Mean = mean(TotalPHQ))

sw_14

#mean by gender
sw_15 <- sw_11 %>%
  select(everything()) %>%
  group_by(Gender) %>%
  summarise(Mean = mean(TotalPHQ))

sw_15

#mean by tribe
sw_16 <- sw_11 %>%
  select(everything()) %>%
  group_by(Tribe) %>%
  summarise(Mean = mean(TotalPHQ))

sw_16

# ** Emphasis on PHQ1
#get relevant columns
dataset_phq1 <- dataset %>%
  select(1, 2, 29, 30, 31, 32, 33)

head(dataset_phq1)
tail(dataset_phq1)

#pop mean
pop_PHQ1_mean <- mean(dataset_phq1$PHQ1) # 1.33

pop_PHQ1_mean

#mean by school
sw_17 <- dataset_phq1 %>%
  select(everything()) %>%
  group_by(School) %>%
  summarise(Mean = mean(PHQ1))

sw_17

#mean by age
sw_18 <- dataset_phq1 %>%
  select(everything()) %>%
  group_by(Age) %>%
  summarise(Mean = mean(PHQ1))

sw_18

#mean by gender
sw_19 <- dataset_phq1 %>%
  select(everything()) %>%
  group_by(Gender) %>%
  summarise(Mean = mean(PHQ1))

sw_19

#mean by tribe
sw_20 <- dataset_phq1 %>%
  select(everything()) %>%
  group_by(Tribe) %>%
  summarise(Mean = mean(PHQ1))

sw_20
