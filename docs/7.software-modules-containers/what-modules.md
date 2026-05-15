# Introduction to the module system 

!!! note "Objectives"

    - Learn the basics of the module system which is used to access most of the software at the majority of the HPC centres in Sweden 
    - Learn about some of the most used commands for the module system
    - Find existing modules  
 
Most programs are accessed by first loading them as a ‘module’. Thus, knowing about modules is *necessary* for you to be able to access the majority of the installed software at a centre! 

Modules are:

- used to set up your environment (paths to executables, libraries, etc.) for using a particular (set of) software package(s)
- a tool to help users manage their Unix/Linux shell environment, allowing groups of related environment-variable settings to be made or removed dynamically
- allows having multiple versions of a program or package available by just loading the proper module
- are installed in a hierarchial layout. This means that some modules are only available after loading a specific compiler and/or MPI version, etc. 
    - that is, the modules have *prerequisites* that needs to be loaded before they can be loaded. 
    - Whether or not modules have prerequisites vary by center. More on this later! 

Many of the centres in Sweden are using the <a href="https://lmod.readthedocs.io/en/latest/" target="_blank">Lmod</a> module system. It is an environment module system that is Lua based. 

Many, but not all, of the centres in Sweden are using the <a href="https://docs.easybuild.io/" target="_blank">EasyBuild</a> framework for building and installing software modules.   

PDC also provides some software as containers, found in  ``/pdc/software/sing_hub`` (or ``$PDC_SHUB``). ``singularity exec -B /cfs/klemming <sandbox folder> <myexe>``

LUMI has no modules and uses containers 


!!! warning "Important" 

    - Take care not to use any system-installed versions of ``gcc``, ``python``, etc. Always use the module instead, when available! 
    - Always check if there is a module instead of just building the software/package yourself! 
        - Remember to check with different capitalization! 
        - If the center you are at have modules installed in a hierarchical fashion (LUNARC, HPC2N, PDC) you must use ``module spider`` to check if a software is installed, since ``module avail`` only lists what is available with what is currently loaded
    - If there is a software missing that you need, then ask if it can be installed. 

## Useful commands 

This is a list of some of the most useful commands for the module system. In the list below, ``MODULE`` is used as a stand-in for any software module. 

- See which modules exists: ``module spider or ml spider``
- See which versions exist of a specific module: ``module spider MODULE`` or ``ml spider MODULE``
    - This way is only recommended at HPC2N, LUNARC, (C3SE), and PDC 
- See prerequisites and how to load a specfic version of a module: ``module spider MODULE/VERSION`` or ``ml spider MODULE/VERSION``
- List modules depending only on what is currently loaded: ``module avail`` or ``ml av``
    - At UPPMAX and NSC (and C3SE) this will list all available modules!
    - On Bianca, bioinfo tools are seen after loading ``bioinfo-tools``
- See which modules are currently loaded: ``module list`` or ``ml``
- Loading a module: ``module load MODULE`` or ``ml MODULE``
- Loading a specific version of a module: ``module load MODULE/VERSION`` or ``ml MODULE/VERSION``
- Unload a module: ``module unload MODULE`` or ``ml -MODULE``
- Get more information about the paths etc. of a module: ``ml show MODULE`` or ``module show MODULE``
- Get information about what is in a module: ``module help MODULE`` or ``ml help MODULE`` 
- Unload all modules except the ‘sticky’ modules: ``module purge or ml purge``
- Module collections to load/unload a bunch of modules: ``module save <collection>`` and ``module restore <collection>``

## Finding existing modules 

!!! warning 

    This differs somewhat between centres. Some centres recommend using ``module avail`` while at others it is better to use ``module spider``! 

    This is mainly to do with whether or not modules in general have prerequisite modules that needs loading before, or not. 

    - ``module spider``: HPC2N, LUNARC, (C3SE), PDC  
    - ``module avail``: UPPMAX, NSC, C3SE 

### With ``module spider``

This is the recommended way to find existing software modules at **HPC2N**, **LUNARC**, (**C3SE**), and **PDC**. 

??? note "Why is `ml spider` slow at the UPPMAX clusters?"

    The reason is the large software stack at UPPMAX (1000s of modules, inclusing different versions). It takes time to go through everything!

!!! hint 

    ``module spider`` can be written in short form as ``ml spider``

??? note "Example, HPC2N" 

    ```bash
    b-an01 [~]$ module spider

    --------------------------------------------------------------------------------------------------------------
    The following is a list of the modules and extensions currently available:
    --------------------------------------------------------------------------------------------------------------
      :  (E)

      ABRicate: ABRicate/1.0.0
        Mass screening of contigs for antimicrobial and virulence genes

      ABySS: ABySS/2.2.5
        Assembly By Short Sequences - a de novo, parallel, paired-end sequence assembler

      ACTC: ACTC/1.1
        ACTC converts independent triangles into triangle strips or fans.

      ADGofTest: ADGofTest/0.3 (E)

      AICcmodavg: AICcmodavg/2.3-0 (E), AICcmodavg/2.3-1 (E), ...

      ALDEx2: ALDEx2/1.20.0 (E), ALDEx2/1.26.0 (E), ALDEx2/1.28.1 (E), ...

      ALL: ALL/1.30.0 (E), ALL/1.36.0 (E), ALL/1.38.0 (E), ...

      AMAPVox: AMAPVox/0.12.0 (E), AMAPVox/1.0.0 (E), AMAPVox/1.0.1 (E), ...

      AMGX: AMGX/2.2.0-CUDA-11.3.1
        Distributed multigrid linear solver library on GPU

      AMOS: AMOS/3.1.0
        The AMOS consortium is committed to the development of open-source whole genome assembly software

      AMPtorch: AMPtorch/0.1
        AMPtorch is a PyTorch implementation of the Atomistic Machine-learning Package (AMP) code that seeks to provide users with improved performance and flexibility as compared to the original code. The implementation does so by benefiting from state-of-the-art machine learning methods and techniques to be optimized in conjunction with high-throughput supercomputers.

      ANCOMBC: ANCOMBC/1.6.4 (E), ANCOMBC/2.4.0 (E), ANCOMBC/2.6.0 (E)

    ...
    ```

!!! hint 

    You can check if a specific software module is installed by trying ``module spider <SOFTWARE>``

    Example, GROMACS at HPC2N (it works the same at LUNARC, C3SE, and PDC): 

    ```bash
    b-an01 [~]$ module spider GROMACS

    --------------------------------------------------------------------------------------------------------------------
      GROMACS:
    --------------------------------------------------------------------------------------------------------------------
        Description:
          GROMACS is a versatile package to perform molecular dynamics, i.e. simulate the Newtonian equations of motion for systems with hundreds to millions of particles.

         Versions:
            GROMACS/3.3.3-cphmd-1.3
            GROMACS/3.3.3-cphmd-1.3-1lpernode
            GROMACS/3.3.3-cphmd-1.4
            GROMACS/4.0.7-ionstr
            GROMACS/5.1.4
            GROMACS/2016.x-drude-20180214-g3f7439a
            GROMACS/2016.x-drude-20220117-g78fe3d1e
            GROMACS/2016.x-drude-20220120-ge35ae4e2
            GROMACS/2016.4
            GROMACS/2018.8
            GROMACS/2019
            GROMACS/2019.4-PLUMED-2.5.4
            GROMACS/2021
            GROMACS/2022.4
            GROMACS/2023.1-CUDA-11.7.0
            GROMACS/2023.1
            GROMACS/2023.3-CUDA-12.1.1-PLUMED-2.9.0
            GROMACS/2024.1
            GROMACS/2024.3-CUDA-12.4.0
         Other possible modules matches:
            GROMACS-LS

    --------------------------------------------------------------------------------------------------------------------
      To find other possible module matches execute:

          $ module -r spider '.*GROMACS.*'

    --------------------------------------------------------------------------------------------------------------------
      For detailed information about a specific "GROMACS" package (including how to load the modules) use the module's full name.
      Note that names that have a trailing (E) are extensions provided by other modules.
      For example:

         $ module spider GROMACS/2024.3-CUDA-12.4.0
    --------------------------------------------------------------------------------------------------------------------
    ```
 
    **NOTE**: Beware that you may have to try with different capitalization to find the software! 

### With ``module avail`` 

This is the recommended way to find existing software modules at **UPPMAX** and **NSC**. It also works at **C3SE**.  

!!! hint

    ``module avail`` can be written in short form as ``ml av`` 


??? note "Example, Pelle (NSC works the same)" 

    ```bash

    [bjornc@pelle3-ae ~]$ ml av

    -------------------------------------------------- /sw/arch/local/modules ---------------------------------------------------
       BLAST_databases/latest                 MMseqs2_data/20240202      NONMEM/7.6.0                  (D)    dds-cli/latest
       GaussView/5.0.8                        NCBI_taxonomy/latest       PsN/5.3.1                            matlab/R2019a
       Gaussian/g09.d01                       NONMEM/7.4.3-GCC-13.3.0    RStudio/2025.09.0-387                nf-core/latest
       Kraken2_data/latest                    NONMEM/7.4.3               SMC++/1.15.5.dev14+g6779faec7        pixi-tools/latest
       KrakenUniq_data/latest                 NONMEM/7.4.4-GCC-13.3.0    VASP/6.5.0                           pixy/2.0.0.beta14
       KrakenUniq_data/20230619-104733 (D)    NONMEM/7.5.1-GCC-13.3.0    bioinfo-tools/latest                 uv-tools/latest
    
    -------------------------------------------------- /sw/arch/eb/modules/all --------------------------------------------------
       A5-miseq/20160825-GCCcore-13.3.0
       ABySS/2.3.10-foss-2024a
       ACTC/1.1-GCCcore-13.3.0
       ADMIXTURE/1.3.0
       AGAT/1.4.1-GCCcore-13.3.0
       AGE/0.4-GCCcore-13.3.0
       ANIcalculator/1.0-GCCcore-13.3.0
       ANNOVAR/20250302-GCCcore-13.3.0
       ANTLR/2.7.7-GCCcore-13.3.0
       AOCL-BLAS/5.0-GCC-13.3.0
       AOCL-BLAS/5.0-GCC-14.2.0
       AOCL-BLAS/5.1-GCC-14.3.0                                        (D)
       ATK/2.38.0-GCCcore-13.3.0
           ATSAS/3.2.1-1
       AUGUSTUS/3.5.0-foss-2024a
       Abseil/20230125.3-GCCcore-12.3.0
       Abseil/20240722.0-GCCcore-13.3.0                                (D)
       AdapterRemoval/2.3.4-GCCcore-13.3.0
       Amber/24.3-foss-2023a-AmberTools-24.10-CUDA-12.1.1-PLUMED-2.9.0
       Amber/24.3-foss-2023a-AmberTools-24.10-CUDA-12.1.1

    --More--

    ```

??? note "Example, Bianca (NSC works the same)" 

    ```bash
    [bjornc@sens2025560-bianca ~]$ module avail

    --------------------------------- /sw/mf/bianca/applications ----------------------------------
      ABINIT/8.10.3                          comsol/6.1
      ALPS/2.3.0                             comsol/6.2                       (D)
      Amber/20                               comsol/6.3
      Ansys/19.1                             conda/latest
      Ansys/19.5                             coreutils/8.27
      Ansys/2020R1                    (D)    coreutils/9.1                    (D)
      BLAKE2/20230212-ed1974e                cowsay/3.03
      CDO/1.9.5                              cp2k/4.1-gcc
      CDO/1.9.7.1-intel18.3                  cp2k/6.1-gcc
      CDO/1.9.7.1                     (D)    cp2k/8.1-gcc                     (D)
      COIN-OR-OptimizationSuite/1.8.0        darsync/20240208-7ff09d9
      CPLEXOptimizationStudio/12.9.0         desmond/2022-2
      CPLEXOptimizationStudio/20.10   (D)    doxygen/1.8.11
      CST_Studio/2023.0                      doxygen/1.9.6                    (D)
      Cromwell/71                            eLSA/20160907-febe2d7a57c8
      Cromwell/86                     (D)    emacs/25.2
      DBdeployer/latest                      emacs/27.2
      DOCK/3.7                               emacs/28.2                       (D)
      FFmpeg/4.4                             freesurfer/6.0.0
      FFmpeg/5.1.2                    (D)    freesurfer/7.4.1                 (D)
      GDAL/2.1.0                             gamess/20170930
      GDAL/3.1.0                             gaussian/g09.d01
      GDAL/3.6.2                             gaussview/5.0.8
      GDAL/3.7.2                      (D)    gawk/4.1.4
      GOTM/5.3-221-gac7ec88d                 gdl/1.0.0-rc.1
      GhostPDL/9.53.3                        gnuplot/system
      GoogleCloudSDK/217.0.0                 gnuplot/5.0.7
      GoogleCloudSDK/447.0.0                 gnuplot/5.2.7                    (D)
    ...
    ```

!!! hint 

    You can check if a specific software module is installed by trying ``module avail <SOFTWARE>``

    Example, GROMACS at NSC: 

    ```bash 
    [x_birbr@tetralith3 ~]$ module avail GROMACS

    --------------------- /software/sse2/tetralith_el9/modules ---------------------
       GROMACS/recommendation                    (D)
       GROMACS/2021.3-PLUMED-nsc1-gcc-9.3.0-bare
       GROMACS/2022.2-nsc1-gcc-9.3.0-bare
       GROMACS/2023.4-gpu-hpc1-g9
       GROMACS/2023.4-mpi+omp-hpc1-g9
       GROMACS/2024.2-mpi+omp-hpc1-g11
       GROMACS/2024.4-mpi+omp+double-cp2k-g11

      Where:
       D:  Default Module
    ```

!!! warning

    If you do ``module avail`` at one of the centres that recommend ``module spider`` you will not get a full list of software, only those are available to load with **no other prerequisites than are currently loaded**. This *is* however, a good way to find **compiler toolchains** (more about that later).  

??? note "Example, HPC2N" 

    Here you only get what is available without loading anything else. Most modules have **prerequisistes** so this is not the way to find all modules! 

    ```bash 
    b-an01 [~]$ module avail

    ------------------------------------------- /hpc2n/eb/modules/all/Core -------------------------------------------
      ATSAS/3.2.1-1_amd64                                binutils/2.34
      Advisor/2023.2.0                                   binutils/2.35
      BLAST/2.11.0-Linux_x86_64                          binutils/2.36.1
      Bison/3.0.4                                        binutils/2.37
      Bison/3.0.5                                        binutils/2.38
      Bison/3.3.2                                        binutils/2.39
      Bison/3.5.3                                        binutils/2.40
      Bison/3.7.1                                        binutils/2.42                  (D)
      Bison/3.7.6                                        biosoup/0.11.0
      Bison/3.8.2                              (D)       code-server/4.97.2
      CMake/3.18.4                                       cuDNN/8.0.4.30-CUDA-11.1.1
      COMSOL/5.4.0.225                                   cuDNN/8.2.1.32-CUDA-11.3.1
      COMSOL/5.6.0.401                                   cuDNN/8.2.2.26-CUDA-11.4.1
      COMSOL/6.0.0.354                         (D)       cuDNN/8.4.1.50-CUDA-11.7.0
      CUDA/8.0.61                                        cuDNN/8.9.2.26-CUDA-12.1.1
      CUDA/10.1.105                                      cuDNN/9.1.1.17-CUDA-12.4.0
      CUDA/10.1.243                                      cuDNN/9.2.0.82-CUDA-12.4.0
      CUDA/11.3.1                                        cuDNN/9.5.0.50-CUDA-12.6.0     (D)
      CUDA/11.4.1                                        cuSPARSELt/0.6.0.6-CUDA-12.1.1
      CUDA/11.5.0                                        cuTENSOR/1.2.2.5-CUDA-11.1.1
      CUDA/11.6.0                                        cuTENSOR/2.0.1.2-CUDA-12.1.1   (D)
      CUDA/11.7.0                                        ffnvcodec/11.1.5.2
      CUDA/12.0.0                                        ffnvcodec/12.0.16.0
      CUDA/12.1.1                                        ffnvcodec/12.1.14.0
      CUDA/12.4.0                                        ffnvcodec/12.2.72.0            (D)
      CUDA/12.5.0                                        flex/2.6.3
      CUDA/12.6.0                              (D)       flex/2.6.4                     (D)
      CUDAcore/11.0.2                                    foss/2019a
      CUDAcore/11.1.1                          (D)       foss/2019b
      Catch2/2.13.9                                      foss/2020a
      Cereal/1.3.2                                       foss/2020b
      CheckM-Database/2015_01_16                         foss/2021a
      ChimeraX/1.1                                       foss/2021b
    ...
    ``` 

!!! note "<img src="../images/shell-logo_small.png"> Exercise" 

    1. Try listing the available modules. Use either ``module spider`` or ``module avail``, depending on your centre. 
    2. Try checking for a specific software module to see if it is installed: 
        - GROMACS
        - Python
        - OpenFOAM
        - R 
    3. What happens if you change the capitalization when you search for a module? Do you still find it? (Centre-dependent!) 


## Summary 

!!! note 

    - We learned about some of the most useful commands
    - We saw how to find which modules are available at a centre
        - Using ``module spider``
        - Using ``module avail`` 
 
