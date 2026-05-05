# File systems 

This section will be a basic overview of the Linux filesystem concepts, not an in-depth description of filesystem types. 
When we come to the "Introduction to Linux" session, we will look more at commands to navigate and modify the filesystem. 

!!! note 

    A file system is a hierarchical structure of directories/folders used by the operating system to manage, organize, store, and retrieve data from storage devices (SSG, HDD, USB, ...) 

    It is an interface between applications and hardware. 

    Windows, macOS, Linux/Unix, etc. all use file systems. Often they are "hidden" to the user when using a graphical interface, especially as files are commonly found by searching. Many applications save to specific directories and remember where files were last placed, and so can quickly offer the correct file to the user. 

![Tree of dir structure](../../images/tree.png){: style="width: 400px;float: right"}

The Linux filesystem directory structure starts with the top root directory, which is shown as `/`. Below this are several other standard directories. Of particular interest are `usr/bin`, `home`, `usr/lib`, and `usr/lib64`. A common directory which you will also often find is `usr/local/bin`.

Shown with folders, part of it would look like this: 

![Folders of the file system, Linux](../../images/filesystem-folders.png){: style="width: 400px;float: right"}

The picture on the right shows typical subdirectories under `/` (note that the command `tree` does not work at all HPC centers, though it does work on Tetralith---see the page [tree](../tree) under the "Extras" section for how to install if it is missing). Some of the directories have a **symbolic link** to a different name---this is often done to make it quicker to write, but can also be for compatibility reasons since some software have hardcoded paths.

!!! Note

    The `path` or `pathname` is the representation of the location of a file or folder/directory on a computer file system.

- **/** is the root of the directory structure on a Linux filesystem
- **/usr/bin** contains (most) of the system-specific binaries
- **/usr/local/bin** holds non-system binaries. often locally compiled/maintained packages
- **/home** is where the home directories of the users of the system are located
- **/usr/lib** holds kernel modules and shared library images needed to boot the system and run commands in the root filesystem
- **/usr/lib64** is the same as **/usr/lib**, just for 64-bit libraries

User installed binaries are often located in **/opt**.

The file system could also be illustrated like this:

![folders of filesystem structure](images/filesystem-folders.png){: style="width: 500px;float: left"}

!!! important "Note about `/`"

    The character `/` can be

    1. the root directory, if it appears alone or at the front of a file or directory name
    2. a separator if it appears in other positions within the path.

!!! note

    If you are on a local cluster, on an HPC center, etc. where you are not root, you will be in your home directory by default when you login. You can use `cd ..` a couple times to go to the root of the system and do `tree` there if you want, or do `tree` in your home directory (you can always return there with just `cd`).

!!! caution

    Running `tree` in `/` on a supercomputing center will probably give a very large/long output!

### Home folders on Tetralith

![home folders file structure](images/homefolders-focus.png){: style="width: 500px;float: left"}
<br><br style="clear: both;">

The above shows an illustration where the home folders are emphasized.

## Your home directory

When you login to the computer (as a non root user), you will end up in your home directory. At most HPC centers, your home directory will appear as `~` in the terminal prompt, and can also be used in commands instead of having to type out `/home/YOUR_USERNAME`.

The `path` to your home directory varies somewhat. Here are some examples for me:

- Tetralith: `/home/x_birbr`
- Kebnekaise: `/home/b/bbrydsoe`
- Cosmos: `/home/bbrydsoe`
- My laptop, ncc-1701: `/home/bbrydsoe`
- My home desktop, defiant: `/home/bbrydsoe`

!!! note

    You can always use the command `pwd` to see the path to your current working directory!

    You can also always return to your home directory by giving the command `cd` and pressing `enter`.

There are is also an "environment variable" that can be used as shortcut for the path: `$HOME`. We will talk more about (environment) variables later.

## pwd

The command `pwd` (**p**rint **w**orking **d**irectory) will print out the full pathname of the working directory to the screen.

You can use this to find out which directory you are in.

### Example, in your home directory 

=== "On Tetralith"

     user ``x_birbr``:

     ```bash
     [x_birbr@tetralith3 ~]$ pwd
     /home/x_birbr
     [x_birbr@tetralith3 ~]$
     ```

=== "On Dardel"

    user ``bbrydsoe``:

    ```bash
    bbrydsoe@login1:~> pwd
    /cfs/klemming/home/b/bbrydsoe
    bbrydsoe@login1:~>
    ```

=== "On Alvis"

    user ``brydso``:

    ```bash
    [brydso@alvis2 ~]$ pwd
    /cephyr/users/brydso/Alvis
    [brydso@alvis2 ~]$
    ```

=== "On Kebnekaise"

     user ``bbrydsoe``:

     ```bash
     b-an01 [~]$ pwd
     /home/b/bbrydsoe
     b-an01 [~]$
     ```

=== "On Cosmos"

     user ``bbrydsoe``:

     ```bash
     [bbrydsoe@cosmos1 ~]$ pwd
     /home/bbrydsoe
     [bbrydsoe@cosmos1 ~]$
     ```

### Example, in a directory named `testdir`

On Tetralith, user ``x_birbr``:

```bash
[x_birbr@tetralith3 testdir]$ pwd
/home/x_birbr/testdir
[x_birbr@tetralith3 testdir]$
```

### Example, in subdirectory `mydir` under directory `testdir`

On Tetralith, user ``x_birbr``:

```bash
[x_birbr@tetralith3 mydir]$ pwd
/home/x_birbr/testdir/mydir
[x_birbr@tetralith3 mydir]$
```

## ls - listing files/directories

The `ls` command is used to list files and/or directories. If you just give the command `ls` with no flags, it will list all files and subdirectories in the current directory except for hidden files.

<div>
```bash
ls [flags] [directory]
```
</div>

This way you can to list files/subdirectories for any directory, but the default one is the one you are currently standing in.

Some examples:

- `ls /` lists contents of the root directory
- `ls ..` lists the contents of the parent directory of the current
- `ls ~` lists the contents of your user home directory
- `ls *` lists contents of current directory and subdirectories

!!! Note "Commonly used flags"

    - `-a` lists content including hidden files and directories
    - `-l` lists content in long table format (permissions, owners, size in bytes, modification date/time, file/directory name)
    - `-lh` adds an extra column to above representing size of each file/directory
    - `-t` lists content sorted by last modified date in descending order
    - `-tr` lists content sorted by last modified date in ascending order
    - `-s` list files with their sizes

To get more flags, type `ls --help` or `man ls` in the terminal to see the manual.

!!! tip

    You can often get more info on flags/options and usage for a Linux command with

    - `COMMAND --help`
    - `man COMMAND`

    where COMMAND is the Linux command you want information about, like `ls`, `mkdir`, etc.

!!! Example "The output for a few of the flags, for a directory with two subdirectories and some files"

    ```bash
    [x_birbr@tetralith1 mytestdir]$ ls
    myfile.txt  myotherfile.txt  testdir1  testdir2

    [x_birbr@tetralith1 mytestdir]$ ls -a
    ./  ../  myfile.txt  myotherfile.dat  testdir1/  testdir2/

    [x_birbr@tetralith1 mytestdir]$ ls -l
    total 3
    -rw-rw-r-- 1 x_birbr x_birbr   27 Sep 11 11:43 myfile.txt
    -rw-rw-r-- 1 x_birbr x_birbr   33 Sep 11 11:43 myotherfile.txt
    drwxrwxr-x 2 x_birbr x_birbr 4096 Sep 11 11:40 testdir1
    drwxrwxr-x 2 x_birbr x_birbr 4096 Sep 11 11:39 testdir2

    [x_birbr@tetralith1 mytestdir]$ ls -la
    total 5
    drwxrwxr-x 4 x_birbr x_birbr 4096 Sep 11 11:43 .
    drwx------ 3 x_birbr x_birbr 4096 Sep 11 11:43 ..
    -rw-rw-r-- 1 x_birbr x_birbr   27 Sep 11 11:43 myfile.txt
    -rw-rw-r-- 1 x_birbr x_birbr   33 Sep 11 11:43 myotherfile.txt
    drwxrwxr-x 2 x_birbr x_birbr 4096 Sep 11 11:40 testdir1
    drwxrwxr-x 2 x_birbr x_birbr 4096 Sep 11 11:39 testdir2

    [x_birbr@tetralith1 mytestdir]$ ls -lah
    total 5.0K
    drwxrwxr-x 4 x_birbr x_birbr 4.0K Sep 11 11:43 .
    drwx------ 3 x_birbr x_birbr 4.0K Sep 11 11:43 ..
    -rw-rw-r-- 1 x_birbr x_birbr   27 Sep 11 11:43 myfile.txt
    -rw-rw-r-- 1 x_birbr x_birbr   33 Sep 11 11:43 myotherfile.txt
    drwxrwxr-x 2 x_birbr x_birbr 4.0K Sep 11 11:40 testdir1
    drwxrwxr-x 2 x_birbr x_birbr 4.0K Sep 11 11:39 testdir2

    [x_birbr@tetralith1 mytestdir]$ ls -latr
    total 5
    drwxrwxr-x 2 x_birbr x_birbr 4096 Sep 11 11:39 testdir2
    drwxrwxr-x 2 x_birbr x_birbr 4096 Sep 11 11:40 testdir1
    -rw-rw-r-- 1 x_birbr x_birbr   27 Sep 11 11:43 myfile.txt
    -rw-rw-r-- 1 x_birbr x_birbr   33 Sep 11 11:43 myotherfile.txt
    drwx------ 3 x_birbr x_birbr 4096 Sep 11 11:43 ..
    drwxrwxr-x 4 x_birbr x_birbr 4096 Sep 11 11:43 .

    [x_birbr@tetralith1 mytestdir]$ ls *
    myfile.txt  myotherfile.dat

    testdir1:
    file1.txt  file2.sh  file3.c  file4.dat

    testdir2:
    file1.txt  file2.txt  file3.c

    [x_birbr@tetralith1 mytestdir]$ cd testdir1
    b-an01 [~/mytestdir/testdir1]$ ls -l
    total 2
    -rw-rw-r-- 1 x_birbr x_birbr 31 Sep 11 11:47 file1.txt
    -rw-rw-r-- 1 x_birbr x_birbr 16 Sep 11 11:49 file2.sh
    -rw-rw-r-- 1 x_birbr x_birbr 74 Sep 11 11:49 file3.c
    -rw-rw-r-- 1 x_birbr x_birbr 25 Sep 11 11:50 file4.dat

    [x_birbr@tetralith1 mytestdir]$ ls -ls
    total 2
    1 -rw-rw-r-- 1 x_birbr x_birbr 31 Sep 11 11:47 file1.txt
    1 -rw-rw-r-- 1 x_birbr x_birbr 16 Sep 11 11:49 file2.sh
    1 -rw-rw-r-- 1 x_birbr x_birbr 74 Sep 11 11:49 file3.c
    1 -rw-rw-r-- 1 x_birbr x_birbr 25 Sep 11 11:50 file4.dat
    ```

