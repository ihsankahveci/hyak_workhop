# HYAK WORKSHOP
This repo is created as a part of the CSDE Workshop on Introduction to the UNIX/Linux Shell.  
It includes a sample script for working with UW HYAK -- on-campus high-performance computing platform for scalable scientific computing.

## Instructions
**Object:** Running a simple regression model and calculating Bootstrap Confidence Intervals. 

1. First we need to log-in to our HYAK instance. Open a terminal instance and paste the following:  
```bash 
ssh [UW-NetID]@mox.hyak.uw.edu
```

2. Enter your password. Then, you will be directed to 2-Factor Authentication via Duo Mobile. 

3. Once you are successfully logged in, navigate to your project directory. (Hint: `ls`, `cd`, `pwd` commands are your best friends.)

4. Then, you can submit your job via this command:  
```bash 
sbatch submit.slurm
```

5. If successfuly, you should receive a message with your job id:  
`Submitted batch job [JOBID]`

6. You can track the progress of your job via: 
```bash 
sacct -j [JOBID]
```

## Files:  
- `example.R`: Demonstration of the task, interactively. 
- `bootstrap.R`: Bootstrapping script designed to be used with slurm script.  
-  `submit.slurm`: Slurm script for allocating resources, submitting jobs, exporting the output.
- `slurm-[JOBID].out`: Once our job is finished, the console output is stored in here.
- `bootstrap_output.RDS`: The resulting data.frame with bootstrap estimates. 
- `bootstrap_distribution.png`: Plots that show the distribution of estimates.


