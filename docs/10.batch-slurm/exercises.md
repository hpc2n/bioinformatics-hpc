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

Batch jobs are not normally interactive, and you cannot usually make changes to them after submitting them. If you need to do that, you use *interactive* jobs. 

Interactive jobs are jobs where you ask for resources, like for a batch job, but you do not send off the commands for computations and such, instead work on the resources in a back and forth, *interactive* manner. 

On Kebnekaise this can happen in two ways; either with the command `salloc` or through OpenOnDemand. 

Using `salloc` is not true interactivity, in that you stay on the login node and have to preface every command with `srun` in order to run it on the compute node resources you have allocated. 

With OpenOnDemand you work directly on the allocated compute nodes, like on a regular desktop. 

1. What do you get if you allocate resources with `salloc -A hpc2ncourses2026-013 -t 00:10:00 -n 1`?
    - In addition, what happens if you run a script or executable directly, without prefacing it with `srun`? 
2. Go to https://portal.hpc2n.umu.se/ and login.
    - Start a "Kebnekaise desktop" and ask for 2 cores (Any nodes) for 1 hour. Launch the desktop when the resources have been allocated. Open a terminal (XCFE terminal or MATE terminal depending on what desktop environment you chose). 
    Try with the command `srun /bin/hostname` to see that you got two cores and on which node(s) they are allocated. 

## Sample job scripts 

The exercises are using files located within the directory you got from unpacking the tarball. They are in subdirectories under `exercises/10.batch/`. 

The directory/folder `exercises` and its subdirectories are located either in your home directory (go there with `cd`) or in your project storage (go there with `cd /proj/nobackup/cddb_course/<the-dir-you-created>) depending on where you placed it.  

- The batch scripts you need to submit all have suffixes `.sh`. 
- Some, but not all of the batch scripts have the project ID already added. You should always check! Use `nano <the-batchscript>` to see if it is added. If not, do so! You project ID is "hpc2ncourses2026-013". 

1. Go to the subfolder `dependency` under `<path-to/>exercises/10.batch/`
    - Check with `nano mmmult.py` if the project ID is added. Otherwise do so. Then exit (and save). 
    - Submit it with `sbatch mmmult.sh`
    - Check on it with `squeue --me`. Is it running? Pending? 
    - What is the job ID? 
    - If it has started running, check if it has started writing to a file named `slurm-<job ID>.out` 
2. Go to the subfolder `MPI` under `<path-to/>exercises/10.batch/` and use `nano` to check if the batch script `run_integration2D.sh` has the correct project ID. Otherwise change it to "hpc2ncourses2026-013". 
    - Note that `srun` is used to run the MPI executable. Also note that this executable (Python script) has an input and how it is given in the batch submit script. 
    - Also note that this batch script has named output and error files. 
    - Submit the batch script mentioned above. See which output files are created. 
    - Try and make some changes to the batch script (open with `nano`, make the changes, quit-save) and submit it to see if the output changes.
        - Change the name of the output/error files (keep the `%j` as this is the job ID and guarantees unique output files so nothing gets overwritten). 
        - Change the number of MPI tasks (it is 14 cores in the study material and 16 in the submit script in the exercises - try another number) 
        - Change the input parameter from 10000 to something else. Note, if you make it larger, the 10 minutes walltime may or may not be enough. 
3. How would you change the batch script `run_integration2D.sh` to give each task more memory? There is more than one answer. 
4. Inside the subfolder `job-array` there is a job script `hello-world-array.sh`. Change to the subfolder. 
    - Look inside the job script with `nano hello-world-array.sh`. How many tasks are there in the array here? Also see how many cores for each task. 
    - Change `<proj ID>` to "hpc2ncourses2026-013". Quit-save. 
    - Submit the batch script. Check with `squeue --me`. How many cores are allocated? How many output files are created? 
    - Try and change the number of tasks in the array (use `nano`). Quit-save. Submit the batch script again. Check with `squeue --me`. Did the number of allocated cores change? What about the number of output files? 
5. 


