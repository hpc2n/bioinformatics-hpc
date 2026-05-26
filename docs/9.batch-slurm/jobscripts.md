# Sample job scripts

## Basic Serial Job

In this section we discuss the running of a serial Python script using a couple of services as an example. But first let's spend a few lines on partitions.

### Partitions

As discussed, not all compute nodes offered by a service are equal.  Nodes may offer different hardware (e.g. CPU type, amount of memory, number of GPUs or no GPU). There might also be differences on how the nodes are configured. To control that a job is placed on the correct kind of compute nodes, the nodes may be placed in partitions.

Information about partitions can usually be found with ``sinfo``. 

Even if there are several partitions, there is only a single partition, ``batch``, that users can submit jobs to. The system then figures out, based on requested features which actual partition(s) the job should be sent to.

Since there is only one partition available for users to submit jobs to, you should remove any use of ``#SBATCH -p`` you may have in your scripts. 

Previously, the most common use of -p was for targeting the LargeMemory nodes, this is now done using a feature request like this: 

```bash
#SBATCH -C largemem
``` 

In addition you need to have requested the largemem resource in your project. 

### Examples

Let's say you have a simple Python script called mmmult.py that creates 2 random-valued matrices, multiplies them together, and prints the shape of the result and the computation time. Let's also say that you want to run this code in your current working directory.  Here is how you can run that program utilising 1 core on 1 node: 

=== "Kebnekaise"

    ```bash
    #!/bin/bash
    #SBATCH -A <sysop> # Change to your own
    #SBATCH --time=00:10:00 # Asking for 10 minutes
    #SBATCH -n 1 # Asking for 1 core

    # Load any modules you need, here for Python/3.11.3 and compatible SciPy-bundle
    module load GCC/12.3.0 Python/3.11.3 SciPy-bundle/2023.07

    # Run your Python script
    python mmmult.py
    ```

=== "mmmult.py"

    ```python
    import timeit
    import numpy as np

    starttime = timeit.default_timer()

    np.random.seed(1701)

    A = np.random.randint(-1000, 1000, size=(8,4))
    B = np.random.randint(-1000, 1000, size =(4,4))

    print("This is matrix A:\n", A)
    print("The shape of matrix A is ", A.shape)
    print()
    print("This is matrix B:\n", B)
    print("The shape of matrix B is ", B.shape)
    print()
    print("Doing matrix-matrix multiplication...")
    print()

    C = np.matmul(A, B)

    print("The product of matrices A and B is:\n", C)
    print("The shape of the resulting matrix is ", C.shape)
    print()
    print("Time elapsed for generating matrices and multiplying them is ", timeit.default_timer() - starttime)
    ```

## OpenMP and shared memory programming

Shared memory programming is a parallel programming model associated with threads.  You start a LINUX/UNIX process, which spawns threads.   The memory of the process can be accessed by all the threads.  The threads are typically placed on and often bound to different logical or physical cores of a single hardware node.   The number of cores available on a node limits the number of threads one can reasonably start on a node.  In shared memory programming it is typically not possible to utilise cores from different nodes. All cores need to be in the same node.  The aim of spawning threads is to speed up the calculation to achieve a fast time to solution.

OpenMP is an API widely used in scientific computing to facilitate shared memory programming.  The behaviour of an application utilising OpenMP can be controlled by a number of environment variables.  Even the behaviour of many applications utilising a different API to facilitate shared memory programming, can be controlled by OpenMP environment variables.

When executing shared memory applications, unless there is a suitable default, one may need to ensure that only one task is used.   This can be done by using the `-n` option of SLURM, e.g. having a line:

```bash
#SBATCH -n 1
```
in the script.  The number of cores to host the threads can be requested by using either the `-c` or the `--cpus-per-task` option.  Both of which do exactly the same thing, so use only one of those.  The following would request eight (logical) cores

```bash
#SBATCH -c 8
``` 
!!! Important

    Depending on how the service you are using is configured, you might be requesting logical cores, with multiple logical cores being placed on a single physical core.   This is called hyperthreading.  It is important to experiment whether placing threads on multiple logical cores of a physical core benefits or hinders the performance of your application.

    Kebnekaise is not using hyperthreading. 

In general, the environment variable `OMP_NUM_THREADS` will be picked up from your request with the `-c` option.  It typically uses all the cores you requested. To ensure that the right value is set, you can include this in your Slurm batch script 

```bash
# Set OMP_NUM_THREADS to the same value as -c
# with a fallback in case it isn't set.
# SLURM_CPUS_PER_TASK is set to the value of -c, but only if -c is explicitly set
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
   omp_threads=$SLURM_CPUS_PER_TASK
else
omp_threads=1
fi
export OMP_NUM_THREADS=$omp_threads
``` 

This is an example of an OpenMP batch script for Kebnekaise, that asks for 28 cores. 

```bash 
#!/bin/bash
# Example with 28 cores for OpenMP
#
# Project/Account - change to your own 
#SBATCH -A hpc2nXXXX-YYY
#
# Number of cores
#SBATCH -c 28
#
# Runtime of this jobs is less then 12 hours.
#SBATCH --time=12:00:00
#
# Clear the environment from any previously loaded modules
module purge > /dev/null 2>&1

# Load the module environment suitable for the job - here foss/2021b 
module load foss/2021b 

# Set OMP_NUM_THREADS to the same value as -c
# with a fallback in case it isn't set.
# SLURM_CPUS_PER_TASK is set to the value of -c, but only if -c is explicitly set
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
   omp_threads=$SLURM_CPUS_PER_TASK
else
omp_threads=1
fi
export OMP_NUM_THREADS=$omp_threads

./openmp_program
```

If you wanted to run the above job, but only use some of the cores for running on (to perhaps use more memory than what is available on 1 core), you can submit with

```bash
sbatch -c 14 MYJOB.sh 
```

## Applications using MPI

Some form of message passing is required when utilising multiple nodes for a simulation.  One has multiple programs, called tasks, running.  Typically these are multiple copies of the same executable with each getting its own dedicated core.  Each task has its own memory, which is called distributed memory.  Data exchange is facilitated by coping data between the tasks. This can accomplished inside the node if both task are running on the same node or has to utilise the network if the tasks in question are located on different nodes.  The **Message Passing Interface (MPI)** is the most commonly used API in scientific computing, when programming message passing applications.

The illustration shows 5 tasks being executed, with the time running from the top to the bottom.  At the beginning, data (e.g. read from an input file) is distributed from task 0 to the other tasks, indicated by the blue arrows.  Following this, the tasks exchange data at regular intervals.   In a real application the communication patterns are typically more complex than this.

![mpi illustration](../images/mpi_illustration.png){: style="width: 500px;float: right"}

!!! Important

    When runing an executable that utilises MPI you need to start multiple executables.  Typically you start one executable on each requested core. Most of the time multiple copies of the same excutable are used.  

    To start multiple copies of the same executable a special program, a so called **job launcher** is required.  Depending on the system and libraries used the name of the jobs launcher differs.

In the following sample script it is assumed that an mpi executable name `integration2D_f90` in the submission directory.   The executable takes the problem size as a number as a command line argument.  In the example the problem size is 10000.

!!! note "Example MPI job"

    ```bash
    #!/bin/bash

    # Set account 
    #SBATCH -A <project ID> 

    # Set the time 
    #SBATCH -t 00:10:00

    # ask for 14 core, experiment for what works best 
    #SBATCH -n 14

    # name output and error file
    #SBATCH -o mpi_process_%j.out
    #SBATCH -e mpi_process_%j.err

    # write this script to stdout-file - useful for scripting errors
    cat $0

    # Load the toolchain you compiled with 
    module load foss/2023b

    # Run your mpi_executable
    srun ./integration2D_f90 10000
    ```

- Asking for whole nodes (``- N``) and possibly ``--tasks-per-node``
- ``srun`` and ``mpirun`` should be interchangeable. 
- Remember, you need to load modules with MPI
- At some centres ``mpirun --bind-to-core`` or ``srun --cpu-bind=cores`` is recommended for MPI jobs 

## Memory-intensive jobs 

- Running out of memory ("OOM"):
    - usually the job stops ("crashes")
    - check the Slurm error/log files
    - check with sacct/seff/jobstats/job-usage depending on cluster
- Fixes:
    - use "fat" nodes
    - allocate more cores just for memory
    - tweak memory usage in app, if possible

### Increasing memory per task

A way to increase memory per task that works generally is to simply ask for more cores per task, where some are just giving memory.

!!! note "Example"

    In this case, we are asking for 16 tasks, with 2 cores per task. This means we are asking for 32 cores in total. We do this by adding this to our batch script: 

    ```bash
    #SBATCH --ntasks=16 --cpus-per-task=2
    ```

    **NOTE** You can also write 

    - ``--cpus-per-task=#num`` in short form as ``-c #num``
    - ``--ntasks=#numtasks`` in short form as ``-n #numtasks``  

**Example script template**

Here asking for 8 tasks, 2 cores per task. 

```bash 
#!/bin/bash
#SBATCH -A <account>
#SBATCH -t HHH:MM:SS
#SBATCH -n 8
#SBATCH -c 2

module load <modules>

srun ./myprogram
```

**Example script template**

Here we have a non-threaded code which needs more memory (up to twice the amount we have on two cores). 

```bash 
#!/bin/bash
#SBATCH -A <account>
#SBATCH -t HHH:MM:SS
#SBATCH -c 2

module load <modules>

./myprogram
```

### Memory availability 

Anoter way of getting extra memory is to use nodes that have more memory. A useful command to identify how much memory is available on different nodes is `sinfo -o "%10P %20l %30N %10z %10c %20m %20f %20G"`. Here is an overview of some of the available nodes on Kebnekaise:  

| Type | RAM/core | cores/node | requesting flag |
| ---- | -------- | ---------- | --------------- |
| Intel Skylake | 6785 MB | 28 | ``-C skylake`` |
| AMD Zen3 | 8020 MB | 128 | ``-C zen3`` |
| AMD Zen4 | 2516 MB | 256 | ``-C zen4`` |
| V100 | 6785 MB | 28 | ``--gpus=<#num> -C v100`` |
| A100 | 10600 MB | 48 | ``--gpus=<#num> -C a100`` |
| MI100 | 10600 MB | 48 | ``--gpus=<#num> -C mi100`` |
| A6000 | 6630 MB | 48 | ``--gpus=<#num> -C a6000`` |
| H100 | 6630 MB | 96 | ``--gpus=<#num> -C h100`` |
| L40s | 11968 MB | 64 | ``--gpus=<#num> -C l40s`` |
| A40 | 11968 MB | 64 | ``--gpus=<#num> -C a40`` |
| Largemem | 41666 MB | 72 | ``-C largemem`` |

## I/O intensive jobs 

!!! NOTE

    This section comes with many caveats; it depends a lot on the type of job and the system. Often, if you are in the situation where you have an I/O intensive job, you need to talk to support as it will be very individualized. 

- Not all systems offer node local discs
- In most cases, you should use the project storage
- Centre-dependent. If needed you can use node-local disc for **single-node** jobs
    - Remember you need to copy data to/from the node-local scratch (``$SNIC_TMP``)! 
    - On some systems ``$TMPDIR`` also points to the node local disc
    - The environment variable ``$SLURM_SUBMIT_DIR`` is the directory you submitted from


### Example 

```bash
#!/bin/bash 
#SBATCH -A <account>
#SBATCH -t HHH:MM:SS 
#SBATCH -n <cores>

module load <modules>

# Copy your data etc. to node local scratch disc
cp -p mydata.dat $SNIC_TMP
cp -p myprogram $SNIC_TMP

# Change to that directory
cd $SNIC_TMP

# Run your program
./myprogram

# Copy the results back to the submission directory 
cp -p mynewdata.dat $SLURM_SUBMIT_DIR
```

!!! warning "NOTE"

    When using node local disk it is important to remember to copy the output data back, since it will go away when the job ends!

## Job arrays 

- Job arrays: a mechanism for submitting and managing collections of similar jobs.
- All jobs must have the same initial options (e.g. size, time limit, etc.)
- the execution times can vary depending on input data
- You create multiple jobs from one script, using the ``-- array`` directive.
- This requires very little BASH scripting abilities
- max number of jobs is restricted by max number of jobs/user - centre specific

- [More information here on the official Slurm documentation pages.](https://slurm.schedmd.com/job_array.html)

!!! note "Example"

    This shows how to run a small Python script ``hello-world-array.py`` as an array. 

    ```py
    # import sys library (we need this for the command line args)
    import sys

    # print task number
    print('Hello world! from task number: ', sys.argv[1])
    ```

    You could then make a batch script like this, ``hello-world-array.sh``: 

    ```bash
    #!/bin/bash
    # A very simple example of how to run a Python script with a job array
    #SBATCH -A <account>
    #SBATCH --time=00:05:00 # Asking for 5 minutes
    #SBATCH --array=1-10   # how many tasks in the array
    #SBATCH -c 1 # Asking for 1 core    # one core per task
    # Create specific output files for each task with the environment variable %j
    # which contains the job id and %a for each step
    #SBATCH -o hello-world-%j-%a.out

    # Load any modules you need
    module load <module> <python-module> 

    # Run your Python script
    srun python hello-world-array.py $SLURM_ARRAY_TASK_ID
    ```

!!! hint 

    Try it! You can find the above script under the folders in the exercise tarball. 

### Some array comments 

- Default step of 1
    - Example: ``#SBATCH --array=4-80``
- Give an index (here steps of 4)
    - Example: ``#SBATCH --array=1-100:4``
- Give a list instead of a range
    - Example: ``#SBATCH --array=5,8,33,38``
- Throttle jobs, so only a smaller number of jobs run at a time
    - Example: ``#SBATCH --array1-400%4``
- Name output/error files so each job (``%j`` or ``%A``) and step (``%a``) gets  own file
    - ``#SBATCH -o process_%j_%a.out``
    - ``#SBATCH -e process_%j_%a.err``
- There is an environment variable ``$SLURM_ARRAY_TASK_ID`` which can be used to check/query with

## GPU jobs 

Kebnekaise has many different type of GPUs. The command `sinfo -o "%10P %20l %30N %10z %10c %20m %20f %20G" | grep gpu` is very useful as well to identify the GPUs available on a cluster. 

| cores/node | RAM/node | GPUs, type (per node) | 
| -------- | ---------- | -------- | ---- |
| 28 (skylake), <br>72 (largemem), <br>128/256 (Zen3/Zen4) | 128-3072 GB | NVidia v100 (2), <br>NVidia a100 (2), <br>NVidia a6000 (2), <br>NVidia l40s (2 or 6), <br>NVidia H100 (4), <br>NVidia A40 (8), <br>AMD MI100 (2) |

### Allocating a GPU 

This is how you allocate a GPU on Kebnekaise.

| batch settings | Comments |
| -------------- | -------- |
| ``#SBATCH --gpus=x``<br>``#SBATCH -C <type>`` | - type is the type of GPU in lower case<br>- x is the number of that type of GPU.<br>See above table for both | 

### Example GPU scripts 

This shows a simple GPU script, asking for 1 or 2 cards on a single node. 

```bash 
#!/bin/bash
#SBATCH -A hpc2nXXXX-YYY # Change to your own project ID
#Asking for runtime: hours, minutes, seconds. At most 1 week
#SBATCH -t HHH:MM:SS
# Ask for GPU resources. You pick type as one of the ones shown above
# and how many cards you want, at most as many as shown above. Here 2 L40s
#SBATCH --gpus:2
#SBATCH -C l40s
# Writing output and error files
SBATCH --output=output%J.out
#SBATCH --error=error%J.error

# Purge unneeded modules. Load any needed GPU modules and any prerequisites
ml purge > /dev/null 2>&1
module load <MODULES>
   
<run-my-GPU-code>
```
                       
!!! hint

   You can find a few example GPU batch scripts and corresponding programs in the cluster subfolders in the exercises tarball. 

   Some of them requires installing some Python packages in a virtual environment. It is described in the ``.sh`` file for each 

   - alvis, cosmos, kebnekaise, pelle, tetralith
       - add-list.py, add-list.sh 
       - pytorch_fitting_gpu.py, pytorch_fitting_gpu.sh
       - integration2d_gpu.py, integration2d_gpu_shared.py, job-gpu.sh   
   - dardel
       - hello_world_gpu.cpp, hello_world_gpu.sh 

## Miscellaneous 

There are many other types of jobs in Slurm. Here are a few more examples. 

!!! note 

    If you are on Dardel, you also need to add a partition. 

### Multiple serial jobs, simultaneously 

```bash
#!/bin/bash
#SBATCH -A <job ID>
# Add enough cores that all jobs can run at the same time 
#SBATCH -n <cores>
# Make sure the time is long enough that the longest job have time to finish 
#SBATCH --time=HHH:MM:SS

module load <modules>

srun -n 1 --exclusive ./program data1 &
srun -n 1 --exclusive ./program2 data2 &
srun -n 1 --exclusive ./program3 data3 &
...
srun -n 1 --exclusive ./program4 data4 &
wait
```

### Multiple simultaneous jobs (serial or parallel) 

In this example, 3 jobs each with 14 cores

```bash
#!/bin/bash
#SBATCH -A <job ID>
# Since the files run simultaneously I need enough cores for all of them to run
#SBATCH -n 56
# Remember to ask for enough time for all jobs to complete
#SBATCH --time=00:10:00

module load <modules>

srun -n 14 --exclusive ./mympiprogram data &
srun -n 14 --exclusive ./my2mpi data2 &
srun -n 14 --exclusive ./my3mpi data3 &
wait
```

### Multiple sequential jobs (serial or parallel) 

This example is for jobs where some are with 14 tasks with 2 cores per task and some are 4 tasks with 4 cores per task 

```bash
#!/bin/bash
#SBATCH -A <job ID>
# Since the programs run sequentially I only need enough cores for the largest of them to run
#SBATCH -c 28
# Remember to ask for enough time for all jobs to complete
#SBATCH --time=HHH:MM:SS

module load <modules>

srun -n 14 -c 2 ./myprogram data
srun -n 4 -c 4 ./myotherprogram mydata
...
srun -n 14 -c 2 ./my2program data2
```

