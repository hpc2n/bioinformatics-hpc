# Exercises for the section Modules in batch scripts 

In the same folder as this file there are two Python files, "integration2d_mpi.py" and "mmmult.py". 

1. Look at the serial batch script example for your centre at https://hpc2n.github.io/selecting-modules/batch/ 
2. Find out which modules are mentioned as needed for running the Python script.
3. Try to run the serial R script "mmmult.py" with the command ``python mmmult.py`` and see that it does not run. 
4. Try load the modules that are required to run the serial R script "mmmult.py"
5. Now again try and run "mmmult.py" with ``python mmmult.py``and see that it runs. 
6. You can try only loading some of the modules and see that it requires them all. 
7. Unload the modules
8. Try also loading the modules needed for running the MPI job.
9. Try running it with ``srun python integration2d_mpi.py``
10. Does it run? (No, it needs to be submitted as a batch job).  


