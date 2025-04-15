#' -----
#' Purpose: Practice with 'marginaleffects' package
#' Author: Talia Sternbach (with help from website below)
#' Date created: March 6, 2024
#' Last update: March 6, 2024
#' -----

# Load packages
library(lme4)
library(marginaleffects)
library(tidyverse)

# Prep data ====================================================================
# Load data
data("Orange") # Growth of Orange Trees
head(Orange)

# Add factor variable
# Whether or not the tree was exposed to pests
Orange$pests = sample(x = c(0,1), size = nrow(Orange), 
                      replace = T, prob = c(0.75, 0.25))

Orange$pests = as.factor(Orange$pests) # set as factor variable

# View data summary
summary(Orange)
# Tree = unique ID for each orange tree
# age = age of the tree
# circumference = tree circumference in centimeters
# pests = whether the tree was exposed to pests

# Are older trees bigger, controlling for exposure to pests? ===================
## Simple linear model
lm_growth <- lm(circumference ~ age + pests, data = Orange)
lm_growth

## Multiple measurements per tree -- adding a random intercept for 'Tree'
re_growth <- lmer(circumference ~ age + pests + (1|Tree), 
                  data = Orange, 
                  REML = T, # optimize REML criterion rather than log-likelihood
                  na.action = na.omit # run complete case
                  )
re_growth
confint(re_growth)
## On average, an orange tree's circumference increases by ~0.11 (0.10, 0.12) cm per year of growth.

# Marginal effects =============================================================
# Text, quotes, code, and other materials from: 
# https://marginaleffects.com/vignettes/get_started.html#:~:text=The%20marginaleffects%20package%20allows%20R,special%20case%20of%20averaged%20predictions.

# Marginal can refer to
  # (1) marginal effects = "effect of a tiny (marginal) change in the regressor
    # on the outcome (i.e., slope or partial derivative)."
  # (2) marginal means = marginalizing over rows of a prediction grid (i.e., 
    # taking the average or integral over observations).

## (1) Predictions ----
## "outcome predicted by a fitted model on a specified scale for a given 
## combination of values of predictor variables" (ex. observed values, means, 
## or factor levels of predictor variables). Alternate names = fitted values or 
## adjusted predictions.

## Predictions returns unit-level estimates, so we get one prediction per row 
## of the original dataframe. These are 'conditional' estimates -- conditional 
## on the levels of predictors included in the regression model.

predictions(re_growth)

## We can also get predictions based on specific values of predictors.
## Ex. Predicted tree growth with all predictors set to their mean values.

predictions(re_growth, 
            newdata = "mean")

## The predicted orange tree circumference = 101 (82.4, 119.0) cm for tree #1,
## at 922 years old, and without pests.

## We can also use 'datagrid' to specify levels of the predictors. Any predictor
## without value(s) in datagrid are set to their mean or mode.

predictions(re_growth, 
            newdata = datagrid(
              Tree = c(1:5),
              pests = c(0,1))
            )

## Using this approach, we can get the predicted tree circumference for each 
## tree, with and without exposure to pests, at the mean age of all trees in the data set.

## We could also specify the value of predictors as a function. For example,
## below, we get the predicted tree circumference at the min and max tree ages 
## in the observed data, holding 'Tree' and 'pests' at their mean/mode.

predictions(re_growth, 
            newdata = 
              datagrid(age = range)
            )

## (2) Comparisons ----
## Allows us to compare model predictions across different regressor values.
## E.g., contrasts, differences, risk ratios, odds, etc.

## (3) Slopes ----
## Takes a partial derivative with respect to predictor(s) of interest (e.g., 
## getting a 'marginal effect' or trend).

## Running slopes on the full regression yields a marginal effect estimate for each
## observation in the original data frame AND for each predictor in your regression
## model (i.e., slopes yields nrow(data.frame) x n_predictors).

slopes(re_growth)

nrow(Orange)*2 # slopes should return 70 marginal effect estimates
nrow(slopes(re_growth)) # we get 70 estimates

## For continuous variables, slopes gives the change in the outcome ('marginal effect')
## for a 1-unit increase in the continuous predictor. We get the difference
## in the outcome ('marginal effect') between levels of binary variables. If we 
## have a categorical predictor with >2 levels, slopes will return the marginal
## effect for each level of the predictor relative to the baseline value.

## We can also estimate the partial derivative ('marginal effect') of the outcome 
## for a specific predictor. The code below gives the marginal effect 
## (change in tree circumference) for each observation in the original data frame 
## with respect to the predictor 'age'.

slopes(re_growth,
       variables = "age")

## We see that on average, a 1-year increase in tree age results in an ~0.11 cm 
## increase in tree circumference.

## We can also estimate the partial derivative with respect to a specific predictor
## while other predictors are set at a specific value, or at their mean/mode value.

slopes(re_growth,
       variables = "age",
       newdata = datagrid(pests = 0:1,
                          Tree = 1:5))

## The marginal effect for age is the same in all specifications b/c we estimated
## a linear model without interactions or variable transformations. So, the marginal
## effect will be the same across levels of different variables.

## Adding in the 'by' argument allows us to "marginalize within subgroups of the
## data".

slopes(re_growth,
       variables = "age",
       newdata = datagrid(pests = 0:1,
                          Tree = 1:5),
       by = "pests")

## or...

slopes(re_growth,
       variables = "age",
       by = "pests")

## Removing the 'newdata' specification doesn't change the results because 'by'
## is already marginalizing over variable levels specified in 'newdata' within
## subgroups of the "by" variable(s).

## Subsetting the original data is another way to specify 'newdata'.
slopes(re_growth,
       variables = "age",
       newdata = subset(Orange, Tree == 3),
       by = "pests")




#-------------------------------------------------------------------------------
# USING A NEW DATA FRAME
# Create new data for baseline predictions
new_data_baseline <- 
  data1 %>%
  #subset(data1, coal_ban==1) %>%                          # subset coal_ban == 1 b/c we're estimating ATT -- the effect in *treated* units and reference for coal_ban == 0 so there won't be estimated effects at level == 0 (right?).
  mutate(PM25_indoor_seasonal_hs = realtime_hs_PM_gm,      # set indoor PM to mean baseline value (year 2) in untreated homes
         temp = mean_w1_temp)                              # set indoor temperature to mean baseline value (year 1)

# Create new data for WHO predictions
new_data_WHO <- 
  data1 %>%
  #subset(data1, coal_ban==1) %>%                          # subset coal_ban == 1 b/c we're estimating ATT -- the effect in *treated* units and reference for coal_ban == 0 so there won't be estimated effects at level == 0 (right?).
  mutate(PM25_indoor_seasonal_hs = who_pm,                 # set indoor PM to WHO annual avg recommendation
         temp = who_temp)                              # set indoor temperature to WHO recommendation



slopes(etwfe_raw,
       variables = "coal_ban",
       newdata = new_data_baseline)

## The marginal effect for age is the same in all specifications b/c we estimated
## a linear model without interactions or variable transformations. So, the marginal
## effect will be the same across levels of different variables.

## Adding in the 'by' argument allows us to "marginalize within subgroups of the
## data".

slopes(etwfe_raw,
       variables = "coal_ban",
       newdata = new_data_baseline,
       by = c("coal_ban"))

slopes(etwfe_raw,
       newdata = new_data_baseline,
       by = "coal_ban")

## or...

slopes(etwfe_raw,
       variables = "coal_ban",
       by = "coal_ban")

## Removing the 'newdata' specification doesn't change the results because 'by'
## is already marginalizing over variable levels specified in 'newdata' within
## subgroups of the "by" variable(s).

