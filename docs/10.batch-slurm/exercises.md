# Extra exercises 

These exercises are meant as extra (optional) training and can be done either during classes if there is time, or later.

## Slurm commands  

These commands are run in a terminal. Either connect to Kebnekaise using an SSH client or use OpenOnDemand and start a terminal. 

1. Type the command `projinfo`. Look at the output. Try adding some options, `projinfo -vd -u <your-username>`. You now get output telling you who are in the same project and how much each has run. However, the output is not always reliable and updated. Go to `https://supr.naiss.se` and click on your project `hpc2ncourses2026-013` in the left side, then scroll down to see usage (click on usage per day and usage per account). 
2. 
    - Either on your own computer, or in your project storage space on Kebnekaise, create a directory to build in. Enter it.
    - Go to https://github.com/pezmaster31/bamtools
    - Click the green "<> Code" button and then right-click the "Download ZIP"
    - Fetch it with `wget <url you copied>
    - You will have downloaded a file named `master.zip`. Unzip it. 
    - Enter the directory `bamtools-master` that was created. 
    - Create a directory inside to build in: `mkdir build` 
    - Load some modules: `module load foss/2024a CMake/3.29.3`
    - Create build files with cmake: `cmake ..`
    - `make`
    - The variable DESTDIR is the path to where you want the binaries, libraries, and include files located: `make DESTDIR=/path/to/where/you/want/the/installed/files/bamtools install`
    - If you want to be able to use bamtools without giving the full path, add the paths to your `bashrc`:
        - `export PATH=$PATH:/path/to/where/you/installed/files/bamtools/bin`
        - `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/where/you/installed/files/bamtools/lib`

## Installing software from a Git repository - R

1. Installing `hdf5r` and `loomR` from GitHub, on Kebnekaise 
    - Load some modules: `module load GCC/14.3.0 R/4.5.2`
    - We need `devtools`, so first install that if you have not. 
        - Start `R`
        - `install.packages("devtools")`
            - You will be asked to confirm installing to your own R library if you have not set that up. You will also be asked for a mirror to use. Pick Sweden, Umeå. 
    - Now you can use devtools to install from GitHub, you need to also install prerequisites: 
        - `devtools::install_github("hadley/stringr")`
        - `devtools::install_github(repo = "hhoeflin/hdf5r")`
        - `devtools::install_github(repo = "mojaveazure/loomR", ref = "develop")`

## Installing software from a Git repository - Python 

1. Let us install `nimfa` - Non-negative matrix factorization
    - Go to your project storage space on Kebnekaise
    - Load some modules, including Python, SciPy-bundle (numpy, scipy), matplotlib, the Git module, with prerequisites: `module load GCC/13.2.0 Python/3.11.5 SciPy-bundle/2023.11 matplotlib/3.8.2 git/2.42.0`
        - Scipy, numpy, and matplotlib are prerequisites for nimfa. Also, nimfa does not currently work for Python > 3.11.x. 
    - Go to `https://github.com/ccshao/nimfa` and clone: `git clone https://github.com/ccshao/nimfa.git`
    - Enter the `nimfa` directory. 
    - Install to the path where you want nimfa available, example: `python setup.py install --prefix=/proj/nobackup/cddb_course/<your-dir>/mynimfa`  
    - Set PYTHONPATH (example): `export PYTHONPATH=$PYTHONPATH:/proj/nobackup/cddb_course/<your-dir>/mynimfa/lib/python3.11/site-packages/`
    - You can find a test to run and see if it worked on: `https://nimfa.biolab.si/` (Start Python first) 


