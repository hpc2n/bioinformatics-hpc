# Copying files from Kebnekaise, and making zip and gzip archives

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University

You do most of your work on Kebnekaise, but sometimes you need a file on your own computer: to open a table in a spreadsheet, to look at a figure, to keep a copy of your results, or to send them to someone. This page shows how to pack files into one archive (zip, tar.gz or gzip), how to copy files and archives from Kebnekaise to your own computer, and back again, and how to unpack them.

## How the commands on this page are shown

The blocks look the same as on the [pushing to GitHub guide](../git-ssh-setup/git-ssh-setup.md).

A plain grey block is a command to paste as it is. Nothing in it needs changing:

```
echo "This is a command to paste exactly as it is"
```

!!! warning "Edit before you paste"
    A command that contains something only you know is in an orange box like this one. The words in CAPITAL LETTERS are placeholders. Replace each one with your own text, and keep everything else. The box tells you what each placeholder means.

    ```
    echo "Hello, MY NAME"
    ```

    - `MY NAME`: your own name, for example `Maria Svensson`.

!!! tip "What you should see (do not paste this)"
    Output that the computer prints back is in a green box like this one. It is there for you to compare with your screen. It is not a command, so do not paste it.

    ```
    Hello, Maria Svensson
    ```

Paste one block at a time, press Enter, and wait for the prompt to come back before you paste the next block.

!!! warning "Use straight quotation marks"
    Commands use straight quotation marks, `"` and `'`. If you copy a command from a Word document, an email or a chat window, they can turn into curly ones, `“ ”` and `‘ ’`, and the command then fails with errors that seem unrelated. Copy commands from the boxes on the course pages instead of retyping them.

!!! warning "Where you type matters"
    Each section says where to type: **on Kebnekaise** (in a terminal where you have logged in with `ssh`) or **on your own computer** (in a terminal window that is *not* logged in to Kebnekaise). Archives are made where the files are; copying is started from your own computer.

The examples use a folder called `myproject` that holds a `README.md` and a `results` folder. Use your own folder and file names.

---

## Part 1: Pack files into an archive (on Kebnekaise)

An archive packs many files, or a whole folder, into one file, usually compressed so that it is smaller. One file is easier to copy, to keep and to send than many.

| Format | Made with | Good for |
|---|---|---|
| `.zip` | `zip` | A folder that you want to open on almost any computer |
| `.tar.gz` | `tar` | A folder; the usual format on Linux |
| `.gz` | `gzip` | A single large file, such as a FASTQ or a big table; many biological data files are shared this way |

First go to the folder that holds the folder you want to pack, and look at what is there:

!!! warning "Edit before you paste"
    ```
    cd PATH_TO_THE_FOLDER
    ls
    ```

    - `PATH_TO_THE_FOLDER`: the folder that contains the folder you want to pack, for example `/proj/nobackup/cddb_course/students/msvensson`.

### A zip file

This packs the folder `myproject`, and everything in it, into `myproject.zip`. `-r` includes folders and what is inside them. If the folder is a Git repository, `-x "myproject/.git/*"` leaves out the hidden `.git` folder, which holds the Git history (that is on GitHub already).

```
zip -r myproject.zip myproject -x "myproject/.git/*"
```

!!! tip "What you should see (do not paste this)"
    One line for each file or folder that was added. Your names and percentages will differ.

    ```
      adding: myproject/ (stored 0%)
      adding: myproject/results/ (stored 0%)
      adding: myproject/results/TP53_protein.fasta (deflated 29%)
      adding: myproject/results/TP53_blastp_local.tsv (deflated 69%)
      adding: myproject/README.md (stored 0%)
    ```

Check what is inside the zip file, without unpacking it:

```
unzip -l myproject.zip
```

!!! tip "What you should see (do not paste this)"
    ```
    Archive:  myproject.zip
      Length      Date    Time    Name
    ---------  ---------- -----   ----
            0  2026-09-30 09:32   myproject/
            0  2026-09-30 09:32   myproject/results/
          490  2026-09-30 09:32   myproject/results/TP53_protein.fasta
         2674  2026-09-30 09:32   myproject/results/TP53_blastp_local.tsv
           13  2026-09-30 09:32   myproject/README.md
    ---------                     -------
         3177                     5 files
    ```

To pack only some files, name them after the zip file, separated by spaces. Here the command is run from *inside* `myproject`, and the zip file is written to the folder above it (`..`):

!!! warning "Edit before you paste"
    ```
    zip -r ../SOME_NAME.zip FILE_OR_FOLDER FILE_OR_FOLDER
    ```

    - `SOME_NAME`: a name for the zip file, for example `results_only`.
    - `FILE_OR_FOLDER`: a file or folder to include, for example `README.md results`. Add as many as you need.

To unpack a zip file: `unzip myproject.zip`. It recreates the folder `myproject` in the folder you are in.

### A tar.gz file

`tar` is the standard archiving tool on Linux. The letters after `-` say what to do: `c` create, `z` compress with gzip, `f` the name of the archive follows. `--exclude=.git` leaves out the Git history.

```
tar -czf myproject.tar.gz --exclude=.git myproject
```

List what is inside (`t` for "table of contents"):

```
tar -tzf myproject.tar.gz
```

!!! tip "What you should see (do not paste this)"
    ```
    myproject/
    myproject/results/
    myproject/results/TP53_protein.fasta
    myproject/results/TP53_blastp_local.tsv
    myproject/README.md
    ```

To unpack it (`x` for "extract"): `tar -xzf myproject.tar.gz`. It recreates the folder `myproject` in the folder you are in.

### A single file with gzip

`gzip` compresses one file. By itself it **replaces** the file with a compressed `.gz` version; `-k` (keep) leaves the original as well.

!!! warning "Edit before you paste"
    ```
    gzip -k FILE_NAME
    ls -l FILE_NAME*
    ```

    - `FILE_NAME`: the file to compress, for example `TP53_blastp_local.tsv`.

!!! tip "What you should see (do not paste this)"
    The original and the compressed file. This BLAST table went from 2674 to 864 bytes.

    ```
    -rw-rw----+ 1 msvensson ps30756 2674 Sep 30 09:32 TP53_blastp_local.tsv
    -rw-rw----+ 1 msvensson ps30756  864 Sep 30 09:32 TP53_blastp_local.tsv.gz
    ```

You do not have to unpack a `.gz` file to look inside it: `zcat` prints the uncompressed text, so you can use it in a pipe like any other file:

```
zcat TP53_blastp_local.tsv.gz | head -2
```

To unpack it: `gunzip TP53_blastp_local.tsv.gz`, which turns it back into `TP53_blastp_local.tsv`.

---

## Part 2: Find the full path of the file (on Kebnekaise)

To copy a file you need its full path on Kebnekaise. In the folder that holds the file, type:

```
pwd
```

!!! tip "What you should see (do not paste this)"
    The full path of the folder you are in. Yours will be different. Add `/` and the file name to the end to get the full path of the file, for example `/proj/nobackup/cddb_course/students/msvensson/myproject.zip`.

    ```
    /proj/nobackup/cddb_course/students/msvensson
    ```

---

## Part 3: Copy files between Kebnekaise and your own computer

### Route A: with `scp` (in a terminal on your own computer)

Open a terminal window on your own computer. This is not the Kebnekaise window: do not log in to Kebnekaise for this step. Go to the folder where you want the file, then paste the command below. The dot at the end means "here", the folder your terminal is in.

!!! warning "Edit before you paste"
    ```
    scp YOUR_HPC2N_USERNAME@kebnekaise.hpc2n.umu.se:FULL_PATH .
    ```

    - `YOUR_HPC2N_USERNAME`: your HPC2N username, the one you use to log in to Kebnekaise.
    - `FULL_PATH`: the full path of the file from Part 2, for example `/proj/nobackup/cddb_course/students/msvensson/myproject.zip`.

`scp` asks for the same login details as `ssh`. When it has finished, the file is in the folder your terminal is in.

To copy a whole folder instead of one file, add `-r`: `scp -r YOUR_HPC2N_USERNAME@kebnekaise.hpc2n.umu.se:FULL_PATH_OF_THE_FOLDER .` For many files it is usually quicker and tidier to pack them first (Part 1) and copy the one archive.

To copy the other way, from your own computer to Kebnekaise, swap the two parts. The file comes first, and the Kebnekaise folder second, ending in `/`:

!!! warning "Edit before you paste"
    ```
    scp FILE_NAME YOUR_HPC2N_USERNAME@kebnekaise.hpc2n.umu.se:FULL_PATH_OF_A_FOLDER/
    ```

    - `FILE_NAME`: the file on your own computer, for example `notes.txt`.
    - `YOUR_HPC2N_USERNAME`: your HPC2N username.
    - `FULL_PATH_OF_A_FOLDER`: the folder on Kebnekaise to copy it into, for example `/proj/nobackup/cddb_course/students/msvensson`.

!!! tip "Optional, for larger folders: rsync"
    If `rsync` is installed on your computer, it copies only what has changed, and can be run again to finish an interrupted copy. The `/` at the end of the source means "the contents of this folder":

    `rsync -av YOUR_HPC2N_USERNAME@kebnekaise.hpc2n.umu.se:FULL_PATH_OF_THE_FOLDER/ LOCAL_FOLDER/`

### Route B: with the Open OnDemand file browser (in a web browser)

1. Go to [portal.hpc2n.umu.se](https://portal.hpc2n.umu.se) and log in.
2. Open the *Files* app and go to the folder that holds the file.
3. Select the file and choose *Download*. Your browser saves it in its download folder.


---

## Part 4: Unpack on your own computer

Most computers open a `.zip` file with a double-click. In a terminal on your own computer you can also use the same commands as on Kebnekaise:

| Archive | Command |
|---|---|
| `myproject.zip` | `unzip myproject.zip` |
| `myproject.tar.gz` | `tar -xzf myproject.tar.gz` |
| `TP53_blastp_local.tsv.gz` | `gunzip TP53_blastp_local.tsv.gz` |

---

## Troubleshooting

| What you see | What it means and what to do |
|---|---|
| `scp: ...: No such file or directory` | The path is wrong. Run `pwd` in the folder with the file on Kebnekaise (Part 2), check that the file is there with `ls`, and use that path. |
| `scp` says `Permission denied` | The username or the password is wrong, or you cannot log in to Kebnekaise. Try logging in with `ssh` first. |
| `zip warning: name not matched` and `zip error: Nothing to do!` | The file or folder name after the zip file does not exist in the folder you are in. Check the names with `ls`. |
| `tar: ...: Cannot stat: No such file or directory` | The same for `tar`: check the folder name with `ls`. |
| `gzip: ... already exists; not overwritten` | There is already a `.gz` file with that name. Remove or rename it, or use the one you have. |
| Your original file is gone after `gzip` | `gzip` without `-k` replaces the file with the `.gz` file. `gunzip` brings it back. |
| The zip file looks too small, or is empty | Check its contents with `unzip -l`. Only the files and folders you name are included. |
