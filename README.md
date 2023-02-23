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

4. We can use `sftp` or `git` (recommended) for file transfer between local and HYAK. (Hint: You can use `lcd`, `lls`, `lpwd` to navigate through local files.)
```bash
sftp [UW-NetID]@mox.hyak.uw.edu
put -r [PATH-TO-LOCAL-FILE]
```

5. Then, you can submit your job via this command:  
```bash 
sbatch submit.slurm
```

6. If successfuly, you should receive a message with your job id:  
`Submitted batch job [JOBID]`

7. You can track the progress of your job via: 
```bash 
sacct -j [JOBID]
```
8. Once finished, you can do quickly check the output in command line:
```bash
cat slurm-*
```
9. To export final output into our local machines, we can use `sftp` or `git` (recommended) again:
```bash
get -r [PATH-TO-REMOTE-FILE]
```

## Files:  
- `example.R`: Demonstration of the task, interactively. 
- `bootstrap.R`: Bootstrapping script designed to be used with a slurm script.  
- `submit.slurm`: Slurm script for a single batch submission.
- `slurm-[JOBID].out`: Once our job is finished, the console output is stored in here.
- `output/`: The resulting data.frames with bootstrap estimates. 
- `plots/`: Plots that show the distribution of bootstrap estimates.
- `bootstrapArray.R`: Bootstrapping script modified for array batch submission  
- `submitArray.slurm`: Slurm script modified for array batch submission.
- `slurm-[JOBID]_N.out`: Outputs of array batches stored in this format.


