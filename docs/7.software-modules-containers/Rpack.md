# Installing R packages yourself. 

This page is about installing R/CRAN add-ons in your user account

R is a free software environment for statistical computing and graphics. There exists a large number of R add-on packages. The ``R`` modules and bundles like ``R-bundle-bioconductor``, ``R-bundle-CRAN``, and ``R-bundle-CRAN-extra`` has most of the packages available from CRAN. If you need more than those, the quickest and sometimes best solution is to install those add-ons on your own account. Otherwise ask support to have them installed (and usually then added to the R-bundle-CRAN-extra module). 

### Preparations

We need to create a place for the add-ons to be and tell R where to find them. The initial setup only needs to be done once, but separate package directories need to be created for each R version used:

- R reads the <code>$HOME/.Renviron</code> file to setup its environment. It should be created by R on first run, or you can create it with the command: <kbd>touch $HOME/.Renviron</kbd>
- <strong>NOTE: </strong>In this example we are going to assume you have chosen to place the R packages in a directory under your home directory. You will need separate ones for each R version.
- Since the environment file probably is empty now, tell R where your chosen add-on directory is with the command line:<br>
```bash
echo R_LIBS_USER=\"$HOME/R-packages-%V\" > ~/.Renviron
```
- However if it is **not** empty, you can edit <code>$HOME/.Renviron</code> with your favorite editor so that <code>R_LIBS</code> contain the path to your chosen add-on directory. It should look something like this when you are done:<br>
```bash
R_LIBS_USER="/home/u/user/R-packages-%V"
```
    - <strong>NOTE:</strong> Replace "<code>/home/u/user</code>" with the value of <code>$HOME</code>. Run '<code>echo $HOME</code>' to see its value.
    - <strong>NOTE:</strong> The <code>%V</code> should be written as-is, it is substituted at runtime with the active R version.
- For each version of R you are using, create a directory matching the pattern used in <code>.Renviron</code> to store your packages in. This example is shown for R version 3.6.0:<br>
```bash
mkdir -p $HOME/R-packages-3.6.0
```

### Installing R add-ons

There are two ways to install an R add-on from <a href="http://cran.r-project.org/" target="_blank">CRAN</a>, which is not installed on our system. You can either choose the one that automatically downloads the add-on and handles all the dependencies, or one that is somewhat simpler and does not handle dependencies.

#### Automatic download and install

!!! Example 

    In this example we use the <a href="http://cran.r-project.org/web/packages/plyr/index.html" target="_blank">plyr</a> add-on, mostly because it has a dependency (<a href="http://cran.r-project.org/web/packages/Rcpp/index.html" target="_blank">Rcpp</a>).

    - Load the R module first. This example loads the R version 3.5.1: <br>
    ```bash
    ml GCC/7.3.0-2.30  OpenMPI/3.1.1 R/3.5.1
    ```
    - Tell R to install the plyr add-on from the CRAN repo in Sweden (chosen from <a href="http://cran.r-project.org/mirrors.html" target="_blank">CRAN mirror list</a>). We ask R to be quiet and don't bother saving and restoring the environment.<br>
    ```bash
    R --quiet --no-save --no-restore -e "install.packages('plyr', repos='http://ftp.acc.umu.se/mirror/CRAN/')"
    ```
    You get a warning about 'lib' being unspecified. You can safely ignore that.
    

!!! NOTE 

    If the package has dependencies that come from more than one repo it will not work. You either run the "install.packages" interactively in R or use the manual method.

#### Manual download and install

- Download the add-on of interest from <a href="http://cran.r-project.org/" target="_blank">the CRAN Package site</a>. 
- Install from inside R with <code>R CMD INSTALL -l <package></code>

!!! Example 

    1. In this case we download <a href="http://cran.r-project.org/src/contrib/ash_1.0-9.tar.gz" title="http://cran.r-project.org/src/contrib/ash_1.0-9.tar.gz" target="_blank">http://cran.r-project.org/src/contrib/ash_1.0-9.tar.gz</a> (it has no dependencies):<br>
    ```bash
    wget http://cran.r-project.org/src/contrib/ash_1.0-9.tar.gz
    ```
    2. Load the R module. Here we use R version 3.5.1: <br>
    ```bash
    ml GCC/7.3.0-2.30 OpenMPI/3.1.1 R/3.5.1
    ```
    3. Tell R to install it into your chosen add-on directory:<br>
    ```bash
    R CMD INSTALL -l $HOME/R-packages-3.5.1 ash.tar.gz
    ``` 

### Using your package

To use your installed add-ons, start R and just use the following R expression to load the plyr add-on (replacing "plyr" with your add-on):

<div>
```bash
library("plyr")
```
</div>

### More information

For more information about installing and using your own packages see the offical <a href="http://cran.r-project.org/doc/FAQ/R-FAQ.html" target="_blank">FAQ</a> (<a href="http://cran.r-project.org/doc/FAQ/R-FAQ.html" target="_blank">http://cran.r-project.org/doc/FAQ/R-FAQ.html</a>), particularly <a href="http://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-add_002don-packages-be-installed_003f" target="_blank">How can add-on packages be installed</a> and <a href="http://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-add_002don-packages-be-used_003f" target="_blank">How can add-on packages be used?</a>.

