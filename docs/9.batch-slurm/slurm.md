# Introduction to Slurm

The batch system used at HPC2N (and most other HPC centres in Sweden) is called Slurm.

!!! note "Guides and documentation"

    - HPC2N: <a href="https://docs.hpc2n.umu.se/documentation/batchsystem/intro/" target="_blank">https://docs.hpc2n.umu.se/documentation/batchsystem/intro/</a>

Slurm is an Open Source job scheduler, which provides three key functions:

- Keeps track of available system resources - it allocates to users, exclusive or non-exclusive access to resources for some period of time
- Enforces local system resource usage and job scheduling policies - provides a framework for starting, executing, and monitoring work
- Manages a job queue, distributing work across resources according to policies

Slurm is designed to handle thousands of nodes in a single cluster, and can sustain throughput of 120,000 jobs per hour.

You can run programs either by giving all the commands on the command line or by submitting a job script.

Using a job script is often recommended:

- If you ask for the resources on the command line, you will wait for the program to run before you can use the window again (unless you can send it to the background with ``&``).
- If you use a job script you have an easy record of the commands you used, to reuse or edit for later use.

In order to run a batch job, you need to create and submit a SLURM submit file (also called a batch submit file, a batch script, or a job script).

## Slurm commands

There are many more commands than the ones we have chosen to look at here, but these are the most commonly used ones. You can find more information on the Slurm homepage: <a href="https://slurm.schedmd.com/documentation.html" target="_blank">Slurm documentation</a>.

- **salloc**: requesting an interactive allocation
- **interactive**: another way of requesting an interactive allocation
- **sbatch**: submitting jobs to the batch system
- **squeue**: viewing the state of the batch queue
- **scancel**: cancel a job
- **scontrol show**: getting more info on jobs, nodes
- **sinfo**: information about the partitions/queues

Let us look at these one at a time.

### salloc and interactive

This will be covered in the next section about Interactive. 

### sbatch

The command ``sbatch`` is used to submit jobs to the batch system.

This is done from the command line in the same way at all the HPC centres in Sweden:

```bash
sbatch <batchscript.sh>
```

For any batch submit script ``<batchscript.sh>``. 

- You can name the submit script whatever you want to. 
- It is a convention to use the suffix ``.sbatch`` or ``.sh``, but it is not a requirement. You can use any or no suffix. It is merely to make it easier to find the script among the other files.

!!! note

    - At clusters that have OpenOnDemand installed, like Kebnekaise, you do not have to submit a batch job, but can run directly on the already allocated resources (see interactive jobs).
        - OpenOnDemand is a good option for interactive tasks, graphical applications/visualization, and simpler job submittions. It can also be more user-friendly.
        - Regardless, there are many situations where submitting a batch job is the best option instead, including when you want to run jobs that need many resources (time, memory, multiple cores, multiple GPUs) or when you run multiple jobs concurrently or in a specified succession, without need for manual intervention. Batch jobs are often also preferred for automation (scripts) and reproducibility. Many types of application software fall into this category.
    - At clusters that have ThinLinc, like Kebnekaise, you can also submit MATLAB jobs to compute resources from within MATLAB.

We will talk much more about batch scripts in a short while, but for now we can use <a href="../simple.sh" target="_blank">this small batch script</a> for testing the Slurm commands:

```bash
#!/bin/bash
# Project id - change to your own!
#SBATCH -A PROJ-ID
# Asking for 1 core
#SBATCH -n 1
# Asking for a walltime of 1 min
#SBATCH --time=00:01:00

echo "What is the hostname? It is this: "

/bin/hostname
```

!!! hint 

    You find the above batch script named "simple.sh" in the exercises tarball, under the folder "introslurm". 

    REMEMBER TO CHANGE THE PROJECT ID TO YOUR OWN! 

    ??? hint "Checking for Slurm project IDs valid for your user"
        From the terminal, you can ask Slurm for project IDs currently
        associated with your user with the command `projinfo`, on most clusters.
        If not available, use this command:
        ```
        sacctmgr list assoc where user="$USER" format=Account -P --noheader
        ```


**Example**:

Submitting the above batch script on Kebnekaise

```bash
b-cn1613 [~]$ sbatch simple.sh 
Submitted batch job 44976964
```

As you can see, you get the job id when submitting the batch script.

When it has run, you can see with ``ls`` that you got a file called ``slurm-JOBID.out`` in your directory.

!!! hint

    Try it out! 

### squeue

The command ``squeue`` is for viewing the state of the batch queue.

If you just give the command, you will get a long list of all jobs in the queue, so it is usually best to constrain it to your own jobs. This can be done in two ways:

- ``squeue -u <username>``
- ``squeue --me``

**Example**:

```bash
b-cn1613 [~]$ squeue --me
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          34815904   cpu_sky mpi_gree bbrydsoe  R       0:00      1 b-cn1404
          34815905   cpu_sky mpi_hell bbrydsoe  R       0:00      2 b-cn[1404,1511]
          34815906   cpu_sky mpi_hi.s bbrydsoe  R       0:00      2 b-cn[1511-1512]
          34815907   cpu_sky simple.s bbrydsoe  R       0:00      1 b-cn1512
          34815908   cpu_sky compiler bbrydsoe  R       0:00      2 b-cn[1415,1512]
          34815909   cpu_sky mpi_gree bbrydsoe  R       0:00      1 b-cn1415
          34815910   cpu_sky mpi_hell bbrydsoe  R       0:00      3 b-cn[1415,1421-1422]
          34815911   cpu_sky mpi_hi.s bbrydsoe  R       0:00      1 b-cn1422
          34815912   cpu_sky simple.s bbrydsoe  R       0:00      1 b-cn1422
          34815913   cpu_sky compiler bbrydsoe  R       0:00      2 b-cn[1422,1427]
          34815902  cpu_zen4 simple.s bbrydsoe CG       0:03      1 b-cn1707
          34815903  cpu_zen4 compiler bbrydsoe  R       0:00      1 b-cn1708
          34815898  cpu_zen4 compiler bbrydsoe  R       0:03      2 b-cn[1703,1705]
          34815899  cpu_zen4 mpi_gree bbrydsoe  R       0:03      2 b-cn[1705,1707]
          34815900  cpu_zen4 mpi_hell bbrydsoe  R       0:03      1 b-cn1707
          34815901  cpu_zen4 mpi_hi.s bbrydsoe  R       0:03      1 b-cn1707
          34815922 cpu_zen4, simple.s bbrydsoe PD       0:00      1 (Priority)
          34815921 cpu_zen4, mpi_hi.s bbrydsoe PD       0:00      1 (Priority)
          34815920 cpu_zen4, mpi_hell bbrydsoe PD       0:00      1 (Priority)
          34815919 cpu_zen4, mpi_gree bbrydsoe PD       0:00      1 (Priority)
          34815918 cpu_zen4, compiler bbrydsoe PD       0:00      1 (Priority)
          34815917 cpu_zen4, simple.s bbrydsoe PD       0:00      1 (Priority)
          34815916 cpu_zen4, mpi_hi.s bbrydsoe PD       0:00      1 (Priority)
          34815915 cpu_zen4, mpi_hell bbrydsoe PD       0:00      1 (Priority)
          34815914 cpu_zen4, mpi_gree bbrydsoe PD       0:00      1 (Resources)
```

Here you also see some of the "states" a job can be in. Some of the more common ones are:

- **CA**: CANCELLED. Job was explicitly cancelled by the user or system administrator.
- **CF**: CONFIGURING. Job has been allocated resources, but are waiting for them to become ready for use (e.g. booting).
- **CG**: COMPLETING. Job is in the process of completing. Some processes on some nodes may still be active.
- **PD**: PENDING. Job is awaiting resource allocation.
- **R**: RUNNING. Job currently has an allocation.
- **S**: SUSPENDED. Job has an allocation, but execution has been suspended and resources have been released for other jobs.

List above from <a href="https://slurm.schedmd.com/squeue.html" target="_blank">Slurm workload manager page about squeue</a>.

**Example**:

Submit the "simple.sh" script several times, then do ``squeue --me`` to see that it is running, pending, or completing.

```bash
b-cn1613 [~]$ sbatch simple.sh 
Submitted batch job 44977154
b-cn1613 [~]$ sbatch simple.sh 
Submitted batch job 44977157
b-cn1613 [~]$ sbatch simple.sh 
Submitted batch job 44977158
b-cn1613 [~]$ sbatch simple.sh 
Submitted batch job 44977159
b-cn1613 [~]$ sbatch simple.sh 
Submitted batch job 44977160
b-cn1613 [~]$ sbatch simple.sh 
Submitted batch job 44977164
b-cn1613 [~]$ squeue --me
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          44977159  cpu_zen4 simple.s bbrydsoe CG       0:02      1 b-cn1704
          44977154  cpu_zen4 simple.s bbrydsoe CG       0:02      1 b-cn1704
          44977157  cpu_zen4 simple.s bbrydsoe CG       0:02      1 b-cn1704
          44977158  cpu_zen4 simple.s bbrydsoe  R       0:02      1 b-cn1704
          44977160  cpu_zen4 simple.s bbrydsoe  R       0:02      1 b-cn1703
          44977164  cpu_zen4 simple.s bbrydsoe PD       0:00      1 (None)
```

!!! hint

    Try it! Remember, "arrow up" lets you quickly access a previous command. 

### scancel

The command to cancel a job is ``scancel``.

You can either cancel a specific job:

``scancel <job id>``

or cancel all your jobs:

``scancel -u <username>``

!!! note

    As before, you get the ``<job id>`` either from when you submitted the job or from ``squeue --me``.

!!! warning "Note"

    Only administrators can cancel other people's jobs!

### scontrol show

The command ``scontrol show`` is used for getting more info on jobs and nodes.

#### scontrol show job

As usual, you get the ``<job id>`` from either when you submit the job or from ``squeue --me``.

The command is:

```bash
scontrol show job <job id>
```

**Example**:

```bash
b-cn1613 [~]$ scontrol show job 44977164
JobId=44977164 JobName=simple.sh
   UserId=bbrydsoe(2897) GroupId=folk(3001) MCS_label=N/A
   Priority=2954545 Nice=0 Account=sysop QOS=normal
   JobState=COMPLETED Reason=None Dependency=(null)
   Requeue=0 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   RunTime=00:00:02 TimeLimit=00:01:00 TimeMin=N/A
   SubmitTime=2026-05-26T11:01:05 EligibleTime=2026-05-26T11:01:05
   AccrueTime=2026-05-26T11:01:05
   StartTime=2026-05-26T11:01:05 EndTime=2026-05-26T11:01:07 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2026-05-26T11:01:05 Scheduler=Main
   Partition=cpu_zen4 AllocNode:Sid=b-cn1613:996734
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=b-cn1703
   BatchHost=b-cn1703
   NumNodes=1 NumCPUs=1 NumTasks=1 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=1,mem=6785M,node=1,billing=1
   AllocTRES=cpu=1,mem=2516M,node=1,billing=1
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=1 MinMemoryCPU=2516M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:02:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/pfs/stor10/users/home/b/bbrydsoe/simple.sh
   WorkDir=/pfs/stor10/users/home/b/bbrydsoe
   StdErr=/pfs/stor10/users/home/b/bbrydsoe/slurm-44977164.out
   StdIn=/dev/null
   StdOut=/pfs/stor10/users/home/b/bbrydsoe/slurm-44977164.out
   Power=
```

Here you get much interesting information:

- **JobState=COMPLETED**: the job was completed and was not FAILED. It could also have been PENDING or COMPLETING
- **RunTime=00:00:02**: the job ran for 2 seconds
- **TimeLimit=00:01:00**: It could have run for up to 1 min (what you asked for)
- **SubmitTime=2026-05-26T11:01:05**: when your job was submitted
- **StartTime=2026-05-26T11:01:05**: when the job started
- **Partition=cpu_zen4**: what partition/type of node it ran on
- **NodeList=b-cn1703**: which specific node(s) it ran on
- **BatchHost=b-cn1703**: which of the nodes (if several) that was the master
- **NumNodes=1 NumCPUs=1 NumTasks=1 CPUs/Task=1**: number of nodes, cpus, tasks
- **WorkDir=/pfs/stor10/users/home/b/bbrydsoe**: which directory your job was submitted from/was running in
- **StdOut=/pfs/stor10/users/home/b/bbrydsoe/slurm-44977164.out**: which directory the output files will be placed in and their name(s) 

The command ``scontrol show job <job id>`` can be run also while the job is pending, and can be used to get an estimate of when the job will start. Actual start time depends on the jobs priority, any other (people's) jobs starting and completing and being submitted, etc.

It is often useful to know which nodes a job ran on if something did not work - perhaps the node was faulty.

!!! hint "Exercise" 

    Try it! Submit the "simple.sh" batch script and then do ``scontrol show job JOBID`` using the job ID you got when you submitted the batch script. Try to find the "SubmitTime", "StartTime", and "NodeList" in the output. 

#### scontrol show node

This command is used to get information about a specific node. You can for instance see its features, how many cores per socket, uptime, etc. Specifics will vary and depend on the cluster you are running jobs at.

**Example**:

This is for one of the AMD Zen4 nodes at Kebnekaise, HPC2N.

```bash
b-cn1613 [~]$ scontrol show node b-cn1703
NodeName=b-cn1703 Arch=x86_64 CoresPerSocket=128 
   CPUAlloc=253 CPUEfctv=256 CPUTot=256 CPULoad=253.38
   AvailableFeatures=rack17,amd_cpu,zen4
   ActiveFeatures=rack17,amd_cpu,zen4
   Gres=(null)
   NodeAddr=b-cn1703 NodeHostName=b-cn1703 Version=23.02.7
   OS=Linux 5.15.0-142-generic #152-Ubuntu SMP Mon May 19 10:54:31 UTC 2025 
   RealMemory=644096 AllocMem=636548 FreeMem=749623 Sockets=2 Boards=1
   State=MIXED ThreadsPerCore=1 TmpDisk=0 Weight=100 Owner=N/A MCS_label=N/A
   Partitions=cpu_zen4 
   BootTime=2025-06-24T06:32:25 SlurmdStartTime=2025-06-24T06:37:02
   LastBusyTime=2025-06-24T08:29:45 ResumeAfterTime=None
   CfgTRES=cpu=256,mem=629G,billing=256
   AllocTRES=cpu=253,mem=636548M
   CapWatts=n/a
   CurrentWatts=0 AveWatts=0
   ExtSensorsJoules=n/s ExtSensorsWatts=0 ExtSensorsTemp=n/s
```

### sinfo

The command ``sinfo`` gives you information about the partitions/queues.

**Example**:

This is for Kebnekaise, HPC2N

```bash
b-cn1613 [~]$ sinfo
PARTITION       AVAIL  TIMELIMIT  NODES  STATE NODELIST
batch              up 7-00:00:00      0    n/a 
cpu_sky            up 7-00:00:00      1 drain* b-cn1431
cpu_sky            up 7-00:00:00      2   comp b-cn[1409,1415]
cpu_sky            up 7-00:00:00      1  drain b-cn1427
cpu_sky            up 7-00:00:00      8    mix b-cn[1411,1417-1418,1428,1513,1515,1521-1522]
cpu_sky            up 7-00:00:00     36  alloc b-cn[1401-1404,1406-1407,1410,1412-1414,1419-1426,1429-1430,1432-1434,1436-1440,1511-1512,1514,1516-1520]
cpu_zen3           up 7-00:00:00      1  alloc b-cn1614
cpu_zen4           up 7-00:00:00      3   comp b-cn[1704,1706,1708]
cpu_zen4           up 7-00:00:00      3    mix b-cn[1702-1703,1705]
cpu_zen4           up 7-00:00:00      2  alloc b-cn[1701,1707]
cpu_largemem       up 7-00:00:00      1 drain* b-cn0850
cpu_largemem       up 7-00:00:00      2   resv b-cn[0649-0650]
cpu_largemem       up 7-00:00:00      3    mix b-cn[0849,0949-0950]
cpu_largemem       up 7-00:00:00      4  alloc b-cn[1049-1050,1201-1202]
cpu_bdw            up 7-00:00:00      1  maint b-cn1120
gpu_sky            up 7-00:00:00      9    mix b-cn[1501-1505,1507-1510]
gpu_sky            up 7-00:00:00      1  alloc b-cn1506
gpu_zen3           up 7-00:00:00      2    mix b-cn[1609-1610]
gpu_zen3           up 7-00:00:00      1   idle b-cn1612
gpu_zen4           up 7-00:00:00      4    mix b-cn[1601-1602,1604,1712]
gpu_zen4           up 7-00:00:00      2  alloc b-cn[1603,1605]
gpu_zen4           up 7-00:00:00      8   idle b-cn[1606-1608,1709-1711,1713,1718]
gpu_zen4_8xgpu     up 7-00:00:00      2  alloc b-cn[1714-1715]
gpu_zen4_8xgpu     up 7-00:00:00      1   resv b-cn1716
gpu_zen4_2xh100    up 7-00:00:00      1    mix b-cn1717
``

As you can see, it shows partitions, nodes, and states. State can be drain, idle, resv, alloc, mix, plnd (and a few others), where the exact naming varies between centers.

- **drain**: node is draining after running a job
- **resv**: node is reserved/has a reservation for something
- **alloc**: node is allocated for a job
- **mix**: node is in several states, could for instance be that it is allocated, but starting to drain
- **idle**: node is free and can be allocated
- **plnd**: job planned for a higher priority job

You can see the full list of states and their meaning with ``man sinfo``.

!!! hint

    Try it! Give the command ``sinfo`` and look at the output from your chosen HPC cluster. 

## Slurm job scripts

Now we have looked at the commands to control the job, but what about the job scripts? 

We had a small example further up on the page, which we used to test the commands, but now we will look more at the job scripts themselves. 

### Simplest job 

The simplest possible batch script would look something like this:

```bash
#!/bin/bash
#SBATCH -A <proj-id>    ###replace with your project ID
#SBATCH -t 00:05:00
#SBATCH -n 1

echo $HOSTNAME
```

!!! note

    A job submission file can either be very simple, with most of the job attributes specified on the command line, or it may consist of several Slurm directives, comments and executable statements. 

    A Slurm directive provides a way of specifying job attributes in addition to the command line options. All Slurm directives are prefaced with `#SBATCH` which *must* be written with capital letters. 

    Comments are added with a `#` in front - an extra `#` in front of the Slurm directive comment that out. 

!!! note "Common Slurm arguments" 

    Some of the most commonly used arguments are:

    - `-A PROJ-ID`: The project that should be accounted. It is a simple conversion from the SUPR project id. You can also find your project account with the command projinfo. The PROJ-ID argument is of the form **hpc2nXXXX-YYY** on Kebnekaise  
    - `-N`: number of nodes
    - `-n`, `--ntasks=`: number of tasks. Since cores-per-task is 1 as default, this then translates to number of cores. NOTE that you cannot be sure the cores all end up on the same node. If you have a threaded job or otherwise need to have all the cores on the same node, you should instead use `-c` or a combination of `-N` and `-c`.  
    - `-c`, `--cores-per-task=`: This changes the number of cores each task may use. Can also be used for getting more memory, with some cores only providing memory. (example: **-c 2 -n 4** allocates 4 tasks and 2 cores per task, totally 8 cores). More about this argument later. 
    - `-t`, `--time=`: walltime. How long your job is allowed to run. Given as HHH:MM:SS (example: 4 hours and 20 min is given as 4:20:00). Different clusters have different maximum walltime, but it is usually at least a week. 
    - `-p`: partition. Only used at some clusters. Not on Kebnekaise where batch is the only partition.  

    In addition, these can be quite useful: 

    - `-o`, `--output=`: Used for naming the output differently than
      `slurm-<job-id>.out` and splitting it from errors and such. A `%j` in the
      specified filename will be replaced with the job id, which is highly
      recommended to prevent output from being overwritten the next time you run
      the job. Additional 
      [specifiers for the filename pattern](https://slurm.schedmd.com/sbatch.html#SECTION_FILENAME-PATTERN),
      for more advanced cases, can be found in the Slurm documentation.
    - `-e`, `--error=`: Used for naming and splitting the error from the other
      output. Using `%j` in the name to get separate files for separate runs is
      again highly recommended.

    Example: 

    ```bash
    #SBATCH -o process_%j.out    
    #SBATCH -e process_%j.err    
    ``` 

**Now for the example script, "Simplest job", above**:

The first line is called the “shebang” and it indicates that the script is written in the bash shell language.

The second, third, and fourth lines are resource statements to the Slurm batch scheduler. Also called Slurm directives. 

The second line above is where you put your **project ID**. 
Depending on cluster, this is either always required or not technically required if you only have one project to your name. Regardless, we recommend that you make a habit of including it. 

The third line in the example above provides the **walltime**, the maximum amount of time that the program would be allowed to run (5 minutes in this example). If a job does not finish within the specified walltime, the resource management system terminates it and any data that were not already written to a file before time ran out are lost.

The fourth line asks for compute resources, here one task (resulting in one core
as cores-per-task is defaulting to one). You could ask for more cores if it was
a parallel job, or for GPUs and so on. More about that later.  

The last line in the above sample is the code to be executed by the batch script. In this case, it just prints the name of the server on which the code ran.

All of the parameters that Slurm needs to determine which resources to allocate,
under whose account, and for how long, are given as a series of resource
statements of the form `#SBATCH -<option> <value>` or
`#SBATCH --<key-words>=<value>` (note: `<` and `>` are not typically used in
real arguments; they are just used here to indicate placeholder text).
Alternatively they can be given as command-line options to `sbatch` but it is
generally useful to save them in the script.

On compute nodes, unless otherwise specified, a batch script will run on 1 core of 1 node by default. However, it is generally required to always give the number of cores or nodes, so you should make it a habit to include it. 

!!! Note

    You find the above job script in the exercises tarball. It is named "first.sh". 

    Remember to change the project ID to your own! 

!!! note "Some comments on time/walltime"

    - the job **will** terminate when the time runs out, whether it has finished or not
    - you will only be "charged" for the consumed time
    - asking for a lot more time than needed will generally make the job take longer to start
    - short jobs can start quicker (backfill)
    - if you have no idea how long your job takes, ask for "long" time
    - **Conclusion**: It is typically a good idea to overbook your job with perhaps 30% (or more). 

!!! note

    There are many more resource statements and other commands that can go into the Slurm batch script. We will look at some of them in the next section, where we show some sample job scripts. 

You submit the job script with ``sbatch <jobscript.sh>`` as was mentioned earlier.

## Dependencies 

Sometimes your workflow has jobs that depend on a previous job (a pipeline). This can be handled through Slurm (if many, make a script):

- Submit your first job: ``sbatch my-job.sh``
- Wait for that job to finish before starting next job: ``sbatch -d afterok:<prev-JOBID> my-next-job.sh``

Generally: 

- **`after:jobid[:jobid...]`** begin after specified jobs have started
- **`afterany:jobid[:jobid...]`** begin after specified jobs have terminated
- **`afternotok:jobid[:jobid...]`** begin after specified jobs have failed
- **`afterok:jobid[:jobid...]`**  begin after specified jobs have run to completion with exit code zero
- **`singleton`** begin execution after all previously launched jobs with the same name and user have ended 

!!! hint

    **Try it!** You can use `matrix-gen.sh` as the first and `mmmult-v2.sh` as the dependent job. You find these batch scripts in the exercises tarball, under your cluster. 

    - Remember to change the project ID of the scripts to be your project ID. 
    - Remember, you can use `squeue --me` to see if your jobs are running - and probably also that one of them is now marked as being dependent on another. 

### Script example 

This simple script can be run from the command line. It starts one job; gets the job ID, then tell Slurm to wait until job one has finished before starting a second job which is dependent on the first.  

```bash
#!/bin/bash

# first job - no dependencies
jid1=$(sbatch --parsable matrix-gen.sh)

# Next job depend on first job 
sbatch --dependency=afterany:${jid1} mmmult-v2.sh
```

If you want to test it, the scripts for this can be found in the tarball with the exercises> under the cluster name and then "dependency". 

The first job it runs generates two matrices and then the second job does matrix-matrix multiplication, but not until the first has finished. 

## How to monitor jobs

Unless mentioned, these are valid at all clusters. 

Use the following:

- `sacct`: `sacct -l -j JOBID`. Lots of (wide format) info about a job with job-id JOBID
- `scontrol show job JOBID`: info about a job, including estimated start time, assigned nodes, working directory, etc. 
- `squeue --me --start`: your running and queued jobs with estimated start time
- `job_usage` (HPC2N): grafana graphics of resource use for job (> few minutes)
- and several more 

See [Job monitoring and efficiency](../monitoring) for more about job info, including several commands that are site-specific and very useful. 

