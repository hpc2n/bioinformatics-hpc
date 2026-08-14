# Summary Exercises and Catch-Up

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Session date:** 18 September 2026 · 13:00–16:00

---

This session gives you time to consolidate the bioinformatics content covered since 10 September, work through any exercises you have not yet completed, and catch up on anything you found difficult. Nathaniel is available throughout to answer questions.

**None of this is assessed, and none of it needs to be finished during the scheduled session.** Everything below can equally well be done at home, in the week before the exam, at your own pace. The scheduled 18 September session is there so Nathaniel is available in person if you want to work through something together — it is not a deadline for this page.

The material below is organised in three tiers, roughly in order of increasing difficulty:

1. **Catch-up** — finish anything from earlier sessions you did not complete.
2. **Consolidation and extension** — go a bit further than the original exercises, still within what the exam might expect.
3. **Advanced** (clearly marked below) — genuinely challenging, optional material, beyond anything the exam will ask of you. Skip it entirely if you are short on time.

## Tier 1 — Catch-up

Work through the exercises in the order that is most useful to you.

### 1. Biological databases

Use the [Database Landscape handout](11.database-landscape/database-landscape.md) to:

- Complete any curl-based exercises you did not finish during the session
- Retrieve a gene of your own choice from UniProt and inspect its GO terms, cross-references, and evidence codes
- Try querying NCBI Entrez for a species or gene relevant to your own research interests

### 2. File formats

Use the [File Formats handout](13.file-formats/file-formats.md) to:

- Complete any FASTQ, BAM, VCF, or GTF exercises not yet finished
- Try the coordinate system exercise — confirm you can correctly convert between 0-based (BED) and 1-based (VCF/GTF) coordinates for a specific variant

### 3. FAIR and open science

Use the [FAIR and Open Science handout](14.fair-open-science/fair-open-science.md) and [FAIR in Practice handout](15.fair-in-practice/fair-in-practice.md) to:

- Complete the GEO/ENA metadata sufficiency checklist for the AspWood dataset (ERP016242)
- Work through the paper reproducibility assessment exercise using your chosen essay paper
- Make progress on your FAIR essay
- If you did not finish it in session: run a BLAST search via the NCBI web interface, the command line on Kebnekaise, and the PlantGenIE/NCBI API, using the Slurm script in `exercises/15.fair-in-practice/` — see the [BLAST background reference](12.blast/blast.md) if you need a refresher first

### If you missed a session entirely

Work through these in order:

- [ ] [Biological databases](11.database-landscape/database-landscape.md) — INSDC, UniProt, GO, specialist resources
- [ ] [File formats](13.file-formats/file-formats.md) — FASTA, FASTQ, SAM/BAM, VCF, GTF, BED
- [ ] [FAIR and open science](14.fair-open-science/fair-open-science.md) — FAIR principles, reproducibility, open science
- [ ] [FAIR in practice](15.fair-in-practice/fair-in-practice.md) — three ways to run BLAST, PlantGenIE API, GEO metadata, paper reproducibility (background: [BLAST reference](12.blast/blast.md))

## Tier 2 — Consolidation and extension

If you are up to date with everything above, these go a step further with the same tools and ideas — still within what the exam might reasonably expect.

- **Databases:** the [Database Landscape handout](11.database-landscape/database-landscape.md) has an "Extension Tasks" section at the end (a plant gene example, and searching ENA programmatically) — work through Extension A and Extension B there if you have not already.
- **FAIR in practice:** having run BLAST three ways (web, CLI, API) in Lecture 15, try it on a protein of your own choosing rather than TP53 — compare the top hits and E-values you get from each method, and note any differences in what each interface makes easy or hard to see.
- **File formats:** pick a variant from the VCF exercise and manually trace it through to a BED-format coordinate, then check your answer with a one-line script — this is the kind of off-by-one bug that causes real problems in genomics pipelines.

---

## Tier 3 — Advanced (optional, beyond exam scope)

**Everything from here on is deliberately challenging and will not be examined.** It is here for anyone who wants to see what a piece of real, current research analysis looks like end-to-end, using tools from across the whole course (public archives, containers, HPC scratch, alignment, variant reading).

### Sample identity checking from RNA-seq

[**`exercises/summary-exercises/swasp47-identity-check/`**](../exercises/summary-exercises/swasp47-identity-check/README.md) — a real, currently unpublished case study from Nathaniel's own research group: is a cloned gene's plant-of-origin really what it was labelled as? The case study answers this by genotyping diagnostic SNP positions from public RNA-seq, and touches spliced alignment, the ENA API (as in Lecture 11), containers, node-local scratch (as in the Batch system/Slurm lecture), and the FAIR idea that **reproducibility is not validity** — a pipeline can run perfectly on the wrong sample and still look fine.

Start with the [case study README](../exercises/summary-exercises/swasp47-identity-check/README.md) — it explains the biology, the method, and which parts you can run yourself directly versus which need a reference file Nathaniel has not yet staged on shared storage.

---

## Essay reminder

The FAIR compliance essay deadline is set in Canvas — see the [essay assignment](14.fair-open-science/fair-essay-assignment.md) for the full brief, the deadline, and the paper shortlist. Use this week to make progress on your paper assessment if you have not already done so.

---

*5BI00A Computing for Data-Driven Biology · Department of Plant Physiology, Umeå University*
