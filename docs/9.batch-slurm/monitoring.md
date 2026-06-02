# Job monitoring and efficiency

This section looks at how to monitor your job(s), including to see if they are efficient. 

Many of the relevant commands have already been discussed in previous parts: 

- `squeue`: for viewing the state of the batch queue. More here: <a href="https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#squeue" target="_blank">https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#squeue</a>
- `scancel`: to cancel a job. More info here: <a href="https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#scancel" target="_blank">https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#scancel</a>
- `sinfo`: information about the partitions/queues. More info here: <a href="https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#sinfo" target="_blank">https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#sinfo</a>
- `scontrol show job`: lots of information about a job. More info here: <a href="https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#scontrol__show__job" target="_blank">https://hpc2n.github.io/bioinformatics-hpc/9.batch-slurm/slurm/#scontrol__show__job</a>

But there are several others that have either not been mentioned or only done so briefly, including `sacct`, `projinfo`, `sshare`` and a number of center specific commands. We will look more into all of them here. 

## Why is a job ineffective? 

There are several reasons that a job might be ineffective. Some of those could be: 

- using more threads than the allocated number of cores
- not using all the cores you have allocated (unless on purpose/for memory)
- inefficient use of the file system (many small files, open/close many files)
- running a job that could run on GPUs on CPUs instead

Job monitoring is (also) about detecting signs the job is not running efficiently. This can be done with many different commands. 

## Job monitoring 

Now let us look at some of the commands that are generally available, as well as those that are specific to one or more centres. 

### Commands valid at all centres 

| Command | What |  
| ------- | ---- | 
| ``scontrol show job JOBID`` | info about a job, including *estimated* start time | 
| ``squeue --me --start`` | your running and queued jobs with *estimated* start time | 
| ``sacct -l -j JOBID`` | info about j ob, pipe to ``less -S`` for scrolling side-ways (it is a wide output) | 
| ``projinfo`` | usage of your project, adding ``-vd`` lists member usage | 
| ``sshare -l -A <proj-account>`` | gives priority/fairshare (LevelIFS) | 

Most up-to-date project usage on a project's SUPR page, linked from here: <a href="https://supr.naiss.se/project/" target="_blank">https://supr.naiss.se/project/</a>

### Site-specific (Kebnekaise) commands 

| Command | What |  
| ------- | ---- | 
| ``job-usage JOBID`` | grafana graphics of resource use for job (> few minutes) | 

