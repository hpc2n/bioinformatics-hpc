# Interactive jobs

There are more than one way to start an interactive job. It can be done either from the command line or inside ThinLinc (GfxLauncher) or from a portal (OpenOnDemand portal). 

## salloc and interactive

The Slurm command ``salloc`` is for requesting an interactive allocation. This is not "true interactivity" as we will see.  

| salloc | OpenOnDemand |  
| ------ | ------------ |  
| Recommended | Recommended (OOD) |  

### Examples

Usage: ``salloc -A [project_name] -t HHH:MM:SS``

You have to give project ID and walltime. If you need more CPUs (1 is default) or GPUs, you have to ask for that as well.

```bash
b-icn1613 [~]$ salloc -A <PROJ-ID> -t 00:10:00
salloc: Pending job allocation 34624444
salloc: job 34624444 queued and waiting for resources
salloc: job 34624444 has been allocated resources
salloc: Granted job allocation 34624444
salloc: Nodes b-cn1403 are ready for job
b-cn1613 [~]$
```
        
WARNING! This is not true interactivity! Note that we are still on the login node!
      
In order to run anything in the allocation, you need to preface with ``srun`` like this:
         
```bash
b-cn1613 [~]$ srun /bin/hostname
b-cn1403.hpc2n.umu.se
b-cn1613 [~]$
```
        
Otherwise anything will run on the login node! Also, interactive sessions (for instance a program that asks for input) will not work correctly as that dialogoue happens on the compute node which you do not have real access to!

## OpenOnDemand

This is the recommended way to do interactive jobs at HPC2N. 

- Go to <a href="https://portal.hpc2n.umu.se/" target="_blank">https://portal.hpc2n.umu.se/</a> and login.
- Documentation here: <a href="https://docs.hpc2n.umu.se/tutorials/connections/#open__ondemand" target="_blank">https://docs.hpc2n.umu.se/tutorials/connections/#open__ondemand</a>

!!! note

    - At centres that have OpenOnDemand installed, you do not have to submit a batch job, but can run directly on the already allocated resources (see interactive jobs).
        - OpenOnDemand is a good option for interactive tasks, graphical applications/visualization, and simpler job submittions. It can also be more user-friendly.
        - Regardless, there are many situations where submitting a batch job is the best option instead, including when you want to run jobs that need many resources (time, memory, multiple cores, multiple GPUs) or when you run multiple jobs concurrently or in a specified succession, without need for manual intervention. Batch jobs are often also preferred for automation (scripts) and reproducibility. Many types of application software fall into this category.
    - At centres that have ThinLinc you can usually submit MATLAB jobs to compute resources from within MATLAB.

