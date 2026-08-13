# BLAST and Sequence Similarity — Background Reference

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University

**This is a self-study reference page, not a taught lecture.** It covers what BLAST is and the concepts you need to interpret its output — homology, the seed-and-extend algorithm, scoring, and E-values. Read this before the "Three ways to run BLAST" session in [Lecture 15: FAIR in Practice](../15.fair-in-practice/fair-in-practice.md), where you will actually run BLAST via the website, the command line, and an API.

---

## 1. Sequence Similarity: Why It Matters

### 1.1 The Core Biological Principle

Sequences that are similar are likely to be related by common ancestry — they are **homologous**. Homologous sequences often share biological function because the underlying protein structure, and therefore function, is conserved by natural selection. This is the foundational assumption of comparative genomics and database annotation.

This assumption is powerful but not unconditional. Two important distinctions:

**Orthologues** — genes in different species that descended from the same gene in a common ancestor, typically through speciation events. Orthologues usually (but not always) retain the same function across species.

**Paralogues** — genes within the same genome that are related by gene duplication. Paralogues often diverge in function after duplication — one copy may retain the ancestral role while the other acquires a new one.

When you find a database hit for an unknown sequence, knowing whether the hit is likely an orthologue or a paralogue significantly affects how you interpret the functional annotation.

### 1.2 What Sequence Similarity Can and Cannot Tell You

**It can tell you:**
- Whether two sequences are likely related by common ancestry
- Which organisms carry a related sequence
- Which domains or regions are most conserved (and therefore likely functionally important)
- A starting hypothesis about the function of an unknown sequence

**It cannot, on its own, tell you:**
- That two sequences have the same function (similar sequence ≠ identical function)
- The direction of annotation transfer (which organism's annotation is reliable enough to transfer)
- Whether similarity is due to common ancestry or convergent evolution (though this is rare at the sequence level)
- Anything about sequences that are so diverged that similarity is no longer detectable (the "twilight zone" below ~25–30% identity)

---

## 2. How BLAST Works: A Conceptual Overview

BLAST — the Basic Local Alignment Search Tool — was published by Altschul et al. in 1990 and remains one of the most widely used tools in all of bioinformatics. Understanding what it does (even without the mathematics) makes you a significantly better interpreter of its results.

### 2.1 The Problem BLAST Solves

You have a query sequence — perhaps a newly sequenced gene — and you want to find all similar sequences in a database that may contain billions of sequences. Naively comparing your query to every database sequence letter by letter would be computationally prohibitive. BLAST uses a heuristic approach that is fast enough to be practical and sensitive enough to find most biologically meaningful matches.

The key word is **heuristic**: BLAST does not guarantee finding the optimal alignment. It is designed to find good alignments quickly, and for practical purposes in most biological applications it works extremely well. But it is not mathematically exhaustive.

### 2.2 The Seed-and-Extend Strategy

BLAST works in two main stages:

**Stage 1 — Seeding:** BLAST breaks your query sequence into short overlapping words of length *k* (typically 11 nucleotides for DNA, 3 amino acids for protein). It looks for exact or near-exact matches to these short words in the database. These are called **seeds** or **hits**. This step is very fast because it uses a pre-indexed lookup table of the database.

**Stage 2 — Extension:** When a seed is found, BLAST extends the alignment in both directions from the seed, adding one residue at a time, as long as the alignment score continues to improve above a threshold. Extension stops when the score drops too far below the best score seen so far. The final aligned region is called a **High-Scoring Pair (HSP)**.

This seed-and-extend approach is the key to BLAST's speed: by only extending from promising seeds, it avoids doing full alignments with most database sequences.

### 2.3 Scoring: Matches, Mismatches, and Gaps

Each alignment position is assigned a score:
- A matched residue receives a positive score
- A mismatched residue receives a penalty (which may be positive for conservative substitutions)
- Introducing a gap incurs a gap open penalty
- Extending a gap incurs a gap extension penalty

For protein BLAST, scores are not just +1/−1 for match/mismatch. They are taken from a **substitution matrix** — a table that assigns different scores to different amino acid pairs based on how frequently they are observed to substitute for one another in real proteins.

### 2.4 Substitution Matrices: BLOSUM and PAM

**BLOSUM (BLOcks SUbstitution Matrix)** matrices are derived from alignments of conserved blocks in related protein families. The number in the name indicates the maximum percentage identity of the sequences used to build it:
- **BLOSUM62** — derived from sequences sharing ≤62% identity; the default for most searches, appropriate for moderately diverged sequences
- **BLOSUM80** — derived from more similar sequences; better for finding close relatives
- **BLOSUM45** — derived from more diverged sequences; more sensitive for finding distant relatives

**PAM (Point Accepted Mutation)** matrices take a different approach, modelling protein evolution explicitly. PAM1 represents 1 accepted mutation per 100 residues; PAM250 represents 250 mutations (i.e., highly diverged sequences). PAM matrices are older and less commonly used than BLOSUM for database searches.

> **What you need to know in practice:** The default matrix (BLOSUM62) works well for most searches. If you are looking for distantly related sequences, consider BLOSUM45. If you are looking for very closely related sequences, consider BLOSUM80. The comparative genomics course will explore this in more depth.

### 2.5 The E-value: The Most Important Number in Your Results

The **E-value (Expect value)** answers the question: "How many times would I expect to find a match this good (or better) by chance in a database of this size?"

- **E-value = 0.001** means you would expect to find one match this good by chance once in every 1,000 searches of this database — so this is a strong hit
- **E-value = 10** means you would expect ten matches this good by chance — this is almost certainly noise
- **E-value = 1e-100** (or reported as 0.0) means this match is astronomically unlikely to be coincidental — you have found a clear homologue

Commonly used thresholds:
- **E < 1e-5** — generally considered significant for database annotation
- **E < 1e-3** — often used as a more permissive threshold when searching for distant homologues
- **E > 0.01** — treat with scepticism; likely to include false positives

!!! danger
    **The E-value depends on database size.** The same alignment against a small database will have a lower E-value than against a large database — not because the alignment is better, but because there are fewer sequences to compete with. This is why you should always note which database you searched and its approximate size when reporting BLAST results.

The **bit score** is a database-size-independent measure of alignment quality. When comparing results across different database sizes or different searches, bit scores are more meaningful than E-values.

### 2.6 The Five BLAST Programmes

| Programme | Query | Database | Use case |
|-----------|-------|----------|----------|
| **blastn** | Nucleotide | Nucleotide | Find similar DNA/RNA sequences; identify species from a sequenced fragment |
| **blastp** | Protein | Protein | Find similar protein sequences; most sensitive for distant homologues |
| **blastx** | Nucleotide (translated) | Protein | Find protein matches for an unannotated nucleotide sequence |
| **tblastn** | Protein | Nucleotide (translated) | Find unannotated genomic regions encoding a protein of interest |
| **tblastx** | Nucleotide (translated) | Nucleotide (translated) | Sensitive search for distant nucleotide homologues via protein comparison |

> **Rule of thumb:** Protein-level comparisons (blastp, blastx, tblastx) are more sensitive for finding distant evolutionary relationships than nucleotide comparisons (blastn), because protein sequences are more conserved than their underlying DNA sequences. For most functional annotation tasks, blastp or blastx is preferred.

---

## 3. Interpreting BLAST Results

### 3.1 The Results Table

A typical BLAST results table contains:

| Column | Meaning |
|--------|---------|
| Description | Name of the database sequence (subject) |
| Scientific name | Organism the subject sequence comes from |
| Max score | Bit score of the best HSP for this subject sequence |
| Total score | Sum of bit scores for all HSPs |
| Query cover | Percentage of the query sequence covered by the alignment |
| E value | Expect value for the best HSP |
| Per. ident | Percentage of identical residues in the alignment |
| Accession | Database accession number of the subject sequence |

### 3.2 Reading an Alignment

Below the table, BLAST shows the actual pairwise alignments. Each alignment block shows:

```
Query  1    MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDP  60
            MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDP
Sbjct  1    MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDP  60
```

The middle line shows:
- **Letters** — identical residues
- **`+`** — similar residues (conservative substitution)
- **` ` (space)** — dissimilar residues or gaps

Regions with no middle characters are the least conserved; regions with solid identity rows are the most constrained — often functionally important domains.

### 3.3 Common Pitfalls in Interpreting BLAST Results

**High identity across a short region is not the same as high identity across the full protein.** A protein may share a conserved domain with a database hit but differ substantially elsewhere. Always check query coverage alongside percentage identity.

**The top hit is not always the most biologically informative hit.** Highly redundant databases (nr/nt) contain many sequences from the same species, so your closest relative by E-value may be another sequence from the same organism rather than a true cross-species comparison.

**Low-complexity regions inflate significance.** Regions rich in a single amino acid (e.g., polyglutamine tracts, coiled-coils) or simple sequence repeats can produce spuriously significant alignments. BLAST's low-complexity filter (enabled by default) helps with this but does not always catch every case.

---

## Where to Practise This

The hands-on exercise — running the same BLAST search via the website, the command line, and an API — is taught in [Lecture 15: FAIR in Practice](../15.fair-in-practice/fair-in-practice.md).

---

## Further Reading

- Altschul S.F. et al. (1990). Basic local alignment search tool. *Journal of Molecular Biology*, 215(3): 403–410. — The original BLAST paper; a landmark in bioinformatics history.
- Altschul S.F. et al. (1997). Gapped BLAST and PSI-BLAST: a new generation of protein database search programs. *Nucleic Acids Research*, 25(17): 3389–3402. — Introduction of gapped alignments and the position-specific scoring matrix approach.
- Camacho C. et al. (2009). BLAST+: architecture and applications. *BMC Bioinformatics*, 10: 421. — The paper describing BLAST+, the command-line implementation you will use throughout this programme.
- NCBI BLAST documentation: https://blast.ncbi.nlm.nih.gov/doc/blast-help/

---
