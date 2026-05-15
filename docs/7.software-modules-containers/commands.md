# Module system commands 

!!! note "Objectives"

    - Find software module versions
    - Load a module (with potential prerequisites):
         - default (often not recommended!)
         - a specific version of software
    - Unload software modules, including specific versions 
    - Unload all software modules with ``module purge``
    - List the loaded modules 
    - Get some information about a module (``module show`` and ``module help``)  
    - Learn about module collections to load/unload a bunch of modules (``module save <collection>`` and ``module restore <collection>``)

In the previous section we saw how to find out which modules are available, including looking for a specific software module.    

Now it is time to learn more useful module commands! 

## Finding software versions 

If you just load a module without specifying the version, you will get the default version or an error. 

There are good reasons not to just load the default version, even when it is possible: 

- The default version is often the newest one installed, which means the default changes the next time an even newer version is installed. This could break your code or at least give a different result, which is bad for resproducibility. 
- Sometimes you actually need a specific version, which could differ from the one the centre has decided on as default. 

!!! note

    However, when you have loaded the prerequisites, usually GCC/intel/foss you can generally safely load the rest of the modules without giving the version as it is now locked in by your choice of prerequisite. This also means it is easier to find compatible modules. 

So how do you find out which versions are available for a specific software? 

### Reminder ``module spider`` 

!!! note

    The command to find the available versions for a software module named MODULE is: 

    ```bash
    module spider MODULE
    ```

    or, in short form 

    ```bash
    ml spider MODULE
    ``` 

### List toolchains With ``module avail`` 

!!! note

    The command to find the available version for a toolchain or software module without prerequisites, named MODULE is: 

    ```bash 
    module avail MODULE
    ```

    or, in short form 

    ```bash 
    ml av MODULE
    ``` 

### Example 

Finding available versions of Python. 

!!! tip 

    Type along!

**module spider**

```bash
module spider Python
```

??? note "Click to show" 

    ```bash
    b-an01 [~]$ module spider Python

    --------------------------------------------------------------------------------------------------------------------
      Python:
    --------------------------------------------------------------------------------------------------------------------
        Description:
          Python is a programming language that lets you work more quickly and integrate your systems more effectively.

         Versions:
            Python/2.7.18-bare
            Python/2.7.18
            Python/3.8.6
            Python/3.9.6-bare
            Python/3.9.6
            Python/3.10.4-bare
            Python/3.10.4
            Python/3.10.8-bare
            Python/3.10.8
            Python/3.11.3
            Python/3.11.5
            Python/3.12.3
            Python/3.13.1
            Python/3.13.5
         Other possible modules matches:
            Biopython  Boost.Python  Brotli-python  CUDA-Python  GitPython  ...

    ----------------------------------------------------------------------------
      To find other possible module matches execute:

          $ module -r spider '.*Python.*'

    ----------------------------------------------------------------------------
      For detailed information about a specific "Python" package (including how to load the modules) use the module's full name.
      Note that names that have a trailing (E) are extensions provided by other modu
les.
      For example:

         $ module spider Python/3.13.5
    ----------------------------------------------------------------------------
    ```

!!! note "<img src="../../images/shell-logo_small.png"> Exercise" 

    1. At your chosen centre, check the different output for ``module avail Python`` and ``module spider Python``
    2. Do you get the same output for "Python" and "python"? 

## List loaded modules 

There is a very useful command to list which modules you have loaded. 

It is 

``module list``

or, in short form 

``ml``

!!! tip 

    Try it now! 

With nothing loaded, only the "sticky" modules are listed. They are modules that are needed for the environment to function correctly, so do not remove them! 

## Load software module 

In order to load modules, we need to know *how*. This differs by center only inasmuch as some centers have prerequisites (usually **compiler toolchains**) for most of the software modules. 

The centers that recommend ``module spider`` for finding the software modules generally have prerequisites (HPC2N, LUNARC, PDC - and sometimes C3SE), while those who recommend ``module avail`` generally do not (UPPMAX, NSC). 

Thus; if the centers suggests you do ``module spider`` you will need to check the required prerequisites to load. 

### Prerequisites 

- This is done with ``module spider <module>/<version>`` 
- You can also do this at the centers recommending ``module avail``, but that will generally just tell you the module can be loaded directly. 

!!! note "Prerequisites"

    At some centres it is common that modules have prerequisites (usually GCC, various libraries or something similar) while at other centres most modules can be loaded directly.

    - **HPC2N**: most software modules have prerequisites (GCC/Intel, OpenMPI, ...), a few do not (MATLAB, ...)
    - **LUNARC**: most software modules have prerequisites (GCC/Intel, OpenMPI, ...), a few do not (MATLAB, ...)
    - **UPPMAX**: software modules can generally be loaded directly unless its is related to bioinformatics (then load ``bioinfo-tools`` first). New cluster Pelle does not require you to load ``bioinfo-tools``
    
        !!! note 
        
            - **On Pelle things are more like NSC, you may follow the examples for that cluster instead of Bianca**
            - Though, note that output details will most probably be different on Pelle!

    - **NSC**: software modules can generally be loaded directly
    - **PDC**: most software modules have prerequisites (PDC which is a collection of compilers and libraries), a few do not (MATLAB, cray-modules, ...)
    - **C3SE**: software modules can generally be loaded directly

=== "HPC2N" 

    !!! note "Example, finding out how to load Python, version 3.12.3"
 
        ```bash 
        b-an01 [~]$ module spider Python/3.12.3

        --------------------------------------------------------------------------------------------------------------------
          Python: Python/3.12.3
        --------------------------------------------------------------------------------------------------------------------
            Description:
              Python is a programming language that lets you work more quickly and integrate your systems more effectively.


            You will need to load all module(s) on any one of the lines below before the "Python/3.12.3" module is available to load.

              GCCcore/13.3.0
 
            This module provides the following extensions:

               flit_core/3.9.0 (E), packaging/24.0 (E), pip/24.0 (E), setuptools/70.0.0 (E), setuptools_scm/8.1.0 (E), tomli/2.0.1 (E), typing_extensions/4.11.0 (E), wheel/0.43.0 (E)

            Help:
              Description
              ===========
              Python is a programming language that lets you work more quickly and integrate your systems more effectively.
      
      
              More information
              ================
               - Homepage: https://python.org/
      
      
              Included extensions
              ===================
              flit_core-3.9.0, packaging-24.0, pip-24.0, setuptools-70.0.0, setuptools_scm-8.1.0, tomli-2.0.1, typing_extensions-4.11.0, wheel-0.43.0
        ```
   
        There are some things to pay attention to here: 

        - You are told the prerequisites are "GCCcore/13.3.0" (if you need OpenMPI or modules requiring it, it is better to load "GCC/13.3.0" as GCCcore is part of it) 
        - After loading that, you can load the module itself, "Python/3.12.3" 
        - You are told about the extensions that are included. Here, this would be the Python packages that are included, which is not very many. HPC2N and some of the other centres use separate modules or *module bundles* (SciPy-bundle for instance) for any extensions/packages that you might need. 

=== "UPPMAX" 

    !!! note "Example, Finding out how to load Python, version 3.12.3 (Pelle)" 
        
        ```bash 
        [bbrydsoe@pelle2 ~]$ ml spider Python/3.12.3-GCCcore-13.3.0 

        ------------------------------------------------------------------------------------------------------
          Python: Python/3.12.3-GCCcore-13.3.0
        ------------------------------------------------------------------------------------------------------
            Description:
              Python is a programming language that lets you work more quickly and integrate your systems more effectively.

            This module can be loaded directly: module load Python/3.12.3-GCCcore-13.3.0

            This module provides the following extensions:

               flit_core/3.9.0 (E), packaging/24.0 (E), pip/24.0 (E), setuptools/70.0.0 (E), setuptools_scm/8.1.0 (E), tomli/2.0.1 (E), typing_extensions/4.11.0 (E), wheel/0.43.0 (E)

          Help:
            Description
            ===========
            Python is a programming language that lets you work more quickly and integrate your systems more effectively.
      
      
            More information
            ================
            - Homepage: https://python.org/
      
      
            Included extensions
            ===================
            flit_core-3.9.0, packaging-24.0, pip-24.0, setuptools-70.0.0,
            setuptools_scm-8.1.0, tomli-2.0.1, typing_extensions-4.11.0, wheel-0.43.0
        ```

        Here we learn: 

        - You can load "Python/3.12.3" directly
        - It was built with "gcc/13.3.0" (might be useful for compatibility with other things). 
        - It lists all the extensions (here Python packages) loaded with it - not very many, as most are loaded as part of various Python bundles.  

=== "NSC" 

    !!! note "Example, finding out how to load Python, version 3.11.5" 

        ```bash 
        [x_birbr@tetralith3 ~]$ module avail Python/3.11.5

        ------------------------------------------ /software/sse2/tetralith_el9/modules -------------------------------------------
           Python/3.11.5-bare-hpc1-gcc-2023b-eb    Python/3.11.5-env-hpc1-gcc-2023b-eb
        ```

        This was not so helpful. Let us try with "module spider": 

        ```bash
        [x_birbr@tetralith3 ~]$ module spider Python/3.11.5
        ####################################################################################################################################
        # NOTE: At NSC the output of 'module spider' is generally not helpful as all relevant software modules are shown by 'module avail' #
        # Some HPC centers hide software until the necessary dependencies have been loaded. NSC does not do that.                          #
        ####################################################################################################################################

        -----------------------------------------------------------------------------------------------------------------------          
          Python: Python/3.11.5
        -----------------------------------------------------------------------------------------------------------------------
        Description:
          Python is a programming language that lets you work more quickly and integrate your systems more effectively.


        You will need to load all module(s) on any one of the lines below before the "Python/3.11.5" module is available to load.

              buildtool-easybuild/.5.1.1-hpce5ba34320  GCCcore/13.2.0
              buildtool-easybuild/4.8.0-hpce082752a2  GCCcore/13.2.0
              buildtool-easybuild/4.9.4-hpc71cbb0050  GCCcore/13.2.0
 
        Help:
      
              Description
              ===========
              Python is a programming language that lets you work more quickly and integrate your systems more effectively.
      
      
              More information
              ================
               - Homepage: https://python.org/
      
      
              Included extensions
              ===================
              flit_core-3.9.0, packaging-23.2, pip-23.2.1, setuptools-68.2.2, setuptools-scm-8.0.4, tomli-2.0.1, typing_extensions-4.8.0, wheel-0.41.2
        ```
    
        - Here we learn that there is a "bare" Python (like "Python/3.11.5-bare-hpc1-gcc-2023b-eb") that you can load directly
        - Otherwise, you need to load the prerequisites of a buildtool and a GCCcore first, before loading Python. That is knowledge that can be useful for finding compatibility with other software modules  
        - You also learn that there is a (small) number of extensions/packages with this Python  

=== "PDC" 

    !!! note "Example, finding out how to load Python, version 3.12.3"

        ```bash 
        bbrydsoe@login1:~> ml spider python/3.12.3

        ------------------------------------------------------------------------------------------------------
            python: python/3.12.3
        ------------------------------------------------------------------------------------------------------
            Description:
              Python is a programming language that lets you work more quickly and integrate your systems more effectively.


            This module can be loaded directly: module load python/3.12.3

            Help:
              Description
              ===========
              Python is a programming language that lets you work more quickly and integrate your systems more effectively.
      
      
              More information
              ================
              - Homepage: https://python.org/
        ```

        However, checking their website, this is generally not the Python you should load, but rather this one (now checking on version 3.11.7): 

        ```bash
        bbrydsoe@login1:~> ml spider cray-python/3.11.7

        ------------------------------------------------------------------------------------------------------
          cray-python: cray-python/3.11.7
        ------------------------------------------------------------------------------------------------------

            This module can be loaded directly: module load cray-python/3.11.7

            Help:
              This modulefile defines the system paths and environment
              variables needed to use cray-python.
      
              cray-python 3.11.7
              ====================
      
              Release Date
              ------------
              July 2024
      
              Purpose
              -------
              Cray Python is an implementation of the Python programming language for the Cray Programming Environment. The numpy and scipy modules are configured to call Cray Libsci routines. The mpi4py module is configured to call Cray MPICH routines.
              Cray Python is designed to run Python codes on the compute nodes of an HPE supercomputer. HPE does not make changes to the Python source or any of its libraries nor does it plan to make changes in future releases.
      
              The cray-python 3.11.7 release contains
      
              - python-3.11.7
              - numpy-1.24.4
              - scipy-1.10.1
              - mpi4py-3.1.4
              - dask-2023.6.1
      
              Product and OS Dependencies
              ---------------------------
              The cray-python 3.11.7 release is supported on
              - Cray EX systems running SLES 15 or RHEL 8
      
              Documentation
              -------------
              https://www.python.org/doc
      
              Changelog
              ---------
              https://docs.python.org/release/3.11.7/whatsnew/changelog.html
      
              Modulefile
              ----------
                  module load cray-python/3.11.7
      
              Installation
              ------------
                  rpm -ihv cray-python-3.11.7-20240617153007.0687944-1.sles15sp4.x86_64.rpm
      
              To make this the default version, execute
      
                  /opt/cray/pe/admin-pe/set_default_files/set_default_python_3.11.7
      
              Certain components, files, or programs contained within this package are
              © Copyright 2021-2024 Hewlett Packard Enterprise Development LP
      
      
              ===================================================================
              To re-display python/3.11.7 release information,
              type:    less /opt/cray/pe/python/3.11.7/release_info
              ===================================================================
        ```  

        We learn: 
 
        - Generally use cray-python instead of python 
        - You can load it with no prerequisites (there are normally prerequisites on Dardel (PDC)) 


### Loading 

To load a software module, do: 

- (if needed) ``module load <prerequisite>/<suitable version>``
- ``module load <module>/<compatible version>``

and the versions you got from ``module spider``. 

Again, ``ml load <module>/<version>`` can be used as a short form. 

When you have loaded the module, you can see that your list of loaded modules has changed. This is done with ``module list`` or ``ml``. 

!!! hint 

    Type along! Below is seen an example for HPC2N where almost everything has prerequisites. 

!!! note "Example, HPC2N"

    Loading Python 3.12.3 and prerequisites, and checking before and after which modules are loaded.

    ```bash
    module list
    ```

    ??? note "Click to show output!" 

        ```bash
        b-an01 [~]$ module list

        Currently Loaded Modules:
          1) snicenvironment (S)   2) systemdefault (S)

          Where:
           S:  Module is Sticky, requires --force to unload or purge
        ```
  
    ```bash
    module load GCCcore/13.3.0 Python/3.12.3
    ```

    or load them on separate lines 

    ```bash
    module load GCCcore/13.3.0
    module load Python/3.12.3
    ```

    What is the advantage to loading them one at a time? You can then easier find compatible modules that depend on that version, using ``module avail``. 

    ??? note "Click to show output!" 

        ```bash
        b-an01 [~]$ module load GCCcore/13.3.0 Python/3.12.3
        b-an01 [~]$
        ```

    And now do ``module list`` again! 

    ??? note "Click to show output!" 

        ```bash 
        b-an01 [~]$ module list

        Currently Loaded Modules:
          1) snicenvironment (S)   4) zlib/1.3.1      7) ncurses/6.5      10) SQLite/3.45.3  13) OpenSSL/3
          2) systemdefault   (S)   5) binutils/2.42   8) libreadline/8.2  11) XZ/5.4.5       14) Python/3.12.3
          3) GCCcore/13.3.0        6) bzip2/1.0.8     9) Tcl/8.6.14       12) libffi/3.4.5

          Where:
           S:  Module is Sticky, requires --force to unload or purge
        ```
    
!!! note "Example, NSC" 

    Loading Python version 3.11.5 (the module is called Python/3.11.5-env-hpc1-gcc-2023b-eb and can be loaded directly). Also do ``module list`` before and after! 

    ```bash
    module list
    ```

    ??? note "Click to show output!" 

        ```bash
        [x_birbr@tetralith3 ~]$ module list

        Currently Loaded Modules:
          1) hpc/.1.10.1 (H,S)

          Where:
           S:  Module is Sticky, requires --force to unload or purge
           H:             Hidden Module
        ```
        
    ```bash
    module load Python/3.11.5-env-hpc1-gcc-2023b-eb
    ```

    ??? note "Click to show output!" 

        ```bash
        [x_birbr@tetralith3 ~]$ module load Python/3.11.5-env-hpc1-gcc-2023b-eb
        [x_birbr@tetralith3 ~]$ 
        ```

    ```bash
    ml
    ```

    ??? note "Click to show output!" 

        ```bash
        [x_birbr@tetralith3 ~]$ ml

        Currently Loaded Modules:
          1) hpc/.1.10.1 (H,S)   2) Python/3.11.5-env-hpc1-gcc-2023b-eb

          Where:
           S:  Module is Sticky, requires --force to unload or purge
           H:             Hidden Module
        ```
 
    **Or** load one of the Python modules with prerequisites: 

    ??? note "Click to show output!" 

        ```bash 
        [x_birbr@tetralith3 ~]$ ml buildtool-easybuild/4.8.0-hpce082752a2 GCCcore/13.2.0 Python/3.11.5 
        [x_birbr@tetralith3 ~]$
        ``` 

        Let us see the output of "module list" now: 

        ```bash 
        [x_birbr@tetralith3 ~]$ module list

        Currently Loaded Modules:
          1) hpc/.1.10.1                            (H,S)   5) binutils/.2.40  (H)   9) Tcl/8.6.13     13) OpenSSL/1.1
          2) buildtool-easybuild/4.8.0-hpce082752a2         6) bzip2/1.0.8          10) SQLite/3.43.1  14) Python/3.11.5
          3) GCCcore/13.2.0                                 7) ncurses/6.4          11) XZ/5.4.4
          4) zlib/.1.2.13                           (H)     8) libreadline/8.2      12) libffi/3.4.4

          Where:
           S:  Module is Sticky, requires --force to unload or purge
           H:             Hidden Module
        ``` 

!!! warning "Important"

    - You can do several ``module load`` on the same line. Or you can do them one at a time, as you want.
        - The modules have to be loaded in order! You cannot list the prerequisite after the module that needs it!
    - One advantage to loading modules one at a time is that you can then find compatible modules that depend on that version easily.
        - Example: you have loaded GCC/13.2.0 and Python/3.11.5 at HPC2N or LUNARC. You can now do ``ml av`` or ``module avail`` to see which versions of other modules you want to load, say ``SciPy-bundle``, are compatible. 
        - If you know the name of the module you want, you can even start writing ``module load SciPy-bundle/`` (for instance) and press TAB - the system will then autocomplete to the compatible one(s). 

### Loading several modules

There are situations where you need to load several modules, even at centres where there are no prerequisites. 

!!! note "Example" 

    You need some Python packages not included in the base Python you loaded, for instance PyTorch, or TensorFlow, or maybe AlphaFold. 

    You now need to load a version of that module which is compatible with the Python you want. 
   
    === "HPC2N"

        Tensorflow needs Python and SciPy-bundle. SciPy-bundle also needs OpenMPI. TensorFlow *loads* Python and SciPy-bundle itself, but you need their prerequisites: 

        ```bash 
        b-an01 [~]$ module spider TensorFlow/2.15.1-CUDA-12.1.1

        --------------------------------------------------------------------------------------------------------------------
          TensorFlow: TensorFlow/2.15.1-CUDA-12.1.1
        --------------------------------------------------------------------------------------------------------------------
            Description:
              An open-source software library for Machine Intelligence


            You will need to load all module(s) on any one of the lines below before the "TensorFlow/2.15.1-CUDA-12.1.1" module is available to load.

              GCC/12.3.0  OpenMPI/4.1.5
 
            This module provides the following extensions:

               absl-py/2.1.0 (E), astor/0.8.1 (E), astunparse/1.6.3 (E), cachetools/5.3.3 (E), google-auth-oauthlib/1.2.0 (E), google-auth/2.29.0 (E), google-pasta/0.2.0 (E), gviz-api/1.10.0 (E), keras/2.15.0 (E), Markdown/3.6 (E), oauthlib/3.2.2 (E), pyasn1-modules/0.4.0 (E), requests-oauthlib/2.0.0 (E), rsa/4.9 (E), tblib/3.0.0 (E), tensorboard-data-server/0.7.2 (E), tensorboard-plugin-profile/2.15.1 (E), tensorboard/2.15.2 (E), tensorflow-estimator/2.15.0 (E), TensorFlow/2.15.1 (E), termcolor/2.3.0 (E), Werkzeug/3.0.2 (E), wrapt/1.14.1 (E)
        ```

        ```bash 
        b-an01 [~]$ module load GCC/12.3.0 OpenMPI/4.1.5
        b-an01 [~]$ module load TensorFlow/2.15.1-CUDA-12.1.1
        ```

    === "UPPMAX" 

        TensorFlow is not installed, so let us look at an example with PyTorch instead. 

        ```bash
        [bbrydsoe@pelle2 ~]$ ml spider PyTorch

        --------------------------------------------------------------------------------------------
          PyTorch: PyTorch/2.6.0-foss-2024a
        --------------------------------------------------------------------------------------------

            Description:
              Tensors and Dynamic neural networks in Python with strong GPU acceleration. PyTorch is a deep learning framework that puts Python first.

            This module can be loaded directly: module load PyTorch/2.6.0-foss-2024a

            Help:
              Description
              ===========
              Tensors and Dynamic neural networks in Python with strong GPU acceleration.
              PyTorch is a deep learning framework that puts Python first.
      
      
              More information
              ================
              - Homepage: https://pytorch.org/
        ```    
        
        ```bash 
        [bbrydsoe@pelle2 ~]$ ml PyTorch/2.6.0-foss-2024a
        [bbrydsoe@pelle2 ~]$
        ``` 

        However, if you for instance need Matlab together with Gurobi, then you need to load both modules: 

        ```bash 
        [bbrydsoe@pelle2 ~]$ ml MATLAB/2024a
        [bbrydsoe@pelle2 ~]$ ml Gurobi/12.0.1-GCCcore-13.3.0
        ``` 

    === "NSC" 

        TensorFlow is not installed, so if you need that you would have to install it yourself in a Virtual environment. Let us assume we need "pandas" which is installed. It is included in SciPy-bundle, which pulls in Python and OpenMPI, but does have other prerequisites 

        ```bash
        [x_birbr@tetralith3 ~]$ ml spider SciPy-bundle/2023.11
        ####################################################################################################################################
        # NOTE: At NSC the output of 'module spider' is generally not helpful as all relevant software modules are shown by 'module avail' #
        # Some HPC centers hide software until the necessary dependencies have been loaded. NSC does not do that.                          #
        ####################################################################################################################################

        -----------------------------------------------------------------------------------------------------------------------
          SciPy-bundle: SciPy-bundle/2023.11
        -----------------------------------------------------------------------------------------------------------------------
            Description:
              Bundle of Python packages for scientific software


            You will need to load all module(s) on any one of the lines below before the "SciPy-bundle/2023.11" module is available to load.

              buildtool-easybuild/.5.1.1-hpce5ba34320  GCC/13.2.0
              buildtool-easybuild/4.8.0-hpce082752a2  GCC/13.2.0
              buildtool-easybuild/4.9.4-hpc71cbb0050  GCC/13.2.0
 
            Help:
      
              Description
              ===========
              Bundle of Python packages for scientific software
      
      
              More information
              ================
              - Homepage: https://python.org/
      
      
              Included extensions
              ===================
              beniget-0.4.1, Bottleneck-1.3.7, deap-1.4.1, gast-0.5.4, mpmath-1.3.0,
              numexpr-2.8.7, numpy-1.26.2, pandas-2.1.3, ply-3.11, pythran-0.14.0,
              scipy-1.11.4, tzdata-2023.3, versioneer-0.29
        ``` 

        ```bash 
        [x_birbr@tetralith3 ~]$ ml buildtool-easybuild/4.8.0-hpce082752a2  GCC/13.2.0 SciPy-bundle/2023.11
        ```

        Another useful "super" package at NSC is "Python-bundle-PyPI/2023.10". 

    === "PDC" 

        To access TensorFlow and/or PyTorch, you need to use Singularity. First load these modules: 

        ```bash
        bbrydsoe@login1:~> ml PDC/24.11 singularity/4.2.0-cpeGNU-24.11
        bbrydsoe@login1:~>
        ```
        
        Then you can open a shell session within the container with: 

        ```bash
        bbrydsoe@login1:~> singularity shell --rocm -B /cfs/klemming /pdc/software/resources/sing_hub/rocm5.7-tf2.13-dev
        Singularity> 
        ```

        For more information, look on this documentation page: https://support.pdc.kth.se/doc/applications/tensorflow/ 
     
## Unload software modules

Aside from ``module unload`` this section will also cover ``module purge``! 

!!! note 

    Why would you want to unload a module?

    - If you want to use a different version of a module, you need to unload the current one first 
    - If you need a different version of a dependent module, but it is not compatible with the current prerequisite you have loaded 
  
Modules can be unloaded with: 

- ``module unload <MODULE>`` **may or may not work**
- ``module unload <MODULE>/<version>``
- ``ml unload <MODULE>/<version>`` **short form of the above**
- ``module -<MODULE>/<version>`` 
- ``ml -<MODULE>/<version>`` **short form of the above** 
- ``ml -<MODULE>/<version>`` **short form of the above**

Unloading a module **will not unload the prerequisites**. 

This is not usually a problem at the centres where there rarely are prerequisites (UPPMAX, NSC), but can be annoying at centres who usually have prerequisites for the modules (HPC2N, LUNARC, C3SE, PDC). However, there the easy solution is ``module purge`` (HPC2N, LUNARC, C3SE). 

The command ``module purge`` removes all the loaded modules, except the "sticky" modules. It is recommended at HPC2N, LUNARC, and C3SE. 

!!! warning 

    Do not use ``module purge`` at PDC! 

    At PDC, there are a lot of necessary, "system-modules" that are preloaded. When you do ``module purge`` they will also be unloaded and things may not work as it should! 

    At UPPMAX (Bianca, not Pelle), the system-module "uppmax" will get unloaded with ``module purge``, but can easily be reloaded with ``module load uppmax``. 

    - To see what the ``uppmax`` module does, do: ``ml show uppmax``. It sets some environment variables and aliases.

### Unloading examples 

#### No prerequisites 

Unloading one module, with no prerequisites (for clarity, we also do ``module list`` before and after to show what is happening. 

!!! tip

    Type along!

    First load a suitable module for your center (with no prerequisites). Suggestions: 

    - HPC2N, LUNARC: GCC/12.3.0
    - UPPMAX (Pelle): Python/3.12.3-GCCcore-13.3.0
    - UPPMAX (Bianca): python/3.12.3-GCCcore-13.3.0    
    - C3SE: Python/3.12.7
    - NSC: Python/3.11.5-env-hpc1-gcc-2023b-eb
    - PDC: cray-python/3.11.5

!!! note "HPC2N"

    Check which modules are loaded (after loading GCC/12.3.0 earlier)

    ```bash
    b-an01 [~]$ module list

    Currently Loaded Modules:
      1) snicenvironment (S)   3) GCCcore/12.3.0   5) binutils/2.40
      2) systemdefault   (S)   4) zlib/1.2.13      6) GCC/12.3.0

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    b-an01 [~]$ 
    ```

    Unload GCC/12.3.0 

    ```bash
    b-an01 [~]$ module unload GCC/12.3.0
    b-an01 [~]$ 
    ```

    Check which modules are loaded 

    ```bash
    b-an01 [~]$ module list

    Currently Loaded Modules:
      1) snicenvironment (S)   2) systemdefault (S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

!!! note "NSC"

    Check which modules are loaded (after loading Python/3.11.5-env-hpc1-gcc-2023b-eb earlier) 

    ```bash 
    [x_birbr@tetralith3 ~]$ module list    
    Currently Loaded Modules:
      1) hpc/.1.10.1 (H,S)   2) Python/3.11.5-env-hpc1-gcc-2023b-eb

      Where:
       S:  Module is Sticky, requires --force to unload or purge
       H:             Hidden Module
    ```

    Unload Python/3.11.5-env-hpc1-gcc-2023b-eb 

    ```bash
    [x_birbr@tetralith3 ~]$ ml -Python/3.11.5-env-hpc1-gcc-2023b-eb
    [x_birbr@tetralith3 ~]$ 
    ``` 

    Check which modules are loaded 

    ```bash  
    [x_birbr@tetralith3 ~]$ ml

    Currently Loaded Modules:
      1) hpc/.1.10.1 (H,S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
       H:             Hidden Module
    ```

#### Prerequisites

Here we look at what happens when you unload something that has a prerequisite. 

!!! note "Example, HPC2N"

    LUNARC would be the same. 

    Loading Python and prerequisites

    ```bash
    b-an01 [~]$ module load GCC/12.3.0
    b-an01 [~]$ module load Python/3.11.3 
    ```

    Check loaded modules

    ```bash
    b-an01 [~]$ ml
    
    Currently Loaded Modules:
      1) snicenvironment (S)   4) zlib/1.2.13     7) bzip2/1.0.8      10) Tcl/8.6.13     13) libffi/3.4.4
      2) systemdefault   (S)   5) binutils/2.40   8) ncurses/6.4      11) SQLite/3.42.0  14) OpenSSL/1.1
      3) GCCcore/12.3.0        6) GCC/12.3.0      9) libreadline/8.2  12) XZ/5.4.2       15) Python/3.11.3

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

    Unload Python/3.11.3

    ```bash
    b-an01 [~]$ ml unload Python/3.11.3
    ```

    Check loaded modules 

    ```bash 
    b-an01 [~]$ ml

    Currently Loaded Modules:
      1) snicenvironment (S)   3) GCCcore/12.3.0   5) binutils/2.40
      2) systemdefault   (S)   4) zlib/1.2.13      6) GCC/12.3.0

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

    Unload GCC/12.3.0

    ```bash
    b-an01 [~]$ ml -GCC/12.3.0
    ```

    Check loaded modules

    ```bash 
    b-an01 [~]$ ml

    Currently Loaded Modules:
      1) snicenvironment (S)   2) systemdefault (S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

What happens if you try and unload the prerequisite?

!!! note "Example, HPC2N"

    ```bash
    b-an01 [~]$ ml GCC/12.3.0 Python/3.11.3
    b-an01 [~]$ ml

    Currently Loaded Modules:
      1) snicenvironment (S)   4) zlib/1.2.13     7) bzip2/1.0.8      10) Tcl/8.6.13     13) libffi/3.4.4
      2) systemdefault   (S)   5) binutils/2.40   8) ncurses/6.4      11) SQLite/3.42.0  14) OpenSSL/1.1
      3) GCCcore/12.3.0        6) GCC/12.3.0      9) libreadline/8.2  12) XZ/5.4.2       15) Python/3.11.3

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    b-an01 [~]$ ml -GCC/12.3.0

    Inactive Modules:
      1) OpenSSL/1.1       3) SQLite/3.42.0     5) XZ/5.4.2        7) libffi/3.4.4
      2) Python/3.11.3     4) Tcl/8.6.13        6) bzip2/1.0.8     8) libreadline/8.2

    Due to MODULEPATH changes, the following have been reloaded:
      1) binutils/2.40     2) ncurses/6.4     3) zlib/1.2.13
    ```

### ``module purge``

What about ``module purge``? 

!!! warning "Important"

    At some centres, ``module purge`` is recommended and at some it is at least safe: HPC2N, LUNARC, NSC, C3SE 

=== "HPC2N" 

    ```bash
    b-an01 [~]$ ml GCC/12.3.0 Python/3.11.3
    b-an01 [~]$ ml

    Currently Loaded Modules:
      1) snicenvironment (S)   4) zlib/1.2.13     7) bzip2/1.0.8      10) Tcl/8.6.13     13) libffi/3.4.4
      2) systemdefault   (S)   5) binutils/2.40   8) ncurses/6.4      11) SQLite/3.42.0  14) OpenSSL/1.1
      3) GCCcore/12.3.0        6) GCC/12.3.0      9) libreadline/8.2  12) XZ/5.4.2       15) Python/3.11.3

      Where:
       S:  Module is Sticky, requires --force to unload or purge

 

    b-an01 [~]$ ml purge
    The following modules were not unloaded:
      (Use "module --force purge" to unload all):

      1) snicenvironment   2) systemdefault
    b-an01 [~]$ ml

    Currently Loaded Modules:
      1) snicenvironment (S)   2) systemdefault (S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

    All good! 

=== "LUNARC"

    ```bash
    [bbrydsoe@cosmos3 ~]$ ml GCC/12.3.0 Python/3.11.3
    [bbrydsoe@cosmos3 ~]$ ml

    Currently Loaded Modules:
      1) SoftwareTree/Milan (S)   4) binutils/2.40   7) ncurses/6.4      10) SQLite/3.42.0  13) OpenSSL/1.1
      2) GCCcore/12.3.0           5) GCC/12.3.0      8) libreadline/8.2  11) XZ/5.4.2       14) Python/3.11.3
      3) zlib/1.2.13              6) bzip2/1.0.8     9) Tcl/8.6.13       12) libffi/3.4.4

      Where:
       S:  Module is Sticky, requires --force to unload or purge

 

    [bbrydsoe@cosmos3 ~]$ ml purge
    The following modules were not unloaded:
      (Use "module --force purge" to unload all):

      1) SoftwareTree/Milan
    [bbrydsoe@cosmos3 ~]$ ml

    Currently Loaded Modules:
      1) SoftwareTree/Milan (S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

    All good!

=== "C3SE"

    ```bash 
    [brydso@alvis1 ~]$ ml
    No modules loaded
    [brydso@alvis1 ~]$ ml Python/3.12.3-GCCcore-13.3.0
    [brydso@alvis1 ~]$ ml

    Currently Loaded Modules:
      1) GCCcore/13.3.0                 5) ncurses/6.5-GCCcore-13.3.0       9) XZ/5.4.5-GCCcore-13.3.0
      2) zlib/1.3.1-GCCcore-13.3.0      6) libreadline/8.2-GCCcore-13.3.0  10) libffi/3.4.5-GCCcore-13.3.0
      3) binutils/2.42-GCCcore-13.3.0   7) Tcl/8.6.14-GCCcore-13.3.0       11) OpenSSL/3
      4) bzip2/1.0.8-GCCcore-13.3.0     8) SQLite/3.45.3-GCCcore-13.3.0    12) Python/3.12.3-GCCcore-13.3.0

 

    [brydso@alvis1 ~]$ ml purge
    [brydso@alvis1 ~]$ ml
    No modules loaded
    ``` 

    All good! No modules before that got lost! 

=== "NSC"

    ```bash 
    [x_birbr@tetralith3 ~]$ ml Python/3.11.5-env-hpc1-gcc-2023b-eb
    [x_birbr@tetralith3 ~]$ ml 

    Currently Loaded Modules:
      1) hpc/.1.10.1 (H,S)   2) Python/3.11.5-env-hpc1-gcc-2023b-eb

      Where:
       S:  Module is Sticky, requires --force to unload or purge
       H:             Hidden Module
    [x_birbr@tetralith3 ~]$ ml purge
    The following modules were not unloaded:
      (Use "module --force purge" to unload all):

      1) hpc/.1.10.1
    [x_birbr@tetralith3 ~]$ ml

    Currently Loaded Modules:
      1) hpc/.1.10.1 (H,S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
       H:             Hidden Module
    ```

    All good! 

!!! warning "Important"

    While at other centres, it is more or less problematic to use ``module purge``: UPPMAX, PDC 


=== "UPPMAX"

    ```bash
    [bbrydsoe@pelle2 ~]$ ml Python/3.12.3-GCCcore-13.3.0
    [bbrydsoe@pelle2 ~]$ ml

    Currently Loaded Modules:
      1) GCCcore/13.3.0                   7) Tcl/8.6.14-GCCcore-13.3.0
      2) zlib/1.3.1-GCCcore-13.3.0        8) SQLite/3.45.3-GCCcore-13.3.0
      3) binutils/2.42-GCCcore-13.3.0     9) XZ/5.4.5-GCCcore-13.3.0
      4) bzip2/1.0.8-GCCcore-13.3.0      10) libffi/3.4.5-GCCcore-13.3.0
      5) ncurses/6.5-GCCcore-13.3.0      11) OpenSSL/3
      6) libreadline/8.2-GCCcore-13.3.0  12) Python/3.12.3-GCCcore-13.3.0

    ```
       
    ```bash 
    [bbrydsoe@pelle2 ~]$ ml purge
    [bbrydsoe@pelle2 ~]$ ml
    No modules loaded
    ```

    Warning! You need to reload "uppmax" module! ``module load uppmax`` if you are on Bianca. New cluster Pelle has (as of today) no ``uppmax`` module

=== "PDC"         

    ```bash 
    bbrydsoe@login1:~> ml

    Currently Loaded Modules:
      1) craype-x86-rome                        6) cce/17.0.0           11) PrgEnv-cray/8.5.0
      2) libfabric/1.20.1                       7) craype/2.7.30        12) snic-env/1.0.0
      3) craype-network-ofi                     8) cray-dsmml/0.2.2     13) systemdefault/1.0.0 (S)
      4) perftools-base/23.12.0                 9) cray-mpich/8.1.28
      5) xpmem/2.8.2-1.0_3.9__g84a27a5.shasta  10) cray-libsci/23.12.5

      Where:
       S:  Module is Sticky, requires --force to unload or purge

 

    bbrydsoe@login1:~> ml cray-python/3.11.5
    bbrydsoe@login1:~> ml

    Currently Loaded Modules:
      1) craype-x86-rome                        6) cce/17.0.0           11) PrgEnv-cray/8.5.0
      2) libfabric/1.20.1                       7) craype/2.7.30        12) snic-env/1.0.0
      3) craype-network-ofi                     8) cray-dsmml/0.2.2     13) systemdefault/1.0.0 (S)
      4) perftools-base/23.12.0                 9) cray-mpich/8.1.28    14) cray-python/3.11.5
      5) xpmem/2.8.2-1.0_3.9__g84a27a5.shasta  10) cray-libsci/23.12.5

      Where:
       S:  Module is Sticky, requires --force to unload or purge

 

    bbrydsoe@login1:~> ml purge
    The following modules were not unloaded:
      (Use "module --force purge" to unload all):

      1) systemdefault/1.0.0
    bbrydsoe@login1:~> ml

    Currently Loaded Modules:
      1) systemdefault/1.0.0 (S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ``` 

    WARNING WARNING WARNING !!! Lots of modules got unloaded! Either logout and login again, or make sure you have saved a list of the system-modules so you can reload all of them (or use [module collections](#module__saverestore) - which we get to soon.  

!!! note "<img src="../images/shell-logo_small.png"> Exercise"

    1. Check how to load R at your centre. Pick a version. 
    2. Does it have prerequisites at your centre?
    3. Load R for a specific version (but first load prerequisites if there are any). 
    4. Run ``module list`` to see what modules got loaded. Was it more than you expected? 
    5. Unload R (and prerequisites if there are any). See what happens. 
    6. Do ``module list`` again. 

## module show 

This command shows commands in the module file (MODULE) and can be used to list information about modules. 

- at centres with a "flat" structure this can be used on all modules since there are no prerequisites: UPPMAX, NSC
- at centres with a "hierarchial" structure this can only be used on the modules that are currently available to load (and can be seen with ``module avail``): HPC2N, LUNARC, C3SE, PDC 

**Example, HPC2N** 

Let us look at CUDA: 

```bash 
b-an01 [~]$ ml show CUDA/12.6.0
----------------------------------------------------------------------------------------------------------------------
   /hpc2n/eb/modules/all/Core/CUDA/12.6.0.lua:
----------------------------------------------------------------------------------------------------------------------
help([[
Description
===========
CUDA (formerly Compute Unified Device Architecture) is a parallel
 computing platform and programming model created by NVIDIA and implemented by the
 graphics processing units (GPUs) that they produce. CUDA gives developers access
 to the virtual instruction set and memory of the parallel computational elements in CUDA GPUs.


More information
================
 - Homepage: https://developer.nvidia.com/cuda-toolkit
]])
whatis("Description: CUDA (formerly Compute Unified Device Architecture) is a parallel
 computing platform and programming model created by NVIDIA and implemented by the
 graphics processing units (GPUs) that they produce. CUDA gives developers access
 to the virtual instruction set and memory of the parallel computational elements in CUDA GPUs.")
whatis("Homepage: https://developer.nvidia.com/cuda-toolkit")
whatis("URL: https://developer.nvidia.com/cuda-toolkit")
conflict("CUDA")
prepend_path("CMAKE_PREFIX_PATH","/hpc2n/eb/software/CUDA/12.6.0")
prepend_path("CPATH","/hpc2n/eb/software/CUDA/12.6.0/include")
prepend_path("CPATH","/hpc2n/eb/software/CUDA/12.6.0/extras/CUPTI/include")
prepend_path("CPATH","/hpc2n/eb/software/CUDA/12.6.0/nvvm/include")
prepend_path("LD_LIBRARY_PATH","/hpc2n/eb/software/CUDA/12.6.0/lib")
prepend_path("LD_LIBRARY_PATH","/hpc2n/eb/software/CUDA/12.6.0/extras/CUPTI/lib64")
prepend_path("LD_LIBRARY_PATH","/hpc2n/eb/software/CUDA/12.6.0/nvvm/lib64")
prepend_path("LIBRARY_PATH","/hpc2n/eb/software/CUDA/12.6.0/lib")
prepend_path("LIBRARY_PATH","/hpc2n/eb/software/CUDA/12.6.0/extras/CUPTI/lib64")
prepend_path("LIBRARY_PATH","/hpc2n/eb/software/CUDA/12.6.0/nvvm/lib64")
prepend_path("LIBRARY_PATH","/hpc2n/eb/software/CUDA/12.6.0/stubs/lib64")
prepend_path("PATH","/hpc2n/eb/software/CUDA/12.6.0/bin")
prepend_path("PATH","/hpc2n/eb/software/CUDA/12.6.0/nvvm/bin")
prepend_path("PKG_CONFIG_PATH","/hpc2n/eb/software/CUDA/12.6.0/pkgconfig")
prepend_path("XDG_DATA_DIRS","/hpc2n/eb/software/CUDA/12.6.0/share")
setenv("EBROOTCUDA","/hpc2n/eb/software/CUDA/12.6.0")
setenv("EBVERSIONCUDA","12.6.0")
setenv("EBDEVELCUDA","/hpc2n/eb/software/CUDA/12.6.0/easybuild/Core-CUDA-12.6.0-easybuild-devel")
setenv("CUDA_HOME","/hpc2n/eb/software/CUDA/12.6.0")
setenv("CUDA_ROOT","/hpc2n/eb/software/CUDA/12.6.0")
setenv("CUDA_PATH","/hpc2n/eb/software/CUDA/12.6.0")
```

!!! note "buildenv"

    The most useful usage of ``module show`` is with the ``buildenv`` module. If you load a "compiler toolchain" (see next section) and then the "buildenv" module, you can do 

    ```bash
    module show buildenv
    ``` 

    to see all the various useful environment variables that can now be accessed for linking with when you are building something. 

    If you want to read more about this, you can check the [buildenv - build environment](../advanced_module/#buildenv__-__build__environment) section under "EXTRA" -> "Advanced module commands".  

## module help 

This command prints the list of possible commands and can also be used to get the help message from module(s). 

- at centres with a "flat" structure this can be used on all modules since there are no prerequisites: UPPMAX, NSC
- at centres with a "hierarchial" structure this can only be used on the modules that are currently available to load (and can be seen with ``module avail``): HPC2N, LUNARC, C3SE, PDC

**Example, HPC2N** 

Let us look at CUDA:

```bash
b-an01 [~]$ module help CUDA/12.6.0

----------------------------------------- Module Specific Help for "CUDA/12.6.0" -----------------------------------------

Description
===========
CUDA (formerly Compute Unified Device Architecture) is a parallel
 computing platform and programming model created by NVIDIA and implemented by the
 graphics processing units (GPUs) that they produce. CUDA gives developers access
 to the virtual instruction set and memory of the parallel computational elements in CUDA GPUs.


More information
================
 - Homepage: https://developer.nvidia.com/cuda-toolkit
```

## module save/restore 

Module collections are used to load/unload a bunch of modules: ``module save <collection>`` and ``module restore <collection>``. 

This can be useful if you often need to load the same several modules in specific versions, for instance. 

### Creating a module collection

1. Load the modules you need.
2. Save the collection (you can name it as you want, here MYMODULES):
```bash
module save MYMODULES
```

**Example** 

Assuming we need pandas and matplotlib at HPC2N (very similar to LUNARC): 

1. Load the modules
```bash
b-an01 [~]$ module load GCC/12.3.0 
b-an01 [~]$ module load Python/3.11.3 
b-an01 [~]$ module load OpenMPI/4.1.5 
b-an01 [~]$ module load SciPy-bundle/2023.07 
b-an01 [~]$ module load matplotlib/3.7.2 
```
2. Save to a collection (here, "mypython")
```bash
b-an01 [~]$ module save mypython
Saved current collection of modules to: "mypython"

b-an01 [~]$ 
```

- Then, maybe later you find you also need ``mpi4py`` so you load it and add it to the collection: 
```bash
b-an01 [~]$ ml mpi4py/3.1.4 
b-an01 [~]$ module save mypython
Saved current collection of modules to: "mypython"

b-an01 [~]$ 
```

- After you have been logged out and in again, or maybe unloaded/purged the modules, you can then restore it again: 
```bash 
b-an01 [~]$ module restore mypython
Restoring modules from user's mypython
b-an01 [~]$ 
```

- You can get a listing of all your module collections by typing:
```bash
b-an01 [~]$ module savelist
```

- To query the contents of a module collection use
```bash
b-an01 [~]$ module describe mypython
```

!!! warning 

    If you are working on PDC's cluster Dardel, and are used to the command ``module purge`` then this is a good way of restoring the system-modules: 

    - Immediately after logging in (before loading or unloading anything) create a collection: ``module save pdcsystem`` (name as you want)
    - Then, after you have done ``module purge``, just do ``module restore pdcsystem`` and you are back to the correct system setup. 

### Workflow - module collections 

- Create a module collection
- Work with it 
- Possibly unload all modules and load different ones to work with
- Then later restore the module collection again and keep working
- Possibly add more modules and save them to the collection 
- Each time you have logged out and are logging in again, you can easily restore the modules you need
    - Much safer than having it in your ``.bashrc`` since that is something easily forgotten about and then when you suddenly need to work with different modules or different versions, maybe months later, you are wondering why it is not working as it should and the reason is that you have auto-loaded things in your ``.bashrc``! 

!!! note " <img src="../images/shell-logo_small.png"> Exercise" 

    - Try loading some modules
    - create a module collection
    - do ``module list`` to see what you have
    - unload the modules
    - check with ``module list`` 
    - restore the module collection
    - check with ``module list`` 

## Hints

!!! note 

    How would you find, for instance, installed Python package modules for a specific Python version?  

!!! warning "Important"

    At centres with prerequisites, you need to load, say, GCC instead of GCCcore in order to be able to access, for instance, SciPy-bundle!!! You also need to load a compatible OpenMPI in order to be sure to get all available installed Python package modules. 

**Example, HPC2N**

(Very similar to LUNARC)  

1. First load the Python module and prerequisites, and OpenMPI  
  ```bash
  b-an01 [~]$ module load GCC/12.3.0
  b-an01 [~]$ module load Python/3.11.3
  b-an01 [~]$ module load OpenMPI/4.1.5
  ```
2. Then you can check what Python package modules are installed (scroll down a bit):  
   ```bash 
   b-an01 [~]$ module avail
   ...
   ----------------------- This is a list of module extensions "module --nx avail ..." to not show. ------------------------
                                                  (E)     fontBitstreamVera                         (E)
    ADGofTest                                     (E)     fontLiberation                            (E)
    AICcmodavg                                    (E)     fontawesome                               (E)
    ALDEx2                                        (E)     fontquiver                                (E)
    ALL                                           (E)     fonttools                                 (E)
    AMAPVox                                       (E)     forcats                                   (E)
    ANCOMBC                                       (E)     foreach                                   (E)
    ATACseqQC                                     (E)     forecast                                  (E)
    AUC                                           (E)     foreign                                   (E)
    AUCell                                        (E)     formatR                                   (E)
    Aerial-Gym-Simulator                          (E)     formula.tools                             (E)
    AgiMicroRna                                   (E)     formulaic                                 (E)
    AlgDesign                                     (E)     fossil                                    (E)
    Algorithm::Dependency                         (E)     fpc                                       (E)
    Algorithm::Diff                               (E)     fpp                                       (E)
    Alien::Base                                   (E)     fracdiff                                  (E)
    Alien::Build::Plugin::Download::GitLab        (E)     fresh                                     (E)
    Alien::Libxml2                                (E)     frozenlist                                (E)
    AlphaFold                                     (E)     fs                                        (E)
    AlphaPulldown                                 (E)     fsc.export                                (E)
    ... 
   ``` 
3. The "module extensions" are things that are available as part of a modules. Sometimes several for each module. You can see for instance "foreach" R package is available (the list has everything available, not just Python packages). You can then do ``module spider foreach`` to see versions and then ``module spider foreach/1.5.2`` to see where you find that extension. 
4. If you keep going further down on the list you got with "module avail" then you see that "mpi4py" is available and that "pandas" is available. Let us see how to load these. 
5. Doing
```bash
b-an01 [~]$ module avail mpi4py
```
tells us it can be loaded directly
6. Doing
```bash
b-an01 [~]$ module avail pandas
```
gives some conflicting answer, so we try with ``module spider pandas`` and then ``module spider pandas/version`` to learn that it is part of SciPy-bundle. 
7. We can then load SciPy-bundle directly and get "pandas" available. 

!!! note

    Of course, you can always try doing ``module spider <software or package>`` and ``module avail <software or package>`` directly to see if you are lucky and get the name it is called. 

## Summary 

!!! note 

    - We learned about the following commands: 
        - load
        - unload 
        - purge
        - show
        - help
        - save/restore 
   
 
