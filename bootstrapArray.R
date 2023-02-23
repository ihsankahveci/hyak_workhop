# Setup ####
# make sure we have all the packages we need.
# install.packages("renv")
renv::restore()

## Array Job info ####
## Define vector we previously looped over
N_list = c(100, 500, 1000)

## Grab integer index of job (i.e. 1, 2, or 3 for elements of N_list)
array_index = as.numeric(commandArgs(trailingOnly = TRUE))

## Specify N (the looping variable from bootstrap.R)
## as the appropriate element of N_list
N = N_list[array_index]

## Libraries ####
# install.packages(c("modeldata", "ggplot2",
#                    "magrittr", "tibble", "dplyr"))
library(modeldata, quietly = TRUE)
library(ggplot2, quietly = TRUE)
library(magrittr, quietly = TRUE)
library(tibble, quietly = TRUE)
library(dplyr, quietly = TRUE)

## Set options and seed ####
options(scipen = 99)
set.seed(57)

## Load data ####
data(stackoverflow)

# REGRESSION with BOOTSTRAP CONFIDENCE INTERVALS ####
## first define the variables
## then write a for loop for bootstrapping
## collect the results into a data.frame %>% 

data = stackoverflow %>% 
  mutate(Startup = ifelse(CompanySizeNumber > 100, 0, 1))

## Specify model formula object
formula = Salary ~ -1 + Country + OpenSource + Remote + +Startup + YearsCodedJob
coef_df = list()

## Fit model + bootstrap ####
## for each N in the N_list
## sample the data with replacement (N times)
## run the same regression model on the resampled data (boot)
## extract model coefficients
## add them to the same data.frame

for (i in 1:N){
  boot = slice_sample(data, prop = 1, replace = TRUE)
  fit = glm(formula, data = boot)
  coef_df = coef(fit) %>% 
    as_tibble(rownames = "term") %>% 
    mutate("N" = as.character(N))  %>% 
    bind_rows(coef_df)
}
cat(N, "bootstraps are completed.\n")



## plot the distribution of estimates ####
plot = coef_df %>% 
  ggplot(aes(x = value, y = after_stat(scaled))) + 
  geom_density(fill = 'lightblue', alpha = 0.5) + 
  facet_wrap(~term, scales = "free_x") + 
  ggtitle("Bootstrap samples") +
  theme_bw()

ggsave(plot, filename = paste0("plots/bootstrap_distribution_", N, ".png"))

## calculate percentile CIs ####
## last line splits each N into different data.frame
alpha = 0.05
bootsrap_CI = coef_df %>% 
  group_by(term, N) %>% 
  summarise_all(list(
    estimate = mean, 
    `2.5 %` = ~quantile(.x, probs = alpha),
    `97.5 %` = ~quantile(.x, probs = 1 - alpha)))

## save output into RDS object ####
saveRDS(bootsrap_CI, paste0("output/bootstrap_output_", N, ".RDS"))
cat("Bootstrap completed and saved.\n")

## compare bootstrap CI with across N ####
bootsrap_CI %>% knitr::kable(digits = 1)

# making sure store the dependencies of our script ####
renv::snapshot()


