# Exam practice image (5BI00A)

A Docker image for practising the exam workflow on your own computer while Kebnekaise is unavailable. It is not a copy of Kebnekaise: the `module` command and Slurm (`sbatch`, `squeue`, `sacct`, `scancel`) are small imitations, so the exam commands can be typed as written. Everything else (git, ssh, curl, BLAST+ 2.17.0, awk, grep, sort, zip) is the real tool.

## Build and start

You need Docker; the [Docker installation instructions](https://docs.docker.com/get-started/get-docker/) cover Docker Desktop for Mac, Windows and Linux. Then, from this folder:

```bash
docker build -t exam-practice .
```

The first build downloads BLAST+ and Swiss-Prot and builds the BLAST database, so it needs a network connection and a few minutes. Start it with:

```bash
docker run -it --rm -v exam-practice:/home/student exam-practice
```

The named volume `exam-practice` keeps your files and your SSH key between sessions. Work in `~/work`, which is also reachable as `/proj/nobackup/cddb_course/students/student`. Start with:

```bash
exam-practice-check
```

## What you can practise

| Exam skill | In the image |
|---|---|
| Retrieve records from UniProt and NCBI Entrez with `curl` | Real services, so you need a network connection |
| BLAST locally as a Slurm job | `sbatch` runs the job on your computer against `/proj/nobackup/cddb_course/databases/swissprot/swissprot`, using the Lecture 15 job script unchanged |
| BLAST through the EBI Job Dispatcher API | Real service |
| Filter results with `grep`, `awk`, `sort` | Real tools (GNU awk 5.1, as on the login nodes) |
| Git, SSH key, push to GitHub, zip | Real tools. Create the key inside the image (guide steps 2 to 5) |

The imitated commands accept only what the course uses. `module load BLAST+/2.17.0` on its own is refused, as on Kebnekaise: load `GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0`. A job script needs `#SBATCH --account=hpc2ncourses2026-013`.

## What differs from Kebnekaise

- The database is the current UniProt Swiss-Prot release (see `RELEASE.txt` in the database folder), not the 13 August 2026 course copy. Hits and E-values can differ slightly.
- Jobs start immediately and run in the background on your computer. Only `--time` is enforced. There is no queue, no memory limit and no node choice.
- There is no Open OnDemand and no login. Set up and test your SSH key on Kebnekaise itself once it is back.
- The image is built for the processor of the computer that builds it (x86-64 or ARM64).
