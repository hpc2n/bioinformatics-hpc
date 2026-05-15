# Compiler toolchains

!!! note "Objectives"

    - Learn what compiler toolchains are and why they are used
    - Be able to find which compiler toolchains are installed
    - Be able load the compiler toolchain you want

At HPC2N software is built using the EasyBuild deployment framework. Under this framework, software is built around "**toolchains**": compatible groups of C and Fortran compilers, MPI libraries, linear algebra libraries, and other fundamental programs used internally by more familiar packages that users work with directly (e.g., Python, R, GROMACS, etc.).

HPC2N, like most HPC centers recommend using toolchains to build and compile software, whether
you use EasyBuild not.  

Toolchains:

- keep software consitent, everything is build using the same compiler and the same underlying libraries
- provides access to modern versions of the compiler, offering recent language standards and optimisation techniques.   
    - System compilers are often old -  **Don't use for compiling production software**
- integrates with the module system - makes linking libraries easy

## Available Toolchains

### Toolchains for regular CPU nodes

For most of the following toolchains, multiple versions are available. 
Use `ml spider <toolchain>` to determine which versions are available and what modules are required as prerequisites to load them, if any.

    **GCC Compiler Toolchains**
    
       * **GCC**: GCC compiler only
       * **foss**: GCC, OpenMPI, OpenBLAS, FFTW, BLACS, ScaLAPACK
       * **gompi**: GCC, OpenMPI
       * **gomkl**: GCC, OpenMPI, MKL
       * **gfbf**: GCC, FlexiBLAS, FFTW  (no MPI)

    **Intel Compiler Toolchains**
    
       * **intel**: icc, ifort, Intel MPI, MKL
       * **intel-compilers**: icc, icpc, ifort, icx, icpx, ifx (no MPI or MKL)
       * **iimpi**: icc, ifort, Intel MPI


### CUDA based toolchains for GPU nodes

    - As of recently you load GCC and CUDA separately.
    - New tools are typically build with the latest versions of both.

    * foss, GCC, CUDA
    * intel, CUDA 

## Selecting a toolchain

The above toolchain choices can be a bit overwhelming, especially for new users. 
Good choices for general use are the toolchains:

    * **foss**, to use the GCC compiler suite
    * **intel**, to use the Intel compiler suite
    * **gomkl**, to use the GCC compiler suite with Intel's Math Kernel Library (MKL)

    **Example:** To check the foss versions available, use

    ```bash
     module avail foss
    ```

    and you will get an output similar to this example:

    ```bash
    ------------------------------------- /hpc2n/eb/modules/all/Core --------------------------------------
       foss/2021b    foss/2022b    foss/2023b    foss/2025a        foss/2025b
       foss/2022a    foss/2023a    foss/2024a    foss/2025b (D)

     Where:
      D:  Default Module

    If the avail list is too long consider trying:

    "module --default avail" or "ml -d av" to just list the default modules.
"module overview" or "ml ov" to display the number of modules for each name.

    Use "module spider" to find all possible modules and extensions.
    Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".
    ```

    The version numbers indicate roughly when each version was released. Version 2023a was released at the beginning of 2023, 2023b in the middle of 2023, and  2024a at the start of 2024. If you load e.g. the `foss/2024a` module as shown below,

    ```bash
    module load foss/2024a
    ```

    It will load several modules for you, including the compiler, libraries, and
    other utilities. The command `module list`, or `ml` for short, can then show you
    what modules are now loaded and available for use. Below is the output of `ml`
    after loading `foss/2024a`:

    ```bash
    Currently Loaded Modules:
      1) snicenvironment (S)   9) libxml2/2.12.7       17) UCC/1.3.0
      2) systemdefault   (S)  10) libpciaccess/0.18.1  18) OpenMPI/5.0.3
      3) GCCcore/13.3.0       11) hwloc/2.10.0         19) OpenBLAS/0.3.27
      4) zlib/1.3.1           12) OpenSSL/3            20) FlexiBLAS/3.4.4
      5) binutils/2.42        13) libevent/2.1.12      21) FFTW/3.3.10
      6) GCC/13.3.0           14) UCX/1.16.0           22) FFTW.MPI/3.3.10
      7) numactl/2.0.18       15) PMIx/5.0.2           23) ScaLAPACK/2.2.0-fb
      8) XZ/5.4.5             16) PRRTE/3.0.5          24) foss/2024a

      Where:
       S:  Module is Sticky, requires --force to unload or purge
    ```

After loading a toolchain, many new modules become available, each reliant on
the specific versions of the modules included in the toolchain. Use `ml avail`
to see what modules you can load given the toolchain you've loaded.

For some packages with very long or very short release intervals, there may be
multiple versions of a software package available for your chosen toolchain.
The version that loads by default if no version number is given will have a
`(D)` to the right of it when listed using `ml avail`. This default version is
subject to change, so it is recommended to always provide version numbers.

Not all modules have a version associated with your choice of toolchain. If you
switch toolchains, keep the following in mind:

* The module system will attempt to upgrade or downgrade any previously
loaded modules to match the new choice of toolchain.
* If one or more modules loaded with the previous choice of toolchain do
not have a version installed that is compatible with the new toolchain,
then the module system will raise an error.
* For some packages (e.g., Python, Perl, etc.) there is a system version
built into the operating system that runs without loading any module or
toolchain. These should be avoided since they are subject to change.
    
## Compiling serial code using a toolchain

If you have loaded a toolchain, choose your compiler from the following table
based on your coding language and toolchain choice. Note that there are 2 Intel
versions per language; versions ending with x are newer OneAPI versions supported
from 2023 onward. The version without x are deprecated in older available versions and not 
supported from intel/2024a and forward. 

    | Coding Language | If GCC Toolchain | If Intel Toolchain |
    | :-------------- | :--------------- | :----------------- |
    | C               | gcc              | icc, icx           |
    | C++             | g++              | icpc, icpx         |
    | Fortran         | gfortran         | ifort, ifx         |

    For some open-source toolchains, there may be no difference between compiling
    serial code with a toolchain and using a built-in compiler. The differences are
    more visible when using an Intel toolchain or when using MPI.

### Toolchains using MPI

    The table below shows which MPI compiler to use given your choices of toolchain
    and coding language:

    | Coding Language | If Toolchain with OpenMPI | If Intel Toolchain |
    | :-------------- | :------------------------ | :----------------- |
    | C               | mpicc                     | mpiicc             |
    | C++             | mpicxx                    | mpiicpc            |
    | Fortran         | mpifort                   | mpiifort           |
 
