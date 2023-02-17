
renv::restore()
library(modeldata)
library(tidyverse)
options(scipen = 99)
set.seed(57)

data(stackoverflow)

## explore the data
stackoverflow |> glimpse()
## sanity check on the dependent variable
hist(stackoverflow$Salary)

data = stackoverflow |> 
  mutate(Startup = ifelse(CompanySizeNumber > 100, 0, 1))

## REGRESSION with MODEL CONFIDENCE INTERVALS
## aka. DELTA METHOD
fit = glm(Salary ~ -1 + Country + OpenSource + Remote + Startup + YearsCodedJob,
          data = data)

## R has a buit-in summary function for GLM objects.
summary(fit)

## Let's create our own summary table
## Understanding this is important for the second part.
model_CI = confint(fit, level = 0.95) |> 
  as_tibble(rownames = "terms") |> 
  mutate(estimate = coef(fit), .after = "terms") 


## REGRESSION with BOOTSTRAP CONFIDENCE INTERVALS
## first define the variables
## then write a for loop for bootstrapping
## collect the results into a data.frame

data = stackoverflow |> 
  mutate(Startup = ifelse(CompanySizeNumber > 100, 0, 1))

N = 100
formula = Salary ~ -1 + Country + OpenSource + Remote + Startup + YearsCodedJob
coef_df = list()

## from 1 to N times
## sample the data with replacement
## run the same regression model on the resampled data (boot)
## extract model coefficients
## add them to the same data.frame
for (i in 1:N){
  boot = slice_sample(data, prop = 1, replace = TRUE)
  fit = glm(formula, data = boot)
  boot_coef = as_tibble(coef(fit), rownames = "term")
  coef_df = rbind(coef_df, boot_coef)
}

## check the output data.frame
head(coef_df)

## plot the distribution of estimates
coef_df |> 
  ggplot(aes(x = value, y = after_stat(scaled))) + 
  geom_density() + 
  facet_wrap(~term, scales = "free_x") + 
  ggtitle(paste0(N, " bootstrap samples")) +
  theme_bw()

## calculate percentile CIs
alpha = 0.05
bootsrap_CI = coef_df |> 
  group_by(term) |> 
  summarise_all(list(
    estimate = mean, 
    `2.5 %` = ~quantile(.x, probs = alpha),
    `97.5 %` = ~quantile(.x, probs = 1 - alpha))) 
  

## compare bootstrap CI with model CI
model_CI |> knitr::kable(digits = 1)
bootsrap_CI |> knitr::kable(digits = 1)







