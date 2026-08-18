# Installing software from a Git repository

The source code for much bioinformatics software are on Github or other Git repositories. 

How to install from such a repository depends on how the authors have it set up. The repository can always just be cloned and then there is usually a description in the README on how to install. In addition, they will sometimes have a tarball that can be downloaded instead. 

Another case is if it is an R package that is on GitHub, but not on R CRAN. 

Let us look at some examples. 

## Cloning a software repository and installing it 

If you want to install some software you have found on GitHub, the usual way to do so is to clone the repository and then install it, following the description in the README file that is usually there. 

!!! Example "Exercise/example: install" 

    Try this example out!

    We are going to download and install ``primer3`` found on <a href="https://github.com/primer3-org/primer3" target="_blank">https://github.com/primer3-org/primer3</a>. 

    ``primer3`` is used to design PCR primers from DNA sequence. 

    More importantly, it has a fairly standard and simple install structure. 

    1. Go to <a href="https://github.com/primer3-org/primer3" target="_blank">https://github.com/primer3-org/primer3</a>
    2. Click on the green "<> Code" button. Make sure it is set to "HTTPS" and then copy the url (click the small copy-symbol to the right of the url) and then open a terminal on Kebnekaise (or your own Linux computer if you are installing there) and type ``git clone https://github.com/primer3-org/primer3.git`` and press "enter". 
    3. After the repository has been cloned, it is time to follow the install instructions on the README. Do note that if you are on Kebnekaise you CANNOT do ``sudo apt-get install -y build-essential g++ cmake git-all`` as users do not have sudo access. That should not matter as those are already installed - but you need to load some modules. 
    4. ``module load GCC/14.3.0 CMake/4.0.3 git/2.50.1``
    5. ``cd primer3/src``
    6. ``make``
    7. ``make test``

    Then to run it on for instance the included example, from inside ``cd primer3/src`` do: ``./primer3_core ../example``

## R package from GitHub 

There are two main paths here; automatic and manual. 

!!! hint "Installing R packages from CRAN"

    Most CRAN packages are already available in one of the R package modules at Kebnekaise, and you can usually just ask us to install any that are missing. 

    However, if you do want to install an R package from CRAN yourself, then there is [documentation on installing from CRAN here](https://hpc2n.github.io/bioinformatics-hpc/08.software-modules-containers/Rpack/).

### Automatic download and install from GitHub

If you want to install a package that is not on CRAN, but which do have a GitHub page, then there is an automatic way of installing, but you need to handle prerequsites yourself by installing those first. It can also be that the package is not in as finished a state as those on CRAN, so be careful.

To install packages from GitHub directly, from inside R, you first need to install the ``devtools`` package. **Note** that you only need to install this once.

This is how you install a package from GitHub. It is done from **inside R**: 

```bash
install.packages("devtools")   # ONLY ONCE
devtools::install_github("DeveloperName/package")
```

Remember, if there are any prerequisites, you need to install those first! 

!!! note "Example/exercise"

    Try this example! 

    In this example we want to install the package ``inspectdf``. It is not on CRAN or Bioconductor, so let us get it from the GitHub page for the project: <a href="https://github.com/alastairrushworth/inspectdf" target="_blank">https://github.com/alastairrushworth/inspectdf</a> 

    We also need to install devtools so we can install packages from GitHub. In this case there are no prerequisites, but if there were we would have to install them first. 

    **Note** that it may suggest you to update a number of packages first. You can do that if you want. 

    Let us start out by loading the R module (and prerequisites) and the R-bundle-Bioconductor and R-bundle-CRAN (and prerequisites). I am going to use R/4.4.2 in this example: 

    ```bash
    module load GCC/13.3.0 R/4.4.2
    module load OpenMPI/5.0.3 R-bundle-Bioconductor/3.20-R-4.4.2 R-bundle-CRAN/2024.11
    ```

    Now we configure the location for R to install your packages. If there is a lot, you should use your project storage as your home directory only has 25GB: 

    On command line (change path to your own): 

    ```bash
    echo R_LIBS_USER="/proj/nobackup/path-to-your-projectdir/R-packages-%V" > ~/.Renviron
    ```

    (If you already have the file ``$HOME/.Renviron`` then instead edit it, with say ``nano``). 

    Create the above directory (once per R version you use): 

    ```bash
    mkdir -p /proj/nobackup/path-to-your-projectdir/R-packages-VERSION
    ```

    Now we start R and then install ``devtools``: 

    ```bash
    R
    ```

    ```R
    install.packages("devtools") # ONLY ONCE (per R version you use) 
    ```

    It will ask for a CRAN mirror. Pick the one closes to you. It will install devtools. It may take some minutes. 

    Now it is time to install the R package ``inspectdf`` from GitHub. You do that like this (from inside R): 

    ```R
    devtools::install_github("alastairrushworth/inspectdf")
    ```

### Manual download and install

If the package is not on CRAN or you want the development version, or you for other reason want to install a package you downloaded, then this is how to install from the command line:

``R CMD INSTALL -l <path-to-R-package>/R-package.tar.gz``

NOTE that if you install a package this way, you need to handle any dependencies yourself.

## Python package from a Git repository 

Many Python packages are already installed on HPC2N, so check first if what you need is already available. You can find many of them listed here: <a href="https://docs.hpc2n.umu.se/software/apps/#python__modules" target="_blank">https://docs.hpc2n.umu.se/software/apps/#python__modules</a>. 

If you need a different package, then there are a number of ways to install it: 

- Download the repository as a zip file and run the included Python scripts
- Clone the repository from GitHub 
- Clone/download zip and install
- Install an installable Python package directly from GitHub with pip

### Download the repo as zip, run included Python scripts 

This is the easiest way, but you have to check yourself if it needs updating/downloading a new version since it is not in any way connected to the Git repository. 

1. Go to the projects GitHub (or other) page.
2. Click the green "<> Code" button and pick "Download Zip"
3. Run the script directly without installation. 

### Clone the repository from GitHub 

The difference between this and the previous is that you get a local copy that is connected to the repository on GitHub and so you can update it with got pull (or git fetch).

1. Click the green "<> Code" button and under "Clone" copy the **HTTPS** version of the url. 
2. Do ``git clone <url you got>``
3. Run the script, without installation. 

### Clone/download zip and install 

Sometimes you will get a Python package that needs to be downloaded and installed locally. The process can vary from local install with [Python setup](https://docs.hpc2n.umu.se/software/userinstalls/#installing__with__setuppy) to building with ``make``.

!!! note "Example: pybedtools" 

    1. ``git clone https://github.com/daler/pybedtools.git``
    2. ``cd pybedtools``
    3. Load modules and prerequisites: ``module load GCC/14.3.0 Cython/3.1.2 git/2.50.1``
    4. ``python setup.py cythonize``

!!! note "Example: SPAdes" 

    1. Go to: ``https://github.com/ablab/spades/releases/tag/v4.3.0``
    2. Copy the tarball source code and fetch it: ``wget https://github.com/ablab/spades/archive/refs/tags/v4.3.0.tar.gz``
    3. Untar it: ``tar zxvf v4.3.0.tar.gz``
    4. Enter directory: ``cd spades-4.3.0``
    5. Load some modules: ``module load foss/2026.1 CMake/4.2.1 zlib/2.3.2 Python/3.14.2``
    6.  Build (default dir is ./bin, remove PREFIZ option if you are happy with that): ``PREFIX=<destination_dir> ./spades_compile.sh``
 

### Install an installable Python package directly from GitHub with pip

If the repository you have found on GitHub is structured as an installable Python package, you can install the Python package directly from GitHub, with pip. 

This is very handy, if it is not available on PyPi or similar. 

!!! hint "Syntax"

    The general syntax is: 

    ``pip install git+https://github.com/USERNAME/REPOSITORY.git``

!!! note "Example: BioNumPy"

    1. Load some modules: ``module load GCC/14.3.0 Python/3.13.5 SciPy-bundle/2025.07`` 
    2. Copy the HTTPS url from the green "<> Code" button.
    3. Install with pip: ``pip install git+https://github.com/bionumpy/bionumpy.git``

## References 

- https://github.com/danielecook/Awesome-Bioinformatics
- https://www.fabriziomusacchio.com/blog/2022-10-31-GitHub/ 

