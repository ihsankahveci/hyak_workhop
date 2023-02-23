# Setup ####
# make sure we have all the packages we need.
if (!require("renv")) install.packages("renv")

renv::restore()

## Specify N for number of bootstraps
N = 100 
 
## Libraries ####
# install.packages(c("modeldata", "ggplot2",
#                    "magrittr", "tibble", "dplyr", "knitr"))
library(modeldata, warn.conflicts = FALSE, quietly = TRUE)
library(ggplot2, warn.conflicts = FALSE, quietly = TRUE)
library(magrittr, warn.conflicts = FALSE, quietly = TRUE)
library(tibble, warn.conflicts = FALSE, quietly = TRUE)
library(dplyr, warn.conflicts = FALSE, quietly = TRUE)

## Set options and seed ####
options(scipen = 99)
set.seed(57)

## Load data ####
data(stackoverflow)

# REGRESSION with BOOTSTRAP CONFIDENCE INTERVALS ####
## first define the variables
## then write a for loop for bootstrapping
## collect the results into a data.frame 

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
    bind_rows(coef_df)
}
cat(N, "bootstraps are completed.\n")


## plot the distribution of estimates ####
plot = coef_df %>% 
  ggplot(aes(x = value, y = after_stat(scaled))) + 
  geom_density(fill = 'lightgreen', alpha = 0.5) + 
  facet_wrap(~term, scales = "free_x") + 
  ggtitle(paste0(N, " bootstrap samples")) +
  theme_bw()

## Create plots folder if doesn't exist ####
if(!dir.exists("./plots")){
  dir.create("./plots")
}

## Save plot ####
ggsave(plot, filename = "plots/bootstrap_distribution.png")

## calculate percentile CIs ####
## last line splits each N into different data.frame
alpha = 0.05
bootsrap_CI = coef_df %>% 
  group_by(term) %>% 
  summarise_all(list(
    estimate = mean, 
    `2.5 %` = ~quantile(.x, probs = alpha),
    `97.5 %` = ~quantile(.x, probs = 1 - alpha)))


## Create output folder if doesn't exist ####
if(!dir.exists("./output")){
  dir.create("./output")
}

## save output into RDS object ####
saveRDS(bootsrap_CI, "output/bootstrap_output.RDS")
cat("Bootstrap completed and saved.\n")

## compare bootstrap CI with across N ####
bootsrap_CI %>% knitr::kable(digits = 1)



