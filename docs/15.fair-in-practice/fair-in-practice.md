# 15. FAIR in Practice

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Slides:** [PDF](../../PDFs/lecture-15-fair-in-practice.pdf)  
**Exercises:** See [`exercises/`](../../exercises/15.fair-in-practice/)

**This is a self-study exercise page, not a taught session.** Work through Parts 1–4 at your own pace, following on from [Lecture 14: FAIR and Open Science](../14.fair-open-science/fair-open-science.md), where Jamie McCann introduced PlantGenIE live. Bring questions to office hours or post on the Canvas discussion board.

---

## Hands-On Exercises in Interoperability and Reusability
### Master's Programme in Bioinformatics — Umeå University
### Computing for Data-Driven Biology (5BI00A)

---

## Session Aims

By the end of these exercises you should be able to:

1. Run a BLAST search via a website, from the command line on HPC, and via an API — and explain when and why you would choose each
2. Query a REST API from the command line and parse the response — demonstrating Interoperability in practice
3. Explain how a well-designed API embodies the Interoperable and Reusable principles of FAIR
4. Apply a structured metadata sufficiency checklist to a real GEO or ENA dataset
5. Identify specific metadata fields whose absence would prevent reanalysis of a published RNA-seq study
6. Assess the computational reproducibility of a published bioinformatics study using a structured framework
7. Build a minimal reproducible report (Jupyter notebook) that combines code, narrative, and live output
8. Commit all exercise outputs, commands, and findings to Git

**Links to course ILOs:** These exercises directly address ILOs 1, 3, 7, 9, 12, and 13. They are the practical companion to Lecture 14 and provide direct preparation for the FAIR essay assessment. For background on BLAST itself, see the [BLAST background reference](../12.blast/blast.md).

**PlantGenIE guest contribution:** Jamie McCann, developer of PlantGenIE (plantgenie.se) at Umeå University, introduced the platform live in Lecture 14. Part 1 below puts that introduction into practice, working directly with the API he described.

---

## Part 1 — Interoperability: Three Ways to Run BLAST

**Background reading:** If you have not used BLAST before, or want a refresher on what it does and how to interpret its output (E-values, bit scores, the BLOSUM matrix), read the [BLAST background reference](../12.blast/blast.md) before starting this part. This part assumes you already know what BLAST is — it focuses on *how*, *when*, and *why* you would run it in each of three different ways.

### 1.1 The Same Search, Three Different Tools

Running a BLAST search is not just "go to the NCBI website." The same search can be run through a web interface, from the command line against a local database, or programmatically via an API — and which one you should use depends entirely on the task.

| Way | How | When to use it | Why |
|-----|-----|-----------------|-----|
| **Website** | NCBI BLAST web interface (or a resource's own web BLAST, e.g. PlantGenIE's) | Exploring a single sequence interactively; sharing results with non-CLI collaborators | No setup required; results viewer with alignments, taxonomy, and distance trees built in |
| **Command line (local/HPC)** | BLAST+ installed on Kebnekaise, run against a local database copy via Slurm | Large-scale or routine searches; integrating BLAST into a documented, reproducible pipeline | No rate limits; fully scriptable; the script itself is your record of exactly what was run |
| **API** | Submit a query and retrieve results programmatically over HTTP (NCBI's BLAST API, or a resource's own API such as PlantGenIE's) | Automating a small number of searches; integrating BLAST into another tool without a browser | Demonstrates Interoperability directly — the same data a browser shows you, exposed through a documented, machine-readable interface |

The exercises below walk through all three using the same query sequence, so you can compare the experience directly.

### 1.2 What is PlantGenIE?

PlantGenIE (plantgenie.se) is a bioinformatics resource for plant and tree genomics developed at Umeå University, with primary development by Jamie McCann and contributions from the research groups of Nathaniel Street and others at UPSC. It integrates genome browsers, gene expression and co-expression data, functional annotations, a BLAST search interface, and REST API endpoints exposing all of the above — for boreal forest tree species including *Picea abies* (Norway spruce) and *Populus tremula* (European aspen).

PlantGenIE is currently undergoing active redevelopment, including a new *Picea abies* genome assembly with a different gene identifier scheme than earlier versions. The base URL, endpoints, and example gene ID used in these exercises have been verified against the live API. If an endpoint has changed since, check the current API documentation (Section "Further Reading" below) or post on the Canvas discussion board.

The PlantGenIE codebase is publicly available on GitHub: https://github.com/plantgenie

### 1.3 Why PlantGenIE Demonstrates Interoperability

Recall from Lecture 14 that **Interoperability** requires:
- Using standard formats and protocols
- Using ontologies and controlled vocabularies for metadata
- Providing cross-references to related databases
- Making data accessible via documented, machine-readable interfaces

PlantGenIE's REST API embodies each of these:

- **Standard protocol:** HTTP/HTTPS — the same protocol your browser uses; any programming language or command-line tool can query it
- **Standard formats:** Responses are returned as JSON (a widely used, machine-readable format) or FASTA (a standard bioinformatics format)
- **Ontology cross-references:** Gene entries link to GO terms, InterPro domains, and NCBI taxonomy identifiers
- **Documentation:** The API endpoints are documented, which means any researcher can query them programmatically without needing to contact the authors or navigate a specific web interface

Querying PlantGenIE from the command line — rather than through the web browser — is exactly what Interoperability enables. The same data that is presented visually in the browser is accessible programmatically, in a standard format, to any researcher or tool.

### 1.4 REST APIs: A Brief Technical Overview

A REST (Representational State Transfer) API is an interface to a web service that follows a set of conventions, allowing resources to be retrieved using standard HTTP methods and URLs.

The key concept is that each **endpoint** is a URL that returns a specific piece of data — for example, a gene-information endpoint, an expression-data endpoint, and a BLAST endpoint. You query these endpoints using `curl` or equivalent tools, and the response arrives as JSON or plain text. This is identical in structure to the NCBI and UniProt API calls you made in Lecture 11 — the same concept, a different resource.

**JSON** (JavaScript Object Notation) is the standard response format for most REST APIs, structured as key-value pairs, e.g. a gene ID, organism, description, and lists of GO/InterPro cross-references. You can parse JSON responses at the command line using `jq` (if available) or Python, or simply use `grep` for extracting specific fields.

**PlantGenIE's endpoints take a JSON request body via POST**, unlike the simpler path-based GET requests used for NCBI and UniProt in Lecture 11 — a useful contrast in REST API design. The base URL and gene ID used below are confirmed working; if the API has changed since, check the current documentation or ask on the Canvas discussion board.

### 1.4 Hands-On: Querying the PlantGenIE API

**Prerequisites:** Login to Kebnekaise via OnDemand. Create a working directory and initialise Git.

```bash
cd ~/course
mkdir -p lecture15-fair-practice && cd lecture15-fair-practice
git init
cat > README.md << 'EOF'
# Lecture 15: FAIR in Practice
## Exercises in Interoperability and Reusability
EOF
git add README.md
git commit -m "initial commit: lecture15 FAIR practical exercises"
```

---

#### Exercise 1A — Retrieve gene information from PlantGenIE

*Confirmed working against the live API — if it has since changed, check the current documentation or ask on the Canvas discussion board.*

```bash
BASE="https://www.plantgenie.se/api"
SPECIES="populus-tremula"
GENE_ID="Potra2n4c9093"

# Retrieve annotation for a specific gene — note this is a POST with a JSON
# body, not a simple GET-by-path like the NCBI/UniProt calls in Lecture 11
curl -s -X POST "${BASE}/v1/annotations" \
  -H "Content-Type: application/json" \
  -d "{\"species\": \"${SPECIES}\", \"geneIds\": [\"${GENE_ID}\"]}" \
  > gene_info.json

# Inspect the JSON response
cat gene_info.json
```

*Questions to answer in your README:*
- What is the functional annotation of this gene? (If `geneName`/`description` are `null`, what does that tell you about the completeness of this resource's annotation for this gene, versus the resource's design?)
- Try a different gene ID from the same species — does its annotation differ?
- What does needing a JSON request body, rather than a simple URL, tell you about this API's design compared to NCBI/UniProt's?

---

#### Exercise 1B — Query gene expression data

PlantGenIE integrates gene expression data from multiple experiments. The expression endpoint allows retrieval of expression values for a gene across the samples in a chosen experiment.

```bash
# List available experiments and note one for Populus tremula
curl -s "${BASE}/v1/expression/available-experiments" > experiments.json
cat experiments.json

EXPERIMENT_ID=15   # "Potra Wood Development" — likely the AspWood dataset (ERP016242) from Part 2

# Retrieve expression data for the same gene across this experiment's samples
curl -s -X POST "${BASE}/v1/expression" \
  -H "Content-Type: application/json" \
  -d "{\"experimentId\": ${EXPERIMENT_ID}, \"geneIds\": [\"${GENE_ID}\"]}" \
  > expression_data.json
cat expression_data.json

# How many samples are represented?
python3 -c "import json; d=json.load(open('expression_data.json')); print(len(d['samples']))"

# Which sample shows the highest expression?
python3 -c "
import json
d = json.load(open('expression_data.json'))
pairs = sorted(zip(d['samples'], d['values']), key=lambda x: x[1], reverse=True)
for sample, value in pairs[:5]:
    print(sample, value)
"
```

*Questions to answer in your README:*
- In which sample(s) is this gene most highly expressed?
- What are the expression units (check the `units` field)? Are they specified?
- What information would you need to reproduce an analysis using this expression data?

---

#### Exercise 1C — BLAST via the website

Go to the PlantGenIE website (or NCBI BLAST at https://blast.ncbi.nlm.nih.gov/ for comparison) and run a `blastp` search using the TP53 protein sequence retrieved in Lecture 11.

*Questions to answer in your README:*
- What parameters did you set (database, programme, E-value threshold)?
- How long did the search take, and what did the results viewer show you that a plain text file would not?
- What would make this approach impractical if you needed to search 500 sequences instead of one?

---

#### Exercise 1D — BLAST from the command line (local/HPC)

Run the same search locally on Kebnekaise, against a local database copy, submitted as a Slurm job:

```bash
module load GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0
module list   # Verify it loaded correctly

# Check the local database is accessible
ls /proj/nobackup/cddb_course/databases/swissprot/

cat > blast_tp53.sh << 'EOF'
#!/bin/bash
#SBATCH --job-name=blast_tp53
#SBATCH --account=hpc2ncourses2026-013
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --output=blast_tp53_%j.out
#SBATCH --error=blast_tp53_%j.err

module load GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0

blastp \
  -query TP53_protein.fasta \
  -db /proj/nobackup/cddb_course/databases/swissprot/swissprot \
  -out TP53_blastp_local.txt \
  -outfmt 6 \
  -evalue 1e-5 \
  -num_threads 4 \
  -max_target_seqs 50

echo "BLAST complete: $(date)"
EOF

sbatch blast_tp53.sh
squeue -u $USER

# Once complete, inspect tabular output (format 6)
# Columns: qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore
head -20 TP53_blastp_local.txt
sort -k11 -n TP53_blastp_local.txt | head -20
awk '$11 < 1e-10' TP53_blastp_local.txt | wc -l
```

*Questions to answer in your README:*
- How does the setup effort compare to the website approach — and how does that change once the database and script already exist?
- What does the Slurm script itself give you that the website result page does not?

---

#### Exercise 1E — BLAST via an API

Two ways to submit a BLAST search programmatically:

**NCBI's BLAST API** (fully documented, works today):

```bash
RID=$(curl -s "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi" \
  --data "CMD=Put&PROGRAM=blastp&DATABASE=swissprot&QUERY=P04637\
&FORMAT_TYPE=Text&email=your@email.se" \
  | grep -o "RID = [A-Z0-9]*" | awk '{print $3}')

echo "Job submitted. RID: $RID"

# Poll until the search is ready — a real blastp search against swissprot
# typically takes 2-3 minutes, not the ~45s you might expect
while true; do
  sleep 20
  STATUS=$(curl -s "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=${RID}" \
    | grep -o "Status=[A-Z]*")
  echo "$STATUS"
  [ "$STATUS" = "Status=READY" ] && break
done

curl -s "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi" \
  --data "CMD=Get&RID=${RID}&FORMAT_TYPE=Text" \
  > TP53_blastp_swissprot.txt

grep "^>" TP53_blastp_swissprot.txt | head -10
grep "Score\|Expect\|Identities" TP53_blastp_swissprot.txt | head -20
```

**PlantGenIE's BLAST API** — PlantGenIE also exposes a BLAST endpoint. Check the current API documentation (Section "Further Reading" below) for its endpoint and request format, and try submitting a query the same way you did for the annotation and expression endpoints in Exercises 1A–1B.

*Questions to answer in your README:*
- What makes submitting a BLAST job via API different from the website — in terms of what you get back and how you'd use it in a pipeline?
- What makes this interaction an example of Interoperability?

---

#### Exercise 1F — Compare the three approaches and commit your findings

| Approach | Speed | Scalability | Reproducibility | Control |
|----------|-------|-------------|-----------------|---------|
| Website | Fast for 1 sequence | Not scalable | Low (no record of parameters) | Limited |
| API | Moderate | ~10s of sequences | Good (parameters in code) | Moderate |
| Local HPC | Slow to set up, fast to run | Highly scalable | Excellent (script + Slurm log) | Full |

```bash
# Document your findings in the README
cat >> README.md << 'EOF'

## Part 1: Three Ways to Run BLAST + PlantGenIE API (Interoperability)

### Gene information and expression (PlantGenIE)
<!-- Add your findings here -->

### BLAST — website, local/HPC, API
<!-- Add your findings and the comparison table here -->

### Interoperability assessment of PlantGenIE
<!-- In 3-4 sentences: how does the PlantGenIE API demonstrate the I principle of FAIR? -->

EOF

git add .
git commit -m "lecture15: three ways to run BLAST + PlantGenIE API exercises complete

- BLAST via website, local/HPC Slurm job, and API (NCBI + PlantGenIE)
- Gene information and expression queries via PlantGenIE REST API
- Findings documented in README"
```

---

## Part 2 — Reusability: GEO/ENA Metadata Assessment

### 2.1 The Core Question

The **Reusable** principle of FAIR requires that data has sufficient metadata to enable someone other than the original authors to understand and reuse it for a new analysis. In practice for RNA-seq data, this means: could a researcher who finds this dataset in GEO or ENA run a differential expression analysis without contacting the authors?

This exercise asks you to answer that question for a specific, provided dataset.

### 2.2 The Metadata Sufficiency Checklist

Work through the following checklist for the dataset below. Record your findings — yes/no and supporting evidence — in your README.

**The dataset accession for this exercise:** ERP016242 (European Nucleotide Archive)

**The associated paper:** Sundell D. et al. (2017). AspWood: High-Spatial-Resolution Transcriptome Profiles Reveal Uncharacterized Modularity of Wood Formation in *Populus tremula*. *The Plant Cell* 29(7): 1585–1604. DOI: 10.1105/tpc.17.00153

**Data accessible at:** https://www.ebi.ac.uk/ena/browser/view/ERP016242

**Why this dataset:** The data are directly integrated into PlantGenIE, creating strong continuity with Exercise 1 — you can query PlantGenIE for genes identified as differentially expressed in this study. Published in 2017 — one year after the FAIR principles were formalised — it provides an instructive temporal perspective on the evolution of FAIR practices. As data from the course leader's own research group, it can be discussed with complete transparency about what decisions were made at deposition time and what would be done differently under current standards. This framing — that FAIR assessment is about continuous improvement, not fault-finding — is itself an important lesson.

**Finding the dataset:**
- [ ] Can you locate the dataset by searching the GEO or ENA database without knowing the accession in advance?
- [ ] Is there a persistent, stable identifier (accession number) for the dataset?
- [ ] Is the identifier cited in the paper?

**Sample identification:**
- [ ] Can you tell how many samples are in the dataset?
- [ ] Can you assign each sample to an experimental condition (control vs treated, genotype A vs B, etc.) from the metadata alone?
- [ ] Are biological replicates identifiable?

**Biological metadata:**
- [ ] Is the organism identified with a taxonomy ID (not just a name)?
- [ ] Is the tissue or cell type specified? Is it annotated with an ontology term (e.g. UBERON, EFO, CL)?
- [ ] Is the treatment or experimental condition specified? Is it annotated with an ontology term (e.g. EFO, CHEBI)?
- [ ] Are any other relevant variables specified (age, sex, genotype, growth conditions, time point)?

**Technical metadata:**
- [ ] Is the sequencing platform specified?
- [ ] Is the library preparation protocol specified (stranded/unstranded, poly-A/ribo-depleted)?
- [ ] Is read length and paired/single end specified?

**Data availability:**
- [ ] Are raw FASTQ files available (not only processed count matrices)?
- [ ] Are processed results available (count matrix, normalised data)?
- [ ] Is the reference genome/transcriptome version specified?
- [ ] Is the alignment tool and version specified?

**Reproducibility:**
- [ ] Is analysis code available?
- [ ] Are software versions specified for all tools used?
- [ ] Is there a workflow definition (Snakemake, Nextflow) or equivalent?
- [ ] Does the paper declare adherence to a community metadata standard (e.g. MINSEQE)?

### 2.3 Scoring and Documenting Your Assessment

For each item in the checklist, record:
- **Pass** — the information is clearly present
- **Partial** — the information is present but incomplete (e.g. tissue type is given as text but no ontology term)
- **Fail** — the information is absent

Then write a brief paragraph (3–5 sentences) answering: **If you wanted to reproduce the main differential expression analysis from this paper, what specific information is missing that would prevent you from doing so?**

```bash
# In your README, add the metadata assessment section
cat >> README.md << 'EOF'

## Part 2: GEO/ENA Metadata Assessment (Reusability)

### Dataset assessed
Accession: <!-- add -->
Paper: <!-- add -->

### Checklist summary
| Category | Pass | Partial | Fail |
|----------|------|---------|------|
| Sample identification | | | |
| Biological metadata | | | |
| Technical metadata | | | |
| Data availability | | | |
| Reproducibility | | | |

### Key finding
<!-- 3-5 sentences: what is missing and what would it prevent? -->

EOF

git add README.md
git commit -m "lecture15: GEO metadata assessment complete"
```

---

## Part 3 — Paper Reproducibility Exercise

### 3.1 Overview

This exercise uses your chosen essay paper. Working individually, you will systematically assess the computational reproducibility of the published analysis — using the same framework you will apply in the essay itself.

*Note: you are not re-running the analysis. You are assessing whether you could re-run it from what the paper reports.*

### 3.2 The Reproducibility Assessment

Open your chosen paper and work through the following:

**Step 1 — Map the analysis pipeline**
List every computational step mentioned in the methods section, in order. For each step, record:
- What tool was used?
- Was the version specified?
- Were the key parameters reported?

Example table structure:

| Step | Tool | Version specified? | Parameters reported? |
|------|------|--------------------|----------------------|
| Quality trimming | Trimmomatic | v0.39 ✓ | LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 ✓ |
| Alignment | HISAT2 | v2.1.0 ✓ | Default ✗ — "default parameters" is insufficient |
| Quantification | featureCounts | Not specified ✗ | Not specified ✗ |
| DE analysis | DESeq2 | v1.20.0 ✓ | Shrinkage estimator not specified ✗ |

**Step 2 — Assess code availability**
- Is analysis code available at all?
- If yes: is it versioned (Git tag, Zenodo DOI)? Is it documented? Does it specify software dependencies?
- If no: is there any indication of how the analysis could be reproduced?

**Step 3 — Assess the reference genome situation**
- Is the reference genome specified?
- Is a version (assembly accession) given?
- Is the annotation version (GTF/GFF) specified?
- Could you identify exactly the same reference genome and annotation to reproduce the alignment?

**Step 4 — Write a reproducibility verdict**
In 2–3 sentences: based on what the paper reports, could an independent researcher reproduce the main analysis? What would they need to obtain from the authors that is not in the paper?

```bash
cat >> README.md << 'EOF'

## Part 3: Paper Reproducibility Assessment

### Paper assessed
<!-- Title, DOI -->

### Analysis pipeline reconstruction
| Step | Tool | Version? | Parameters? |
|------|------|----------|-------------|
| | | | |

### Code availability
<!-- What is available and what is not -->

### Reference genome situation
<!-- Is the exact genome/annotation version reproducible? -->

### Reproducibility verdict
<!-- 2-3 sentences -->

EOF

git add README.md
git commit -m "lecture15: paper reproducibility assessment complete

- Pipeline reconstruction table
- Code and reference genome assessment
- Ready for essay development"
```

---

## Part 4 — Building a Reproducible Report

### 4.1 Why This Exercise

In Part 3 you assessed whether someone else's paper was computationally reproducible. Here, you do the positive version yourself: turn a small piece of this exercise into an actual reproducible report — a notebook that combines code, narrative, and live output in one rerunnable file, rather than a terminal transcript and a folder of output files. See [Lecture 14, Section 4.5](../14.fair-open-science/fair-open-science.md) for why this matters.

### 4.2 Build a Minimal Jupyter Notebook

Launch a Jupyter Notebook session via OnDemand (the same launcher you have used elsewhere in this course), open a new Python notebook in your `lecture15-fair-practice` directory, and build three cells:

1. **Markdown cell** — a one-sentence description of what the notebook does, e.g. "Summarises the PlantGenIE expression query for Potra2n4c9093 from Exercise 1B."
2. **Code cell** — load and summarise a result you already produced earlier:
```python
import json
data = json.load(open("expression_data.json"))
print(f"{len(data['samples'])} samples returned for this gene")
```
3. **Markdown cell** — one sentence interpreting the output.

Run all cells top to bottom (`Kernel → Restart & Run All`) to confirm the notebook reproduces its own output from scratch — that is the test that matters, not just that it ran once while you were writing it.

Export the notebook to HTML (`File → Download as → HTML`) and commit both files:

```bash
git add expression_report.ipynb expression_report.html
git commit -m "lecture15: minimal reproducible report (Jupyter)

- Notebook reproduces the Exercise 1B expression summary from scratch
- HTML export committed alongside the source notebook"
```

### 4.3 The R Equivalent (for reference — you will use this properly in Data Science for Biology with R)

The same idea in R uses R Markdown, rendered with `knitr`, via RStudio Server (also available on OnDemand). A minimal `.Rmd` file looks like this:

````markdown
---
title: "Expression query summary"
output: html_document
---

Summarises the PlantGenIE expression query for Potra2n4c9093.

```{r}
data <- jsonlite::fromJSON("expression_data.json")
cat(length(data$samples), "samples returned for this gene\n")
```
````

Rendering this file (`rmarkdown::render("report.Rmd")`) produces an HTML report the same way `knitr` renders it inside RStudio — the R code, the narrative, and the live output all in one document. You do not need to run this yourself now; it is here so you recognise the pattern when you meet it properly in the next course.

*Questions to answer in your README:*
- What did the notebook approach make explicit that a bare script or terminal history would not?
- If you handed only your `.ipynb` file to a labmate with no other context, could they understand what it did and why, and reproduce the output themselves?

```bash
cat >> README.md << 'EOF'

## Part 4: Reproducible Report (Jupyter)

### What the notebook makes explicit
<!-- vs a bare script or terminal history -->

### Could a labmate reproduce this from the notebook alone?
<!-- yes/no and why -->

EOF

git add README.md
git commit -m "lecture15: reproducible report reflection complete"
```

---

## Essay Assessment

The full FAIR essay assignment — what it asks, what distinguishes a G from a VG response, and the curated paper shortlist — is covered in [Lecture 14, Section 10](../14.fair-open-science/fair-open-science.md#10-introduction-to-the-fair-essay-assessment). The metadata assessment (Part 2) and paper reproducibility exercise (Part 3) you have just completed are direct practice for the essay — the same frameworks apply. Bring questions to office hours or post on the Canvas discussion board.

---

## What You Should Know After These Exercises

✅ **Run a BLAST search via a website, from the command line on HPC, and via an API**, and explain when and why you would choose each.

✅ **Query a REST API from the command line** using `curl` and parse the response with `grep` or `jq`.

✅ **Explain why APIs embody the Interoperable principle** of FAIR — standardised protocols, standard formats, documented endpoints.

✅ **Describe PlantGenIE** as an example of a specialist research resource that exposes its data through a documented API, enabling programmatic access from any tool.

✅ **Apply the metadata sufficiency checklist** to a real GEO or ENA dataset and identify which missing fields would prevent reanalysis.

✅ **Reconstruct the analysis pipeline** from a published methods section, noting which steps have complete version and parameter information and which do not.

✅ **Build a minimal Jupyter notebook that reproduces its own output from scratch**, and explain what it makes explicit that a bare script does not.

✅ **Commit all exercise outputs and findings to Git** with structured README documentation and meaningful commit messages.

✅ **Describe what distinguishes a G from a VG essay response** and apply this distinction to your own paper assessment.

---

## Further Reading

- PlantGenIE documentation and API reference: https://www.plantgenie.se/api/docs (confirmed by Jamie McCann)
- PlantGenIE GitHub: https://github.com/plantgenie
- MINSEQE (Minimum Information about a high-throughput Nucleotide SeQuencing Experiment): https://fairsharing.org/FAIRsharing.a55z32
- MIxS (Minimum Information about any (x) Sequence): https://www.gensc.org/pages/standards-intro.html
- The Turing Way — Reproducible Research: https://the-turing-way.netlify.app/reproducible-research
- Jupyter documentation: https://jupyter.org/documentation
- R Markdown documentation: https://rmarkdown.rstudio.com/
- HPC2N OnDemand interactive apps (Jupyter Notebook, RStudio Server): https://docs.hpc2n.umu.se/tutorials/connections/

---

