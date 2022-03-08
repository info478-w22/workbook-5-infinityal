# Workbook 6: analyze NHANES data

# Set up
library(foreign)
library(survey)
library(Hmisc)
demo <- sasxport.get("DEMo_I.XPT")
alco <- sasxport.get("ALQ_I.XPT")

nhanes <- merge(x = demo, y = alco, by = "seqn", all = TRUE)
wt_sum <- sum(nhanes$wtint2yr, na.rm = TRUE)

# Analysis
nhanes$alq151[nhanes$alq151 == 2] <- 0
nhanes$alq151[nhanes$alq151 == 7] <- NA
nhanes$alq151[nhanes$alq151 == 9] <- NA

nhanes_survey <- svydesign(
  id = ~sdmvpsu,
  nest = TRUE,
  strata = ~sdmvstra,
  weights = ~wtint2yr,
  data = nhanes
  
)

nhanes_mean <- svymean(~alq151, nhanes_survey,na.rm = TRUE)

gender_mean_by <- svyby(~alq151, ~riagendr, nhanes_survey,svymean, na.rm = TRUE)
