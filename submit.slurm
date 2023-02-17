#!/bin/bash

#SBATCH --job-name=csde_workshop
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ikahveci@uw.edu
#SBATCH --account=csde

## Resources
#SBATCH --partition=csde
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10G
#SBATCH --gpus=<type:quantity> 
#SBATCH --time=1:00:00 # Max runtime in DD-HH:MM:SS format.

## specify the working directory for this job
## (.) means current directory
#SBATCH --chdir=.

## export all your environment variables to the batch job session
#SBATCH --export=all

## Modules to use (optional).
# module load r_3.6.0
module load apptainer
apptainer pull docker://rocker/tidyverse:latest


## scripts to be executed here
Rscript bootstrap.R




