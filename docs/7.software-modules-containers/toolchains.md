# Compiler toolchains

!!! note "Objectives"

    - Learn what compiler toolchains are and why they are used
    - Be able to find which compiler toolchains are installed
    - Be able load the compiler toolchain you want

At many Swedish (and other European) HPC centres, software is built using the
EasyBuild deployment framework. Under this framework, software is built around
"**toolchains**": compatible groups of C and Fortran compilers, MPI libraries,
linear algebra libraries, and other fundamental programs used internally by more
familiar packages that users work with directly (e.g., Python, R, GROMACS, etc.).

Most HPC centers recommend using toolchains to build and compile software, whether
you use EasyBuild not.  Toolchains:

- keep software consitent, everything is build using the same compiler and the same underlying libraries
- provides access to modern versions of the compiler, offering recent language standards and optimisation techniques.   
    - System compilers are often old -  **Don't use for compiling production software**
- integrates with the module system - makes linking libraries easy

## Available Toolchains by HPC Center

### Toolchains for regular CPU nodes

For most of the following toolchains, multiple versions are available on each of
the specified clusters. Use `ml spider <toolchain>` to determine which versions
are available and what modules are required as prerequisites to load them, if
any.

=== "Dardel"

    Dardel uses the **Cray Programming Environment (CPE)**, which differs significantly from the setup on other NAISS and University systems.  Load a `cpe` module to access a specific version of the CPE, e.g.

    ```
    ml cpe/24.11
    ```
    
    To use installed software titles installed with the latest version of the CPE, load the `PDC` module

    ```
    ml PDC
    ```

    Access to older software versions is provided by loading the relevant `PDCOLD` module .

    In contrast to other systems, it is not advisable to do a `module purge` on Dardel when wanting to remove software.  Use 
    
    - `module unload` to remove a module
    - `module swap` to exchange one module for another
    - `module load` which will load a module and unloads everything that conflicts

    On Dardel three different compilers are available.  By default you get the Cray compiling environment (CCE), commonly referred to as the *Cray compiler*.  In addition the *GNU compiler suite*, the *Intel Programming Environment* and the 
    *AMD AOCC compilers* are available. The compilers can be accessed by loading on of:

    ```
    ml PrgEnv-cray
    ml PrgEnv-gnu
    ml PrgEng-intel
    ml PrgEnv-aocc
    ```

    The `PrgEnv-cray`is loaded by default after login.  
   
    The modules `cray-libsci`, providing e.g. BLAS/LAPACK/ScaLAPACK and `cray-mpich` providing MPI capabilities are automatically included with all four compiler choices.
    
    For software built or intended to be built with EasyBuild, there are 3 toolchains that help to assemble the appropriate combinations of the modules mentioned above, among other tools to support parallel programming.

    - cpeCRAY: based on `PrgEnv-cray`
    - cpeAMD: based on `PrgEnv-gnu`
    - cpeGNU: based on `PrgEnv-aocc`
    
    In the interest of time, we refer readers to [this page on the CPE](https://support.pdc.kth.se/doc/software_development/development/#the-cray-programming-environment) and [this page on CPE-based toolchains](https://support.pdc.kth.se/doc/software_development/easybuild/#toolchains).

=== "Tetralith"
      
    The toolchains available on Tetralith are called **buildenv**, which stands for build environment.   For CPU code build environments based on the Intel compiler and the GNU compiler suite are provided.

    Check

    ```
    module avail buildenv-gcc
    ```

    or 

    ```
    module avail buildenv-intel
    ```

    To check the available versions.  For example command

    ```
    module help buildenv-gcc/2023b-eb
    ```

    shows what is included in the module. In case of `buildenv-gcc/2023b-eb` it is OpenMPI for MPI support, OpenBLAS (BLAS and LAPACK support), FFTW and ScaLAPACK in addtion to the GCC compiler suite.  

    The `buildenv-intel/2023a-eb` contains Intel C/C++ and Fortran compilers, Intel MPI and Intel MKL.
    

=== "Kebnekaise"

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

=== "Cosmos"

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


=== "Pelle"

    **GCC Compiler Toolchains**
    
       * **GCC**: GCC compiler only
       * **foss**: GCC, OpenMPI, OpenBLAS, FFTW, BLACS, ScaLAPACK
       * **gfbf**: GCC, FlexiBLAS, FFTW  (no MPI)
       
    **Intel Compiler Toolchains**
    
       * **intel**: icc, ifort, Intel MPI, MKL
       * **intel-compilers**: icc, icpc, ifort, icx, icpx, ifx (no MPI or MKL)
       * **iimpi**: icc, ifort, Intel MPI

=== "Bianca"

    Toolchains are less visible than on other clusters. Most software was built manually without EasyBuild. Expect to load compilers, MPI libraries, math libraries, and other modules individually, taking common EasyBuild toolchains as inspiration. 
    
       * Need only a compiler? Search for available GCC or intel modules.
       * Need math libraries, like OpenBLAS? Search for that and GCC or intel will be a dependency.
       * Need MPI? See UPPMAX documentation about [combinations of compilers and MPI libraries](https://docs.uppmax.uu.se/software/parallel_comb/)
           * On Bianca you need to load ``gcc`` and ``openmpi`` on separate lines, like:

           ```bash
           ml gcc/9.3.0
           ml openmpi/3.1.5
           ```
           

    The **EasyBuild toolchains** below may be found for *some* tools in their names and dependencies, but are mainly intended to show which libraries go together. Use `ml avail <toolchain>` instead of `ml spider <toolchain>` to see if they are available:
    
    **GCC Compiler Toolchains**
    
       * **GCC**: GCC compiler only
       * **foss**: GCC, OpenMPI, OpenBLAS, FFTW, BLACS, ScaLAPACK
       * **gompi**: GCC, OpenMPI
       
    **Intel Compiler Toolchains**
    
       * **intel**: icc, ifort, Intel MPI, MKL
       * **iimpi**: icc, ifort, Intel MPI



### CUDA based toolchains for GPU nodes

=== "Tetralith"

    **GCC Compiler Toolchains for GPU**
    
       * **buildenv-gcccuda**: GCC, CUDA, OpenMPI, OpenBLAS, FFTW, ScaLAPACK


=== "Kebnekaise"

    - As of today you load GCC and CUDA separately.
    - New tools are typically build with the latest versions of both.

    * foss, GCC, CUDA
    * intel, CUDA 

=== "Cosmos"

    **GCC Compiler Toolchains for GPU**
    
       * **gcccuda**:  GCC, CUDA
       * **fosscuda**: GCC, CUDA, OpenMPI, OpenBLAS, FFTW, ScaLAPACK

    **Intel Compiler Toolchains for GPU**
    
       * **iccifortcuda**: icc, ifort, CUDA
       * **iimpic**: icc, ifort, CUDA, Intel MPI
       * **intelcuda**: icc, ifort, CUDA, Intel MPI, MKL


=== "Pelle"

    - As of today you load GCC and CUDA separately.
    - New tools are typically build with the latest versions of both.


## Selecting a toolchain

The above toolchain choices can be a bit overwhelming, especially for new users. 
Good choices for general use are the toolchains:

=== "Dardel"

    * **PrgEnv-cray**, Cray compiling environment (CCE)
    * **PrgEnv-gnu**, GNU compiler suite
    * **PrgEnv-intel**, Intel Programming Environment
    * **PrgEnv-aocc**, AMD AOCC compilers* 

    **Example:** to check the Programming envrionmnets available, use

    ```bash
    ml avail PrgEnv
    ```
    
=== "Tetralith"

    * **buildenv-gcc**, to use the GCC compiler suite
    * **buildenv-intel** to use the Intel compiler suite

    **Example:** to check the Programming envrionmnets available, use

    ```bash
    ml avail buildenv
    ```

=== "Kebnekaise, Cosmos, Pelle"

    * **foss**, to use the GCC compiler suite
    * **intel**, to use the Intel compiler suite
    * **gomkl**, to use the GCC compiler suite with Intel's Math Kernel Library (MKL)

    **Example:** To check the foss versions available, use

    ```bash
     module avail foss
    ```

    and you will get an output similar to this example on COSMOS:

    ```bash
    ----------------- /sw/easybuild_milan/modules/all/Core ------------------
    foss/2020b    foss/2022a    foss/2023b          fosscuda/2020b
    foss/2021a    foss/2022b    foss/2024a
    foss/2021b    foss/2023a    foss/2024.05 (D)

    Where:
    D:  Default Module

    If the avail list is too long consider trying:

    "module --default avail" or "ml -d av" to just list the default modules.
    "module overview" or "ml ov" to display the number of modules for each 
    name.  
    
    Use "module spider" to find all possible modules and extensions.
    Use "module keyword key1 key2 ..." to search for all possible modules
    matching any of the "keys".
    ```

    The version numbers indicate roughly when each version was released. Version 2023a was released at the beginning of 2023, 2023b in the middle of 2023, and  2024a at the start of 2024. If you load e.g. the `foss/2024a` module as shown below,

    ```bash
    module load foss/2024a
    ```

    It will load several modules for you, including the compiler, libraries, and
    other utilities. The command `module list`, or `ml` for short, can then show you
    what modules are now loaded and available for use. Below is the output of `ml`
    after loading `foss/2024a` on COSMOS:

    ```bash
    Currently Loaded Modules:
     1) SoftwareTree/Milan  (S)  13) UCX/1.16.0
     2) GCCcore/13.3.0           14) libfabric/1.21.0
     3) zlib/1.3.1               15) PMIx/5.0.2
     4) binutils/2.42            16) PRRTE/3.0.5
     5) GCC/13.3.0               17) UCC/1.3.0
     6) numactl/2.0.18           18) OpenMPI/5.0.3
     7) XZ/5.4.5                 19) OpenBLAS/0.3.27
     8) libxml2/2.12.7           20) FlexiBLAS/3.4.4
     9) libpciaccess/0.18.1      21) FFTW/3.3.10
    10) hwloc/2.10.0             22) FFTW.MPI/3.3.10
    11) OpenSSL/3                23) ScaLAPACK/2.2.0-fb
    12) libevent/2.1.12          24) foss/2024a

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

=== "Dardel"

    After loading a PrgEnv one always uses the same compiler wrappers for compiling, independent of the compiler suite used.  These wrappers are recommended for serail and parallel code.

    | Coding Language | Compiler wrapper |
    | :-------------- | :--------------- |
    | C               | cc               |
    | C++             | CC               |
    | Fortran         | ftn              |


=== "Tetralith"

    After loading your buildenv choose your compiler command from the following table based on your coding language.

    | Coding Language | If buildenv-gcc  | If buildenv-intel  |
    | :-------------- | :--------------- | :----------------- |
    | C               | gcc              | icc                |
    | C++             | g++              | icpc               |
    | Fortran         | gfortran         | ifort              |

=== "Kebnekaise, Cosmos, Pelle"

    If you have loaded a toolchain, choose your compiler from the following table
    based on your coding language and toolchain choice. Note that there are 2 Intel
    versions per language; versions ending with x are newer OneAPI versions supported
    from 2023 onward.

    | Coding Language | If GCC Toolchain | If Intel Toolchain |
    | :-------------- | :--------------- | :----------------- |
    | C               | gcc              | icc, icx           |
    | C++             | g++              | icpc, icpx         |
    | Fortran         | gfortran         | ifort, ifx         |

    For some open-source toolchains, there may be no difference between compiling
    serial code with a toolchain and using a built-in compiler. The differences are
    more visible when using an Intel toolchain or when using MPI.

### Toolchains using MPI

=== "Dardel"

    After loading a PrgEnv one always uses the same compiler wrappers for compiling, independent of the compiler suite used.  These wrappers are recommended for serail and parallel code.

    | Coding Language | Compiler wrapper |
    | :-------------- | :--------------- |
    | C               | cc               |
    | C++             | CC               |
    | Fortran         | ftn              |

=== "Tetralith"
  
    The table below shows which MPI compiler to use given your choices of toolchain
    and coding language:

    | Coding Language | If buildenv-gcc           | If buildenv-intel  |
    | :-------------- | :------------------------ | :----------------- |
    | C               | mpicc                     | mpiicc             |
    | C++             | mpicxx                    | mpiicpc            |
    | Fortran         | mpifort                   | mpiifort           |
     


=== "Kebnekaise, Cosmos, Pelle"

    The table below shows which MPI compiler to use given your choices of toolchain
    and coding language:

    | Coding Language | If Toolchain with OpenMPI | If Intel Toolchain |
    | :-------------- | :------------------------ | :----------------- |
    | C               | mpicc                     | mpiicc             |
    | C++             | mpicxx                    | mpiicpc            |
    | Fortran         | mpifort                   | mpiifort           |
 
