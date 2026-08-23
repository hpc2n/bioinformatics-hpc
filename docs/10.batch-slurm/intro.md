# Introduction to "Running batch jobs with Slurm on HPC systems"

!!! note "Learning outcomes"

    - Concepts of a job scheduler
        - why it is needed
        - basic priniples how it works
    - sbatch with options for CPU job scripts
    - sample job scripts
        - Basic jobs
        - I/O intensive jobs
        - OpenMP and MPI jobs
        - Job arrays
        - Simple example for task farming
        - increasing the memory per task / memory hungry jobs
        - running on GPUs
    - job monitoring, job efficiency
    - how to find optimal sbatch options

For most of this section you only need a terminal window on Kebnekaise, so you can either login with regular SSH or you could use OpenOnDemand's Kebnekaise desktop and open a terminal. Doing the latter one is a bit "overkill" since you are actually running a batch job when you have started a Kebnekaise desktop there. 

Another option is using ThinLinc if you feel confident with that. 

!!! note "Login info"

    - SSH: ``ssh <user>@kebnekaise.hpc2n.umu.se``
    - ThinLinc:
        - Server: ``kebnekaise-tl.hpc2n.umu.se``
        - Username: ``<your-hpc2n-username>``
        - Password: ``<yout-hpc2n-password>``
    - ThinLinc Webaccess:
        - Put ``https://kebnekaise-tl.hpc2n.umu.se:300/`` in browser address bar
        - Put ``<your-hpc2n-username>`` and ``<your-hpc2n-password>`` in th e login box that opens and click ``Login``
    - Open OnDemand: ``https://portal.hpc2n.umu.se`` 

## Schedule

| Time | Topic | Activity | Teacher |
| ---- | ----- | -------- | ------- |
| 09:00 | Introduction | Lecture | PO |
| 09:10 | Batch system concepts | Lecture | PO |
| 09:30 | Slurm commands | Lecture + code-along + exercises | PO |
| 10:20 | BREAK | | |
| 10:35 | Interactive jobs | Lecture + code-along | BB | 
| 10:50 | Job script examples | Lecture + code-along + exercises | BB |
| 12:00 | BREAK | | | 
| 13:00 | Job monitoring and efficiency | Lecture + code-along + exercises | BB | 
| 13:50 | Summary | Lecture | BB, PO | 
| 14:00 | End of course day | | |

## Prepare the exercise environment 

It is now time to login and download the exercises. 

1. Login to your Kebnekaise, as mentioned above. . 
2. Create a directory to work in: ``mkdir batch-intro``
3. Fetch the exercises tarball: ``wget https://github.com/hpc2n/bioinformatics-hpc/raw/refs/heads/main/exercises.tar.gz``
4. Unpack the tarball: ``tar zxvf exercises.tar.gz``
5. You will get a directory ``exercises``. Go into it: ``cd exercises``
6. Go into the subdirectory ``10.batch``.
7. There will be various directories for the different types of batch scripts. 
8. Within the directories should be various batch script examples (and some .py, .f90 and .c files for the test scripts). 

