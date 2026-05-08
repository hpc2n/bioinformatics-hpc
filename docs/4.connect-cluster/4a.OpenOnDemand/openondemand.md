# OpenOnDemand 

Open OnDemand is a web service that allows HPC users to schedule jobs, run notebooks and work interactively on a remote cluster from any device that supports a modern browser. The Open OnDemand project was funded by NSF and is currently maintained by the <a href="https://www.osc.edu/" target="_blank">Ohio SuperComputing Centre</a>. Read more about <a href="https://openondemand.org/" target="_blank">OpenOndemand.org</a>.

There is a YouTube video covering parts of this documentation as well. You can find it here: <a href="https://youtu.be/-nx3iXmOhPI?si=NS7B8UuGfxjQEZrn" target="_blank">How to use OpenOnDemand to connect to HPC2N's Kebnekaise cluster</a>.

!!! tip "NOTE"

    Anything you run through OpenOnDemand is already running as a batch job, and will be running on the compute nodes you got allocated. 

!!! note "Access"

    1. In order to access the HPC2N OnDemand Web Portal, point your browser to
    ```bash
    https://portal.hpc2n.umu.se
    ```
    The page will look something like this
    ![Open OnDemand Portal for HPC2N](../../../images/open-ondemand-portal.png){: style="width: 90%;"}
    2. Click the blue button labeled "Login to HPC2N OnDemand"
    3. You are sent to the login window. Put your HPC2N username and password, then click "Sign In"
    4. You will now be on the HPC2N Open OnDemand dashboard. The top of it looks like this:
    ![Open OnDemand Dashboard](../../../images/open-ondemand-dashboard.png){: style="width: 90%;"}

!!! note "Overview - dashboard"

    Looking at the top of the HPC2N Open OnDemand dashboard
    ![Open OnDemand Dashboard](../../../images/open-ondemand-dashboard.png){: style="width: 90%;"}
    <br>you find several menu points:

    - **Files**: Links to a file browser that starts in either your home directory or in (one of) your project storage directories
    - **Jobs**: Links to a list of your "Active Jobs" and to a "Job Composer" to create new jobs
    - **Clusters**: the submenu is for shell access (does not currently work)
    - **Interactive Apps**: a list of apps that can be started directly from the dashboard (currently Jupyter, MATLAB, RStudio, VSCode)
    ![Open OnDemand Apps](../images/open-ondemand-apps.png){: style="width: 90%;"}
    - **My Interactive Sessions**: here you find your **active** interactive sessions, for instance Jupyter, MATLAB, etc. You can enter them again as long as they are active, and you can delete them. It could look like this if you have active sessions of MATLAB, the Kebnekaise desktop, and Jupyter notebook:
    ![Open OnDemand Dashboard](../../../images/open-ondemand-sessions.png){: style="width: 90%;"}
    - as well as a logout button to the right in the menu.

Now let us look a little closer at how to use the various Interactive Apps in the Open OnDemand desktop. Right now there are: Kebnekaise desktop, Jupyter notebook, MATLAB, RStudio, and VS Code, but that may change in the future.

Generally, they are started in the same way, with minor differences. As examples we will look at "Kebnekaise desktop" and "Jupyter Notebook". 

## Interactive Apps - Kebnekaise desktop 

This is the first submenu point, under "Interactive Apps" -> "Desktops".
After clicking it, you will after a few moments get this:

![Open OnDemand Kebnekaise desktop](../../../images/open-ondemand-desktop.png){: style="width: 90%;"}

!!! note

    This is used to start a desktop on one of the compute nodes after you have allocated resources.

    This means you will be able to work as if on that node. That means that anything you run from the desktop immediately runs on the allocated resources, without you having to start (another) job.

    Very useful if you want to work interactively with one of the installed pieces of software or your own code.

    In addition to starting programs from the terminal, there are various applications available directly from the menu, like Libreoffice and Firefox.

Let us look at the options for launching this, one by one:

- **Desktop Environment**: Here you can choose either "mate" (resembles Gnome 2/classic) or "xfce" (lightweight and fast). Personal preferrence.
- **Compute Project**: Dropdown menu where you can choose (one of) your compute projects to launch with.
- **Number of hours**: How long you want the job available for. Here you can choose 1-12 hours, but beware that it is a bad idea to pick longer than you need. Not only will it take longer to start, but it will also use up your allocation even if you are not actively doing anything on the desktop. Pick as long as you need to do your job.
- **Number of cores**: How many cores you want access to. You can choose 1-28 and they each have 4GB memory. This is only a valid field to choose if you pick "any" or "Large memory" for the "Node type" selection.
- **Node type**: Here you can choose "any", "any GPU", or "Large memory". If you pick "any GPU" you will not pick anything for "Number of cores".

You can tick the box "I would like to receive an email when the session starts" if you want that. Depending on your choices (mainly number of hours and number of cores), it can take longer or shorter to launch your job.

**Note** that you cannot choose type of CPU or type of GPU here.

After you have made the choices, click "Launch".

You can find all the active sessions under "My Interactive Sessions" and you can shut one down with "Delete". You can also shut it down from inside the desktop. 
!!! note "Example" 

    In this example we start a desktop for 1 hour, and with 4 cores. We then start a terminal inside it. 

!!! note "Filling options"

    This is how it could look, for 1 hour, 4 cores

    ![Open OnDemand Kebnekaise desktop](../images/open-ondemand-desktop-options.png){: style="width: 90%;"}

!!! note "Waiting to launch"

    Then, this is how it looks while it is waiting to start/sitting in queue

    ![Open OnDemand Kebnekaise desktop](../images/open-ondemand-desktop-starting.png){: style="width: 90%;"}

!!! note "Ready"

    Then, when the resources have been allocated and you can go to the desktop

    ![Open OnDemand Kebnekaise desktop](../images/open-ondemand-desktop-started.png){: style="width: 90%;"}

!!! note "Desktop - mate"

    This is how the desktop could look, running "mate" desktop environment

    ![Open OnDemand Kebnekaise desktop](../images/open-ondemand-desktop-mate.png){: style="width: 90%;"}

When you have a desktop open on the allocated resources, you have the option to run

- one of the applications that can be launched from the menu
    - Libreoffice
    - Firefox
    - editors
    - a terminal/shell to load modules and start programs
- a terminal/shell where you can
    - run your own code
    - load modules and run installed software

!!! note "Start a terminal to run something"

    You can now work as normal, from a desktop on the resources you allocated. Anything you run there will run on those resources, and they are available for the time you asked for.

    To start a terminal, for instance, you find "MATE terminal" in the menu:     

    ![Open OnDemand Kebnekaise desktop](../images/open-ondemand-desktop-terminal.png){: style="width: 90%;"}

