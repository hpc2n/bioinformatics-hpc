# Modules in batch scripts 

!!! note "Objectives" 

    - learn briefly about using modules in batch jobs 
    - learn about the difference between when it is a serial, MPI, and GPU job 

This section looks at how to use modules in batch scripts. This is done much the same as when you just load them on the command line. 

!!! note 

    - Any longer, parallel, heavy jobs should be run as a batch job in order not to overload the login node and make it slow/unusuable for everyone. 
    - When you write a batch script you have to **load the modules you need to run the job**, just as you would have otherwise. 
    - If the module has prerequisites, they have to be loaded before the module
    - The modules you load need to be compatible with each other, just like when you load them on the command line. 

When you load modules inside a batch script, there are only really three different cases: 

- serial jobs
- parallel/MPI jobs
- GPU jobs 

We will use Python and various Python package modules as an example. 

!!! note 

    A batch job is submitted to the batch queue with ``sbatch <batchjob.sh>``. 

## Serial jobs 

Here you do not need MPI-enabled modules. If the module has both a GPU and a CPU version, you should load the CPU version. 

!!! note "Example - serial job script" 

    The example Python script used here is <a href="../mmmult.py" target="_blank">mmmult.py</a>. 

    Short serial example for running on Kebnekaise. Loading SciPy-bundle/2023.07 and Python/3.11.3 

    ```bash 
    #!/bin/bash
    #SBATCH -A hpc2nXXXX-YYY # Change to your own project ID 
    #SBATCH --time=00:10:00 # Asking for 10 minutes
    #SBATCH -n 1 # Asking for 1 core

    # Purge the environment of any modules 
    module purge > /dev/null 2>&1 
    # Load any modules you need, here for Python/3.11.3 and compatible SciPy-bundle
    module load GCC/12.3.0 Python/3.11.3 SciPy-bundle/2023.07

    # Run your Python script
    python mmmult.py        
    ``` 

## MPI jobs 

There is little difference between the job scripts for a serial job and an MPI job: 

- you ask for more cores since you want to run more tasks
- you may need other modules that are parallelized versions of the software 

Continuing with a Python example 

!!! note "Example - MPI job script" 

    Make sure you ask for enough tasks and your modules are for parallelized software. Here a program that needs mpi4py: <a href="../integration2d_mpi.py" target="_blank">integration2d_mpi.py</a>. 

    ```bash 
    #!/bin/bash
    # The name of the account you are running in, mandatory.
    #SBATCH -A hpc2nXXXX-YYY
    # Request resources - here for eight MPI tasks
    #SBATCH -n 8
    # Request runtime for the job (HHH:MM:SS) where 168 hours is the maximum at most centres. Here asking for 15 min.
    #SBATCH --time=00:15:00

    # Clear the environment from any previously loaded modules
    module purge > /dev/null 2>&1

    # Load the module environment suitable for the job, it could be more or
    # less, depending on other package needs. This is for a simple job needing
    # mpi4py. 

    ml GCC/12.3.0 Python/3.11.3 SciPy-bundle/2023.07 OpenMPI/4.1.5 mpi4py/3.1.4

    # And finally run the job - use srun for MPI jobs, but not for serial jobs
    srun ./integration2d_mpi.py
    ```

## GPU jobs 

Here there are two things to pay attention to: 

- The modules you load must be for software that is GPU-aware (and often compiled with CUDA as well). 
- You need to ask for GPU resources in the batch script 

!!! note "Example - GPU job script" 

    In this example we make a batch script for running a small Python GPU script called <a href="../add-list.py" target="_blank">add-list.py</a>. It needs "numba". 

    At HPC2N there are many different types of GPU's with different amount of GPU cards. You can read more about that here: <a href="https://docs.hpc2n.umu.se/documentation/batchsystem/resources/" target="_blank">https://docs.hpc2n.umu.se/documentation/batchsystem/resources/</a>. 

    ```bash
    #!/bin/bash
    # Remember to change this to your own project ID!
    #SBATCH -A hpc2nXXXX-YYY     # HPC2N ID - change to your own
    # We are asking for 5 minutes
    #SBATCH --time=00:05:00
    # Asking for one L40s GPU - see the link above for more options
    #SBATCH --gpus=1
    #SBATCH -C l40s

    # Remove any loaded modules and load the ones we need
    module purge  > /dev/null 2>&1
    module load GCC/12.3.0 Python/3.11.3 OpenMPI/4.1.5 SciPy-bundle/2023.07 CUDA/12.1.1 numba/0.58.1 CUDA/12.1.1

    # Run your Python script
    python add-list.py
    ```

