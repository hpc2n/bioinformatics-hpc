# 12. BLAST and Sequence Similarity

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Slides:** [PDF](../../PDFs/lecture-12-blast.pdf)  
**Exercises:** See [`exercises/`](../../exercises/12.blast/)

---


## Session Aims

By the end of this session you should be able to:

1. Explain what sequence similarity is and why it is biologically meaningful
2. Describe how BLAST works at a conceptual level — seeding, extension, scoring, and E-values
3. Interpret a BLAST results table, including E-values, bit scores, and percentage identity
4. Distinguish between the five main BLAST programmes and explain when to use each
5. Run a BLAST search via the NCBI web interface and interpret the output
6. Submit a BLAST search programmatically via the NCBI API using the command line
7. Run BLAST locally on HPC2N using a Slurm job submission
8. Commit BLAST inputs, outputs, and documented commands to Git

**Links to course ILOs:** This session directly addresses ILOs 1, 5, 7, 9, and 12. The algorithmic content provides foundation for the Comparative Genomics course in Semester 2, where BLAST and related tools are treated in much greater depth.

**Note on sequencing:** This lecture follows the Database Landscape session. In the hands-on exercise you will use the TP53 sequence retrieved in Lecture 11 as your query — this is deliberate continuity. Have your `~/course/lecture11-databases/` directory accessible.

---

## Opening Activity

*A short Mentimeter poll will ask whether you have used BLAST before and, if so, what you used it for. This helps calibrate how much time to spend on the web interface versus the command-line components.*

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
    point:** The E-value depends on database size. The same alignment against a small database will have a lower E-value than against a large database — not because the alignment is better, but because there are fewer sequences to compete with. This is why you should always note which database you searched and its approximate size when reporting BLAST results.

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

## 4. Three Ways to Run BLAST

### 4.1 The Web Interface

The NCBI BLAST web interface (https://blast.ncbi.nlm.nih.gov) is the appropriate starting point for exploratory work with a single sequence. It provides access to all BLAST programmes, all major databases, and a well-designed results viewer with taxonomy, alignment viewing, and distance tree tools.

**Appropriate for:** Exploring a new sequence, checking a result interactively, sharing results with collaborators who are not command-line users.

**Not appropriate for:** Running BLAST on hundreds or thousands of sequences, integrating BLAST into a pipeline, running BLAST in a reproducible and documented workflow.

### 4.2 The NCBI API (Programmatic Access)

The NCBI BLAST API allows you to submit jobs and retrieve results from the command line. The workflow is asynchronous: you submit the job, receive a Request ID (RID), wait for it to complete, then retrieve the results.

```bash
# Step 1: Submit a BLAST job (blastp against SwissProt database)
curl "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi" \
  --data "CMD=Put&PROGRAM=blastp&DATABASE=swissprot&QUERY=P04637&FORMAT_TYPE=JSON2&email=your@email.se" \
  | grep -o "RID = [A-Z0-9]*"

# Step 2: Wait ~30 seconds, then retrieve results using your RID
curl "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi" \
  --data "CMD=Get&RID=YOUR_RID_HERE&FORMAT_TYPE=Text" \
  > TP53_blast_results.txt

# Step 3: Inspect results
head -100 TP53_blast_results.txt
grep "^>" TP53_blast_results.txt | head -20
```

**Appropriate for:** Automating a small number of searches, integrating with other command-line tools, documenting searches reproducibly.

**Not appropriate for:** Large-scale searches (hundreds+ sequences) — NCBI imposes rate limits. For scale, use local BLAST.

### 4.3 Local BLAST on HPC2N

For large-scale or routine BLAST searches, installing BLAST+ locally and running against a local copy of the database is far faster and not subject to rate limits. This is the standard approach in production bioinformatics pipelines.

On Kebnekaise, BLAST+ is available as a module:

```bash
module load BLAST+/2.17.0
```

See the hands-on exercise below for the full workflow.

---

## 5. Hands-On Exercise: BLAST from Web to HPC

**Objective:** Run the same BLAST search three ways — web interface, NCBI API, and local HPC — and compare the experience of each. Commit all inputs, outputs, and documented commands to Git.

### Part A — Set up your workspace

```bash
cd ~/course
mkdir -p lecture12-blast && cd lecture12-blast
git init
# Copy the TP53 protein sequence from Lecture 11
cp ../lecture11-databases/TP53_protein.fasta .
git add TP53_protein.fasta
git commit -m "initial commit: lecture12 blast exercise, TP53 query from lecture11"
```

### Part B — Web BLAST (exploratory)

1. Go to https://blast.ncbi.nlm.nih.gov/
2. Select **Protein BLAST (blastp)**
3. Paste the TP53 protein sequence (or enter accession `P04637`)
4. Database: **Swiss-Prot** (not nr — this keeps the results manageable and well-annotated)
5. Click **BLAST** and wait for results

**Questions to answer in your README:**
- What are the top 5 hits? Which organisms do they come from?
- What is the E-value and percentage identity of the top hit?
- At what percentage identity do hits from non-mammalian vertebrates appear?
- Can you find a plant or fungal homologue? What is the E-value and annotation?
- Looking at the alignment for a distant hit — which regions of TP53 are most conserved?

```bash
# Record your observations
cat >> README.md << 'EOF'

## Part B — Web BLAST observations
<!-- Add your answers to the questions above here -->
EOF
git add README.md && git commit -m "lecture12: add web BLAST observations for TP53 blastp vs SwissProt"
```

### Part C — BLAST via NCBI API

```bash
# Submit blastp job for TP53 (UniProt P04637) against SwissProt
# Note: replace your@email.se with your real email (NCBI requires this for API access)
RID=$(curl -s "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi" \
  --data "CMD=Put&PROGRAM=blastp&DATABASE=swissprot&QUERY=P04637\
&FORMAT_TYPE=Text&email=your@email.se" \
  | grep -o "RID = [A-Z0-9]*" | awk '{print $3}')

echo "Job submitted. RID: $RID"
echo "Waiting 45 seconds for results..."
sleep 45

# Retrieve results
curl -s "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi" \
  --data "CMD=Get&RID=${RID}&FORMAT_TYPE=Text" \
  > TP53_blastp_swissprot.txt

# Quick inspection
grep "^>" TP53_blastp_swissprot.txt | head -10
grep "Score\|Expect\|Identities" TP53_blastp_swissprot.txt | head -20
```

```bash
git add TP53_blastp_swissprot.txt
git commit -m "lecture12: add TP53 blastp results retrieved via NCBI API

- Programme: blastp
- Database: SwissProt
- Query: UniProt P04637 (human TP53)
- Retrieved via NCBI Blast.cgi API
- Access date: $(date)"
```

### Part D — Local BLAST on HPC2N via Slurm

For the local exercise we will use a small provided database to avoid the time required to download the full SwissProt database. Your instructor will make this available at:

```
/proj/nobackup/bioinformatics_course/databases/swissprot/
```

```bash
# Load the BLAST+ module
module load BLAST+/2.17.0
module list   # Verify it loaded correctly

# Check the local database is accessible
ls /proj/nobackup/bioinformatics_course/databases/swissprot/

# Create a Slurm job script
cat > blast_tp53.sh << 'EOF'
#!/bin/bash
#SBATCH --job-name=blast_tp53
#SBATCH --account=YOUR_PROJECT_ACCOUNT
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --output=blast_tp53_%j.out
#SBATCH --error=blast_tp53_%j.err

module load BLAST+/2.17.0

blastp \
  -query TP53_protein.fasta \
  -db /proj/nobackup/bioinformatics_course/databases/swissprot/swissprot \
  -out TP53_blastp_local.txt \
  -outfmt 6 \
  -evalue 1e-5 \
  -num_threads 4 \
  -max_target_seqs 50

echo "BLAST complete: $(date)"
EOF

# Submit the job
sbatch blast_tp53.sh

# Monitor job status
squeue -u $USER

# Once complete, inspect tabular output (format 6)
# Columns: qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore
head -20 TP53_blastp_local.txt

# Sort by E-value (column 11)
sort -k11 -n TP53_blastp_local.txt | head -20

# How many hits with E < 1e-10?
awk '$11 < 1e-10' TP53_blastp_local.txt | wc -l
```

```bash
git add blast_tp53.sh TP53_blastp_local.txt
git commit -m "lecture12: add local BLAST job script and results

- blastp against local SwissProt copy on Kebnekaise
- E-value threshold: 1e-5
- Output format: tabular (fmt 6)
- Submitted via Slurm"
```

### Part E — Comparing the three approaches

Add to your README a brief comparison:

| Approach | Speed | Scalability | Reproducibility | Control |
|----------|-------|-------------|-----------------|---------|
| Web interface | Fast for 1 sequence | Not scalable | Low (no record of parameters) | Limited |
| NCBI API | Moderate | ~10s of sequences | Good (paramters in code) | Moderate |
| Local HPC | Slow to set up, fast to run | Highly scalable | Excellent (script + Slurm log) | Full |

---

### Extension Task — Cross-kingdom conservation

Using the plant universal reference gene **ubiquitin** as a query, run a blastp search against SwissProt via the API and answer: in which major lineages is ubiquitin detectable, and what does the very high conservation tell you about its function?

Arabidopsis thaliana ubiquitin accession: `P0CG53`

```bash
# Fetch the sequence from UniProt
curl "https://rest.uniprot.org/uniprotkb/P0CG53.fasta" > ubiquitin_arabidopsis.fasta
head -3 ubiquitin_arabidopsis.fasta
wc -c ubiquitin_arabidopsis.fasta

# Now adapt your API BLAST script to use this as the query
```

*Questions: How does the E-value and percentage identity for ubiquitin hits compare to TP53 hits across distant species? What does this tell you about the selective pressure on these two proteins?*

---

## 6. In-Session Quizzes

### Mentimeter Quiz 1 — Prior knowledge (session opening)
- Q1: "Have you used BLAST before?" (Yes — I know what it does / Yes — but not sure how it works / No / I've heard of it but not used it)
- Q2 (word cloud): "In one word — what do you think BLAST stands for?"

### Mentimeter Quiz 2 — E-value interpretation (end of Block 1)

**Q1:** A blastp search returns a hit with E-value = 2e-85. Which interpretation is correct?
- A) This match could easily occur by chance
- B) This match is extremely unlikely to be coincidental — strong evidence of homology ✓
- C) The E-value tells you the percentage of identical residues
- D) An E-value below 0.05 is always significant regardless of database size

**Q2:** You are annotating a gene from a newly sequenced plant genome. Which BLAST programme would you use to search for its protein function using a protein database?
- A) blastn — nucleotide query vs nucleotide database
- B) blastp — protein query vs protein database
- C) blastx — nucleotide query vs protein database ✓ *(if you only have the DNA sequence)*
- D) tblastn — protein query vs translated nucleotide database

*Note for presenter: Q2 has a nuance — blastp if you have the predicted protein, blastx if you only have the DNA. Discuss both scenarios.*

**Q3:** You find two BLAST hits: Hit A has E-value 1e-50 and 45% identity over the full protein length; Hit B has E-value 1e-60 and 95% identity but only covers 15% of the query. Which is more likely to share the same overall function?
- A) Hit A — higher query coverage at reasonable identity ✓
- B) Hit B — lower E-value and higher identity
- C) They are equally informative
- D) Cannot tell from this information alone

---

## 7. What You Should Know After This Session

✅ **Explain what homology means** and distinguish orthologues from paralogues.

✅ **Describe the seed-and-extend strategy** of BLAST at a conceptual level.

✅ **Explain what an E-value is** and interpret a BLAST E-value correctly, including the effect of database size.

✅ **Distinguish bit score from E-value** and explain when bit score is more appropriate.

✅ **Select the appropriate BLAST programme** (blastn, blastp, blastx, tblastn, tblastx) for a given query/database combination.

✅ **Interpret a BLAST results table** including query coverage, percentage identity, E-value, and bit score.

✅ **Run a BLAST search via the web interface** and identify the key parameters set.

✅ **Submit a BLAST job via the NCBI API** from the command line and retrieve results.

✅ **Write a Slurm job script for local BLAST on HPC2N** and submit, monitor, and retrieve results.

✅ **Commit BLAST inputs, scripts, and outputs to Git** with a meaningful, informative commit message.

---

## 8. Further Reading

- Altschul S.F. et al. (1990). Basic local alignment search tool. *Journal of Molecular Biology*, 215(3): 403–410. — The original BLAST paper; a landmark in bioinformatics history.
- Altschul S.F. et al. (1997). Gapped BLAST and PSI-BLAST: a new generation of protein database search programs. *Nucleic Acids Research*, 25(17): 3389–3402. — Introduction of gapped alignments and the position-specific scoring matrix approach.
- Camacho C. et al. (2009). BLAST+: architecture and applications. *BMC Bioinformatics*, 10: 421. — The paper describing BLAST+, the command-line implementation you will use throughout this programme.
- NCBI BLAST documentation: https://blast.ncbi.nlm.nih.gov/doc/blast-help/

---

