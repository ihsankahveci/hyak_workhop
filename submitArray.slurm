#!/bin/bash

#SBATCH --job-name=csde_workshop
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jlg0003@uw.edu
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

## export all your environment variables to the batch job session
#SBATCH --export=all

## Modules to use (optional).
module load r_3.6.0
# module load apptainer
# apptainer pull docker://rocker/tidyverse:latest

## Execute scripts
R CMD BATCH bootstrapArray.R
module load r_3.6.0
Rscript --verbose bootstrapArray.R ${SLURM_ARRAY_TASK_ID} > bootstratArray_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.Rout





