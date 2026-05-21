# Installing software from a Git repository

The source code for much bioinformatics software are on Github or other Git repositories. 

How to install from such a repository depends on how the authors have it set up. The repository can always just be cloned and then there is usually a description in the README on how to install. In addition, they will sometimes have a tarball that can be downloaded instead. 

Another case is if it is an R package that is on GitHub, but not on R CRAN. 

Let us look at some examples. 

## Cloning a repository and installing 

## R package from GitHub 

THere are two main paths here; automatic and manual. 

### Automatic download and install from GitHub

If you want to install a package that is not on CRAN, but which do have a GitHub page, then there is an automatic way of installing, but you need to handle prerequsites yourself by installing those first. It can also be that the package is not in as finished a state as those on CRAN, so be careful.

To install packages from GitHub directly, from inside R, you first need to install the ``devtools`` package. **Note** that you only need to install this once.

This is how you install a package from GitHub. It is done from **inside R**: 

```bash
install.packages("devtools")   # ONLY ONCE
devtools::install_github("DeveloperName/package")
```

Remember, if there are any prerequisites, you need to install those first! 

!!! note "Example"

    In this example we want to install the package ``krona``. It is not on CRAN, so let us get it from the GitHub page for the project: <a href="https://github.com/marbl/Krona" target="_blank">https://github.com/marbl/Krona</a> 

We also need to install devtools so we can install packages from GitHub. In addition, has some prerequisites, some on CRAN, some on GitHub, so we need to install those as well.

install.packages("devtools") # ONLY ONCE
install.packages("FinancialInstrument")
install.packages("PerformanceAnalytics")

devtools::install_github("braverock/blotter")
devtools::install_github("braverock/quantstrat")

### Manual download and install

If the package is not on CRAN or you want the development version, or you for other reason want to install a package you downloaded, then this is how to install from the command line:

$ R CMD INSTALL -l <path-to-R-package>/R-package.tar.gz

NOTE that if you install a package this way, you need to handle any dependencies yourself.
