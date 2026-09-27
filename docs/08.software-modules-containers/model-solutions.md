# Model solutions for Extra exercises 

These exercises are meant as extra (optional) training and can be done either during classes if there is time, or later.

## Finding existing modules  

1. Finding versions
    - Find which R versions exist
        - Answer: use `module spider R` to get 
          ```bash
          R/4.3.2
          R/4.4.1
          R/4.4.2
          R/4.5.1
          R/4.5.2
          ```
    - What are the prerequisites for R/4.5.2?
        - Answer: use `module spider R/4.5.2` to get `GCC/14.3.0`
    - Which versions of Python exist?
        - Answer: use `module spider Python` to get 
          ```bash
          Python/2.7.18
          Python/3.8.6
          Python/3.11.3
          Python/3.11.5
          Python/3.12.3
          Python/3.13.1
          Python/3.13.5
          Python/3.14.2
          ```
    - What are the prerequisites for Python/3.13.5?
        - Answer: use `module spider Python/3.13.5` to get `GCCcore/14.3.0`     
    - Find the versions of the module R-bundle-Bioconductor
        - Answer: use `module spider R-bundle-Bioconductor` to get
          ```bash
          R-bundle-Bioconductor/3.18-R-4.3.2
          R-bundle-Bioconductor/3.19-R-4.4.1
          R-bundle-Bioconductor/3.20-R-4.4.2
          R-bundle-Bioconductor/3.22-R-4.5.1
          R-bundle-Bioconductor/3.22-R-4.5.2
          ```
    - What are the prerequisites for R-bundle-Bioconductor/3.22-R-4.5.2?
        - Answer: use `module spider R-bundle-Bioconductor/3.22-R-4.5.2` to get `GCC/14.3.0  OpenMPI/5.0.8`

## Loading modules 

1. Loading modules
    - Load R-bundle-Bioconductor/3.22-R-4.5.2 (after first loading any prerequisites).
      ```bash
      b-an01 [~]$ module load GCC/14.3.0  OpenMPI/5.0.8 
      b-an01 [~]$ module load R-bundle-Bioconductor/3.22-R-4.5.2
      ```
    - List the modules that are loaded. 
      ??? info "Click to expand" 
      ```bash
      b-an01 [~/bbafs]$ module list
  
      Currently Loaded Modules:
        1) snicenvironment     (S)  48) elfutils/0.193          95) JasPer/4.2.8
        2) systemdefault       (S)  49) libdrm/2.4.125          96) LittleCMS/2.17
        3) GCCcore/14.3.0           50) libunwind/1.8.2         97) Pango/1.57.0
        4) zlib/1.3.1               51) nettle/3.10.2           98) ImageMagick/7.1.2-7
        5) binutils/2.44            52) OpenGL/2025.09          99) GLPK/5.0
        6) GCC/14.3.0               53) pixman/0.46.4          100) nodejs/22.17.1
        7) numactl/2.0.19           54) libiconv/1.18          101) cffi/1.17.1
        8) XZ/5.8.1                 55) gettext/0.25           102) cryptography/45.0.5
        9) libxml2/2.14.3           56) PCRE2/10.45            103) virtualenv/20.32.0
       10) libpciaccess/0.18.1      57) GLib/2.85.3            104) Python-bundle-PyPI/2025.07
       11) hwloc/2.12.1             58) cairo/1.18.4           105) SciPy-bundle/2025.07
       12) OpenSSL/3                59) libjpeg-turbo/3.1.1    106) GEOS/3.13.1
       13) libevent/2.1.12          60) jbigkit/2.1            107) PCRE/8.45
       14) UCX/1.19.0               61) libdeflate/1.24        108) nlohmann_json/3.12.0
       15) PMIx/5.0.8               62) LibTIFF/4.7.0          109) PROJ/9.6.2
       16) PRRTE/3.0.11             63) giflib/5.2.2           110) libgeotiff/1.7.4
       17) UCC/1.4.4                64) libwebp/1.5.0          111) Szip/2.1.1
       18) OpenMPI/5.0.8            65) Java/21 -> Java/21.0.8 112) libtirpc/1.3.6
       19) OpenBLAS/0.3.30          66) libgit2/1.9.1          113) HDF/4.3.1
       20) FlexiBLAS/3.4.5          67) libidn2/2.3.8          114) Eigen/3.4.0
       21) FFTW/3.3.10              68) libunistring/1.3       115) arpack-ng/3.9.1
       22) FFTW.MPI/3.3.10          69) libpsl/0.21.5          116) Armadillo/15.0.1
       23) ScaLAPACK/2.2.2-fb       70) cURL/8.14.1            117) CFITSIO/4.6.2
       24) bzip2/1.0.8              71) Tk/9.0.1               118) json-c/0.18
       25) expat/2.7.1              72) ICU/77.1               119) Xerces-C++/3.3.0
       26) libpng/1.6.50            73) HarfBuzz/11.4.1        120) Imath/3.1.12
       27) Brotli/1.1.0             74) FriBidi/1.0.16         121) OpenEXR/3.3.4
       28) freetype/2.13.3          75) R/4.5.2                122) Brunsli/0.1
       29) ncurses/6.5              76) Boost/1.88.0           123) Qhull/2020.2
       30) libreadline/8.2          77) GSL/2.8                124) LERC/4.0.0
       31) libtommath/1.3.0         78) NLopt/2.10.0           125) OpenJPEG/2.5.3
       32) Tcl/9.0.1                79) libogg/1.3.6           126) SWIG/4.3.1
       33) SQLite/3.50.1            80) FLAC/1.5.0             127) netCDF/4.9.3
       34) util-linux/2.41          81) libvorbis/1.3.7        128) snappy/1.2.2
       35) fontconfig/2.17.0        82) libopus/1.5.2          129) RapidJSON/1.1.0-20250205
       36) xorg-macros/1.20.2       83) LAME/3.100             130) Abseil/20250512.1
       37) X11/20250608             84) libsndfile/1.2.2       131) RE2/2025-07-22
       38) libffi/3.5.1             85) libaec/1.1.4           132) utf8proc/2.10.0
       39) Python/3.13.5            86) Perl/5.40.2            133) Arrow/22.0.0
       40) GMP/6.3.0                87) HDF5/1.14.6            134) GDAL/3.11.3
       41) Z3/4.15.1                88) UDUNITS/2.2.28         135) MPFR/4.2.2
       42) gzip/1.14                89) Ghostscript/10.05.1    136) PostgreSQL/17.5
       43) lz4/1.10.0               90) freeglut/3.6.0         137) R-bundle-CRAN/2025.11
       44) zstd/1.5.7               91) libde265/1.0.16        138) arrow-R/22.0.0-R-4.5.2
       45) LLVM/20.1.8              92) x265/4.1               139) R-bundle-Bioconductor/3.22-R-4.5.2
       46) Wayland/1.24.0           93) Gdk-Pixbuf/2.42.12
       47) libarchive/3.8.1         94) libheif/1.20.2

         Where:
            S:  Module is Sticky, requires --force to unload or purge
      ```
    - What got loaded? Was it more than you expected? 
      - Answer: so many modules. Both for R and the various R packages prerequisite for the packages in the bundle. 
2. Unloading modules
    - Try and unload one of the modules. What happens if it is a prerequisite? 
      ```bash
      $ module unload GDAL/3.11.3
      Lmod Warning: 
      ----------------------------------------------------------------------------------------------------------------------
      The following dependent module(s) are not currently loaded: GDAL/3.11.3 (required by: R-bundle-CRAN/2025.11)
      ----------------------------------------------------------------------------------------------------------------------
      ```
      or
      ```bash
      $ module unload GCC/14.3.0

      Inactive Modules:
        1) Abseil/20250512.1      29) OpenMPI/5.0.8                         57) binutils/2.44          85) libopus/1.5.2
        2) Arrow/22.0.0           30) OpenSSL/3                             58) bzip2/1.0.8            86) libpciaccess/0.18.1
        3) Boost/1.88.0           31) PCRE2/10.45                           59) cURL/8.14.1            87) libpng/1.6.50
        4) Brotli/1.1.0           32) PMIx/5.0.8                            60) cairo/1.18.4           88) libpsl/0.21.5
        5) FFTW.MPI/3.3.10        33) PRRTE/3.0.11                          61) cffi/1.17.1            89) libreadline/8.2
        6) FFTW/3.3.10            34) Pango/1.57.0                          62) cryptography/45.0.5    90) libsndfile/1.2.2
        7) FLAC/1.5.0             35) Perl/5.40.2                           63) elfutils/0.193         91) libtommath/1.3.0
        8) FlexiBLAS/3.4.5        36) PostgreSQL/17.5                       64) expat/2.7.1            92) libunistring/1.3
        9) FriBidi/1.0.16         37) Python-bundle-PyPI/2025.07            65) fontconfig/2.17.0      93) libunwind/1.8.2
       10) GLPK/5.0               38) Python/3.13.5                         66) freeglut/3.6.0         94) libvorbis/1.3.7
       11) GLib/2.85.3            39) R-bundle-Bioconductor/3.22-R-4.5.2    67) freetype/2.13.3        95) libwebp/1.5.0
       12) GMP/6.3.0              40) R-bundle-CRAN/2025.11                 68) giflib/5.2.2           96) libxml2/2.14.3
       13) GSL/2.8                41) R/4.5.2                               69) gzip/1.14              97) lz4/1.10.0
       14) Gdk-Pixbuf/2.42.12     42) RE2/2025-07-22                        70) hwloc/2.12.1           98) nettle/3.10.2
       15) Ghostscript/10.05.1    43) RapidJSON/1.1.0-20250205              71) jbigkit/2.1            99) nodejs/22.17.1
       16) HDF5/1.14.6            44) SQLite/3.50.1                         72) libaec/1.1.4          100) numactl/2.0.19
       17) HarfBuzz/11.4.1        45) ScaLAPACK/2.2.2-fb                    73) libarchive/3.8.1      101) pixman/0.46.4
       18) ICU/77.1               46) SciPy-bundle/2025.07                  74) libde265/1.0.16       102) snappy/1.2.2
       19) ImageMagick/7.1.2-7    47) Tcl/9.0.1                             75) libdeflate/1.24       103) utf8proc/2.10.0
       20) JasPer/4.2.8           48) Tk/9.0.1                              76) libdrm/2.4.125        104) util-linux/2.41
       21) LAME/3.100             49) UCC/1.4.4                             77) libevent/2.1.12       105) virtualenv/20.32.0
       22) LLVM/20.1.8            50) UCX/1.19.0                            78) libffi/3.5.1          106) x265/4.1
       23) LibTIFF/4.7.0          51) UDUNITS/2.2.28                        79) libgit2/1.9.1         107) xorg-macros/1.20.2
       24) LittleCMS/2.17         52) Wayland/1.24.0                        80) libheif/1.20.2        108) zlib/1.3.1
       25) MPFR/4.2.2             53) X11/20250608                          81) libiconv/1.18         109) zstd/1.5.7
       26) NLopt/2.10.0           54) XZ/5.8.1                              82) libidn2/2.3.8
       27) OpenBLAS/0.3.30        55) Z3/4.15.1                             83) libjpeg-turbo/3.1.1
       28) OpenGL/2025.09         56) arrow-R/22.0.0-R-4.5.2                84) libogg/1.3.6

      Due to MODULEPATH changes, the following have been reloaded:
        1) gettext/0.25     2) ncurses/6.5
      ```
      or
      ```bash
      $ module unload R-bundle-Bioconductor/3.22-R-4.5.2
      ```
    - Do `module purge`. Did everything get unloaded? What did not? 
      ```bash
      $ module purge
      The following modules were not unloaded:
        (Use "module --force purge" to unload all):

        1) snicenvironment   2) systemdefault
      ```
      The environment variables and some other system settings did not get unloaded. That is as it should be. 

## Toolchains 

1. What are compiler toolchains?
    - Answer: they are compatible groups of C and Fortran compilers, MPI libraries, linear algebra libraries, and other fundamental programs used internally by more familiar packages that users work with directly (e.g., Python, R, GROMACS, etc.).
2. How come you can see the compiler toolchains with `ml avail`?
    - Answer: they do not have prerequisites that must be loaded first. 
3. What is included in `foss/2023b`? 
    - Answer: use `module show foss/2023b` to see that it contains `GCC/13.2.0`, `OpenMPI/4.1.6`, `FlexiBLAS/3.3.1`, `FFTW/3.3.10`, `FFTW.MPI/3.3.10`, `ScaLAPACK/2.2.0-fb` 
4. List all `foss` and `ìntel` compiler toolchains. 
    - Answer: 
      ```bash
      $ ml avail foss

      --------------------------------------------- /hpc2n/eb/modules/all/Core ---------------------------------------------
         foss/2023a    foss/2023b    foss/2024a    foss/2025a    foss/2025b    foss/2026.1 (D)    lfoss/2025b
      ```
      ```bash 
      $ ml avail intel

      --------------------------------------------- /hpc2n/eb/modules/all/Core ---------------------------------------------
         intel-compilers/2023.1.0    intel-compilers/2025.1.1        intel/2023a    intel/2025a
         intel-compilers/2023.2.1    intel-compilers/2025.2.0        intel/2023b    intel/2025b
         intel-compilers/2024.2.0    intel-compilers/2025.3.3 (D)    intel/2024a    intel/2026.1 (D)
      ```

## Software module examples 

1. Which prerequisites does `mpi4py` have?
   - Answer: use `ml spider mpi4py` to find the available versions and then pick one and do `ml spider mpi4py/4.1.0` to get `GCC/14.2.0 OpenMPI/5.0.7` or `GCC/14.3.0 OpenMPI/5.0.8`
2. How many version of SciPy-bundle are there?
   - Answer: use `ml spider SciPy-bundle` to find 
     ```bash
     SciPy-bundle/2023.07
     SciPy-bundle/2023.11
     SciPy-bundle/2024.05
     SciPy-bundle/2024.06-Python-2.7.18
     SciPy-bundle/2025.06
     SciPy-bundle/2025.07
     SciPy-bundle/2026.05
     ```
3. Is OpenMPI included when you load SciPy-bundle or is it a prerequisite?
    - Answer: pick one of the above versions and use `module spider SciPy-bundle/2026.05` to check. The answer is that only `GCC/15.2.0` is a prerequisite. Load `GCC/15.2.0` and then load `SciPy-bundle/2026.05`. Use `ml` or `module list` to find that OpenMPI is neither a prerequisite nor is it loaded with the SciPy-bundle. Previously, `mpi4py` was loaded with SciPy-bundle and so had `OPenMPI` as a prerequisite. 
4. What are the prerequisites of `R-bundle-CRAN`? 
    - Answer: use `ml spider R-bundle-CRAN` to find the versions. Pick one of them and use `module spider R-bundle-CRAN/2025.11` to find its prerequisites, which are `GCC/14.3.0 OpenMPI/5.0.8`
5. Find out the installed versions of Nextflow and how to load the newest one. 
    - Answer: Use `ml spider nextflow` to find 
      ```bash
      Nextflow/23.04.2
      Nextflow/24.04.2
      Nextflow/25.10.0
      ```
      Then use `ml spider Nextflow/25.10.0` to find that you can load it directly. 
6. Does BioPython load Python? 
    - Answer: Using `ml spider biopython` we find that there is only one version installed, `Biopython/1.87` and that it has `GCC/15.2.0` as a prerequisite. 
      Loading it (`module load GCC/15.2.0 Biopython/1.87`) and then doing `module list` or `ml` shows that it indeed loads Python, namely `Python/3.14.2`. 

## Modules in batch scripts 

- How do you load a module in a batch script? Do you need to load any prerequisites? 
    - Answer: You load it the same way as you load them on the command line. If the module has prerequisites on the command line, then it also has in the batch script and you must load them first.    

## Containers on Kebnekaise 

1. Which container platform is used on Kebnekaise? 
    - Answer: Apptainer (Singularity is a symbolic link to Apptainer) 
2. Do you need to load a module to make containers available on Kebnekaise? 
    - Answer: No, apptainer is directly available on Kebnekaise without loading anything. 
3. Can you run a downloaded Docker image at Kebnekaise? 
    - Answer: Yes, but it must first be converted to apptainer before you can run it. This is done like this: `apptainer build <myapptainerimage>.sif docker://hostname/repository/imagename:tag` See [the example in the material](https://hpc2n.github.io/bioinformatics-hpc/08.software-modules-containers/containers-kebnekaise/#exerciseexample) for how to do this. 
4. Download a docker image from `https://hub.docker.com/u/biocontainers` to your project directory space on Kebnekaise and convert it to an apptainer image file. Example: `beast2` - or pick an image yourself. 
    - Answer: You also need to convert to apptainer, aside from download. This does both and is for `beast2` (see https://hub.docker.com/r/biocontainers/beast2-mcmc): `apptainer build mybeast2.sif docker://biocontainers/beast2-mcmc:v2.5.1dfsg-2-deb_cv1`
5. Execute your apptainer image with apptainer. If it is a graphical tool you need to use OpenOnDemand (or SSH with x11 forwarding). 
    - Answer: You need the `.sif` apptainer image you downloaded/created and then you execute the program this way, using the regular commands and input files: `apptainer exec -B $PWD:$PWD <myapptainerimage>.sif PROGRAM-COMMAND [OPTIONS] [input and output files]` 


