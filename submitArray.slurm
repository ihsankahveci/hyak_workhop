#!/bin/bash

#SBATCH --job-name=csde_workshop
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ikahveci@uw.edu
#SBATCH --account=csde

## Resources
#SBATCH --partition=csde
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50G
#SBATCH --time=1:00:00 # Max runtime in DD-HH:MM:SS format.

## specify the working directory for this job
## (.) means current directory
#SBATCH --chdir=.

## using slurm arrays and managing exports
#SBATCH --array=1-3
#SBATCH --export=bootstrapArray_%j_%a.out

## Modules to use (optional).
module load r_3.6.0
# module load apptainer
# apptainer pull docker://rocker/tidyverse:latest

## Execute scripts
srun Rscript --verbose bootstrapArray.R ${SLURM_ARRAY_TASK_ID} 






