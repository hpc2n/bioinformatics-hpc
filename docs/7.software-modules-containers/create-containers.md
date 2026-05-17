# Containers on Kebnekaise 

<a href="https://en.wikipedia.org/wiki/Containerization_(computing)" target="_blank">Containers</a> are a way to make software applications run in isolated user spaces. These user spaces are called "containers" in any cloud or non-cloud environment. 

There are different container platforms: 

- Docker
- Singularity
- Apptainer
- Kubernetes 
- etc. 

<a href="http://apptainer.org" target="_blank">Apptainer</a> is a successor of Singularity. Both are better than Docker when you do not have root priviliges. 

!!! note

    Apptainer is what is currently used on Kebnekaise. 

## Overview

Apptainer is a is a free, cross-platform and open-source computer program that performs operating-system-level virtualization also known as containerization. It is freely available to users at HPC2N.

Apptainer is a container system for Linux HPC that lets you define your own environment and makes your work portable and reproducible on any system that supports it. A container is a lightweight, stand-alone, executable package of a piece of software that includes everything needed to run it: code, runtime, system tools, system libraries, settings.

!!! note 

    Apptainer enables you to run applications under a different Linux environment than the one you are currently using. This could solve the problem with working with proprietary licensed Linux software that only has support for another Linux distribution.

**Other typical examples when to use Apptainer are:**

- Reproducibility of software contained in a single file that can be used any many HPC centers!
- Software development performed on RHEL7 (or any Linux distribution that is different from the one in use on HPC2N clusters)
- Working with proprietary licensed Linux software that doesn't have support for the Linux distribution used on the HPC2N clusters
- Need the flexibility to work with software immediately on other HPC hardware that runs with Apptainer
- You want to run software quickly because the software versions are rapidly evolving
- Software metadata files are unmanageable (e.g., installing software with Python, R, conda) – a Apptainer container allows for the use of a single compressed image file.

**But it is also important to know when Apptainer is not the best option. For instance:**

- When performance is important. Apptainer generally does not slow down your code but the images are usually not optimized for the HPC2N clusters. 

## Usage at HPC2N 

This section will describe how to use Apptainer at HPC2N, and how it might differ from how it is used at other sites. The official Apptainer documentation can be found at <a href="https://apptainer.org/docs/" target="_blank">https://apptainer.org/docs/</a>.

!!! warning "Note"

    This documentation is meant for Apptainer 1.x!

### Simple usage

!!! hint "Important"

    There is nothing you have to do to use Apptainer, it is directly available. I.e. you do not need to load a module first. 

!!! warning "Note"

    On Kebnekaise's terminal, the command ``singularity`` is available but it is just a soft-link to ``apptainer``. 

!!! NOTE 

    By default Apptainer caches data in the folder ``$HOME/.apptainer``. This can easily fill the 25 GB space of your HOME.
    To avoid this, place the Apptainer cache folder in your project space.

!!! example "Simple example" 

    This very simple example shows how to run the newer version bash using Apptainer. It involves downloading the bash container image once, and then run bash from the image. It is a trivial example and not especially useful but works as an example. 

    In this example we also first place the Apptainer cache in our project space. 

    ```bash
    # Cache folder located in project space
    export APPTAINER_CACHEDIR=/your-project-folder/.apptainer
    # Download image (once)
    apptainer pull docker://bash
    # Run the image
    apptainer exec bash_latest.sif bash
    # Alternative way that works for this image
    ./bash_latest.sif
    ```

!!! example "MPI example" 

    This example uses [this created example image](#example__openfoam__image__with__mpi).

    ```bash
    #!/bin/bash
    #SBATCH -n 4
    #SBATCH -t 00:10:00
    IMAGE=<path to the image>

    # apptainer exec openfoam.sif find / -xdev -iname '*bashrc' -ipath '*foam*'
    FOAM_BASHRC=/opt/OpenFOAM/OpenFOAM-7/etc/bashrc

    # This MPI version should match whatever this command says:
    # apptainer exec openfoam.sif mpirun --version
    ml GCC/10.2.0 OpenMPI/4.0.5

    # Copied OpenFOAM example
    cd damBreak

    # Execute the serial stuff in one apptainer instance
    # Could also be done with three separate apptainer
    # runs with (very) slight extra overhead
    apptainer exec $IMAGE bash -c "
            source $FOAM_BASHRC &&
            blockMesh -case damBreak &&
            setFields -case damBreak &&
            decomposePar -case damBreak
    "       || exit 1

    # execute interFoam in parallel
    srun apptainer exec $IMAGE bash -c "
            source $FOAM_BASHRC &&
            interFoam -parallel -case damBreak &> result.out
    "
    ```

More detailed examples and information in the [Creating an Apptainer image](#creating__an__apptainer__image) section and [running on this page].

### Specifics of the HPC2N setup

When running a Apptainer image at HPC2N, everything below the following directories from the host environment will be available in the running image:

- $HOME
- /pfs
- /afs
- /scratch
- /tmp

As usual, when running batch jobs, data will have to be placed in the directory tree of a storage project (recommended) or in your ``$HOME`` directory tree.

The current configuration have not limited the paths where containers can be stored. Both ``bind control`` and ``fusemount`` are enabled.

## Comparison, Apptainer and Docker

Apptainer and Docker provides similar functionality, but there are some important differences in the way they work.

|   | Docker | Apptainer | 
| - | ------ | --------- | 
| Runs docker containers | X | X | 
| Edits docker containers | X | X | 
| Interacts with host devices (like GPUs) | X | X | 
| Interacts with host filesystems | X | X | 
| Runs without sudo | | X | 
| Runs as host user | | X | 
| Can become root in container | X | X (using fakeroot, not allowed at HPC2N) | 
| Control network interfaces | X | X (using fakeroot, not allowed at HPC2N) | 
| Configurable capabilities for enhanced security | | X |

Containers were created to isolate applications from the host environment. This means that all necessary dependencies are packaged into the application itself, allowing the application to run anywhere containers are supported. With container technology, administrators are no longer bogged down supporting every tool and library under the sun, and developers have complete control over the environment their tools ship with. You can find more <a href="https://en.wikipedia.org/wiki/OS-level_virtualization" target="_blank">information about containers on this page</a>.

## Unsual error messages and the solution

- ``/opt/wine-devel/bin/wine: error while loading shared libraries: cannot allocate symbol search list: Cannot allocate memory``
    - If running applications in a 32 bit image (for example wine), this might actually mean that you have too high values for some settings and for the high addresses the application crashes or fails.
    - Run ``ulimit -a`` in a job using a submit script and on the accessnode to compare the settings between the different environments.
    - The solution is to add ``ulimit -s 8192`` (if the stack is unlimited or too large) in your submit script before calling apptainer, forcing it to have a lower range of the addresses and thus fits better within the 32 bit environment.

## Creating an Apptainer image 

!!! NOTE 

    You need to be root to do this. Therefore you probably want to do this&nbsp;on your own machine.

### Recipe for building a container

```bash
# Header
Bootstrap: docker        # container base from docker
From: ubuntu:18.04       # which version of the base image
```

!!! tip 

    Best-practice for reproducibility is not to use latest but to always specify which OS version to be pulled!

```bash 
%help
Help message to be shown to the user via apptainer help <image_name>
```

```bash 
%labels 
   meta-data such as Author, etc. which can be seen via: apptainer inspect <image>
```

```bash 
%environment # creates Env. Var. within the container 
   export MY_VAR=’MY_ENV_VAR’ 
```

```bash
%files # copy files into the container at build time  
   my_file_to_be_copied.py / # copies to the root of cont. 
```

```bash
%post # include commands that will be executed 
      # once the container environment is set 
apt-get update 
apt-get install -y gcc 

%runscript # specifies a pre-defined workflow 
           # that runs with apptainer run 
   echo “This is the container’s workflow”
```

### Example: how to install a simple image

In this example, the image we create contains OpenBLAS, based on the OS Linux Ubuntu 16.04.

```bash
Bootstrap: docker
From: ubuntu:16.04
%post
  apt-get update
  apt-get install -y libopenblas-base
```

Save this definition file. In this example we call it "openblas.def".

The following is a command example, showing how you would build an image from the above file

```bash
apptainer build openblas.sif openblas.def
```

### Example: create image from scratch

```bash
BootStrap: yum
OSVersion: 7
MirrorURL: http://mirror.centos.org/centos-%{OSVERSION}/%{OSVERSION}/os/$basearch/
Include: yum
UpdateURL: http://mirror.centos.org/centos-%{OSVERSION}/%{OSVERSION}/updates/$basearch/

%runscript
    echo "This is an echo that is executed when you run the container..."

%post
    yum -y install vim-minimal

    # adding a number of rather useful packages
    yum -y install bash
    yum -y install environment-modules
    yum -y install which
    yum -y install less
    yum -y install sudo         # binary has setuid flag, but it is not honored inside apptainer
    yum -y install wget
    yum -y install coreutils    # provide yes
    yum -y install bzip2        # anaconda extract
    yum -y install tar          # anaconda extract
    
    # bootstrap will terminate on first error, so be careful!
    test -d /etc/apptainer || mkdir /etc/apptainer
    touch                          /etc/apptainer/apptainer_bootstart.log
    echo '*** env ***'          >> /etc/apptainer/apptainer_bootstart.log
    env                         >> /etc/apptainer/apptainer_bootstart.log

    # install anaconda python by download and execution of installer script 
    # the test condition is so that subsequent apptainer bootstrap to expand the image don't re-install anaconda
    cd /opt
    [ -f Anaconda3-4.2.0-Linux-x86_64.sh ]] || wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
    [ -d /opt/anaconda3 ] || bash Anaconda3-4.2.0-Linux-x86_64.sh -p /opt/anaconda3 -b     # -b = batch mode, accept license w/o user input
```

### Example: OpenFOAM image with MPI 

Remember that the container needs to have a compatible MPI version inside in order for the host to talk to it. This example is stripped down (mostly to reduce the length of this page) copy from <a href="https://github.com/fertinaz/Singularity-Openfoam" target="_blank">https://github.com/fertinaz/Singularity-Openfoam</a>. 

<strong>Note</strong>: Building this image takes a long time.

```bash
Bootstrap: docker
From: centos:7

%post
    mpi_vrs=4.0.5
    OF_vrs=7
    base=/opt/OpenFOAM

    yum groupinstall -y 'Development Tools' 
    yum install -y wget git openssl-devel libuuid-devel

    wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-${mpi_vrs}.tar.gz
    tar xf openmpi-${mpi_vrs}.tar.gz && rm -f openmpi-${mpi_vrs}.tar.gz
    cd openmpi-${mpi_vrs}
    ./configure --prefix=/opt/openmpi-${mpi_vrs}
    make all install clean

    export MPI_DIR=/opt/openmpi-${mpi_vrs}
    export MPI_BIN=$MPI_DIR/bin MPI_LIB=$MPI_DIR/lib MPI_INC=$MPI_DIR/include
    export PATH=$MPI_BIN:$PATH
    export LD_LIBRARY_PATH=$MPI_LIB:$LD_LIBRARY_PATH

    mkdir -p $base && cd $base
    wget -O - http://dl.openfoam.org/source/$OF_vrs | tar xz
    mv OpenFOAM-$OF_vrs-version-$OF_vrs OpenFOAM-$OF_vrs
    wget -O - http://dl.openfoam.org/third-party/$OF_vrs | tar xz
    mv ThirdParty-$OF_vrs-version-$OF_vrs ThirdParty-$OF_vrs

    cd OpenFOAM-$OF_vrs    
    sed -i 's,FOAM_INST_DIR=$HOME\/$WM_PROJECT,FOAM_INST_DIR='"$base"',g' etc/bashrc
    sed -i 's/alias wmUnset/#alias wmUnset/' etc/config.sh/aliases
    sed -i '77s/else/#else/' etc/config.sh/aliases
    sed -i 's/unalias wmRefresh/#unalias wmRefresh/' etc/config.sh/aliases

    . etc/bashrc 
    ./Allwmake 2>&1 | tee log.Allwmake

    rm -rf platforms/$WM_OPTIONS/applications
    rm -rf platforms/$WM_OPTIONS/src

    cd $base/ThirdParty-$OF_vrs
    rm -rf build
    rm -rf gcc-* gmp-* mpfr-* binutils-* boost* ParaView-* qt-*

    strip $FOAM_APPBIN/*

    echo '. /opt/OpenFOAM/OpenFOAM-7/etc/bashrc' >> $SINGULARITY_ENVIRONMENT

%environment
    export MPI_DIR=/opt/openmpi-4.0.5
    export MPI_BIN=$MPI_DIR/bin
    export MPI_LIB=$MPI_DIR/lib
    export MPI_INC=$MPI_DIR/include

    export PATH=$MPI_BIN:$PATH
    export LD_LIBRARY_PATH=$MPI_LIB:$LD_LIBRARY_PATH
```

## Useful links

You will find more information and examples for creating Apptainer images and about containers/Apptainer on the below links: 

- <a href="https://uppmax.github.io/Basic_Singularity_Apptainer/">Basic Singularity/Apptainer course from NAISS</a>
- <a href="https://hub.docker.com/" target="_blank">Docker's library of container images</a>
- <a href="https://ngc.nvidia.com" target="_blank">Nvidia's NGC catalogue including an up-to-date plethora of HPC/AI/Visualization container images verified by Nvidia</a>
- <a href="https://github.com/NVIDIA/hpc-container-maker" target="_blank">Nvidia's HPC Container Maker</a>
- <a href="https://github.com/opencontainers/image-spec" target="_blank">Open Containers Image Specifications</a>
- <a href="https://docs.docker.com/develop/develop-images/multistage-build/" target="_blank">Docker multi-stage build</a>
- <a href="https://apptainer.org/docs/user/latest/mpi.html" title="for version 3.8" target="_blank">Official documentation on Apptainer and MPI applications</a>
- <a href="https://apptainer.org/" target="_blank">The official website</a>
- <a href="https://apptainer.org/docs/" target="_blank">Documentation, user guides, and examples at the official website</a>


bbrydsoe@enterprise:~/HPC2Ndocs/docs/software$ 

 




PDC also provides some software as containers, found in  ``/pdc/software/sing_hub`` (or ``$PDC_SHUB``). ``singularity exec -B /cfs/klemming <sandbox folder> <myexe>``
