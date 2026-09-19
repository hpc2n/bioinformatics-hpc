# Exam practice image (5BI00A)

A Docker image for practising the exam workflow on your own computer while Kebnekaise is unavailable. It is not a copy of Kebnekaise: the `module` command and Slurm (`sbatch`, `srun`, `squeue`, `sacct`, `scancel`) are small imitations, so the commands in the course pages can be typed as written. Everything else (git, ssh, curl, BLAST+ 2.17.0, SAMtools, BCFtools, BEDTools, awk, grep, sort, zip) is the real tool.

## Build and start

You need Docker; the [Docker installation instructions](https://docs.docker.com/get-started/get-docker/) cover Docker Desktop for Mac, Windows and Linux. Then, from this folder:

```bash
docker build -t exam-practice .
```

The first build downloads BLAST+, the file-format tools and Swiss-Prot, and builds the BLAST database, so it needs a network connection and several minutes. It needs about 4 GB of disk space. Start it with:

```bash
docker run -it --rm -v exam-practice:/home/student exam-practice
```

The named volume `exam-practice` keeps your files and your SSH key between sessions. Work in `~/work`, which is also reachable as `/proj/nobackup/cddb_course/students/student`. The course exercise folders are in `~/exercises`. Start with:

```bash
exam-practice-check
```

Docker has to keep running while you work. If you quit Docker or Docker Desktop, the container stops and you are back in your own computer's terminal.

## Updating

If you built the image earlier, get the latest files and build again, then start as before:

```bash
git pull
docker build -t exam-practice .
docker run -it --rm -v exam-practice:/home/student exam-practice
```

`docker run` starts whichever image is currently named `exam-practice`, so without the new build you keep the old one. Your files and SSH key are in the volume and are kept. `docker image prune` removes the old image. `docker volume rm exam-practice` deletes the volume and everything in it.

## If `module` is not found

The `module` and Slurm commands exist only in the image's `bash` shell. If you see `module: not found` or `command not found: module`, you are in a different shell: your own computer's terminal, or a plain `sh` session opened some other way. Start the image with the `docker run` command above. Inside the image the prompt looks like `student@<id>:~/work$`. If you are in `sh` there, type `bash`.

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
| Git, SSH key, push to GitHub, zip | Real tools. Create the key inside the image (guide steps 2 to 5). `man git-<command>` works |
| File formats (Lecture 13) | `module load GCC/14.2.0 SAMtools/1.22`, `module load GCC/13.2.0 BCFtools/1.19` and `module load GCC/14.3.0 BEDTools/2.31.1` (or GCC/13.3.0), as on Kebnekaise. `seqkit` is always available |
| The Python one-liners in the Lecture 15 PlantGenIE exercises | Python 3 (standard library only) |

The imitated commands accept only what the course uses. Modules that need others loaded first are refused without them, as on Kebnekaise: `module load BLAST+/2.17.0` on its own fails, so load `GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0`. A job script needs `#SBATCH --account=hpc2ncourses2026-013`.

## What differs from Kebnekaise

- The database is the current UniProt Swiss-Prot release (see `RELEASE.txt` in the database folder), not the 13 August 2026 course copy. Hits and E-values can differ slightly.
- Jobs start immediately and run in the background on your computer. Only `--time` is enforced. There is no queue, no memory limit and no node choice. `srun` starts the command once per task on your computer.
- There is no Open OnDemand and no login. Set up and test your SSH key on Kebnekaise itself once it is back.
- The example data for the file-format exercises (many gigabytes) stays on Kebnekaise and is not in the image, and neither are the compiled programs used in the Slurm sample scripts.
