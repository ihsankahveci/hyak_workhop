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
library(dplyr, warn.conflicts = FALSE, quietly = TRUE)