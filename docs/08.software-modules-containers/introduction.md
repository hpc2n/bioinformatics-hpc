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

## Schedule

| Time | Topic | Activity | Teacher |
| ---- | ----- | -------- | ------- |
| 09:00 | Introduction and preparations | Lecture + code-along | PO |
| 09:15 | The module system | Lecture + code-along + exercises | PO |
| 09:25 | Module system commands | | |
| 10:45 | Branches, merges, and conflicts | Lecture + code-along + exercises | BB |
| 11:45 | Working with remotes I | Lecture  | PO |
| 12:00 | BREAK | | |
| 13:00 | Working with remotes II | Lecture + code-along + exercises | PO |
| 13:15 | Teamwork | Lecture + code-along + exercises | BB |
| 14:00 | Exercises | Exercises on your own/in teams | |
| 14:30 | BREAK | | |
| 14:45 | Exercises | Exercises on your own/in teams | |
| 16:00 | End of course day | | |

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
 
