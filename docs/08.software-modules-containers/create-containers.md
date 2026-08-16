# Creating an Apptainer image 

!!! NOTE 

    You need to be root to do this. Therefore you probably want to do this on your own machine.

## Recipe for building a container

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

## Example: how to install a simple image

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

## Example: create image from scratch

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

## Example: OpenFOAM image with MPI 

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


