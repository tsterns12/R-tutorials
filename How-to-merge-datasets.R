# ----------------------------------------------
# Purpose: Merge datasets with using 'tidyverse'
# Date: December 29, 2023
# Author: Talia Sternbach
# ----------------------------------------------
# Documentation on merging functions for tidyverse can be found at: 
# https://dplyr.tidyverse.org/reference/mutate-joins.html

# Install/load required packages ====
# Use install.packages('tidyverse') if package is not loaded in R studio.
library(tidyverse)

# Create practice datasets ====
# "rnorm" generates random data according to a normal distribution with *n* 
# observations, about a given *mean* and standard deviation (*sd*).
data1 <- data.frame(ID = rep(1:10,3),
                    time = c(rep(1,10), rep(2, 10), rep(3, 10)),
                    weight = rnorm(n = 30, mean = 71, sd = 5)) # weight in kg

data2 <- data.frame(ID = rep(2:11,3),
                    time = c(rep(1,10), rep(2, 10), rep(3, 10)),
                    height = rnorm(n = 30, mean = 1.7, sd = 0.3)) # height in m

# 'data1' contains:
  # ID = participant ID
  # time = time of measurement
  # weight = participant's weight, measured in kilograms

# 'data2' contains:
  # ID = participant ID
  # time = time of measurement
  # height = participant's height, measured in metres

# View data ====
# data1
str(data1)
summary(data1)
unique(data1$ID) # unique participant IDs (1-10)
length(unique(data1$ID)) # 10 unique IDs = 10 participants

# data2
str(data2)
summary(data2)
unique(data2$ID) # unique participant IDs (2-11)
length(unique(data2$ID)) # 10 unique IDs = 10 participants

# **Question:** What is the participant's BMI at each time point? ====

# In order to calculate BMI (BMI = kg/m^2), we need participants' weight and height
# measurements at each time point. However, these variables are recorded in different 
# datasets (data1 = weight and data2 = height). We will need to merge the datasets
# in order to calculate BMI.

# Note that we have multiple participants AND multiple time points. We will need
# to merge on both the participant's 'ID' AND 'time' to ensure the correct
# weight and height measurements are matched.

# Note that while both datasets contain 10 participants, the participant with 
# ID=1 only exists in data1 and the participant with ID=2 only exists in data2. 
# Depending on how we merge the data, we can keep only participants in data1,
# only participants in data2, all participants, or only the 9 participants with 
# BOTH weight (data1) and height (data2). The type of join you use will depend 
# on how you use the merged dataset.

# (STEP 1): Merge datasets ====
## (a) 'inner_join' keeps only observations with matching IDs in BOTH datasets
combined_data_a <- data1 %>% inner_join(data2, by = c("ID", "time"))
length(unique(combined_data_a$ID)) # 9 unique IDs = 9 participants
unique(combined_data_a$ID) # Which participants are in the dataset?

## (b) 'left_join' keeps only observations in data1
combined_data_b <- data1 %>% left_join(data2, by = c("ID", "time"))
length(unique(combined_data_b$ID)) # 10 unique IDs = 10 participants
unique(combined_data_b$ID) # Which participants are in the dataset?

## (c) 'right_join' keeps only observations in data2
combined_data_c <- data1 %>% right_join(data2, by = c("ID", "time"))
length(unique(combined_data_c$ID)) # 10 unique IDs = 10 participants
unique(combined_data_c$ID) # Which participants are in the dataset?

## (d) 'full_join' keeps ALL observations in both datasets
combined_data_d <- data1 %>% full_join(data2, by = c("ID", "time"))
length(unique(combined_data_d$ID)) # 11 unique IDs = 11 participants
unique(combined_data_d$ID) # Which participants are in the dataset?

# (STEP 2): Calculating BMI ====
# Because I need both height and weight to calculat BMI, I am going to use the 
# dataset from (STEP 1, a). This dataset contains only participants with BOTH
# height and weight.

combined_data_BMI <- combined_data_a %>%
  mutate(height2 = (height^2), # square height for denominator in BMI calculation
         BMI = weight/height2) # calculate BMI

# (STEP 3): Summarize BMI data ====
# View the BMI dataset
str(combined_data_BMI)
summary(combined_data_BMI)

# Summary of BMI data, overall
summary(combined_data_BMI$BMI)
hist(combined_data_BMI$BMI, 
     xlab = "BMI (kg/m2)", main = "Histogram of BMIs")

# Summary of BMI data, by participant
BMI_per_participant <- combined_data_BMI %>%
  group_by(ID) %>%
  summarise(n = n(),
            Times = paste(unique(time), collapse = ","),
            Minimum = min(BMI, na.rm = T),
            Max = max(BMI, na.rm = T),
            Mean = mean(BMI, na.rm = T),
            SD = sd(BMI, na.rm = T)) %>%
  ungroup()

# View BMI summary by participant
BMI_per_participant

# Codebook: 
  # ID = participant's ID
  # n = number of observations per participant
  # Times = measurement times per participant
  # Minimum = minimum participant BMI over time
  # Maximum = maximum participant BMI over time
  # Mean = mean of all participant BMI measures
  # SD = standard deviation of all participant BMI measures

# END --------------------------------------------------------------------------
