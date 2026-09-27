# Model solutions for Extra exercises 

These exercises are meant as extra (optional) training and can be done either during classes if there is time, or later.

## Finding existing modules  

1. Finding versions
    - Find which R versions exist
        - Answer: use `module spider R` to get 
          ```bash
          R/4.3.2
          R/4.4.1
          R/4.4.2
          R/4.5.1
          R/4.5.2
          ```
    - What are the prerequisites for R/4.5.2?
        - Answer: use `module spider R/4.5.2` to get `GCC/14.3.0`
    - Which versions of Python exist?
        - Answer: use `module spider Python` to get 
          ```bash
          Python/2.7.18
          Python/3.8.6
          Python/3.11.3
          Python/3.11.5
          Python/3.12.3
          Python/3.13.1
          Python/3.13.5
          Python/3.14.2
          ```
    - What are the prerequisites for Python/3.13.5?
        - Answer: use `module spider Python/3.13.5` to get `GCCcore/14.3.0`     
    - Find the versions of the module R-bundle-Bioconductor
        - Answer: use `module spider R-bundle-Bioconductor` to get
          ```bash
          R-bundle-Bioconductor/3.18-R-4.3.2
          R-bundle-Bioconductor/3.19-R-4.4.1
          R-bundle-Bioconductor/3.20-R-4.4.2
          R-bundle-Bioconductor/3.22-R-4.5.1
          R-bundle-Bioconductor/3.22-R-4.5.2
          ```
    - What are the prerequisites for R-bundle-Bioconductor/3.22-R-4.5.2?
        - Answer: use `module spider R-bundle-Bioconductor/3.22-R-4.5.2` to get `GCC/14.3.0  OpenMPI/5.0.8`

## Loading modules 

1. Loading modules
    - Load R-bundle-Bioconductor/3.22-R-4.5.2 (after first loading any prerequisites).
    - List the modules that are loaded. 
    - What got loaded? Was it more than you expected? 
2. Unloading modules
    - Try and unload one of the modules. What happens if it is a prerequisite? 
    - Do `module purge`. Did everything get unloaded? What did not? 

## Toolchains 

1. What are compiler toolchains?
2. How come you can see the compiler toolchains with `ml avail`?
3. What is included in `foss/2023b`? 
4. List all `foss` and `ìntel` compiler toolchains. 

## Software module examples 

1. Which prerequisites does `mpi4py` have?
2. How many version of SciPy-bundle are there?
3. Is OpenMPI included when you load SciPy-bundle or is it a prerequisite?
4. What are the prerequisites of `R-bundle-CRAN`? 
5. Find out the installed versions of Nextflow and how to load the newest one. 
6. Does BioPython load Python? 

## Modules in batch scripts 

- How do you load a module in a batch script? Do you need to load any prerequisites? 

## Containers on Kebnekaise 

1. Which container platform is used on Kebnekaise? 
2. Do you need to load a module to make containers available on Kebnekaise? 
3. Can you run a downloaded Docker image at Kebnekaise? 
4. Download a docker image from `https://hub.docker.com/u/biocontainers` to your project directory space on Kebnekaise and convert it to an apptainer image file. Example: `beast2` - or pick an image yourself. 
5. Execute your apptainer image with apptainer. If it is a graphical tool you need to use OpenOnDemand (or SSH with x11 forwarding). 


