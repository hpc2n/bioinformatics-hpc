# Accessing software on Kebnekaise

A look at the Kebnekaise module system: finding, loading, and using modules.

In addition we will look at how to use containers on Kebnekaise.

!!! note "Learning outcome"

     - What is the module system?
     - Why do I want to use the module system?
     - What happens when I load/unload modules?
         - paths
         - environment variables
         - more?
     - Useful commands
     - Load examples
     - Compiler toolchains
     - What are containers?
     - When and why should I use containers?
     - How to use containers on Kebnekaise
     - Creating containers on your own computer (optional) 

## Preparations 

In order to type along and do the exercises, please prepare your course environment now, if you have not done so before:

1. Login to Kebnekaise (see [Connecting to a computer cluster (Kebnekaise)](https://hpc2n.github.io/bioinformatics-hpc/02.connect-cluster/connect-cluster/)
    - You will not need a graphical user interface for this course. You can use a regular SSH client. 
    - OpenOnDemand works as well. 
2. Download the exercises 
    ``wget https://github.com/hpc2n/bioinformatics-hpc/raw/refs/heads/main/exercises.tar.gz``
3. Extract the exercises
    ``tar zxvf exercises.tar.gz`` 

## References

- Documentation about selecting modules at HPC2N: <a href="https://docs.hpc2n.umu.se/software/modules/" target="_blank">https://docs.hpc2n.umu.se/software/modules/</a>
 
