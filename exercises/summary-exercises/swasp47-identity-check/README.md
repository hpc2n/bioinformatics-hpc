# Advanced case study: checking sample identity from RNA-seq

**Status: advanced and deliberately challenging — beyond what the exam will expect.**
This is optional, self-paced material for the [Summary Exercises](../../../docs/summary-exercises.md) week. Nobody needs to finish it, and nothing here is examinable.

A real, currently unpublished example from Nathaniel's own research group, used here as research-led teaching — this is what the day-to-day bioinformatics in an active research project actually looks like, not a case built for a course. It asks a simple but consequential question — *is this sample really what its label says?* — and answers it by genotyping a handful of diagnostic sites from public RNA-seq. Along the way it exercises alignment, variant reading, public-archive retrieval, containers, and disk hygiene on shared HPC.

## 1. The problem (why this matters)

A gene had been cloned/synthesised and attributed to a particular plant genotype ("SwAsp47"). Later, genotype data suggested the *sequence* did not match that plant. The critical question for the project became: is the plant material genuinely SwAsp47 (so the error is at the lab bench), or was the wrong plant sampled all along?

Teaching point — **reproducibility is not validity.** A pipeline can run perfectly and give a self-consistent answer from the *wrong sample*. Identity checks are a routine, under-taught part of real analysis, and this is a direct extension of the reproducibility ideas from Lecture 14/15 (FAIR and Open Science).

## 2. The idea

If we know positions where the sequence-of-interest differs from a reference allele, and we have *independent* sequencing of the claimed plant (here, RNA-seq from a public archive, retrieved the same way you retrieved data in Lecture 11), we can genotype those positions from the reads:

- reads show the **reference** allele → the plant is the genuine genotype;
- reads show the **clone/alternate** allele → the plant is a different source.

The positions that discriminate the two alleles are the **diagnostic SNPs**.

## 3. The workflow (three small scripts)

All scripts are in [`scripts/`](scripts/).

**[`01_make_diagnostic_snps.py`](scripts/01_make_diagnostic_snps.py)** — align the coding sequence of interest to the reference genome (minimap2 via `mappy`), read the alignment's `cs` string, and list every position where it differs (reference allele vs clone allele). These are the sites to test. *Concepts: spliced pairwise alignment, CIGAR/`cs` strings, 0- vs 1-based coordinates, alleles/strand.*

This script needs the genome FASTA and the clone CDS as inputs — both unpublished research files not bundled in this repo. **You can read the script to understand the method without running it.** Its output format is shown in [`diagnostic_SNPs.example.tsv`](diagnostic_SNPs.example.tsv), a real (already-generated) example output, so you can go straight to script 03 conceptually even without running script 01 yourself.

**[`02_get_ena_accessions.sh`](scripts/02_get_ena_accessions.sh)** — turn a study accession into run accessions and FASTQ URLs via the ENA portal API, exactly the pattern from Lecture 11. *Concepts: BioProject/study vs run accessions, the ENA filereport API, ENA-hosted vs original-filename FASTQs.* This one needs no private inputs — run it as-is:

```bash
bash scripts/02_get_ena_accessions.sh PRJEB73507 > runs.tsv
grep 'Buds_.*_47_' runs.tsv
```

**[`03_align_and_genotype.sh`](scripts/03_align_and_genotype.sh)** — a Slurm job: for each sample, stream R1 straight from ENA into the aligner, keep only the reads on the gene, and count reference vs alternate reads at the diagnostic positions with `samtools mpileup`. *Concepts: containers for reproducible tools, streaming to avoid disk, MAPQ filtering, pileup interpretation, coverage/depth, node-local scratch.*

Two practices in that script are worth paying attention to:

- **Streaming, not storing.** `curl … | zcat | minimap2 … | samtools …` pipes a multi-GB FASTQ through the tools without ever writing it to disk. On a shared filesystem, downloading raw data "just to align it" is how one user's job fills the storage for a whole department. Peak footprint here is a few hundred MB, on `$SNIC_TMP` (node-local scratch — see the Batch system/Slurm lecture), wiped when the job ends.
- **Containers over the ambient environment.** Pulling `samtools`/`minimap2` as `.sif` images via `apptainer` makes the analysis reproducible and independent of whatever modules happen to be loaded. `apptainer` is a system binary on Kebnekaise — no `module load` needed.

### Running this on Kebnekaise

Verified working on Kebnekaise (2026-08-13):

- `apptainer` is at `/usr/bin/apptainer` (v1.3.5), available with no module load.
- `$SNIC_TMP` is provisioned automatically per job (resolved to `/scratch`, 13 GB, on a test job).
- The login node and compute nodes can both reach the ENA API, PyPI, and Docker Hub.
- For script 01, if you have access to the genome/CDS inputs: `module load GCC/13.3.0 Python/3.12.3`, then `python3 -m venv venv && source venv/bin/activate && pip install mappy` — `mappy` 2.31 installs and imports cleanly with that module pair.

**Before script 03 can be run for real**, the reference transcript FASTA needs to be staged on shared storage (it is not included in this repo, as it is an unpublished research input) — ask Nathaniel for the path once it is placed on `/proj/nobackup/cddb_course/`.

## 4. The result and how to read it

Four independent bud samples of the claimed genotype, genotyped at ten diagnostic sites (values = % of reads carrying the reference/expected allele; depth in parentheses):

```
                     tissue-culture      field
 site (transcript)   X61     X130        X268      X282
 275                 100%(11) 100%(10)   100%(120) 100%(113)
 295                   0%(9)   0%(8)       1%(97)    0%(97)   <- see note
 736..1151          100%     100%        100%      100%
```

Nine of ten sites are 100% the reference/expected allele in every sample — so the plant **is** the genuine genotype; the sequence discrepancy is a bench/synthesis problem, not a mislabelled plant.

**This result is from Nathaniel's real, currently unpublished analysis and is shown here as an illustration of the method — it is pending final wet-lab confirmation.** Treat the bioinformatics approach as the teaching point, not the specific percentages as a settled published finding.

**The interesting tenth site (295)** is one where the plant is genomically heterozygous, yet every RNA-seq sample expresses **only one** allele. That is **allele-specific expression** — a real biological signal (allelic imbalance / *cis*-regulation), and a nice teaching aside: a heterozygous *genotype* can look homozygous in *expression* data. It also flags a limitation: RNA-seq only genotypes expressed exons, and ASE can mask true heterozygosity — so use many markers and, for whole-individual fingerprinting, genome-wide DNA markers rather than one expressed gene.

## 5. Good discussion questions

- Why is RNA-seq a *biased* genotyper (which parts of the genome can it see)?
- Why filter on mapping quality before counting alleles? What goes wrong without it?
- Why can a single gene not identify *which* individual a sample is, even though it can exclude one? (Shared haplotypes; you need genome-wide markers.)
- How many diagnostic sites / how much depth do you need for a confident call?
- The site-295 result: how would you formally test allele-specific expression across a population, and what confounds it (mapping bias to the reference)?
- Where could the error have entered, and which experiment would localise it?

## 6. Source

This case study is adapted from Nathaniel's own SPG paper investigation. Public input used: RNA-seq under ENA study `PRJEB73507`. The genome, annotation, and clone CDS are not public — see the note in Section 3 above.
