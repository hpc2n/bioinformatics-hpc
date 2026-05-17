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

## Examples: Simple usage

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

This example uses [this created example image](../create-containers/#example__openfoam__image__with__mpi).

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

More detailed examples and information in the [Create containers](../create-containers) page.

## Specifics of the HPC2N setup

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

## Useful links

You will find more information and examples about using Apptainer and creating images and about containers/Apptainer on the below links: 

- <a href="https://uppmax.github.io/Basic_Singularity_Apptainer/">Basic Singularity/Apptainer course from NAISS</a>
- <a href="https://hub.docker.com/" target="_blank">Docker's library of container images</a>
- <a href="https://ngc.nvidia.com" target="_blank">Nvidia's NGC catalogue including an up-to-date plethora of HPC/AI/Visualization container images verified by Nvidia</a>
- <a href="https://github.com/NVIDIA/hpc-container-maker" target="_blank">Nvidia's HPC Container Maker</a>
- <a href="https://github.com/opencontainers/image-spec" target="_blank">Open Containers Image Specifications</a>
- <a href="https://docs.docker.com/develop/develop-images/multistage-build/" target="_blank">Docker multi-stage build</a>
- <a href="https://apptainer.org/docs/user/latest/mpi.html" title="for version 3.8" target="_blank">Official documentation on Apptainer and MPI applications</a>
- <a href="https://apptainer.org/" target="_blank">The official website</a>
- <a href="https://apptainer.org/docs/" target="_blank">Documentation, user guides, and examples at the official website</a>




PDC also provides some software as containers, found in  ``/pdc/software/sing_hub`` (or ``$PDC_SHUB``). ``singularity exec -B /cfs/klemming <sandbox folder> <myexe>``
