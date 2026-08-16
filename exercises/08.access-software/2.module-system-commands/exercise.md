# Exercises for the section "Module system commands" 

## module spider and module avail 

1. Find available versions of Python at your centre. Which command works best? 
2. At your chosen centre, check the different output for ``module avail Python`` and ``module spider Python``
3. Do you get the same output for “Python” and “python”?

## module list 

Listing modules 

1. Try the commands ``ml`` and ``module list`` and see that they give the same output. 

## module load 

1. Find out how to load Python version 3.11.x at your centre (pick one if there are several versions). 
2. Load Python/3.11.x and any prerequisites. 
3. Did it have prerequisites at your centre? 
4. After you have loaded the module(s), again do ``module list`` and see that the list of loaded modules have changed. 

## module unload 

You probably have (some) modules loaded now. 

1. Try unload a module that has no prerequisites (like GCC or GCCcore at some centres or Python at others). 
2. Try unload a module that has prerequisites if there are such at your centre. 
3. What happens if you try and unload the prerequisite first? (only some centres have prerequisite modules) 

## module purge

**Warning! Do not do this at PDC!**

At some centres, ``module purge`` is recommended and at some it is at least safe: HPC2N, LUNARC, NSC, C3SE 

At UPPMAX it is not recommended, but the only module you need load again if you did ``module purge`` is ``uppmax``. 

1. Try loading one or more modules again: 
    - HPC2N, LUNARC: GCC/12.3.0 and perhaps Python/3.11.3
    - UPPMAX: Python/3.12.3-GCCcore-13.3.0 
    - C3SE: Python/3.12.3-GCCcore-13.3.0
    - NSC: Python/3.11.5-env-hpc1-gcc-2023b-eb
    - PDC: cray-python/3.11.5
2. Do ``module list`` and look at what is loaded 
3. If you are NOT at PDC, do ``module purge``
4. Do ``module list`` again to see what happened (and do ``module load uppmax`` if you are at UPPMAX). 

## Another, longer example 

1. Check how to load R at your centre. Pick a version.
2. Does it have prerequisites at your centre?
3. Load R for a specific version (but first load prerequisites if there are any).
4. Run ``module list`` to see what modules got loaded. Was it more than you expected?
5. Unload R (and prerequisites if there are any). See what happens.
6. Do ``module list`` again.

## module save/restore 

1. Try loading some modules
2. Create a module collection with ``module save <module-collection>``
3. Do ``module list`` to see what you have
4. Unload the modules
5. Check with ``module list``
6. Rrestore the module collection with ``module restore <module-collection>``
7. Check with module list 





