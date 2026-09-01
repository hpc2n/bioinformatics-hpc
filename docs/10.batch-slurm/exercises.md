# Extra exercises 

These exercises are meant as extra (optional) training and can be done either during classes if there is time, or later.

## Slurm commands  

These commands are run in a terminal. Either connect to Kebnekaise using an SSH client or use OpenOnDemand and start a terminal. 

1. Type the command `projinfo`. Look at the output. Try adding some options, `projinfo -vd -u <your-username>`. You now get output telling you who are in the same project and how much each has run. However, the output is not always reliable and updated. Go to `https://supr.naiss.se` and click on your project `hpc2ncourses2026-013` in the left side, then scroll down to see usage (click on usage per day and usage per account). 
2. Go into the `exercises/10.batch/MPI` and open the file `run_integration2D.sh` in an editor (`nano` is recommended). 
    - Change the project to `hpc2ncourses2026-013`. Save the file. 
    - Submit the script with `sbatch run_integration2D.sh` 
    - Do `squeue --me` to see it is in the queue. What is the status? Submit it a few more times and again check with `squeue --me`. (Remember you can use "arrow up" on the keybord to access a previous command). 
    - You get the job-ID when you submit the job and it is also listed in the furthese-left column when you do `squeue --me`. Try the command `scontrol show job <job-ID>` on one of the job-IDs. What node is the job running on (if it is already running). 
    - Use `sinfo` to see which partitions there are. 
    - Try the command `job_usage <job-ID>` on one of the jobs that have run. Copy the URL and paste it in a browser to see a graphical representation of the job's resources used. 

## Interactive jobs 



