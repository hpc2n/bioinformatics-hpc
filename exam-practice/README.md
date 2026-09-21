# Exam practice image (5BI00A)

A Docker image for practising the exam workflow on your own computer while Kebnekaise is unavailable. It is not a copy of Kebnekaise: the `module` command and Slurm (`sbatch`, `srun`, `squeue`, `sacct`, `scancel`) are small imitations, so the commands in the course pages can be typed as written. Everything else (git, ssh, curl, BLAST+ 2.17.0, SAMtools, BCFtools, BEDTools, awk, grep, sort, zip) is the real tool.

## Read this first: two places, one command at a time

You will type commands in two different places. Each step below says which one.

- **Your computer's terminal.** This is the Terminal app on macOS, PowerShell (or a WSL terminal) on Windows, or a terminal window on Linux. The Docker Desktop app is not a terminal: never type or paste commands into it. Docker Desktop only has to be open and running in the background.
- **The container.** This is the practice environment that Docker starts for you, inside your terminal window. Its prompt always starts with `[practice container]`, for example `[practice container] student@1a2b3c4d5e6f:~/work$`. If the prompt does not start like that, you are not in the container.

Paste or type one command at a time, press Enter, and wait until the prompt comes back before the next command. Do not paste several commands together: the container start-up and the commands after it will not work when they arrive all at once.

## Step by step

### 1. Install Docker, then open it (once)

Install Docker Desktop from the [Docker installation instructions](https://docs.docker.com/get-started/get-docker/) (macOS and Windows), or Docker Engine on Linux. Then open the Docker Desktop app and wait until it says that Docker is running. Leave it open.

### 2. Open a terminal on your computer

Open Terminal (macOS), PowerShell (Windows) or a terminal window (Linux). Steps 3 to 5 are typed here.

### 3. Check that Docker works (your computer's terminal)

```bash
docker version
```

You should see two parts, `Client:` and `Server:`. On Windows and macOS the `Server:` line starts with `Docker Desktop`. If there is only a `Client:` part, followed by an error message, the Docker engine is not running yet: go back to step 1, open the Docker Desktop app and wait until it has started, then run the command again. If you see `command not found`, Docker is not installed.

`docker --version` is not enough for this check: it passes when the `docker` program is installed, even when the engine is not running.

### 4. Get the files and build the image (your computer's terminal; once)

Get a copy of the course repository:

```bash
git clone https://github.com/hpc2n/bioinformatics-hpc.git
```

If `git` is not installed, download the repository as a zip file instead (the green Code button at https://github.com/hpc2n/bioinformatics-hpc, then Download ZIP), unzip it, and open your terminal in the unzipped folder.

Go into the exam-practice folder:

```bash
cd bioinformatics-hpc/exam-practice
```

Check that you are in the right place:

```bash
ls
```

The list must include a file called `Dockerfile`. If it does not, you are in the wrong folder.

Build the image:

```bash
docker build -t exam-practice .
```

The image is about 2.6 GB on disk and the build needs about 4 GB of free disk space. It downloads several tools and the Swiss-Prot database, so it needs a network connection and takes several minutes. Wait until your terminal prompt comes back. If the last lines mention `ERROR`, the build failed (see the table at the end).

### 5. Start the container (your computer's terminal)

```bash
docker run -it --rm --name practice -v exam-practice:/home/student exam-practice
```

The `--name practice` part gives the container a fixed name, which is used later to copy files out of it. Your terminal window now shows this, and the prompt has changed. You are inside the container:

```
You are INSIDE the practice container: the prompt starts with [practice container].
This is not Kebnekaise: module and Slurm are imitated. Work in ~/work. When you have finished working, type exit to leave.
Next: 1) exam-practice-check   2) exam-practice-setup (Git and GitHub)   3) exam-practice-check again
[practice container] student@1a2b3c4d5e6f:~/work$
```

If your prompt does not begin with `[practice container]`, your image was built before that label was added and is out of date: type `exit` and follow "Updating" below before you go on. Steps 6 to 9 are typed at this prompt. The container keeps running only while this window is open. Your files and your SSH key are kept between sessions in the volume called `exam-practice`. Work in `~/work`. The course exercise folders are in `~/exercises`.

### 6. Run the check (in the container)

```bash
exam-practice-check
```

It tests the tools, the imitated `module` and Slurm, the BLAST database and your Git and GitHub set-up. The first time, the Git and GitHub lines fail. That is expected, because your name, your e-mail address and your SSH key are not set up yet. The check says so at the end:

```
  FAIL  git name and e-mail not set yet (expected at first: run exam-practice-setup)
  FAIL  Git default branch is not main yet (expected at first: run exam-practice-setup)
  FAIL  no SSH key yet (expected at first: run exam-practice-setup)
```

If lines in the Tools, Modules or Database groups also say FAIL, something is wrong with the image: see the table at the end.

### 7. Set up Git and your SSH key (in the container)

```bash
exam-practice-setup
```

It asks four things, one after the other, and waits for you each time:

1. Your name and the e-mail address of your GitHub account.
2. It creates an SSH key for you.
3. It shows the public key, one line starting `ssh-ed25519`. Select the line with the mouse and copy it. In your web browser open https://github.com/settings/ssh/new, give the key a title such as `exam practice`, paste the line into the Key box and click Add SSH key. Then return to the container window and press Enter.
4. It tests the connection to GitHub. If GitHub does not accept the key yet, it says so; check that you pasted the whole line, then press Enter to try again.

At the end it prints `Done. Your GitHub user name is ...`.

### 8. Run the check again (in the container)

```bash
exam-practice-check
```

Every line should now say `ok`. (With no web access to UniProt, NCBI or EBI you can run `exam-practice-check --skip-web`.)

### 9. Work in the container, and leave it only when you have finished

Do the exercises or the practice exam in `~/work`, at the `[practice container]` prompt. The exam repository is cloned there with `git clone git@github.com:...`, exactly as on Kebnekaise. Stay in the container while you work: the Git and SSH commands only work there.

Do not type `exit` now. Whenever you have finished working and want to leave the container, type:

```bash
exit
```

The prompt then returns to your own computer's terminal, and the commands of steps 6 to 9 no longer work until you start the container again with the step 5 command.

## Coming back later

You do not repeat steps 1 to 4 or 7. Open Docker Desktop and wait until it is running, open a terminal, and type the step 5 command. Your files and SSH key are still there.

## Getting a file out of the container (for example the zip for Canvas)

Canvas accepts only `.zip` files, and your files are inside the container. The container is called `practice` (from `--name practice` in step 5), and a file that you make in `~/work` is at `/home/student/work` in it. For example, a zip made inside the exam repository `exam-msvensson` is at `/home/student/work/exam-msvensson/exam.zip`. To copy it to your own computer:

1. Leave the container running in its terminal window. Do not type `exit` yet.
2. Open a second terminal window on your own computer (not the Docker Desktop app) and go to the folder where you want the file, for example the folder that you will upload from.
3. Type this, replacing `exam.zip` with the name of your file:

   ```bash
   docker cp practice:/home/student/work/exam.zip .
   ```

   The dot at the end means the folder that the second terminal is in. The file appears there. Write the whole path `/home/student/work/...`: `~/work/...` does not work in this command. `docker cp` copies a file or a whole folder, but Canvas needs a zip file, so make the zip first. If the container was not started with `--name practice`, use its ID in place of `practice`: it is the letters and numbers after `student@` in the container's prompt, or you can list it with `docker ps`.

This works the same on macOS, Windows and Linux. It was tested on macOS and has not been tested on Windows or Linux.

Once the container has ended (after `exit`), `docker cp` no longer finds it (`No such container: practice`). Your files are still in the volume. Start the container again with the step 5 command, and copy the file then.

A second way, without a second window, is to start the container with a shared folder. Use this command instead of the step 5 command:

```bash
docker run -it --rm --name practice -v exam-practice:/home/student -v "$HOME/exam-out:/exam-out" exam-practice
```

Inside the container, `cp exam.zip /exam-out/`. The file appears in the folder `exam-out` in your home directory on your computer. This was tested on macOS. On Windows in PowerShell the folder is written `"$HOME\exam-out:/exam-out"`, which follows Docker's documentation for Windows paths (`C:\Users\name\folder:/path`) but has not been tested. If it does not work, use `docker cp`.

## If something goes wrong

| What you see | What it means and what to do |
|---|---|
| Nothing happens when you paste commands, or the check did not run | The commands were pasted all at once, or into the Docker Desktop app. Type one command at a time in a terminal window. |
| `command not found: docker` | Docker is not installed, or Docker Desktop is not running. Open Docker Desktop and wait until it says it is running. |
| `Cannot connect to the Docker daemon`, `failed to connect to the docker API`, or `ERROR: request returned 500 Internal Server Error for API route and version ... dockerDesktopLinuxEngine ... _ping` | The `docker` program is installed, but the Docker engine is not running. Open the Docker Desktop app, wait until it has finished starting, and run `docker version` until it shows a `Server:` part. If Docker Desktop shows an error itself, or never finishes starting, Docker's documentation lists these causes on Windows: virtualization is switched off in the computer's BIOS/UEFI; the Windows features that WSL 2 needs (Virtual Machine Platform and Windows Subsystem for Linux) are not turned on; anti-virus software conflicts with virtualization; the computer is itself a virtual machine without nested virtualization; or Windows or WSL is too old (Docker asks for Windows 10 22H2 build 19045, Windows 11 23H2 build 22631 or newer, and WSL 2.1.5 or later). See the [Docker Desktop installation page for Windows](https://docs.docker.com/desktop/setup/install/windows-install/). Restarting the computer sometimes helps. If it still fails, send your instructor a screenshot of the Docker Desktop window and the output of `docker version`. |
| `open Dockerfile: no such file or directory` | You are in the wrong folder. Type `cd bioinformatics-hpc/exam-practice` and run the build again. |
| `git: command not found` in step 4 | Git is not installed on your computer. Use Download ZIP instead. |
| Docker Desktop says that virtualization is not supported | Windows cannot start the virtual machine that Docker uses. From Docker's and Microsoft's documentation: check virtualization with `systeminfo` in PowerShell (it should end with "A hypervisor has been detected") or in the Performance tab of Task Manager; switch on virtualization in the BIOS/UEFI settings (usually called `Virtualization Technology (VTx)`, in the CPU options; [Microsoft's instructions](https://support.microsoft.com/windows/c5578302-6e43-4b4b-a449-8ced115f58e1)); turn on the Windows features Virtual Machine Platform and Windows Subsystem for Linux; in PowerShell as administrator run `bcdedit /set hypervisorlaunchtype auto`; restart the computer. A processor that is too old for WSL 2, or a Windows running inside a virtual machine without nested virtualization, cannot be fixed this way. If it cannot be fixed, tell your instructor: you do not need Docker if Kebnekaise is working. |
| The prompt does not start with `[practice container]`, or `module: not found` | You are in your own computer's terminal, in a different shell, or in an old image. If you are inside a container whose prompt is `student@...` without the label, the image is out of date: `exit`, then follow "Updating". Otherwise run the step 5 command. If you are in `sh` inside the container, type `bash`. |
| `exam-practice-setup: command not found` | You are typing it in your own computer's terminal. It exists only in the container: run the step 5 command first. |
| `the input device is not a TTY` (Windows, Git Bash) | Put `winpty` in front of the `docker run` command, or use PowerShell. |
| `permission denied` on `docker` (Linux) | Put `sudo` in front, or add yourself to the `docker` group. |
| `GitHub did not accept the key yet` | The whole line starting `ssh-ed25519` has to be pasted at https://github.com/settings/ssh/new and saved with Add SSH key. Then press Enter in the container to test again. |
| `The container name "/practice" is already in use` | A container called `practice` is still running, probably in another terminal window. Go to that window and type `exit`, or type `docker stop practice`, and then start the container again. |
| `No such container: practice` when you use `docker cp` | The container has ended. Start it again with the step 5 command and copy the file while it is running. |
| The container exits when you close the window | That is normal. Start it again with the step 5 command. Your files are kept in the volume. |

## Updating

If you built the image earlier, get the latest files and build again, then start as before. You need to update if the prompt of the container does not begin with `[practice container]`. Run these in the `exam-practice` folder of your copy of the course repository, the folder that contains the file called `Dockerfile`, one at a time in your computer's terminal:

```bash
cd bioinformatics-hpc/exam-practice
```

```bash
git pull
```

```bash
docker build -t exam-practice .
```

Then use the step 5 command. `docker run` starts whichever image is currently named `exam-practice`, so without the new build you keep the old one. Your files and SSH key are in the volume and are kept. `docker image prune` removes the old image. `docker volume rm exam-practice` deletes the volume and everything in it.

## Notes for your operating system

The image was tested on macOS with an Apple silicon chip, and the x86-64 build under emulation there. It has not been tested on Windows or Linux.

- **macOS:** Docker Desktop must be running. Both Apple silicon and Intel Macs work; the image is built for the chip of the computer that builds it.
- **Windows:** use Docker Desktop and run the commands in PowerShell or in a WSL terminal. In Git Bash, `docker run -it` may fail with "the input device is not a TTY"; put `winpty` in front of the command. Git may convert the line endings of the files when you clone. The build removes those, so this does not matter.
- **Linux:** install Docker Engine. You may need `sudo` before `docker`, or to be a member of the `docker` group.

## What you can practise

| Skill | In the image |
|---|---|
| Retrieve records from UniProt and NCBI Entrez with `curl` | Real services, so you need a network connection |
| BLAST locally as a Slurm job | `sbatch` runs the job on your computer against `/proj/nobackup/cddb_course/databases/swissprot/swissprot`, using the Lecture 15 job script unchanged |
| BLAST through the EBI Job Dispatcher API | Real service |
| Filter results with `grep`, `awk`, `sort`; the Linux exercises | Real tools (GNU awk 5.1, as on the login nodes) and the exercise files in `~/exercises` |
| Git, SSH key, push to GitHub, zip | Real tools. `exam-practice-setup` creates the key inside the image (step 7). `man git-<command>` works |
| File formats (Lecture 13) | `module load GCC/14.2.0 SAMtools/1.22`, `module load GCC/13.2.0 BCFtools/1.19` and `module load GCC/14.3.0 BEDTools/2.31.1` (or GCC/13.3.0), as on Kebnekaise. `seqkit` is always available. The example files are small dummy stand-ins (see below) |
| The Python one-liners in the Lecture 15 PlantGenIE exercises | Python 3 (standard library only) |

The imitated commands accept only what the course uses. Modules that need others loaded first are refused without them, as on Kebnekaise: `module load BLAST+/2.17.0` on its own fails, so load `GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0`. A job script needs `#SBATCH --account=hpc2ncourses2026-013`.

## What differs from Kebnekaise

- The database is the current UniProt Swiss-Prot release (see `RELEASE.txt` in the database folder), not the 13 August 2026 course copy. Hits and E-values can differ slightly.
- Jobs start immediately and run in the background on your computer. Only `--time` is enforced. There is no queue, no memory limit and no node choice. `srun` starts the command once per task on your computer.
- There is no Open OnDemand and no login. Set up and test your SSH key on Kebnekaise itself once it is back.
- The example files for the file-format lecture (`/proj/nobackup/cddb_course/Bioinformatics_File_Formats/example_formats`) are small dummy files. They have the same names and formats as the real ones, so the commands in the lecture run as written, but the content is invented and generated when the image is built. Read counts, gene counts and variant counts therefore differ from the real files, which are large (the BAM file is 2.5 GB) and stay on Kebnekaise. The exercise text files in the real folder are not included.
- The Lecture 10 sample job scripts and exercises are templates for Kebnekaise. They use MPI, OpenMP and GPU programs, job arrays, job dependencies and modules such as `foss`, `Python` and `CUDA` that exist only there. The image runs simple job scripts with `sbatch` and `srun`, but not those.
