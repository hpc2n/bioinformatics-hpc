# Examples of specific tools

!!! note "Objectives" 

    - Be able to find some typical software modules that are installed 
    - Learn how to load those software modules (and any prerequisites)
    - Be able to find out if **Python packages** are installed as their own modules
    - Learn how to find bundles of **R packages** installed as modules 

In the previous section we looked at toolchains, which are often used to install or build your own software. In this chapter we will look at some examples of how to find and load some of the typical software modules that are installed at many of the Swedish HPC centres. 

Loading modules works the same whether the modules are toolchains or standalone packages, with and without prerequisites. The procedure is usually some variation on the following:

1. Use `ml spider <package>` to see **whether a module is installed**, and if so, view the available versions. (At facilities that do not hide packages depending on prerequisites, `module avail <package>` may be preferred.)
2. Use `ml spider <package>/<version>` to **view prerequisites** for a specific version of the module, if any.
3. **Load** the modules with `ml <prerequisite>/<version> <package>/<version>`.

Most of the examples below use outputs from Cosmos, but the workflows will be similar at other institutions except where otherwise noted.

### Outline

- Principles of making Python and R **packages** available to scripts and interactive analysis.
- Start **popular tools** like MATLAB and OpenFOAM and notes about licensed software
- **Exercise**: Dig deeper into **your favorite tools**

## Packages

!!! important

    Both R and Python packages often include many so-called extensions (dependent packages that are usually called modules when not dealing with LMOD modules) that are installed, but cannot be found with `ml spider` or `ml avail`.
    
    In these cases, if you have loaded at least the prerequisites of a standalone package containing the extension, you can use `ml show <package>` on the standalone package to view the Lua module file, which usually has a section on included extensions near the top.
    
    For example, NumPy, SciPy, and Pandas, among other packages, are all are included in `SciPy-bundle`. If you have at least loaded a GCC version, you can use `ml show SciPy-bundle` to view all of the included extensions (Python modules) in the compatible SciPy-bundle.

## Python-based packages

We already learned how to load Python module of a specific version.

It varies between clusters how many packages are installed with the base Python packages, how many are installed as separate modules, what prerequisites are required (most centres apart from PDC are the same), and the available version numbers. 

??? note "Packages at the clusters"

    - **HPC2N** and **C3SE:** Little is installed with the Python module, but most of the common Python packages are available as extra modules (SciPy-bundle, Jupyter, mpi4py, matplotlib, tensorflow, PyTorch, Python-bundle-PyPi, ...)
    - **LUNARC:** Little is installed with the Python module, but instead most of the common Python packages are available as extra modules (SciPy-bundle, Jupyter, mpi4py, matplotlib, tensorflow, PyTorch, Python-bundle-PyPi, ...). Anaconda3 bundles more into one module (SciPy, Pandas, Matplotlib, etc), but other modules loaded alongside it are typically not recognised. Additional modules must be installed in a custom environment.
    - **NSC:** Little is installed with the Python module, but most of the common Python packages are available as extra modules (SciPy-bundle, matplotlib, mpi4py, PyTorch, Python-bundle-PyPi, Jupyter, ...). Most programs on Tetralith also have an extra prerequisite, `buildtool-easybuild/4.X.X-hpc<version>` that must be loaded before anything else.  
    - **UPPMAX-Pelle:** Little is installed with the Python module, but most of the common Python packages are available as extra modules (SciPy-bundle, matplotlib, mpi4py, Python-bundle-PyPi, Jupyter-lab, ...). No Prerequisites are needed! 
    - **UPPMAX-Bianca:** Very many packages are installed with the Python module.  
    - **PDC:** most modules included in SciPy-bundle (NumPy, SciPy, Pandas, etc.) are in `cray-python` modules, and these are compatible with a couple of the installed versions of matplotlib. Python modules that do not include the `cray-` prefix have very little installed in them and are not compatible with most other Python-adjacent modules; these are typically intended as bases for users to build their own environments. Most programs on Dardel also have an extra prerequisite, `PDC/XX.XX` or `PDCOLD/XX.XX` that must be loaded before anything else.
    
### Bundles

- The bundle names reflect the content, like Python packages, and its version, but also which Python version, compilers and libraries that are compatible with it.

- The module endings may contain GCCcore-X.Y.Z and/or [YEAR-a/b]. Example ``SciPy-bundle/2024.05-gfbf-2024a`` or ``Python/3.12.3-GCCcore-13.3.0``
    - GCCcore reflects the GCC compiler version that is compatible when using C/C++ "back end" code.
    - The year reflects an EasyBuild toolchain, see [FOSS toolchains](https://docs.easybuild.io/common-toolchains/#common_toolchains_overview_foss).

??? note "Some FOSS tool chains and Python version using them"

    FOSS | Python version| GCC version | Bundle version
    -----| --------------|-------------|---------------
    2024a| 3.12.3        | 13.3.0      | 2024.06/06
    2025b| 3.13.5        | 14.3.0      | 2025.07

    - ``foss`` is the full level toolchain.
    - ``gfbf`` means that the libraries FlexiBLAS (incl. LAPACK) + FFTW are included.
    - ``gompi`` means that the MPI library OpenMPI is included.

    - See [Toolchain diagram](https://docs.easybuild.io/common-toolchains/#toolchains_diagram)

!!! warning

    - Make sure to use bundles that are compatible with each-other and with needed Python version.
    - Otherwise it is better to create isolated environments with Conda or virtual environments, see [Virtual environments in Python](python_virtual_environments.md).

??? note "Some well-known bundles"

    - HPC and big data
        - dask
        - mpi4py
        - numba
    - Scientific tools
        - SciPy-bundles: ``numpy``, ``pandas``, ``scipy``
        - xarray
    - Biopython
    - Interactivity
        - iPython
        - JupyterLab
    - Graphics and diagrams
        - Matplotlib
        - Seaborn
    - Machine Learning
        - scikit-learn
        - PyTorch
        - TensorFlow
    - Bundle of useful packages
        - Python-bundle-PyPI

[See also about Python bundles at Pelle](https://docs.uppmax.uu.se/software/python_bundles/)

### Principles

- Decide what you need!
    1. Start new project with newest toolchain
    2. Go for version you have used before (reproduce)
    3. Exact versions of many packages may need an isolated environment.
- Load one or several bundles, python is loaded on the fly!

- Check versions

```console
ml spider matplotlib
```

This is a very good way to find packages that are not in a bundle with the same name. For instance, ``pandas`` and ``numpy`` are parts of the ``SciPy-bundle``

or

```console
ml avail matplotlib
```

- Load prerequisites, if needed, and then

```console
ml matplotlib/<version>
```

or

```console
ml matplotlib/<version>
```

- Start Python session in a console with

```console
python
```

- Load a needed library, like

```python
import matplotlib
```

!!! note "Isolated environments"

    - The course Python in an HPC environment: [isolated environments](https://uppmax.github.io/HPC-python/day2/use_isolated_environments.html)

??? warning "Using Bianca?"

    - There are no bundle modules on Bianca
    - But, the Python modules have very many packages installed already.

!!! tip
    
    `grep` does not work directly on the outputs of module commands like `ml show <module>`. To search for an extension in a very long Lua module file, copy the full path of the ``.lua`` file from the `ml show` output, and use `less /path/to/module.lua | grep <extension>`. If there is no output, the extension is not present.

??? note "Missing a package?"

    - Install by conda, pip or other tool or contact support
    - [Install packages](https://uppmax.github.io/HPC-python/day2/install_packages.html)
    - [Use isolated environments](https://uppmax.github.io/HPC-python/day2/use_isolated_environments.html)
    
### Python IDEs

- If you are comfortable editing code in a basic text editor and running at the command-line, the modules used in the example above are all you need.
- For more information on choosing and loading IDEs to work with Matplotlib graphics interactively, we refer readers to [this documentation from the Python for HPC course](https://uppmax.github.io/HPC-python/day2/IDEs.html).

??? note "Python IDEs"

    - Jupyter
    - Spyder
    - Visual Studio Code
    - HPC-python course
        - [Starting from command line](https://uppmax.github.io/HPC-python/day2/IDEs_cmd.html)
        - [Starting from OnDemand](https://uppmax.github.io/HPC-python/day2/ondemand-desktop.html)

## R

!!! important

    Most facilities have only built a handful of R releases, so many of the dependent modules are adapted for multiple versions. The version of such any dependent package should always be specified to ensure reproducibility. If the version number is omitted, the latest will be loaded by default, and that version may change without warning.

Most HPC centres have prerequisites for R, but at a few, like Alvis, R can be loaded directly. Always check the prerequisites with `ml spider` or `ml avail`.

### Principles

- Check versions
- Load prerequisites if needed and then R
- Start R console with

```console
R
```

### R-based packages

At most HPC centres, the base R module usually contains relatively few extensions. Most of the popular packages are in additional bundles like the general `R-bundle-CRAN` and bundle for genomic tools `R-bundle-Bioconductor`. Most HPC centres have prerequisites for R, but at a few, like Alvis, R can be loaded directly. Always check the prerequisites with `ml spider` or `ml avail`.

??? note "Cluster-specific approaches"

    - **NSC (Tetralith):** R can be loaded directly, but **contains few installed packages, and there are no bundles** to provide more. Users are typically expected to install their own extension libraries. **RStudio is included in the base R module, however**.
    - **PDC (Dardel):** Like most programs on Dardel, R also has the prerequisite `PDC/XX.XX` or `PDCOLD/XX.XX`, but the compiler and MPI library are chosen for you. There are about 250 packages available in the basic R module, and there are no additional bundles to provide more packages. Users are typically expected to install their own extension libraries. 
    - **C3SE (Alvis):** R can be loaded directly, but has few installed packages. RStudio can only be reached from an OnDemand session.
    - **UPPMAX (Bianca)**: R can be loaded directly, but has few installed packages. More common modules are available as extensions with the `R_packages` module. RStudio is also a separate module.
    - **LUNARC:** Little is installed with the basic R module, but most common packages are available as extensions of R-bundle-CRAN or R-bundle-Bioconductor. RStudio is also a separate module, and is available as an On-Demand application that automatically loads R and various bundles at start-up.
    - **UPPMAX (Pelle):** Little is installed with the basic R module, but most common packages are available as extensions of R-bundle-CRAN or R-bundle-Bioconductor. RStudio is also a separate module.
    - **HPC2N:** Little is installed with the basic R module, but most common packages are available as extensions of R-bundle-CRAN, R-bundle-CRAN-extra, or R-bundle-Bioconductor. RStudio is a separate module and only runs on the login nodes via Thinlinc, so it should be used sparingly.

??? note "About packages on HPC systems"

    Course module on [R packages](https://uppmax.github.io/R-matlab-julia-HPC/r/packages/)


Many R-packages conveniently specify the version of R they are compatible with in the module name. One example of this is Bioconductor.

### Principles

- Check versions

```console
ml spider R-bundle
```

or

```console
ml avail R-bundle
```

- Load prerequisites, if needed, and then

```console
ml R-bundle-CRAN/<version>
```

or

```console
ml R-bundle-Bioconductor/<version>
```

- The bundles should start the R interpreter ion the fly.
- Start R session in a console with

```console
R
```

- Load a needed library, like

```R
> library(parallel)
```

??? note "Missing a package?"

    - Install by yourself or contact support
    - [Course material](https://uppmax.github.io/R-matlab-julia-HPC/r/packages/#installing-your-own-packages)

### RStudio

Many clusters have RStudio as a module but for Alvis and Dardel RStudio can only be reached from OnDemand.

??? note "RStudio from course"

    [RStudio](https://uppmax.github.io/R-matlab-julia-HPC/r/rstudio/)

## Popular tools

There are of course many popular tools among cluster users. Many of them can be found in every cluster, but some clusters are more niched and may lack some of these common tools.

Capitalisation and other naming conventions may vary between HPC centres.

!!! note

    Are you lacking a tool? Ask the support to install it!


### Principle

- Check versions with ``spider`` or ``avail``
- Load prerequisites, if needed, and then

```console
ml <module name>
```

- Start the tool by following documentation of the tool or the local cluster documentation.
- Usually it is the tool name with lower case or with the first letter capitalised. Or, like for OpenFOAM, commands starting with ``foam``.

You may try out one or several tools in Exercise 3.

- There we also give a bit more detailed info about
    - MATLAB
    - OpenFOAM 

??? note "MATLAB in HPC course"

    [Intro to MATLAB](https://uppmax.github.io/R-matlab-julia-HPC/matlab/intro-matlab/)

??? note "MATLAB Add-Ons and Toolboxes 

    These should be available through the Matlab GUI.

!!! important

    - The Matlab GUI and many other graphical tools is prone to hogging resources if not launched carefully, which makes it risky to run on a login node. 
    - In general, the GUI should only be run via either Desktop On Demand or after booking interactive allocations on compute nodes with `salloc` or `interactive`. 
    - For more particulars on *running* Matlab, see the [relevant page of the R, Matlab, and Julia for HPC course materials](https://uppmax.github.io/R-matlab-julia-HPC/matlab/load_runMatlab.html).

## Specialised Applications

- For most specialised packages (Amber, GROMACS, Nextflow, VASP, etc),
    - (unless there is reason to believe it is included in a larger package or you include a spurious non-alphanumeric character),
    - `ml spider` will tell you whether it is installed or not.
- If the full name of a module includes `CUDA`,
    - then the relevant `CUDA` version will typically be loaded automatically,
    - without the need to choose a CUDA-containing toolchain.

!!! important "Licenses"

    - Some specialised modules (e.g., Abaqus, Gaussian, and VASP) are license-restricted, so they may not load, or may load but refuse to run, if you are not part of the **licensed** user group. 
    - If you run `ml spider` on a specific version of licensed software, the description may (as with VASP) or may not (as with Gaussian) specify that a license is required. 
    - It is up to users to determine the licensing requirements of specialised software packages.

## Exercises (Stop recording)

- Choose 1 or possibly 2 

- Python bundles
- R bundles (Tip, do not choose if using Tetralith, Alvis or Dardel)
- Matlab and other favorite tool
    - (Tip, try several, if you don't find one on your cluster)
    - Let us know if you miss something.

Break-out rooms according to interest and/or cluster

### Python

!!! warning "These clusters do NOT have Python bundles"

    - Dardel
    - Tetralith
    - Alvis

!!! note " <img src="../images/shell-logo_small.png"> Exercise 1: Find python documentation of your cluster"

    ??? note "Cluster documentation of Python"

        - [UPPMAX](https://docs.uppmax.uu.se/software/python/)
        - [HPC2N](https://docs.hpc2n.umu.se/software/apps/#python__modules)
        - [LUNARC](https://lunarc-documentation.readthedocs.io/en/latest/guides/applications/Python/)
        - [NSC](https://www.nsc.liu.se/support/)
        - [PDC](https://support.pdc.kth.se/doc/applications/python/)
        - [C3SE](https://www.c3se.chalmers.se/documentation/module_system/python/)  

!!! note " <img src="../images/shell-logo_small.png"> Exercise 2: Find if there is a `matplotlib` package in a module"

    ??? note "Tip"

        ``ml spider`` is good here.

    ??? note "Matplotlib across centres"

        Matplotlib prerequisites vary significantly across HPC centres: some require none, some need one, some need more than one, and in some cases Matplotlib is only an extension of another module ([more info on how to find Matplotlib at different HPC centres here](https://uppmax.github.io/HPC-python/day3/new-matplotlib-intro.html#load-and-run)). 

        If you only want to see what Matplotlib depends on, a good starting point is to view the output of `ml spider matplotlib` (or `ml avail matplotlib` on NSC), pick an arbitrary version, and view `ml spider matplotlib/<version>`.

!!! note " <img src="../images/shell-logo_small.png"> Exercise 3: Make the Python package Matplotlib available to you and test to load it in a python shell"

    ??? note "Tip"

        ``ml <module name>`` is good here.


    ??? note "Example workflow"

        All of the following code blocks in this example are taken from Cosmos.

        ```bash
        $ ml spider matplotlib

        ----------------------------------------------------------------------------
          matplotlib:
        ----------------------------------------------------------------------------
            Description:
              matplotlib is a python 2D plotting library which produces publication
              quality figures in a variety of hardcopy formats and interactive
              environments across platforms. matplotlib can be used in python
              scripts, the python and ipython shell, web application servers, and
              six graphical user interface toolkits.

             Versions:
                matplotlib/2.2.5-Python-2.7.18
                matplotlib/3.3.3
                matplotlib/3.4.2
                matplotlib/3.4.3
                matplotlib/3.5.2
                matplotlib/3.7.0
                matplotlib/3.7.2
                matplotlib/3.8.2
                matplotlib/3.9.2

        ----------------------------------------------------------------------------
        ```

        If you try the above command at your local HPC centre and get a "not found" error, that probably means Matplotlib is an extension of another module (e.g. on Bianca, there are versions that are part of the base Python module and versions that are part of `python_ML_packages`).

        Let us look at `matplotlib/3.8.2`, for example:

        ```bash
        $ ml spider matplotlib/3.8.2

        ---------------------------------------------------------------------------------
          matplotlib: matplotlib/3.8.2
        ---------------------------------------------------------------------------------
            Description:
              matplotlib is a python 2D plotting library which produces publication
              quality figures in a variety of hardcopy formats and interactive
              environments across platforms. matplotlib can be used in python scripts,
              the python and ipython shell, web application servers, and six graphical
              user interface toolkits.


            You will need to load all module(s) on any one of the lines below before the "mat
        plotlib/3.8.2" module is available to load.

              GCC/13.2.0
        ```

        This means that, on Cosmos at least, only GCC must be loaded before Matplotlib. However, Matplotlib is barely usable without the tools to read in or create the data arrays, so NumPy and/or Pandas are also needed. At most facilities, that means SciPy-bundle is required.

        Note that `ml show matplotlib/<version>` does **not** show which Python version is associated with that version of Matplotlib. If `GCC` is loaded, then you can use `ml avail` with `Python`, `matplotlib`, and/or `SciPy-bundle` to see which versions of these are available to load.

        The more typical scenario is that you want to move code developed on a personal laptop to the cluster. Then you will mainly be constrained to a range of Python versions `Python/X.Y.Z`, in which X absolutely *must* match what you used, Y *should* match but may be flexible by one or two versions, and Z is usually not that important. In a bash terminal, you can check your Python version with `python --version`.

        Let's say you built a script using Python 3.11.8 and a compatible version of Matplotlib on your own laptop. Glob patterns do not work to select subsets of `ml spider` or `ml avail` outputs, so one must view the full list with `ml spider Python` (`ml spider cray-python` on Dardel). Here is the output on Cosmos:

        ```bash
        $ ml spider Python
        ---------------------------------------------------------------------------------
          Python:
        ---------------------------------------------------------------------------------
            Description:
              Python is a programming language that lets you work more quickly and integrate
        your systems more effectively.

             Versions:
                Python/2.7.18-bare
                Python/2.7.18
                Python/3.8.6
                Python/3.9.5-bare
                Python/3.9.5
                Python/3.9.6-bare
                Python/3.9.6
                Python/3.10.4-bare
                Python/3.10.4
                Python/3.10.8-bare
                Python/3.10.8
                Python/3.11.3
                Python/3.11.5
                Python/3.12.3
             Other possible modules matches:
                Biopython  GitPython  IPython  Python-bundle  Python-bundle-PyPI
                bx-python  flatbuffers-python  graphviz-python  meson-python  ...
        ```

        The closest result is `Python/3.11.5` (though probably anything from 3.10.x to 3.12.x would work). Let's check what that requires:

        ```bash
        $ ml spider Python/3.11.5
        ---------------------------------------------------------------------------------
          Python: Python/3.11.5
        ---------------------------------------------------------------------------------
            Description:
              Python is a programming language that lets you work more quickly and
              integrate your systems more effectively.


            You will need to load all module(s) on any one of the lines below before the
            "Python/3.11.5" module is available to load.

              GCCcore/13.2.0

            Help:

              Description
              ===========
              Python is a programming language that lets you work more quickly and integrate 
        your systems more effectively.


              More information
              ================
               - Homepage: https://python.org/


              Included extensions
              ===================
              flit_core-3.9.0, packaging-23.2, pip-23.2.1, setuptools-68.2.2, setuptools-
              scm-8.0.4, tomli-2.0.1, typing_extensions-4.8.0, wheel-0.41.2
        ```

        On this cluster, the base Python module requires GCCcore, but we already saw that Matplotlib requires GCC (whch GCCcore is part of). In fact, nearly every other Python-based module apart from the bare Python itself requires GCC, so you may as well use GCC every time.

        On some facilities, each version of Matplotlib and SciPy-bundle is only be associated with one Python version, so you can load them all at once, using the GCC version to select for everything else, like this:

        ```bash
        ml GCC/13.2.0 Python matplotlib SciPy-bundle
        ```

        However, this is considered bad practice since sometimes additional versions are installed later. We should instead check `ml avail` to see what versions of Matplotlib and Scipy-bundle we can load:


        ```bash
        $ ml avail Scipy-bundle

        ----------------------------- /sw/easybuild_milan/modules/all/Compiler/GCC/13.2.0 -----------------------------
           SciPy-bundle/2023.11
        ```

        (Note: some output omitted for brevity)

        ```bash
        $ ml avail Matplotlib

        ----------------------------- /sw/easybuild_milan/modules/all/Compiler/GCC/13.2.0 -----------------------------
           matplotlib/3.8.2
        ```

        Then the one-line loading command should look like this:

        ```bash
        ml GCC/13.2.0 Python/3.11.5 matplotlib/3.8.2 SciPy-bundle/2023.11
        ```

        If we check what was loaded with `ml` or `module list`, the output looks like this: 

        ```bash
        $ ml

        Currently Loaded Modules:
          1) SoftwareTree/Milan         (S)  26) expat/2.5.0
          2) GCCcore/13.2.0                  27) util-linux/2.39
          3) zlib/1.2.13                     28) fontconfig/2.14.2
          4) binutils/2.40                   29) xorg-macros/1.20.0
          5) GCC/13.2.0                      30) libpciaccess/0.17
          6) bzip2/1.0.8                     31) X11/20231019
          7) ncurses/6.4                     32) Tk/8.6.13
          8) libreadline/8.2                 33) Tkinter/3.11.5
          9) Tcl/8.6.13                      34) NASM/2.16.01
         10) SQLite/3.43.1                   35) libjpeg-turbo/3.0.1
         11) XZ/5.4.4                        36) jbigkit/2.1
         12) libffi/3.4.4                    37) gzip/1.13
         13) OpenSSL/1.1                     38) lz4/1.9.4
         14) Python/3.11.5                   39) zstd/1.5.5
         15) OpenBLAS/0.3.24                 40) libdeflate/1.19
         16) FlexiBLAS/3.3.1                 41) LibTIFF/4.6.0
         17) FFTW/3.3.10                     42) giflib/5.2.1
         18) cffi/1.15.1                     43) libwebp/1.3.2
         19) cryptography/41.0.5             44) OpenJPEG/2.5.0
         20) virtualenv/20.24.6              45) LittleCMS/2.15
         21) Python-bundle-PyPI/2023.10      46) Pillow/10.2.0
         22) pybind11/2.11.1                 47) Qhull/2020.2
         23) libpng/1.6.40                   48) matplotlib/3.8.2
         24) Brotli/1.1.0                    49) SciPy-bundle/2023.11
         25) freetype/2.13.2

          Where:
           S:  Module is Sticky, requires --force to unload or purge
        ```

        If you are comfortable editing code in a basic text editor and running at the command-line, the modules used in the example above are all you need. For more information on choosing and loading IDEs to work with Matplotlib graphics interactively, we refer readers to [this documentation from the Python for HPC course](https://uppmax.github.io/HPC-python/day2/IDEs.html).

!!! note " <img src="../images/shell-logo_small.png"> Exercise 4: Check if the python package XX is available in the present environment"

    Extensions can be hard to find without knowing what includes them, but it is easy to check if modules that are already loaded added the extension silently. If you cannot find a package you want with `ml avail`, `ml spider`, or `ml show <module>`, you should also check `pip list` and `grep` for the package after loading the rest of your modules. 

    ??? note "Example: `psutil`"

        For example, `psutil` is part of Python-bundle-PyPI, which is silently loaded with any SciPy-bundle. Here is the easiest way to find `psutil`:
    
        ```bash
        $ pip list | grep psutil
        psutil                            5.9.5
        
        [notice] A new release of pip is available: 23.1.2 -> 25.1.1
        [notice] To update, run: pip install --upgrade pip
        ```
    
        The `pip list | grep` approach is also helpful if you want to see the version of a package without having to open a Python interpreter.

    !!! note "Tip"

        The same list (and grep) approach works for Anaconda3. The only difference is that you should use `conda list` instead of `pip list` (although `pip list` usually still works). The Anaconda3 module file does **not** list the included extensions, so `conda list | grep <package>` is also the *only* way to see if a package is included without starting up a Python command line interface.

### R

!!! warning "These clusters do NOT have R bundle"

    - Bianca has R_packages that contains CRAN and Bioconductor packages
        - You can load that instead of a bundle in the below exercises.
    - Dardel
    - Tetralith
    - Alvis

!!! note " <img src="../images/shell-logo_small.png"> Exercise 1: Find R documentation of your cluster"

    ??? note "Tip"
    
        - [C3SE](https://www.c3se.chalmers.se/documentation/software/development/r/)
        - [HPC2N](https://www.hpc2n.umu.se/resources/software/r)
        - [LUNARC](https://lunarc-documentation.readthedocs.io/en/latest/guides/applications/Rscript/)
        - [NSC](https://ipv4.www.nsc.liu.se/software/catalogue/tetralith/modules/r.html)
        - [PDC](https://support.pdc.kth.se/doc/contact/contact_support/)
        - [UPPMAX](https://docs.uppmax.uu.se/software/r.md)

!!! note " <img src="../images/shell-logo_small.png"> Exercise 2: Load R and start it!"

    ??? note "Answer"

        Course page [how to load](https://uppmax.github.io/R-matlab-julia-HPC/r/load_run/)

!!! note " <img src="../images/shell-logo_small.png"> Exercise 3: Make the R package ``Seurat`` available to you by loading Bioconductor and test to load it (``library(Seurat)``) in a R shell"


    ??? note "Example at Cosmos"

        ```bash
        $ ml spider bioconductor

        ---------------------------------------------------------------------------------
          R-bundle-Bioconductor:
        ---------------------------------------------------------------------------------
            Description:
              Bioconductor provides tools for the analysis and coprehension of
              high-throughput genomic data.

             Versions:
                R-bundle-Bioconductor/3.15-R-4.2.1
                R-bundle-Bioconductor/3.18-R-4.3.2
                R-bundle-Bioconductor/3.18-R-4.4.1
                R-bundle-Bioconductor/3.19-R-4.4.1

        ---------------------------------------------------------------------------------
          For detailed information about a specific "R-bundle-Bioconductor" package (includin
        g how to load the modules) use the module's full name.
          Note that names that have a trailing (E) are extensions provided by other modules.
          For example:

             $ module spider R-bundle-Bioconductor/3.19-R-4.4.1
        ---------------------------------------------------------------------------------
        ```

        Notice that in this case, there are 2 versions of the Bioconductor bundle associated with `R/4.4.1`, and that there are 2 versions of R associated with `R-bundle-Bioconductor/3.18`. Do not rely on the prerequisites to set which version of `R-bundle-Bioconductor` gets loaded.

        To check the prerequisites with `ml spider`, the specific version number must be included anyway, for all software.

        ```bash
        $ ml spider R-bundle-Bioconductor/3.18-R-4.4.1

        ---------------------------------------------------------------------------------
          R-bundle-Bioconductor: R-bundle-Bioconductor/3.18-R-4.4.1
        ---------------------------------------------------------------------------------
            Description:
              Bioconductor provides tools for the analysis and coprehension of
              high-throughput genomic data.


            You will need to load all module(s) on any one of the lines below before the "R-b
        undle-Bioconductor/3.18-R-4.4.1" module is available to load.

              GCC/12.3.0  OpenMPI/4.1.5

            Help:

              Description
              ===========
              Bioconductor provides tools for the analysis and coprehension
               of high-throughput genomic data.


              More information
              ================
               - Homepage: https://bioconductor.org


              Included extensions
              ===================
              affxparser-1.74.0, affy-1.80.0, affycoretools-1.74.0, affyio-1.72.0,
              AgiMicroRna-2.52.0, agricolae-1.3-7, ALDEx2-1.34.0, ALL-1.44.0, ANCOMBC-2.4.0,
              annaffy-1.74.0, annotate-1.80.0, AnnotationDbi-1.64.1,
              AnnotationFilter-1.26.0, AnnotationForge-1.44.0, AnnotationHub-3.10.0,
              anytime-0.3.9, aroma.affymetrix-3.2.1, aroma.apd-0.7.0, aroma.core-3.3.0,
              aroma.light-3.32.0, ash-1.0-15, ATACseqQC-1.26.0, AUCell-1.24.0,
              aws.s3-0.3.21, aws.signature-0.6.0, babelgene-22.9, ballgown-2.34.0,
              basilisk-1.14.2, basilisk.utils-1.14.1, batchelor-1.18.1, baySeq-2.36.0,
              beachmat-2.18.0, BH-1.84.0-0, Biobase-2.62.0, BiocBaseUtils-1.4.0, ...
        ```

        The list of extensions is too long to copy here, but some popular extensions included in this module are: DeSeq2, GenomeInfoDb, MStats, Seurat, Rsamtools, and more.

        The above prerequisites and the main package can be loaded either one at a time or all at once with,

        ```bash
        $ ml GCC/12.3.0  OpenMPI/4.1.5  R-bundle-Bioconductor/3.18-R-4.4.1
        ```

        In this case, R-bundle-Bioconductor loads the version of R that it is based on automatically (along with about 130 other modules!). That is not the case for all R-bundles at all HPC centres, so pay attention to the prerequisites.

### Matlab and another tool you will be using 

!!! note " <img src="../images/shell-logo_small.png"> Exercise 1: Try to find documentation of the program on your cluster"

    ??? note "Documentation for MATLAB"
    
        - Documentation at the HPC centres UPPMAX, HPC2N, LUNARC, NSC, and PDC
        - [UPPMAX Matlab docs](http://docs.uppmax.uu.se/software/matlab/)
        - HPC2N: [Matlab docs](https://www.hpc2n.umu.se/resources/software/matlab) and [parallel Matlab docs](https://www.hpc2n.umu.se/documentation/guides/parallel-matlab)
        - [LUNARC Matlab docs](https://lunarc-documentation.readthedocs.io/en/latest/guides/applications/MATLAB/)
        - NSC: click [here for general instructions](https://www.nsc.liu.se/software/docs/matlab/) and [here for installations on Tetralith](https://www.nsc.liu.se/software/catalogue/tetralith/modules/matlab.html) specifically
        - [PDC Matlab docs](https://support.pdc.kth.se/doc/applications/?sub=matlab/)

!!! note " <img src="../images/shell-logo_small.png"> Exercise 2: Find version of it. Is it installed?? Look for other tools until you find one that is installed"

??? note "Output from ``ml avail matlab``"

    ```bash
    $ ml avail matlab
    
    --------------------- /software/sse2/tetralith_el9/modules ---------------------
       MATLAB/recommendation (D)    MATLAB/2024a-hpc1-bdist
       MATLAB/2023a-bdist           MATLAB/2025a-hpc1-bdist
       MATLAB/2023b-bdist
    
      Where:
       D:  Default Module
    ```

    Once you have chosen a specific version, use `ml spider` to check if there are prerequisites, like so:

    ```bash
    $ ml spider MATLAB/2024a-hpc1-bdist
    ```

    The full output is too verbose to reprint in full here, but the one important line reads: 

    ```bash
        This module can be loaded directly: module load MATLAB/2024a-hpc1-bdist
    ```

    The command after the colon (:) can be copied, pasted, and entered directly into the bash prompt to load the module, or you can type the short version as follows:
    
    ```bash
    $ ml MATLAB/2024a-hpc1-bdist
    ```
    
??? note "Example OpenFOAM at Cosmos"

    As usual, we start by checking the versions available with, eg. `ml spider OpenFOAM` (or `ml avail OpenFOAM` at a facility like NSC where all modules are visible regardless of the presence of prerequisites). 


    ```bash
    $ ml spider OpenFOAM

    --------------------------------------------------------------------------------------
      OpenFOAM:
    --------------------------------------------------------------------------------------
        Description:
          OpenFOAM is a free, open source CFD software package. OpenFOAM has an extensive
          range of features to solve anything from complex fluid flows involving chemical
          reactions, turbulence and heat transfer, to solid dynamics and
          electromagnetics.

         Versions:
            OpenFOAM/v2112
            OpenFOAM/v2206
            OpenFOAM/v2306
            OpenFOAM/v2406
            OpenFOAM/7-20200508
            OpenFOAM/9
            OpenFOAM/10
            OpenFOAM/11

    --------------------------------------------------------------------------------------
      For detailed information about a specific "OpenFOAM" package (including how to load the 
    modules) use the module's full name.
      Note that names that have a trailing (E) are extensions provided by other modules.
      For example:

         $ module spider OpenFOAM/11
    --------------------------------------------------------------------------------------
    ```

    Let us look at a recent version:

    ```bash
    $ ml spider OpenFOAM/11
    --------------------------------------------------------------------------------------
      OpenFOAM: OpenFOAM/11
    --------------------------------------------------------------------------------------
        Description:
          OpenFOAM is a free, open source CFD software package. OpenFOAM has an extensive
          range of features to solve anything from complex fluid flows involving chemical
          reactions, turbulence and heat transfer, to solid dynamics and
          electromagnetics.


        You will need to load all module(s) on any one of the lines below before the "OpenFOAM
    /11" module is available to load.

          GCC/11.3.0  OpenMPI/4.1.4

        Help:
          Description
          ===========
          OpenFOAM is a free, open source CFD software package.
           OpenFOAM has an extensive range of features to solve
           anything from complex fluid flows involving chemical
           reactions, turbulence and heat transfer, to solid dynamics
           and electromagnetics.


          More information
          ================
           - Homepage: https://www.openfoam.org/
    ```

    On this system, GCC and OpenMPI must be loaded first, but this is not true for every system. Indeed, some versions on some systems (e.g. at NSC) load and use the compilers, MPI libraries, and mathematics libraries from Intel toolchains.

    Now we can load everything all at once like so:

    ```bash
    $ ml GCC/11.3.0  OpenMPI/4.1.4 OpenFOAM/11
    ```

    or load each one at a time. The above command loads almost 90 modules, including several Python packages and visualisation libraries, all of which can be viewed by entering `ml`.

!!! note " <img src="../images/shell-logo_small.png"> Exercise 3. Load and start it"

    At most HPC centres, Matlab and other tools can be loaded directly, but PDC requires the usual prerequisite `PDC/XX.XX` or `PDCOLD/XX.XX`. Capitalisation and other naming conventions also vary between HPC centres; for more information, refer to [this section of the R, Matlab, and Julia for HPC course](https://uppmax.github.io/R-matlab-julia-HPC/matlab/load_runMatlab/#check-for-matlab-versions).



## Wrap-up with questions (No recording)

- Did it work out?
- Would you like a tool installed?
- Questions?

## Courses

- [Using Python in an HPC environment](https://uppmax.github.io/HPC-python/index.html)
- [R-MATLAB-Julia](https://uppmax.github.io/R-matlab-julia-HPC/)

!!! abstract "Summary"

    - Many Python and R packages come in bundle modules.
        - Python has >10 of them
        - R has basically 2: CRAN and Bioconductor.
        - Load a bundle and the correct version of Python or R is loaded on the fly.
    - All clusters have RStudio and Jupyter installed in some way. 
        - Some clusters have Spyder and VS Code
    - Some tools are licensed.
        

    
