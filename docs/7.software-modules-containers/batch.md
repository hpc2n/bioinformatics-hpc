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

    === "HPC2N" 

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

    === "UPPMAX (Pelle)" 

        Short serial example script for Pelle. Loading Python 3.12.3. Numpy is part of the SciPy-bundle module. 

        ```bash 
        #!/bin/bash -l
        #SBATCH -A uppmaxXXXX-Y-ZZZ # Change to your own project ID 
        #SBATCH --time=00:10:00 # Asking for 10 minutes
        #SBATCH -n 1 # Asking for 1 core

        # module purge is not recommended
        # Load any modules you need, here Python 3.12.3 and compatible SciPy-bundle 
        module load Python/3.12.3-GCCcore-13.3.0
        module load SciPy-bundle 
        
        # Run your Python script
        python mmmult.py
        ```

    === "UPPMAX (Bianca)" 

        Short serial example script for Bianca. Loading Python 3.11.8. Numpy is part of this python module. 

        ```bash 
        #!/bin/bash -l
        #SBATCH -A sensXXXX-Y-ZZZ # Change to your own project ID 
        #SBATCH --time=00:10:00 # Asking for 10 minutes
        #SBATCH -n 1 # Asking for 1 core

        # module purge is not recommended
        # Load any modules you need, here Python 3.11.8
        module load python/3.11.8 
    
        # Run your Python script
        python mmmult.py
        ```

    === "LUNARC"

        Short serial example for running on Cosmos. Loading SciPy-bundle/2023.11 and Python/3.11.5 

        ```bash 
        #!/bin/bash
        #SBATCH -A luXXXX-Y-ZZ # Change to your own project ID 
        #SBATCH --time=00:10:00 # Asking for 10 minutes
        #SBATCH -n 1 # Asking for 1 core

        # Purge the environment of any modules
        module purge > /dev/null 2>&1
        # Load any modules you need, here for Python/3.11.5 and compatible SciPy-bundle
        module load GCC/13.2.0 Python/3.11.5 SciPy-bundle/2023.11

        # Run your Python script
        python mmmult.py
        ```

    === "NSC"
 
        Short serial example for running on Tetralith. Loading SciPy-bundle/2022.05 and Python/3.10.4 

        ```bash 
        #!/bin/bash
        #SBATCH -A naissXXXX-YY-ZZZ # Change to your own project ID 
        #SBATCH --time=00:10:00 # Asking for 10 minutes
        #SBATCH -n 1 # Asking for 1 core

        # Purge the environment of any modules - here it is neither recommended or not 
        module purge > /dev/null 2>&1
        # Load any modules you need, here for Python/3.10.4 and compatible SciPy-bundle
        module load buildtool-easybuild/4.8.0-hpce082752a2 GCC/11.3.0 OpenMPI/4.1.4 Python/3.10.4 SciPy-bundle/2022.05

        # Run your Python script
        python mmmult.py
        ``` 

    === "PDC"

        Short serial example for running on Dardel. Loading cray-python/3.11.7 

        ```bash 
        #!/bin/bash
        #SBATCH -A naissXXXX-YY-ZZZ # Change to your own
        #SBATCH --time=00:10:00 # Asking for 10 minutes
        #SBATCH -n 1 # Asking for 1 core
        # At Dardel you always have to give the partition to run in
        # In this case it is the "main" partition 
        #SBATCH -p main 

        # WARNING! Do not do "module purge" here! 
        # Load any modules you need, here for cray-python/3.11.7.
        module load cray-python/3.11.7

        # Run your Python script
        python mmmult.py
        ``` 

    === "C3SE" 

        Short serial example for running on Alvis. Loading Python/3.11.5-GCCcore-13.2.0 and SciPy-bundle/2023.11-gfbf-2023b 

        Note: on Alvis you *must* request a GPU regardless - it is only really for GPU jobs. Here I just ask for 1 T4 

        ```bash 
        #!/bin/bash
        #SBATCH -A naissXXXX-YY-ZZZ # Change to your own
        #SBATCH --time=00:10:00 # Asking for 10 minutes
        #SBATCH -N 1 --gpus-per-node=T4:8  # 1 node with 8 Nvidia T4 GPUs 
        #SBATCH -p alvis
        # Purge the environment of any modules
        module purge > /dev/null 2>&1
        # Load any modules you need, here for Python/3.11.5-GCCcore-13.2.0 and SciPy-bundle/2023.11-gfbf-2023b 
        module load Python/3.11.5-GCCcore-13.2.0
        module load SciPy-bundle/2023.11-gfbf-2023b 

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

    === "HPC2N"

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

    === "UPPMAX (Pelle)"

        ```bash
        #!/bin/bash
        # The name of the account you are running in, mandatory.
        #SBATCH -A uppmaxXXXX-Y-ZZZ
        # Request resources - here for eight MPI tasks
        #SBATCH -n 8
        # Request runtime for the job (HHH:MM:SS) where 168 hours is the maximum at most centres. Here asking for 15 min.
        #SBATCH --time=00:15:00

        ml purge

        # Load the module environment suitable for the job, it could be more or
        # less, depending on other package needs. This is for a simple job needing
        # mpi4py. 

        module load mpi4py/3.1.5-gompi-2023b   # You get GCC/13.2.0, OpenMPI/4.1.6-GCC-13.2.0 and Python/3.11.5-GCCcore-13.2.0 on the fly.

        
        # And finally run the job - use srun for MPI jobs, but not for serial jobs
        srun ./integration2d_mpi.py
        ```

    === "UPPMAX (Bianca)"

        ```bash
        #!/bin/bash
        # The name of the account you are running in, mandatory.
        #SBATCH -A sensXXXX-Y-ZZZ
        # Request resources - here for eight MPI tasks
        #SBATCH -n 8
        # Request runtime for the job (HHH:MM:SS) where 168 hours is the maximum at most centres. Here asking for 15 min.
        #SBATCH --time=00:15:00

        # Module purge is not recommended - if you do it you need to "module load uppmax" after

        # Load the module environment suitable for the job, it could be more or
        # less, depending on other package needs. This is for a simple job needing
        # mpi4py. 

        # Here mpi4py are not installed and you need a virtual env.
        # The following steps would need to be done before submitting the job script: 
        # module load python/3.11.8 python_ML_packages/3.11.8-cpu openmpi/4.1.5
        # python -m venv mympi4py
        # source mympi4py/bin/activate
        # pip install mpi4py

        module load python_ML_packages/3.11.8-cpu openmpi/4.1.5
        source mympi4py/bin/activate
        
        # And finally run the job - use srun for MPI jobs, but not for serial jobs
        srun ./integration2d_mpi.py
        ```

    === "LUNARC"

        ```bash
        #!/bin/bash
        # The name of the account you are running in, mandatory.
        #SBATCH -A luXXXX-Y-ZZ 
        # Request resources - here for eight MPI tasks
        #SBATCH -n 8
        # Request runtime for the job (HHH:MM:SS) where 168 hours is the maximum at most centres. Here asking for 15 min.
        #SBATCH --time=00:15:00

        # Clear the environment from any previously loaded modules
        module purge > /dev/null 2>&1

        # Load the module environment suitable for the job, it could be more or
        # less, depending on other package needs. This is for a simple job needing
        # mpi4py. 

        ml GCC/13.2.0 Python/3.11.5 SciPy-bundle/2023.11 OpenMPI/4.1.6 mpi4py/3.1.5

        # And finally run the job - use srun for MPI jobs, but not for serial jobs
        srun ./integration2d_mpi.py
        ```

    === "NSC"

        ```bash
        #!/bin/bash
        # The name of the account you are running in, mandatory.
        #SBATCH -A naissXXXX-YY-ZZZ
        # Request resources - here for eight MPI tasks
        #SBATCH -n 8
        # Request runtime for the job (HHH:MM:SS) where 168 hours is the maximum at most centres. Here asking for 15 min.
        #SBATCH --time=00:15:00

        # At NSC, module purge is safe and neither recommended nor not 
        module purge > /dev/null 2>&1

        # Load the module environment suitable for the job, it could be more or
        # less, depending on other package needs. This is for a simple job needing
        # mpi4py. 

        ml buildtool-easybuild/4.8.0-hpce082752a2 GCC/11.3.0 OpenMPI/4.1.4 Python/3.10.4 SciPy-bundle/2022.05

        # And finally run the job - use srun for MPI jobs, but not for serial jobs
        srun ./integration2d_mpi.py
        ```

    === "PDC" 

        ```bash
        #!/bin/bash
        # The name of the account you are running in, mandatory.
        #SBATCH -A naissXXXX-YY-ZZZ 
        #SBATCH  -p shared         # name of the queue
        # Request resources - here for eight MPI tasks
        #SBATCH -n 8
        #SBATCH --cpus-per-task=1  # nr. of cores per-task
        # Request runtime for the job (HHH:MM:SS) where 168 hours is the maximum at most centres. Here asking for 15 min.
        #SBATCH --time=00:15:00

        # WARNING! Do not do "module purge" here! 

        # Load the module environment suitable for the job, it could be more or
        # less, depending on other package needs. This is for a simple job needing
        # mpi4py. 

        ml cray-python/3.11.7

        # And finally run the job - use srun for MPI jobs, but not for serial jobs
        srun ./integration2d_mpi.py
        ```

    === "C3SE" 

        Note: on Alvis you *must* request a GPU regardless - it is only really for GPU jobs. Here I just ask for 1 T4 

        ```bash
        #!/bin/bash
        # The name of the account you are running in, mandatory.
        #SBATCH -A naissXXXX-YY-ZZZ
        # Request resources - here for eight MPI tasks
        #SBATCH -n 8
        #SBATCH -N 1 --gpus-per-node=T4:8  # 1 node with 8 Nvidia T4 GPUs
        #BATCH -p alvis
        # Request runtime for the job (HHH:MM:SS) where 168 hours is the maximum at most centres. Here asking for 15 min.
        #SBATCH --time=00:15:00

        # Clear the environment from any previously loaded modules
        module purge > /dev/null 2>&1

        # Load the module environment suitable for the job, it could be more or
        # less, depending on other package needs. This is for a simple job needing
        # mpi4py. 

        ml Python/3.11.5-GCCcore-13.2.0 SciPy-bundle/2023.11-gfbf-2023b mpi4py/3.1.5-gompi-2023b          

        # And finally run the job - use srun for MPI jobs, but not for serial jobs
        srun ./integration2d_mpi.py
        ```

## GPU jobs 

Here there are two things to pay attention to: 

- The modules you load must be for software that is GPU-aware (and often compiled with CUDA as well). 
- You need to ask for GPU resources in the batch script 

!!! note "Example - GPU job script" 

    In this example we make a batch script for running a small Python GPU script called <a href="../add-list.py" target="_blank">add-list.py</a>. It needs "numba". 

    === "HPC2N" 

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

    === "UPPMAX (Pelle)"

        !!! warning 
        
            Note that the numba installation, as of now, gives a segmentation fault for this exercise. We are troubleshooting until next time!

        Pelle has Nvidia L40s and H100 GPUs. Default is L40s and is reached by just stating ``-p gpu --gres=gpu``. To reach one of very few large H100 state ``-p gpu --gpus=h100``.

        ```bash 
        #!/bin/bash
        # Remember to change this to your own project ID!
        #SBATCH -A uppmaxXXXX-Y-ZZZ
        # We are asking for 10 minutes
        #SBATCH --time=00:10:00
        # Asking for one GPU
        #SBATCH -p gpu
        #SBATCH --gres=gpu:1

        module purge  > /dev/null 2>&1
        module load numba/0.60.0-foss-2024a  # You get GCC/13.3.0 OpenMPI/5.0.3-GCC-13.3.0 Python/3.12.3-GCCcore-13.3.0 Python-bundle-PyPI/2024.06-GCCcore-13.3.0 and SciPy-bundle/2024.05-gfbf-2024a and more on the fly!

        # Run your Python script
        python add-list.py
        ``` 
        
    === "UPPMAX (Bianca)"

        ```bash 
        #!/bin/bash -l  # -l is needed
        # Remember to change this to your own project ID!
        #SBATCH -A sensXXXX-Y-ZZZ
        # We are asking for 70 minutes. <= 60 min introduces as bug
        #SBATCH --time=01:10:00
        # Asking for one GPU
        #SBATCH -C gpu 
        #SBATCH --gres=gpu:1

        # If you remove any loaded modules with "module purge" you need 
        # to load the module "uppmax" again. This is how it is done here. 
        module purge  > /dev/null 2>&1
        module load uppmax
        # The Python package "numba" is included in the python_ML_packages which has both a _cpu and a _gpu version.  
        module load python_ML_packages/3.11.8-gpu

        # Run your Python script
        python add-list.py
        ``` 

    === "LUNARC"

        LUNARC has Nvidia A100 GPUs. The modules are arranged as at HPC2N, with prerequisites, and with numba its own module 

        ```bash 
        #!/bin/bash
        Remember to change this to your own project ID!
        #SBATCH -A luXXXX-Y-ZZ
        We are asking for 5 minutes
        #SBATCH --time=00:05:00
        #SBATCH --ntasks-per-node=1
        Asking for one A100 GPU
        #SBATCH -p gpua100
        #SBATCH --gres=gpu:1

        Remove any loaded modules and load the ones we need
        module purge  > /dev/null 2>&1
        module load GCC/12.3.0  Python/3.11.3 OpenMPI/4.1.5 numba/0.58.1 SciPy-bundle/2023.07 CUDA/12.1.1

        Run your Python script
        python add-list.py 
        ```
 
    === "NSC"

        Tetralith has Nvidia T4 GPUs. 

        ```bash 
        #!/bin/bash
        # Remember to change this to your own project ID!
        #SBATCH -A naissXXXX-YY-ZZZ
        # We are asking for 5 minutes
        #SBATCH --time=00:05:00
        # This is how you ask for a GPU at Tetralith - you need all three lines
        #SBATCH -n 1
        #SBATCH -c 32
        #SBATCH --gpus-per-task=1

        # Remove any loaded modules and load the ones we need. This is safe here
        module purge  > /dev/null 2>&1
        # numba is not installed, but we need these in order to get the 
        # prerequisites for an install in a virtual environment 
        module load buildtool-easybuild/4.8.0-hpce082752a2 GCC/13.2.0 Python/3.11.5 SciPy-bundle/2023.11 JupyterLab/4.2.0

        # Load a virtual environment where numba is installed
        # you can create it with the following steps BEFORE running the batch script:
        # ml buildtool-easybuild/4.8.0-hpce082752a2 GCC/13.2.0 Python/3.11.5 SciPy-bundle/2023.11 JupyterLab/4.2.0
        # python -m venv mynumba
        # source mynumba/bin/activate
        # pip install numba
        #

        Then when you want to use it in the batch script, we include this 
        source <path-to>/mynumba/bin/activate

        # Run your Python script
        python add-list.py
        ```  
 
    === "PDC"

        Dardel has 4 AMD Instinct™ MI250X á 2 GCDs per node. 

        - This is AMD GPUs and numba after version 0.53.1 only has compatibility with CUDA (Nvidia GPUs). 
        - The numba 0.53.1 version is too old to work with anything else installed. 
        - Thus, no numba example for PDC. 
        - You would have to use an example with hip instead and you would also need to install hip-python in a virtual environment to get any of it to work.

        If you want to ask for a GPU on Dardel, you add this to a batch script: 

        ```bash 
        #SBATCH -N 1
        #SBATCH --ntasks-per-node=1
        #SBATCH -p gpu
        ```

    === "C3SE" 

        There is some information about job scripts on Alvis here: <a href="https://www.c3se.chalmers.se/documentation/submitting_jobs/running_jobs/#writing-a-job-script" target="_blank">https://www.c3se.chalmers.se/documentation/submitting_jobs/running_jobs/#writing-a-job-script</a> 

        On Alvis there are the following options on (Nvidia) GPUs to request and the lines to add in each case. 

        So you would add ONE of these: 

        ```bash
        #SBATCH --gpus-per-node=V100:1      # up to 4
        #SBATCH --gpus-per-node=T4:1        # up to 8
        #SBATCH --gpus-per-node=A40:1       # up to 4
        #SBATCH --gpus-per-node=A100:1      # up to 4
        #SBATCH --gpus-per-node=A100fat:1   # up to 4
        ``` 

        This is the example script to run the numba example: 

        ```bash 
        #!/usr/bin/env bash
        # Change to your own job ID! The partition is alvis 
        #SBATCH -A NAISSXXXX-Y-ZZ -p alvis
        #SBATCH -N 1 --gpus-per-node=T4:8  # 1 node with 8 Nvidia T4 GPUs
        #SBATCH -t 0-00:10:00

        # module purge and then load the needed modules. numba at Alvis 
        # automatically loads all the other needed modules (GCC, Python, 
        # OpenMPI, SciPy-bundle, etc. so can be loaded directly 
        module purge  > /dev/null 2>&1 
        ml numba/0.58.1-foss-2023a 

        # Run your Python script
        python add-list.py
        ``` 
