# Connecting to a compute cluster (Kebnekaise)

In this session we will look at connecting to Kebnekaise, with specifics dependent on the operating system you are using.

There are several ways to connect:

- Through ThinLinc (client and web)
- Through Open OnDemand
- Through regular SSH (Windows) (macOS) (Linux/Unix)

The two former are best if you want a graphical interface, while the latter is best for text-based interaction as well as connecting when you have a slow connection. 

??? note "Login nodes/access" 

    === "SSH" 

        Kebnekaise main SSH login node

        ``kebnekaise.hpc2n.umu.se``

        Kebnekaise AMD Zen3 login node (since Kebnekaise is a heterogeneous system, the different architectures often have different software (versions). In order to see what is available, and to compile for the correct architecture, there are a few login nodes available.) This for AMD: 

        ``kebnekaise-amd.hpc2n.umu.se``

    === "ThinLinc" 

        Kebnekaise ThinLinc login node

        ``kebnekaise-tl.hpc2n.umu.se``

        Kebnekaise ThinLinc AMD Zen3 login node (since Kebnekaise is a heterogeneous system, the different architectures often have different software (versions). In order to see what is available, and to compile for the correct architecture, there are a few login nodes available.) This for AMD: 

        ``kebnekaise-amd-tl.hpc2n.umu.se``

        ThinLinc can be used as a stand-alone client and through a web browser. See below for details.

    === "URL for Open OnDemand"

        https://portal.hpc2n.umu.se

!!! NOTE

    Remember that the accounts at HPC2N and SUPR are separate. In the welcome mail you got when your HPC2N account was created there was a link to create <a href="https://www.hpc2n.umu.se/forms/user/suprauth?action=pwreset" target="_blank">a first, temporary password</a>. When you have logged in using that, [please change the password](https://docs.hpc2n.umu.se/documentation/access/#first__time__login__password__change).

