# Using Kebnekaise for Git

Here first follows a brief recap of how to connect. This is followed by a short walk-through of using Git on Kebnekaise. 

## Connecting

We will be using the command line only, but connecting through ThinLinc or OpenOndemand works well also - depending on what you prefer. 

### ThinLinc

* Download the client from https://www.cendio.com/thinlinc/download and install it.
* Start the client. Enter the name of the server: kebnekaise-tl.hpc2n.umu.se and then enter your own username.
* Go to "Options" -> "Security". Check that authentication method is set to password.
* Go to "Options" -> "Screen" and uncheck "Full screen mode".
* Enter your HPC2N password. Click "Connect".

More information here: <a href="https://docs.hpc2n.umu.se/tutorials/connections/#thinlinc" target="_blank">https://docs.hpc2n.umu.se/tutorials/connections/#thinlinc</a>. 

### SSH 

If you prefer to login with a regular SSH client (i.e. PuTTY, Terminal, Linux terminal, etc.) then use the following as server: 

```bash
kebnekaise.hpc2n.umu.se
```

Example: logging in from a terminal:

```bash
ssh <HPC2N username>@kebnekaise.hpc2n.umu.se
```

More information here: 

- <a href="https://docs.hpc2n.umu.se/tutorials/connections/#login__nodes" target="_blank">https://docs.hpc2n.umu.se/tutorials/connections/#login__nodes</a>
- <a href="https://docs.hpc2n.umu.se/tutorials/connections/#connecting__from__windows" target="_blank">Connecting from Windows</a>
- <a href="https://docs.hpc2n.umu.se/tutorials/connections/#connecting__from__macos" target="_blank">Connecting from macOS</a>

### Open OnDemand 

If you prefer to use HPC2N's OpenOnDemand web service, then:

- Go to <a href="https://portal.hpc2n.umu.se" target="_blank">https://portal.hpc2n.umu.se</a>
- Login with your HPC2N username and password
- Pick "Interactive Apps" -> "Kebnekaise desktop"
- Fill in the information. Pick 1 regular core and however many hours you expect to use on the course. Launch 
- After you have logged in, start a terminal: "Applications" -> "System Tools" -> "MATE Terminal" 

More information here: <a href="https://docs.hpc2n.umu.se/tutorials/connections/#open__ondemand" target="_blank">https://docs.hpc2n.umu.se/tutorials/connections/#open__ondemand</a>

## Setting up Git on Kebnekaise

Git is already installed on Kebnekaise, but you need to set your name and email globals *unless you have already done this at some earlier time*. 

* Open a terminal. In ThinLinc: Go to the menu at the top. Click “Applications” → “System Tools” → “MATE Terminal”.
* Set your global name: `$ git config --global user.name "Your Name"`
* Set your global email: `$ git config --global user.email "yourname@example.com"` 

You may also want to set your editor. We recommend vim, but other options are nano and emacs. 

* `$ git config --global core.editor vim`

## Testing your configuration 

Create an example folder and cd into that, then create a file test.txt: 

```bash
$ mkdir <mydir> 
$ cd <mydir>
$ touch test.txt
```

Now initialize a repository and add the new file:

```bash
$ git init
$ git add test.txt
```

Now *commit* the change. The editor which you configured earlier should open. Add an example commit message:

```bash
$ git commit test.txt 
```

Now let us look at the log:

```bash
$ git log
```

When you do `git log`, you should see something like: 

```bash
commit ff8b6f699d98c72d5cffc64d65a1c618b976b45a (HEAD -> master)
Author: Birgitte Brydsö <bbrydsoe@cs.umu.se>
Date:   Thu Sep 17 13:53:59 2020 +0200

    Test of git
```

but with name, email and commit message different.

If that is the case, your Git should be configured correctly. 

## Download the exercise materials

For the individual hands-on part, we have created some exercise materials which you will download from the course repository on GitHub. 

* Course GitHub: <a href="hhttps://github.com/hpc2n/bioinformatics-hpc" target="_blank">https://github.com/hpc2n/bioinformatics-hpc</a>
    - Click the green button labeled "Code" to get links to clone or download the materials. 
* Download the material, then please go to the terminal window where you have downloaded and set up Git.
* Change the directory to wherever you wish to have the course material.
* Copy/transfer the tarball there (or download there directly with `wget <url-to-tarball>`)
* Unpack with `tar zxvf <tarball>`

!!! note

    You will get the entire course material, not just for the Git sessions! The exercises are located under "exercises" and then "6.Git". 

## GitHub and SSH keys

* You need to create an account on GitHub for the course
* You also need to create SSH keys on Kebnekaise and install these on GitHub
* We will go through this in a general way which should work regardless of system you are using
    * We will go through it before the Teamwork session. The material for creating and setting up SSH keys are here: FIX THIS LINK!!!! 
