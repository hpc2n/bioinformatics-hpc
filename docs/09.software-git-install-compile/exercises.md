# Extra exercises 

These exercises are meant as extra (optional) training and can be done either during classes if there is time, or later.

## Installing software from a Git repository - general  

1. Installing `bamtools` (it is already on Kebnekaise as a module - this is just as an example)
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
    - Now you can use devtools to install from GitHub, you need to install prerequisites: 
        - `devtools::install_github("hadley/stringr")`
        - `devtools::install_github(repo = "hhoeflin/hdf5r")`
        - `devtools::install_github(repo = "mojaveazure/loomR", ref = "develop")`

## Installing software from a Git repository - Python 

- https://andre-rendeiro.com/2015/04/08/bioinfo_fresh_install_ubuntu


