# 13. Bioinformatics File Formats

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Slides:** [PDF](../../PDFs/lecture-13-file-formats.pdf)  
**Exercises:** See [`exercises/`](../../exercises/13.file-formats/)

---


## Session Aims

By the end of this session you should be able to:

1. Explain why standardised file formats are essential for bioinformatics pipelines
2. Describe the structure and purpose of FASTA, FASTQ, SAM/BAM, VCF, GFF/GTF, and BED formats
3. Interpret Phred quality scores and explain their significance for data quality assessment
4. Parse and inspect common bioinformatics files using command-line tools
5. Use `samtools` for basic BAM file operations: viewing, sorting, indexing, and flagstat
6. Use `awk` and `grep` to extract features and information from text-based formats
7. Commit file format exercises and documented commands to Git

**Links to course ILOs:** This session directly addresses ILOs 1, 4, 7, and 9. It provides essential practical knowledge for every subsequent course in the programme — you will work with these formats constantly.

**Note on context:** You have already encountered FASTA and FASTQ in Lectures 2 and 3. This session deepens that knowledge and extends it to the full range of formats you will use in the programme. Think of today as building a reference toolkit you will return to throughout your studies.

---

## Opening Activity

*A Mentimeter poll will ask which of today's file formats you have previously encountered, and — for any you have used — whether you could describe their structure from memory. This will help calibrate where to focus the session.*

---

## 1. Why File Formats Matter

### 1.1 Formats as Contracts Between Tools

A bioinformatics analysis is not a single program — it is a pipeline: a sequence of tools, each of which reads the output of the previous tool as its input. For this chain to work, every tool must agree on how data is represented. A file format is the contract that makes this possible.

When that contract is broken — a file is in the wrong format, uses non-standard encoding, or has been truncated — the pipeline fails, often with cryptic error messages. Understanding file formats well enough to diagnose these failures is one of the most practically important skills in applied bioinformatics.

### 1.2 The Pipeline as a Series of Format Conversions

A typical short-read genomics analysis follows this chain:

```
Raw sequencer output
        ↓
FASTQ  — quality-trimmed reads
        ↓
SAM/BAM — reads aligned to a reference genome
        ↓
BAM (sorted, indexed) — alignments ready for analysis
        ↓
VCF — variants called from the alignment
        ↓
BED/GFF — genomic features and annotations
```

Each format in this chain has a specific purpose, and the transitions between them are where most pipeline failures occur. By the end of this session, you will understand what each step produces and why.

### 1.3 Text vs Binary Formats

Most bioinformatics formats are **plain text** — they can be opened in any text editor, inspected with `head`, `grep`, `awk`, and `cat`, and debugged without special tools. This is a deliberate design choice that prioritises transparency and debuggability.

Some formats have **binary counterparts** that are more compact and faster to access — BAM (binary SAM), BCF (binary VCF), and compressed BED files. Binary formats are not human-readable but are indexed for rapid random access, which is essential when working with files of many gigabytes.

!!! tip
    ** Always keep a plain-text version of at least the header of a binary file accessible (use `samtools view -H` for BAM, `bcftools view -h` for BCF) so you can inspect what the file contains without fully decompressing it.

---

## 2. FASTA

You have already worked with FASTA in Lectures 2 and 3. Here we cover it more completely.

### 2.1 Structure

```
>sequence_identifier optional_description
SEQUENCE_DATA_ON_ONE_OR_MORE_LINES
```

The `>` character marks the start of a new record. The identifier is the first whitespace-delimited token after `>`. Everything after the first whitespace on the header line is the description and is ignored by most tools.

A **multi-FASTA** file contains multiple records, each with its own header. This is the standard format for genome assemblies, proteomes, and reference sequence collections.

### 2.2 Common Gotchas

**Line length:** FASTA sequences are typically wrapped at 60 or 80 characters per line. Some tools are sensitive to this. The `fold` command wraps sequences to a specified width.

**Header format inconsistency:** Different databases use different header formats. NCBI headers include the accession, version, and description; UniProt headers include the database, accession, and entry name. Tools that parse headers may fail if the expected format is not present.

**Soft vs hard masking:** Lowercase letters in a FASTA sequence indicate soft-masked repeats (the sequence is still used but treated differently by some aligners). Uppercase `N` characters indicate hard-masked regions — positions of unknown sequence.

### 2.3 Useful Commands

```bash
# Count sequences in a FASTA file
grep -c "^>" sequences.fasta

# Extract only header lines
grep "^>" sequences.fasta

# Get length of each sequence (one-liner using awk)
awk '/^>/{if(seq) print name"\t"length(seq); name=$0; seq=""} !/^>/{seq=seq$0} END{if(seq) print name"\t"length(seq)}' sequences.fasta

# Wrap sequence lines at 60 characters
fold -w 60 sequences.fasta
```

---

## 3. FASTQ

### 3.1 Structure

FASTQ is the standard format for raw sequencing reads. Each read occupies exactly four lines:

```
@read_identifier optional_description
SEQUENCE
+
QUALITY_SCORES
```

Line 1: Header — begins with `@` (not `>`)
Line 2: Sequence — the actual nucleotide calls
Line 3: Separator — always `+`, optionally followed by the header again
Line 4: Quality scores — one character per base, encoding the Phred quality score

### 3.2 Phred Quality Scores

The quality score *Q* is defined as:

**Q = −10 × log₁₀(P)**

where *P* is the estimated probability that a base call is incorrect.

| Q score | Error probability | Accuracy |
|---------|------------------|---------|
| 10 | 1 in 10 | 90% |
| 20 | 1 in 100 | 99% |
| 30 | 1 in 1,000 | 99.9% |
| 40 | 1 in 10,000 | 99.99% |

A Q30 score — meaning a 1 in 1,000 probability of an error — is the commonly cited threshold for high-quality base calls. Modern Illumina sequencers typically produce average Q scores of 30–40 for most of a read, with quality declining towards the 3' end.

### 3.3 Quality Score Encoding

Quality scores are encoded as ASCII characters. The encoding adds an offset to the Q score to produce a printable character:

**Phred+33 (Sanger/Illumina 1.8+):** `ASCII character = Q + 33`

A Q30 score becomes ASCII character 63, which is `?`. A Q40 score becomes ASCII character 73, which is `I`.

!!! warning
    ** An older encoding (Phred+64, used by early Illumina pipelines) adds 64 instead of 33. Mixing up encodings is a classic source of pipeline errors. Modern data (post-2011) almost always uses Phred+33.

### 3.4 Parsing FASTQ with Shell Tools

```bash
# Count the number of reads (4 lines per read)
wc -l reads.fastq | awk '{print $1/4}'

# Extract just the sequence lines
awk 'NR%4==2' reads.fastq | head -5

# Extract just the quality score lines
awk 'NR%4==0' reads.fastq | head -5

# Check the range of quality characters (to infer encoding)
awk 'NR%4==0' reads.fastq | fold -w1 | sort -u | head -5

# Get basic statistics with seqkit (if available)
seqkit stats reads.fastq
```

### 3.5 Paired-End Reads

Modern sequencing experiments typically produce **paired-end reads**: two FASTQ files (R1 and R2) where each pair of reads comes from opposite ends of the same DNA fragment. The pairing must be maintained throughout the pipeline — if reads are filtered in one file but not the other, the files become out of sync, which will cause alignment tools to fail.

---

## 4. SAM and BAM

### 4.1 What SAM Represents

SAM (Sequence Alignment/Map) is the standard format for storing read alignments to a reference genome. After FASTQ files have been quality-trimmed, they are aligned to a reference genome using a tool such as HISAT2, STAR, or BWA-MEM. The output is a SAM file describing where each read maps.

BAM is the binary, compressed version of SAM. BAM files are typically 5–10× smaller than equivalent SAM files and can be randomly accessed via an index file (`.bai`). In practice, you will almost always work with BAM files rather than SAM files, but SAM is human-readable and useful for understanding the format.

### 4.2 SAM File Structure

A SAM file has two sections:

**Header section** — lines beginning with `@`:
- `@HD` — file-level metadata (SAM version, sort order)
- `@SQ` — reference sequence dictionary (chromosome names and lengths)
- `@RG` — read group information (sample, library, sequencing platform)
- `@PG` — programme chain (which tools were used to produce this file)

**Alignment section** — one line per read, with 11 mandatory tab-separated fields:

| Field | Name | Description |
|-------|------|-------------|
| 1 | QNAME | Read name |
| 2 | FLAG | Bitwise flag encoding alignment properties |
| 3 | RNAME | Reference sequence name (chromosome) |
| 4 | POS | 1-based leftmost mapping position |
| 5 | MAPQ | Mapping quality score |
| 6 | CIGAR | String encoding the alignment |
| 7 | RNEXT | Reference of the mate read |
| 8 | PNEXT | Position of the mate read |
| 9 | TLEN | Template length (insert size) |
| 10 | SEQ | Read sequence |
| 11 | QUAL | Read quality scores |

### 4.3 The FLAG Field

The FLAG field is a single integer that encodes multiple binary properties of an alignment as a bitwise sum. Common flag values:

| Flag | Value | Meaning |
|------|-------|---------|
| 0x1 | 1 | Template has multiple segments (paired-end) |
| 0x2 | 2 | All segments are properly aligned |
| 0x4 | 4 | The read is unmapped |
| 0x8 | 8 | The mate is unmapped |
| 0x10 | 16 | Read is on the reverse strand |
| 0x100 | 256 | Not the primary alignment |
| 0x400 | 1024 | PCR or optical duplicate |

A FLAG value of 99 means: paired (1) + properly paired (2) + mate on reverse strand (32) + read is first in pair (64) = 1+2+32+64 = 99.

!!! tip
    ** Use the Broad Institute's SAM flag explainer at https://broadinstitute.github.io/picard/explain-flags.html to decode any FLAG value instantly.

### 4.4 The CIGAR String

The CIGAR string encodes how a read aligns to the reference — which bases match, which are insertions, deletions, or clipped:

| Code | Meaning |
|------|---------|
| M | Match or mismatch (aligned) |
| I | Insertion in the read relative to the reference |
| D | Deletion in the read relative to the reference |
| N | Skipped region — used for introns in RNA-seq |
| S | Soft clip — bases in the read not aligned (at ends) |
| H | Hard clip — bases removed from the sequence |

Example: `50M2I30M3D20M` means: 50 aligned bases, 2-base insertion, 30 aligned bases, 3-base deletion, 20 aligned bases.

### 4.5 Working with BAM Files using samtools

```bash
# Load samtools on HPC2N
module load SAMtools/1.22

# View a BAM file as human-readable SAM
samtools view -h alignment.bam | head -50

# View only the header
samtools view -H alignment.bam

# Sort by coordinate (required before indexing)
samtools sort -o alignment.sorted.bam alignment.bam

# Index a sorted BAM file (creates alignment.sorted.bam.bai)
samtools index alignment.sorted.bam

# Alignment statistics
samtools flagstat alignment.sorted.bam

# Count mapped reads
samtools view -c -F 4 alignment.sorted.bam

# View reads mapping to a specific region (requires index)
samtools view alignment.sorted.bam chr1:1000000-2000000 | head -20
```

---

## 5. VCF — Variant Call Format

### 5.1 Purpose and Structure

VCF is the standard format for recording genomic variants — SNPs, indels, and structural variants — identified by comparing sequencing data to a reference genome. It has two sections:

**Meta-information lines** — beginning with `##`:
Describe the file format version, the reference genome used, the variant caller and its parameters, and the meaning of all INFO, FORMAT, and FILTER tags used in the data.

**Header line** — beginning with `#CHROM`:
Column names, followed by sample names.

**Data lines** — one line per variant:

| Column | Description |
|--------|-------------|
| CHROM | Chromosome |
| POS | 1-based position |
| ID | Variant identifier (e.g. rsID, or `.` if none) |
| REF | Reference allele |
| ALT | Alternate allele(s) |
| QUAL | Phred-scaled quality score for the variant call |
| FILTER | PASS or the filter(s) the variant failed |
| INFO | Semicolon-delimited key=value pairs of variant annotations |
| FORMAT | Colon-delimited keys describing the per-sample fields |
| SAMPLE | Per-sample values in the order specified by FORMAT |

### 5.2 Reading a VCF Line

```
chr17  7674220  rs28934578  C  T  .  PASS  DP=245;AF=0.45  GT:DP:GQ  0/1:245:99
```

This records a heterozygous C→T SNP at position 7,674,220 on chromosome 17 (in TP53, as it happens), with depth 245× and genotype quality 99. The GT field `0/1` means heterozygous: one copy of the reference allele (0) and one copy of the alternate (1).

### 5.3 Useful Commands

```bash
# Count variants (excluding header lines)
grep -v "^#" variants.vcf | wc -l

# View only header lines
grep "^#" variants.vcf

# Filter to PASS variants only
grep -v "^#" variants.vcf | awk '$7=="PASS"' | wc -l

# Extract SNPs only (where REF and ALT are both single bases)
grep -v "^#" variants.vcf | awk 'length($4)==1 && length($5)==1'

# With bcftools (more robust for complex VCFs)
module load BCFtools/1.19
bcftools stats variants.vcf | grep "^SN"
bcftools view -f PASS variants.vcf | grep -v "^#" | wc -l
```

---

## 6. GFF and GTF — Genome Annotation Formats

### 6.1 Purpose

GFF (General Feature Format) and GTF (Gene Transfer Format) store genome annotation — the positions and properties of genes, transcripts, exons, UTRs, and other genomic features. They describe what the genome encodes rather than the sequence itself.

### 6.2 Structure

Both formats are nine-column tab-separated text files:

| Column | Name | Description |
|--------|------|-------------|
| 1 | seqname | Chromosome or scaffold name |
| 2 | source | Annotation source (e.g. Ensembl, AUGUSTUS) |
| 3 | feature | Feature type (gene, transcript, exon, CDS, UTR) |
| 4 | start | 1-based start coordinate |
| 5 | end | End coordinate (inclusive) |
| 6 | score | Numeric score or `.` |
| 7 | strand | `+` (forward) or `-` (reverse) |
| 8 | frame | Reading frame (0, 1, 2, or `.`) |
| 9 | attributes | Key-value pairs (syntax differs between GFF2, GFF3, and GTF) |

The key difference between GFF3 and GTF is the attributes field syntax. GFF3 uses `key=value;` pairs; GTF uses `key "value";` pairs. GTF is historically the format used by ENSEMBL and UCSC for vertebrate genomes; GFF3 is more commonly used for plant and other genomes.

### 6.3 Useful Commands

```bash
# Count features by type
awk '!/^#/{print $3}' annotation.gff | sort | uniq -c | sort -rn

# Extract all gene lines
awk '!/^#/ && $3=="gene"' annotation.gff | head -10

# Count genes on each chromosome
awk '!/^#/ && $3=="gene"{print $1}' annotation.gff | sort | uniq -c | sort -rn

# Extract gene names from GTF attributes
awk '!/^#/ && $3=="gene"' annotation.gtf | grep -oP 'gene_name "\K[^"]+' | head -20

# Count exons per gene (more complex — see handout extension)
awk '!/^#/ && $3=="exon"' annotation.gtf | grep -oP 'gene_id "\K[^"]+' | sort | uniq -c | sort -rn | head -20
```

---

## 7. BED — Browser Extensible Data

### 7.1 Purpose and Structure

BED format stores genomic intervals — regions of the genome defined by a chromosome, start, and end position. It is widely used for:
- Defining regions of interest (e.g. genes, regulatory elements, capture targets)
- Storing peak calls from ChIP-seq or ATAC-seq
- Defining exon coordinates for RNA-seq analysis

BED uses **0-based, half-open coordinates**: the start position is 0-based (the first base of a chromosome is position 0, not 1) and the end position is exclusive.

This is one of the most common sources of off-by-one errors in bioinformatics. SAM/VCF/GFF use 1-based coordinates; BED uses 0-based. Always check.

**Mandatory columns (BED3):**

| Column | Description |
|--------|-------------|
| 1 | chrom — chromosome name |
| 2 | chromStart — 0-based start |
| 3 | chromEnd — end (exclusive) |

**Optional additional columns (BED6, BED12):**

| Column | Description |
|--------|-------------|
| 4 | name |
| 5 | score (0–1000) |
| 6 | strand (+ or −) |

### 7.2 Useful Commands

```bash
# Count regions in a BED file
wc -l regions.bed

# Calculate total covered bases
awk '{sum += $3-$2} END {print sum}' regions.bed

# Sort a BED file
sort -k1,1 -k2,2n regions.bed > regions.sorted.bed

# Find regions on a specific chromosome
awk '$1=="chr1"' regions.bed | wc -l

# With bedtools (if available)
module load BEDTools/2.31.1
bedtools intersect -a regions_a.bed -b regions_b.bed | wc -l
```

---

## 8. Format Reference Summary

| Format | Type | Primary use | Coordinate system | Key tool |
|--------|------|-------------|------------------|---------|
| FASTA | Text | Sequences (DNA, RNA, protein) | N/A | seqkit, grep |
| FASTQ | Text | Raw sequencing reads with quality | N/A | seqkit, FastQC |
| SAM | Text | Read alignments (human-readable) | 1-based | samtools |
| BAM | Binary | Read alignments (compressed) | 1-based | samtools |
| VCF | Text | Genomic variants | 1-based | bcftools |
| BCF | Binary | Genomic variants (compressed) | 1-based | bcftools |
| GFF3 | Text | Genome annotation (general) | 1-based | grep, awk |
| GTF | Text | Genome annotation (Ensembl/UCSC) | 1-based | grep, awk |
| BED | Text | Genomic intervals | 0-based | bedtools |

> **Coordinate system warning:** BED is 0-based; everything else is 1-based. This is a constant source of off-by-one errors. When converting between formats, always verify the coordinate system.

---

## 9. Hands-On Exercise: Parsing Bioinformatics Formats on HPC

**Objective:** Work with real examples of each major file format using command-line tools on Kebnekaise. Practice extracting meaningful information from each format without specialised software — then use the appropriate specialist tool.

Your instructor will make example files available at:
```
/proj/nobackup/bioinformatics_course/data/formats/
```

### Part A — Set up

```bash
cd ~/course
mkdir -p lecture13-formats && cd lecture13-formats
git init
cp /proj/nobackup/bioinformatics_course/data/formats/* .
ls -lh    # What files are here? What are their sizes?
git add . && git commit -m "initial commit: lecture13 format exercise files"
```

### Part B — FASTQ inspection

```bash
# How many reads are in the file?
wc -l sample.fastq | awk '{print $1/4}'

# Look at the first read — all four lines
head -4 sample.fastq

# What characters appear in quality scores?
awk 'NR%4==0' sample.fastq | fold -w1 | sort -u

# What is the minimum and maximum quality character?
awk 'NR%4==0' sample.fastq | fold -w1 | sort -u | head -1   # min
awk 'NR%4==0' sample.fastq | fold -w1 | sort -u | tail -1   # max

# Convert the lowest quality character to a Q score (ASCII value minus 33)
# What is the probability of error at this quality?
```

*Questions: Is this Phred+33 encoding? What is the read length? Are all reads the same length?*

### Part C — BAM file operations

```bash
module load SAMtools/1.22

# View the header
samtools view -H sample.bam

# How many reference sequences are in the header?
samtools view -H sample.bam | grep "^@SQ" | wc -l

# Alignment statistics
samtools flagstat sample.bam

# How many reads are mapped?
samtools view -c -F 4 sample.bam

# Sort and index
samtools sort -o sample.sorted.bam sample.bam
samtools index sample.sorted.bam

# Look at the first few alignments — note the FLAG and CIGAR fields
samtools view sample.sorted.bam | head -5

# Decode the FLAG of the first read — what does it tell you?
# Look up: https://broadinstitute.github.io/picard/explain-flags.html

# Extract reads mapping to a specific region
samtools view sample.sorted.bam chr1:1-100000 | wc -l
```

### Part D — VCF inspection

```bash
# View the header
grep "^#" sample.vcf | head -20

# How many variants are in the file?
grep -v "^#" sample.vcf | wc -l

# How many passed all filters?
grep -v "^#" sample.vcf | awk '$7=="PASS"' | wc -l

# What chromosomes have variants?
grep -v "^#" sample.vcf | awk '{print $1}' | sort | uniq -c | sort -rn

# Find any variants in TP53 (chr17 ~7,600,000-7,700,000)
grep -v "^#" sample.vcf | awk '$1=="chr17" && $2>=7600000 && $2<=7700000'

# Count SNPs vs indels
grep -v "^#" sample.vcf | awk 'length($4)==1 && length($5)==1' | wc -l   # SNPs
grep -v "^#" sample.vcf | awk 'length($4)!=1 || length($5)!=1' | wc -l   # indels
```

### Part E — GFF/GTF annotation

```bash
# What feature types are present?
awk '!/^#/{print $3}' sample.gtf | sort | uniq -c | sort -rn

# How many genes are annotated?
awk '!/^#/ && $3=="gene"' sample.gtf | wc -l

# How many genes on each chromosome?
awk '!/^#/ && $3=="gene"{print $1}' sample.gtf | sort | uniq -c | sort -rn | head -10

# Extract gene names
awk '!/^#/ && $3=="gene"' sample.gtf | grep -oP 'gene_name "\K[^"]+' | head -20

# Find the gene with the most exons
awk '!/^#/ && $3=="exon"' sample.gtf | grep -oP 'gene_name "\K[^"]+' | sort | uniq -c | sort -rn | head -5
```

### Part F — Document and commit

```bash
cat >> README.md << 'EOF'

## Format exercise findings

### FASTQ
- Number of reads:
- Read length:
- Quality encoding: Phred+33 / Phred+64 (delete as appropriate)
- Notes:

### BAM
- Number of mapped reads:
- Mapping rate:
- Reference sequences:
- Notes on CIGAR/FLAG:

### VCF
- Total variants:
- PASS variants:
- SNPs / indels:
- Notes:

### GTF
- Number of genes:
- Most exon-dense gene:
- Notes:
EOF

git add .
git commit -m "lecture13: format inspection exercise complete

- Inspected FASTQ, BAM, VCF, and GTF files
- Used samtools, grep, awk, and wc throughout
- Findings documented in README"
```

---

## 10. In-Session Quizzes

### Mentimeter Quiz 1 — Prior knowledge (session opening)
- Q1: "Which of these formats have you previously encountered?" (multi-select): FASTA / FASTQ / SAM / BAM / VCF / GFF / GTF / BED / None of the above
- Q2 (word cloud): "In one word — what is a bioinformatics file format?"

### Mentimeter Quiz 2 — Format knowledge check (end of Block 1)

**Q1:** A FASTQ quality score character is `I`. Using Phred+33 encoding, what is the Q score?
- A) 9
- B) 40 ✓ — ASCII value of `I` is 73; 73−33=40
- C) 33
- D) 73

*Presenter note: walk through the calculation. ASCII('I') = 73. Q = 73 − 33 = 40. P(error) = 10^(−40/10) = 10^−4 = 0.01%.*

**Q2:** A read in a SAM file has FLAG = 16. What does this tell you?
- A) The read is unmapped
- B) The read is on the reverse strand ✓ (0x10 = 16)
- C) The read is a PCR duplicate
- D) The read failed quality filters

**Q3:** You have a BED file with an entry: `chr1  1000  2000`. What is the length of this region in bases?
- A) 1,001 bases
- B) 1,000 bases ✓ — BED is 0-based half-open: 2000−1000=1000
- C) 999 bases
- D) Cannot tell without knowing the coordinate system

---

## 11. What You Should Know After This Session

✅ **Explain why standardised file formats matter** for bioinformatics pipeline design.

✅ **Describe the structure of FASTA and FASTQ**, including the four-line FASTQ record and Phred quality score encoding.

✅ **Convert a quality character to a Q score** using Phred+33 encoding and interpret its error probability.

✅ **Describe the structure of a SAM file** — header section, mandatory fields, FLAG field, and CIGAR string.

✅ **Use `samtools`** to view, sort, index, and run flagstat on a BAM file.

✅ **Describe the structure of VCF, GFF/GTF, and BED** and state the coordinate system each uses.

✅ **Use `grep` and `awk`** to extract specific features or variants from text-based format files.

✅ **Explain the 0-based vs 1-based coordinate distinction** and identify which formats use each.

✅ **Commit format exercises and findings to Git** with a structured README.

---

## 12. Further Reading

- Li H. et al. (2009). The Sequence Alignment/Map format and SAMtools. *Bioinformatics*, 25(16): 2078–2079. — The original SAM/BAM paper.
- Danecek P. et al. (2011). The variant call format and VCFtools. *Bioinformatics*, 27(15): 2156–2158. — The original VCF paper.
- Cock P.J.A. et al. (2010). The Sanger FASTQ file format for sequences with quality scores, and the Solexa/Illumina FASTQ variants. *Nucleic Acids Research*, 38(6): 1767–1771. — Definitive reference on FASTQ encoding.
- Quinlan A.R. & Hall I.M. (2010). BEDTools: a flexible suite of utilities for comparing genomic features. *Bioinformatics*, 26(6): 841–842. — The BEDTools paper; one of the most widely cited bioinformatics tools.
- SAM format specification: https://samtools.github.io/hts-specs/SAMv1.pdf
- VCF format specification: https://samtools.github.io/hts-specs/VCFv4.3.pdf

---

