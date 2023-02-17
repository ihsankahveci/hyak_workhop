
# make sure we have all the packages we need.
renv::restore()

library(modeldata, quietly = TRUE)
library(ggplot2, quietly = TRUE)
library(magrittr, quietly = TRUE)
library(tibble, quietly = TRUE)
library(dplyr, quietly = TRUE)

options(scipen = 99)
set.seed(57)

data(stackoverflow)

## REGRESSION with BOOTSTRAP CONFIDENCE INTERVALS
## first define the variables
## then write a for loop for bootstrapping
## collect the results into a data.frame %>% 

data = stackoverflow %>% 
  mutate(Startup = ifelse(CompanySizeNumber > 100, 0, 1))

N_list = c(100, 1000, 10000)
formula = Salary ~ -1 + Country + OpenSource + Remote + +Startup + YearsCodedJob
coef_df = list()

## for each N in the N_list
## sample the data with replacement (N times)
## run the same regression model on the resampled data (boot)
## extract model coefficients
## add them to the same data.frame
for (N in N_list){
  for (i in 1:N){
    boot = slice_sample(data, prop = 1, replace = TRUE)
    fit = glm(formula, data = boot)
    coef_df = coef(fit) %>% 
      as_tibble(rownames = "term") %>% 
      mutate("N" = as.character(N))  %>% 
      bind_rows(coef_df)
  }
  cat(N, "bootstraps are completed.\n")
}


## plot the distribution of estimates
plot = coef_df %>% 
  ggplot(aes(x = value, y = after_stat(scaled), fill = N)) + 
  geom_density(alpha = 0.5) + 
  facet_wrap(~term, scales = "free_x") + 
  ggtitle("Bootstrap samples") +
  theme_bw()

ggsave(plot, filename = "bootstrap_distribution.png")

## calculate percentile CIs
## last line splits each N into different data.frame
alpha = 0.05
bootsrap_CI = coef_df %>% 
  group_by(N, term) %>% 
  summarise_all(list(
    estimate = mean, 
    `2.5 %` = ~quantile(.x, probs = alpha),
    `97.5 %` = ~quantile(.x, probs = 1 - alpha))) %>% 
  group_split()

## save output into RDS object
saveRDS(bootsrap_CI, "bootstrap_output.RDS")
cat("Bootstrap completed and saved.\n")

## compare bootstrap CI with across N
bootsrap_CI %>% knitr::kable(digits = 1)

# making sure store the dependencies of our script
renv::snapshot()


