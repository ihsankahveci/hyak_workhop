#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)

for (i in args){
  print(paste0('Hello! I am a task number: ', i))
}