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

### List toolchains with ``module avail`` 

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
      Note that names that have a trailing (E) are extensions provided by other modules.
      For example:

         $ module spider Python/3.13.5
    ----------------------------------------------------------------------------
    ```

!!! note "<img src="../../images/shell-logo_small.png"> Exercise" 

    1. Check the different output for ``module avail Python`` and ``module spider Python``
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

In order to load modules, we need to know *how*. This differs by center only inasmuch as some centers have prerequisites (usually **compiler toolchains**) for most of the software modules. As mentioned, HPC2N do.  

### Prerequisites 

- This is done with ``module spider <module>/<version>`` 
- Sometimes you will be told that the module can be loaded directly (MATLAB, ...). 

!!! note "Example, finding out how to load Python, version 3.12.3"
 
    ```bash 
    b-cn1613 [~]$ module spider Python/3.12.3

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

### Loading 

!!! note

    To load a software module, do: 

    - (if needed) ``module load <prerequisite>/<suitable version>``
    - ``module load <module>/<compatible version>``

    with the versions you got from ``module spider``. 

    Again, ``ml load <module>/<version>`` can be used as a short form. 

When you have loaded the module, you can see that your list of loaded modules has changed. This is done with ``module list`` or ``ml``. 

!!! hint 

    Type along!  

!!! note "Example"

    Loading Python 3.12.3 and prerequisites, and checking before and after which modules are loaded.

    ```bash
    module list
    ```

    ??? note "Click to show output!" 

        ```bash
        b-cn1613 [~]$ module list

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
        b-cn1613 [~]$ module load GCCcore/13.3.0 Python/3.12.3
        b-cn1613 [~]$
        ```

    And now do ``module list`` again! 

    ??? note "Click to show output!" 

        ```bash 
        b-cn1613 [~]$ module list

        Currently Loaded Modules:
          1) snicenvironment (S)   4) zlib/1.3.1      7) ncurses/6.5      10) SQLite/3.45.3  13) OpenSSL/3
          2) systemdefault   (S)   5) binutils/2.42   8) libreadline/8.2  11) XZ/5.4.5       14) Python/3.12.3
          3) GCCcore/13.3.0        6) bzip2/1.0.8     9) Tcl/8.6.14       12) libffi/3.4.5

          Where:
           S:  Module is Sticky, requires --force to unload or purge
        ```
    
!!! warning "Important"

    - You can do several ``module load`` on the same line. Or you can do them one at a time, as you want.
        - The modules have to be loaded in order! You cannot list the prerequisite after the module that needs it!
    - One advantage to loading modules one at a time is that you can then find compatible modules that depend on that version easily.
        - Example: you have loaded GCC/13.2.0 and Python/3.11.5 at HPC2N. You can now do ``ml av`` or ``module avail`` to see which versions of other modules you want to load, say ``SciPy-bundle``, are compatible. 
        - If you know the name of the module you want, you can even start writing ``module load SciPy-bundle/`` (for instance) and press TAB - the system will then autocomplete to the compatible one(s). 

### Loading several modules

There are situations where you need to load several modules, even at centres where there are no prerequisites. 

!!! note "Example" 

    You need some Python packages not included in the base Python you loaded, for instance PyTorch, or TensorFlow, or maybe AlphaFold. 

    You now need to load a version of that module which is compatible with the Python you want. 
   
    Tensorflow needs Python and SciPy-bundle. SciPy-bundle also needs OpenMPI. TensorFlow *loads* Python and SciPy-bundle itself, but you need their prerequisites: 

    ```bash 
    b-cn1613 [~]$ module spider TensorFlow/2.15.1-CUDA-12.1.1

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
    b-cn1613 [~]$ module load GCC/12.3.0 OpenMPI/4.1.5
    b-cn1613 [~]$ module load TensorFlow/2.15.1-CUDA-12.1.1
    ```

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

This is not a problem if there are no prerequisites, but can be annoying when there is. However, there the easy solution is ``module purge``. 

The command ``module purge`` removes all the loaded modules, except the "sticky" modules. It is recommended at HPC2N. 

### Unloading examples 

#### No prerequisites 

Unloading one module, with no prerequisites (for clarity, we also do ``module list`` before and after to show what is happening. 

!!! tip

    Type along!

    First load a suitable module (with no prerequisites). Suggestion: 

    - GCC/12.3.0

!!! note 

    Check which modules are loaded (after loading GCC/12.3.0 earlier)

    ```bash
    b-cn1613 [~]$ module list

    Currently Loaded Modules:
      1) snicenvironment (S)   3) GCCcore/12.3.0   5) binutils/2.40
      2) systemdefault   (S)   4) zlib/1.2.13      6) GCC/12.3.0

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    b-cn1613 [~]$ 
    ```

    Unload GCC/12.3.0 

    ```bash
    b-cn1613 [~]$ module unload GCC/12.3.0
    b-cn1613 [~]$ 
    ```

    Check which modules are loaded 

    ```bash
    b-cn1613 [~]$ module list

    Currently Loaded Modules:
      1) snicenvironment (S)   2) systemdefault (S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

#### Prerequisites

Here we look at what happens when you unload something that has a prerequisite. 

!!! note "Example"

    Loading Python and prerequisites

    ```bash
    b-cn1613 [~]$ module load GCC/12.3.0
    b-cn1613 [~]$ module load Python/3.11.3 
    ```

    Check loaded modules

    ```bash
    b-cn1613 [~]$ ml
    
    Currently Loaded Modules:
      1) snicenvironment (S)   4) zlib/1.2.13     7) bzip2/1.0.8      10) Tcl/8.6.13     13) libffi/3.4.4
      2) systemdefault   (S)   5) binutils/2.40   8) ncurses/6.4      11) SQLite/3.42.0  14) OpenSSL/1.1
      3) GCCcore/12.3.0        6) GCC/12.3.0      9) libreadline/8.2  12) XZ/5.4.2       15) Python/3.11.3

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

    Unload Python/3.11.3

    ```bash
    b-cn1613 [~]$ ml unload Python/3.11.3
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
    b-cn1613 [~]$ ml -GCC/12.3.0
    ```

    Check loaded modules

    ```bash 
    b-cn1613 [~]$ ml

    Currently Loaded Modules:
      1) snicenvironment (S)   2) systemdefault (S)

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

What happens if you try and unload the prerequisite?

!!! note "Example"

    ```bash
    b-cn1613 [~]$ ml GCC/12.3.0 Python/3.11.3
    b-cn1613 [~]$ ml

    Currently Loaded Modules:
      1) snicenvironment (S)   4) zlib/1.2.13     7) bzip2/1.0.8      10) Tcl/8.6.13     13) libffi/3.4.4
      2) systemdefault   (S)   5) binutils/2.40   8) ncurses/6.4      11) SQLite/3.42.0  14) OpenSSL/1.1
      3) GCCcore/12.3.0        6) GCC/12.3.0      9) libreadline/8.2  12) XZ/5.4.2       15) Python/3.11.3

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    b-cn1613 [~]$ ml -GCC/12.3.0

    Inactive Modules:
      1) OpenSSL/1.1       3) SQLite/3.42.0     5) XZ/5.4.2        7) libffi/3.4.4
      2) Python/3.11.3     4) Tcl/8.6.13        6) bzip2/1.0.8     8) libreadline/8.2

    Due to MODULEPATH changes, the following have been reloaded:
      1) binutils/2.40     2) ncurses/6.4     3) zlib/1.2.13
    ```

### ``module purge``

What about ``module purge``? 

```bash
b-cn1613 [~]$ ml GCC/12.3.0 Python/3.11.3
b-cn1613 [~]$ ml

Currently Loaded Modules:
  1) snicenvironment (S)   4) zlib/1.2.13     7) bzip2/1.0.8      10) Tcl/8.6.13     13) libffi/3.4.4
  2) systemdefault   (S)   5) binutils/2.40   8) ncurses/6.4      11) SQLite/3.42.0  14) OpenSSL/1.1
  3) GCCcore/12.3.0        6) GCC/12.3.0      9) libreadline/8.2  12) XZ/5.4.2       15) Python/3.11.3

  Where:
   S:  Module is Sticky, requires --force to unload or purge

 

b-cn1613 [~]$ ml purge
The following modules were not unloaded:
  (Use "module --force purge" to unload all):

  1) snicenvironment   2) systemdefault
b-cn1613 [~]$ ml

Currently Loaded Modules:
  1) snicenvironment (S)   2) systemdefault (S)

  Where:
   S:  Module is Sticky, requires --force to unload or purge
```

All good! 

!!! note "<img src="../../images/shell-logo_small.png"> Exercise" 

    1. Check how to load R. Pick a version.
    2. Does it have prerequisites?
    3. Load R for a specific version (but first load prerequisites if there are any).
    4. Run ``module list`` to see what modules got loaded. Was it more than you expected?
    5. Unload R (and prerequisites if there are any). See what happens.
    6. Do ``module list`` again.

## module show 

This command shows commands in the module file (MODULE) and can be used to list information about modules.

- for modules that has a “flat” structure (no prerequisites) this can be used
- for modules that has a “hierarchial” structure (has prerequisites) this cannot be used until the prerequisites have been loaded. 

!!! note "Example: Let us look at CUDA"

    ```bash 
    b-cn1613 [~]$ ml show CUDA/12.6.0
    ----------------------------------------------------------------------------------------------------------------------
       /hpc2n/eb/modules/all/Core/CUDA/12.6.0.lua:
    ----------------------------------------------------------------------------------------------------------------------
    help([[
    Description
    ===========
    CUDA (formerly Compute Unified Device Architecture) is a parallel computing platform and programming model created by NVIDIA and implemented by the graphics processing units (GPUs) that they produce. CUDA gives developers access to the virtual instruction set and memory of the parallel computational elements in CUDA GPUs.

    More information
    ================
     - Homepage: https://developer.nvidia.com/cuda-toolkit
    ]])
    whatis("Description: CUDA (formerly Compute Unified Device Architecture) is a parallel computing platform and programming model created by NVIDIA and implemented by the graphics processing units (GPUs) that they produce. CUDA gives developers access to the virtual instruction set and memory of the parallel computational elements in CUDA GPUs.")
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

- for modules not having prerequisites you can use ``module help`` without loading anything
- for modules with prerequisites this command can only be used on the modules that are currently available to load (and can be seen with ``module avail``)

**Example** 

Let us look at CUDA again:

```bash
b-cn1613 [~]$ module help CUDA/12.6.0

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

Assuming we need pandas and matplotlib at HPC2N: 

1. Load the modules
```bash
b-cn1613 [~]$ module load GCC/12.3.0 
b-cn1613 [~]$ module load Python/3.11.3 
b-cn1613 [~]$ module load OpenMPI/4.1.5 
b-cn1613 [~]$ module load SciPy-bundle/2023.07 
b-cn1613 [~]$ module load matplotlib/3.7.2 
```
2. Save to a collection (here, "mypython")
```bash
b-cn1613 [~]$ module save mypython
Saved current collection of modules to: "mypython"

b-cn1613 [~]$ 
```

- Then, maybe later you find you also need ``mpi4py`` so you load it and add it to the collection: 
```bash
b-cn1613 [~]$ ml mpi4py/3.1.4 
b-cn1613 [~]$ module save mypython
Saved current collection of modules to: "mypython"

b-cn1613 [~]$ 
```

- After you have been logged out and in again, or maybe unloaded/purged the modules, you can then restore it again: 
```bash 
b-cn1613 [~]$ module restore mypython
Restoring modules from user's mypython
b-cn1613 [~]$ 
```

- You can get a listing of all your module collections by typing:
```bash
b-cn1613 [~]$ module savelist
```

- To query the contents of a module collection use
```bash
b-cn1613 [~]$ module describe mypython
```

### Workflow - module collections 

- Create a module collection
- Work with it 
- Possibly unload all modules and load different ones to work with
- Then later restore the module collection again and keep working
- Possibly add more modules and save them to the collection 
- Each time you have logged out and are logging in again, you can easily restore the modules you need
    - Much safer than having it in your ``.bashrc`` since that is something easily forgotten about and then when you suddenly need to work with different modules or different versions, maybe months later, you are wondering why it is not working as it should and the reason is that you have auto-loaded things in your ``.bashrc``! 

!!! note " <img src="../../images/shell-logo_small.png"> Exercise" 

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

**Example**

1. First load the Python module and prerequisites, and OpenMPI  
  ```bash
  b-cn1613 [~]$ module load GCC/12.3.0
  b-cn1613 [~]$ module load Python/3.11.3
  b-cn1613 [~]$ module load OpenMPI/4.1.5
  ```
2. Then you can check what Python package modules are installed (scroll down a bit):  
   ```bash 
   b-cn1613 [~]$ module avail
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
b-cn1613 [~]$ module avail mpi4py
```
tells us it can be loaded directly
6. Doing
```bash
b-cn1613 [~]$ module avail pandas
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
   
 
