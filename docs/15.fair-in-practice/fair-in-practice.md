# 15. FAIR in Practice

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Slides:** [PDF](../../PDFs/lecture-15-fair-in-practice.pdf)  
**Exercises:** See [`exercises/`](../../exercises/15.fair-in-practice/)

---

## Hands-On Exercises in Interoperability and Reusability
### Master's Programme in Bioinformatics — Umeå University
### Computing for Data-Driven Biology (5BI00A)

---

## Session Aims

By the end of this session you should be able to:

1. Query a REST API from the command line and parse the response — demonstrating Interoperability in practice
2. Explain how a well-designed API embodies the Interoperable and Reusable principles of FAIR
3. Apply a structured metadata sufficiency checklist to a real GEO or ENA dataset
4. Identify specific metadata fields whose absence would prevent reanalysis of a published RNA-seq study
5. Assess the computational reproducibility of a published bioinformatics study using a structured framework
6. Commit all exercise outputs, commands, and findings to Git

**Links to course ILOs:** This session directly addresses ILOs 1, 3, 7, 12, and 13. It is the practical companion to Lecture 14 and provides direct preparation for the FAIR essay assessment.

**Guest contribution:** The PlantGenIE API section (Part 1) is co-delivered by **Jamie McCann**, developer of PlantGenIE (plantgenie.se) at Umeå University. This is an opportunity to hear directly from the person who designed the infrastructure — and to understand how the decisions made when building a database resource either enable or hinder FAIR compliance.

---

## Session Structure

| Block | Topic | Time |
|-------|-------|------|
| Block 1 | **I = Interoperable:** PlantGenIE API — querying from the command line | ~50 min |
| Break | | 10 min |
| Block 2 | **R = Reusable:** GEO/ENA metadata assessment + paper reproducibility exercise | ~40 min |
| | Essay briefing and Q&A | ~10 min |

---

## Part 1 — Interoperability: The PlantGenIE API

### 1.1 What is PlantGenIE?

PlantGenIE (plantgenie.se / plantgenie.org) is a bioinformatics resource for plant and tree genomics developed at Umeå University, with primary development by Jamie McCann and contributions from the research groups of Nathaniel Street and others at UPSC. It integrates:

- Genome browsers for boreal forest tree species including *Picea abies* (Norway spruce) and *Populus tremula* (European aspen)
- Gene expression data and co-expression networks
- Functional annotations and gene family tools
- A BLAST search interface
- **REST API endpoints** providing programmatic access to all of the above

PlantGenIE is currently undergoing active redevelopment (plantgenie.se). The exercises in this session use the API endpoints of the current development version. If the site is unavailable on the day of the session, your instructor will provide example responses to work with.

The PlantGenIE codebase is publicly available on GitHub: https://github.com/plantgenie

### 1.2 Why PlantGenIE Demonstrates Interoperability

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

### 1.3 REST APIs: A Brief Technical Overview

A REST (Representational State Transfer) API is an interface to a web service that follows a set of conventions, allowing resources to be retrieved using standard HTTP methods and URLs.

The key concept is that each **endpoint** is a URL that returns a specific piece of data:

```
https://api.plantgenie.se/blast          ← BLAST search endpoint
https://api.plantgenie.se/genes/{id}     ← Gene information endpoint
https://api.plantgenie.se/expression/{id}← Gene expression endpoint
```

You query these endpoints using `curl` or equivalent tools, and the response arrives as JSON or plain text. This is identical in structure to the NCBI and UniProt API calls you made in Lecture 11 — the same concept, a different resource.

**JSON** (JavaScript Object Notation) is the standard response format for most REST APIs. It is structured as key-value pairs:

```json
{
  "gene_id": "MA_10000g0010",
  "organism": "Picea abies",
  "description": "predicted protein",
  "go_terms": ["GO:0005488", "GO:0003676"],
  "interpro": ["IPR001878"]
}
```

You can parse JSON responses at the command line using `jq` (if available) or Python, or simply use `grep` for extracting specific fields.

### 1.4 Hands-On: Querying the PlantGenIE API

**Prerequisites:** Login to Kebnekaise via OnDemand. Create a working directory and initialise Git.

```bash
cd ~/course
mkdir -p lecture15-fair-practice && cd lecture15-fair-practice
git init
cat > README.md << 'EOF'
# Lecture 06: FAIR in Practice
## Exercises in Interoperability and Reusability
EOF
git add README.md
git commit -m "initial commit: lecture15 FAIR practical exercises"
```

---

#### Exercise 1A — Retrieve gene information from PlantGenIE

The PlantGenIE API allows retrieval of gene annotations for *Picea abies* and *Populus tremula*. Norway spruce gene identifiers follow the format `MA_[number]g[number]` (e.g. `MA_10000g0010`).

```bash
# Query gene information for a Norway spruce gene
# Replace PLANTGENIE_BASE_URL with the actual base URL provided in the session
BASE="https://api.plantgenie.se"

# Retrieve information for a specific gene
curl -s "${BASE}/genes/MA_10000g0010" > gene_info.json

# Inspect the JSON response
cat gene_info.json

# Extract specific fields with grep (if jq is not available)
grep -o '"description": "[^"]*"' gene_info.json
grep -o '"go_terms": \[[^]]*\]' gene_info.json
```

*Questions to answer in your README:*
- What is the functional annotation of this gene?
- What GO terms are associated with it?
- Are there cross-references to other databases (InterPro, NCBI)? Which ones?
- What does the presence of these cross-references tell you about the Interoperability of this resource?

---

#### Exercise 1B — Query gene expression data

PlantGenIE integrates gene expression data from multiple experiments. The expression endpoint allows retrieval of expression values for a gene across tissues and conditions.

```bash
# Retrieve expression data for the same gene
curl -s "${BASE}/expression/MA_10000g0010" > expression_data.json
cat expression_data.json

# How many tissues/conditions are represented?
grep -o '"tissue": "[^"]*"' expression_data.json | wc -l

# Which tissues show the highest expression?
# (Inspect the JSON structure and identify the key for expression value)
grep -o '"value": [0-9.]*' expression_data.json | sort -t: -k2 -n | tail -5
```

*Questions to answer in your README:*
- In which tissues is this gene most highly expressed?
- Are the expression units specified in the API response?
- What information would you need to reproduce an analysis using this expression data?

---

#### Exercise 1C — BLAST via the PlantGenIE API

PlantGenIE provides a BLAST API endpoint, allowing you to submit a sequence and retrieve hits against the Norway spruce or aspen genome — from the command line, without opening a browser.

```bash
# Fetch the TP53 protein sequence from Lecture 11 (or use the one below)
# Human TP53 protein, first 50 amino acids as a minimal example
QUERY=">query_seq
MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIE"

# Submit BLAST job to PlantGenIE API
# Note: the API may return a job ID for asynchronous results (like NCBI API)
curl -s -X POST "${BASE}/blast" \
  -H "Content-Type: application/json" \
  -d "{\"sequence\": \"${QUERY}\", \"database\": \"picea_abies\", \"program\": \"blastp\"}" \
  > blast_job.json

cat blast_job.json

# If a job ID is returned, retrieve results:
JOB_ID=$(grep -o '"job_id": "[^"]*"' blast_job.json | cut -d'"' -f4)
echo "Job ID: ${JOB_ID}"
sleep 30
curl -s "${BASE}/blast/results/${JOB_ID}" > blast_results.json
cat blast_results.json
```

*Questions to answer in your README:*
- Does the Norway spruce genome contain any sequences similar to human TP53?
- How does querying BLAST via an API differ from using the web interface?
- What makes this interaction an example of Interoperability?

---

#### Exercise 1D — Commit your findings

```bash
# Document your findings in the README
cat >> README.md << 'EOF'

## Part 1: PlantGenIE API (Interoperability)

### Gene information (MA_10000g0010)
<!-- Add your findings here -->

### Expression data
<!-- Add your findings here -->

### BLAST results
<!-- Add your findings here -->

### Interoperability assessment of PlantGenIE
<!-- In 3-4 sentences: how does the PlantGenIE API demonstrate the I principle of FAIR? -->

EOF

git add .
git commit -m "lecture15: PlantGenIE API exercises complete

- Gene information, expression, and BLAST queries via REST API
- Findings documented in README"
```

---

## Part 2 — Reusability: GEO/ENA Metadata Assessment

### 2.1 The Core Question

The **Reusable** principle of FAIR requires that data has sufficient metadata to enable someone other than the original authors to understand and reuse it for a new analysis. In practice for RNA-seq data, this means: could a researcher who finds this dataset in GEO or ENA run a differential expression analysis without contacting the authors?

This exercise asks you to answer that question for a specific, provided dataset.

### 2.2 The Metadata Sufficiency Checklist

Work through the following checklist for the dataset provided by your instructor. Record your findings — yes/no and supporting evidence — in your README.

**The dataset accession for today's exercise:** ERP016242 (European Nucleotide Archive)

**The associated paper:** Sundell D. et al. (2017). AspWood: High-Spatial-Resolution Transcriptome Profiles Reveal Uncharacterized Modularity of Wood Formation in *Populus tremula*. *The Plant Cell* 29(7): 1585–1604. DOI: 10.1105/plcell.17.00153

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

## Essay Briefing

*This section is covered in the lecture. Key points:*

- The Canvas assignment is now open. The deadline is [set in Canvas].
- The paper shortlist is in the Lecture 14 handout and in Canvas.
- The metadata assessment and reproducibility exercises you have just completed are direct practice for the essay — the same frameworks apply.
- The G/VG distinction comes down to analysis versus description. Noting that code is unavailable is description. Explaining that the absence of code means a reader cannot verify that the normalisation step was applied correctly before the statistical test, and that this makes it impossible to assess whether the reported p-values are valid, is analysis.
- Bring questions to office hours or post on the Canvas discussion board.

---

## What You Should Know After This Session

✅ **Query a REST API from the command line** using `curl` and parse the response with `grep` or `jq`.

✅ **Explain why APIs embody the Interoperable principle** of FAIR — standardised protocols, standard formats, documented endpoints.

✅ **Describe PlantGenIE** as an example of a specialist research resource that exposes its data through a documented API, enabling programmatic access from any tool.

✅ **Apply the metadata sufficiency checklist** to a real GEO or ENA dataset and identify which missing fields would prevent reanalysis.

✅ **Reconstruct the analysis pipeline** from a published methods section, noting which steps have complete version and parameter information and which do not.

✅ **Commit all exercise outputs and findings to Git** with structured README documentation and meaningful commit messages.

✅ **Describe what distinguishes a G from a VG essay response** and apply this distinction to your own paper assessment.

---

## Further Reading

- PlantGenIE documentation and API reference: https://plantgenie.se (when available)
- PlantGenIE GitHub: https://github.com/plantgenie
- MINSEQE (Minimum Information about a high-throughput Nucleotide SeQuencing Experiment): https://fairsharing.org/FAIRsharing.a55z32
- MIxS (Minimum Information about any (x) Sequence): https://www.gensc.org/pages/standards-intro.html
- The Turing Way — Reproducible Research: https://the-turing-way.netlify.app/reproducible-research

---

