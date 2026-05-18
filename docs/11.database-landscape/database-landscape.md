# 11. The Biological Database Landscape

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Slides:** [PDF](../../PDFs/lecture-11-database-landscape.pdf)  
**Exercises:** See [`exercises/`](../../exercises/11.databases/)

---


## Session Aims

By the end of this session you should be able to:

1. Describe the four-tier conceptual hierarchy of biological databases and explain how raw data becomes biological knowledge
2. Identify the major primary archives and explain the role of the International Nucleotide Sequence Database Collaboration (INSDC)
3. Distinguish between GenBank and RefSeq, and between Swiss-Prot and TrEMBL, and explain why these distinctions matter in practice
4. Explain the significance of evidence codes in database annotations
5. Navigate and query representative databases from each tier of the hierarchy using both web interfaces and programmatic (command-line) access
6. Retrieve sequence data from NCBI and UniProt using the command line, and parse the resulting files with Linux tools
7. Commit retrieved data and documented commands to a Git repository

**Links to course ILOs:** This session directly addresses ILOs 1, 4, 5, 7, and 12. It also provides concrete context for ILO 3 (FAIR principles), which is treated in depth in Lecture 13.

**Note on sequencing:** This lecture is designed to follow the HPC2N Linux and command-line training block. The hands-on exercise deliberately applies and reinforces the skills covered there — `curl`, `grep`, `wc`, pipes, and Git — in a bioinformatics context.

---

## Opening Activity — What Do You Already Know?

*Before the lecture begins, a short Mentimeter poll will ask which databases you have heard of, and invite you to describe in one word what you think a biological database is. There are no right or wrong answers — this is to help calibrate the session for the group.*

---

## 1. How Does Data Become Knowledge? A Conceptual Framework

The biological database landscape can seem overwhelming — there are hundreds of databases, covering different organisms, data types, and levels of biological interpretation. Rather than memorising a list, it is more useful to understand the underlying structure: where does each database sit in the journey from raw experimental data to biological knowledge?

### 1.1 The Four-Tier Hierarchy

The following framework is a simplification, but it is a productive one:

**Tier 1 — Primary archives**
Raw, largely uninterpreted experimental data deposited directly by researchers. The defining characteristics are: submissions-based (any researcher can deposit), high-volume, minimal curation, and structured around data preservation and access rather than biological interpretation. Examples: ENA, NCBI SRA, GenBank, PRIDE, GEO, MetaboLights.

**Tier 2 — Reference databases**
Curated, versioned, annotated collections built on top of primary data. Curation may be manual (by expert annotators) or automated (by pipelines), or a mixture. The quality and reliability of annotations is generally higher than in primary archives, but varies between databases and between entries within a database. Examples: RefSeq, UniProt/Swiss-Prot, Ensembl, UCSC Genome Browser.

**Tier 3 — Functional and interpretive databases**
Databases that add biological meaning — functional classification, pathway membership, interaction networks, structural information, domain architecture. These are built on top of Tier 1 and Tier 2 data and involve substantial computational or expert interpretation. Examples: Gene Ontology (GO), InterPro, KEGG, Reactome, STRING, AlphaFold Database, PDB.

**Tier 4 — Specialist and organism-specific resources**
Resources focused on a particular organism, disease domain, or experimental modality. These often integrate data from all three tiers above and add community-curated knowledge specific to their domain. Examples: FlyBase, TAIR, JGI Phytozome, PlantGenIE, gnomAD, ClinVar, SILVA, GBIF.

### 1.2 Why the Hierarchy Matters

Understanding which tier a database belongs to immediately tells you several important things:

- **How much to trust an annotation:** a functionally annotated entry in Swiss-Prot has been manually reviewed by an expert; an automatically annotated entry in TrEMBL has not. Both are valuable, but they are not equivalent.
- **What kind of question it can answer:** you go to Tier 1 for data; you go to Tier 3 for interpretation.
- **What the evidence basis is:** Tier 3 databases often derive their content from Tier 1 and 2, and errors propagate upward — as discussed in Lecture 1.
- **How to find things programmatically:** each tier tends to have characteristic APIs and access patterns.

### 1.3 Cross-Referencing: The Connective Tissue

One of the most important features of the biological database landscape is that databases are richly cross-referenced. A UniProt entry links to the corresponding Ensembl gene, the PDB structures, the InterPro domains, the GO annotations, the KEGG pathways, and the original GenBank nucleotide records. Learning to navigate these cross-references is as important as knowing what each database contains.

---

## 2. The Global Archiving Infrastructure

### 2.1 The INSDC: Why Data Is Where You Find It

The International Nucleotide Sequence Database Collaboration (INSDC) is a long-standing partnership between three databases:

- **GenBank** — operated by the National Center for Biotechnology Information (NCBI), USA
- **European Nucleotide Archive (ENA)** — operated by the European Bioinformatics Institute (EBI), UK
- **DNA Data Bank of Japan (DDBJ)** — operated by the National Institute of Genetics, Japan

These three databases synchronise their data daily. A sequence deposited in ENA is available in GenBank within 24 hours, and vice versa. This is why you can often find the same accession number via any of the three interfaces.

The practical implication: you do not need to worry about which of the three primary nucleotide archives to search — they contain the same data. Your choice of interface is a matter of preference, geography (ENA is often faster from Europe), and which programmatic access tools you prefer.

### 2.2 Primary Archives: Sequence Data

**GenBank** is the original and largest sequence database, containing all publicly available nucleotide sequences. It is submissions-based — any researcher can deposit — and is largely unfiltered. This means it contains both high-quality and low-quality sequences, sequences from poorly characterised organisms, and sequences with minimal annotation.

**RefSeq** is a curated, non-redundant reference database maintained by NCBI. Unlike GenBank, RefSeq sequences are reviewed and annotated by NCBI staff or trusted submitters. Accession numbers beginning with `NM_` (mRNA), `NR_` (non-coding RNA), `NP_` (protein), or `NC_` (chromosomes/genomes) indicate RefSeq records. For most analytical purposes — alignment, annotation, comparative genomics — RefSeq is the preferred reference.

> **Key distinction:** GenBank = everything submitted; RefSeq = curated reference sequences. If you are aligning RNA-seq reads or annotating a genome, use RefSeq. If you are searching for all known sequences of a gene across all species, use GenBank (or a search tool such as BLAST that queries it).

**NCBI SRA (Sequence Read Archive)** stores raw sequencing reads — the actual output of sequencing instruments, before any assembly or processing. This is where you find the raw data underlying published studies. Raw reads are in FASTQ format. The SRA is the most important archive for reproducibility: if a study deposited its raw data here, you can in principle reproduce the entire analysis from scratch.

**ENA (European Nucleotide Archive)** provides access to the same nucleotide data as GenBank/SRA but with a different interface and different programmatic access tools. Many European researchers prefer ENA because of lower latency and because the metadata search interface is arguably more flexible. ENA is also a more prominent submission destination for many European research infrastructures.

### 2.3 Primary Archives: Other Data Types

**GEO (Gene Expression Omnibus)** and **ArrayExpress** are the primary archives for gene expression data — microarray data historically, but increasingly RNA-seq count matrices, normalised data, and processed results. They are complementary: GEO is operated by NCBI; ArrayExpress by EBI. Many datasets are cross-deposited. GEO entries typically consist of a series (a study), samples (biological specimens), and platforms (the measurement technology).

!!! note
    ** GEO stores both raw data (FASTQ files, linked to SRA) and processed data (count matrices, fold-change tables). For reanalysis, always start from the raw data if possible. For FAIR assessment exercises, GEO/ArrayExpress metadata is particularly revealing of data management quality.

**PRIDE (PRoteomics IDEntifications Database)** is the primary archive for mass spectrometry-based proteomics data. It is part of the ProteomeXchange consortium, which coordinates data deposition across proteomics archives. If a paper presents proteomic data, its raw data should be in PRIDE.

**MetaboLights** is the EBI's primary archive for metabolomics studies, covering both raw spectral data and processed metabolite quantification tables. It supports a wide range of metabolomics platforms (NMR, LC-MS, GC-MS).

---

## 3. Reference and Curated Databases

### 3.1 Ensembl and UCSC: Genome Browsers

**Ensembl** (https://www.ensembl.org) is the reference genome annotation portal operated by EBI/WTSI. It provides genome assemblies, gene models, regulatory annotations, and comparative genomics data for a large number of animal genomes, with particular depth for vertebrates. The associated **Ensembl Genomes** portal covers plants, fungi, protists, bacteria, and metazoa. Ensembl is the reference annotation system for many bioinformatics tools and pipelines.

**UCSC Genome Browser** (https://genome.ucsc.edu) provides similar functionality for a somewhat different set of genomes, with particularly comprehensive human annotation tracks including ENCODE regulatory data, conservation data, variant annotations, and clinical data. The UCSC Table Browser is an especially powerful tool for programmatic access to genomic features.

### 3.2 UniProt: The Central Protein Resource

UniProt (https://www.uniprot.org) is the most important protein sequence and function database. It has two components:

**Swiss-Prot** is the manually curated, reviewed component. Each Swiss-Prot entry has been assessed by a trained curator who has reviewed the primary literature, evaluated functional evidence, and assigned standardised annotations. Swiss-Prot contains approximately 500,000 entries. When you need high-confidence functional information about a protein, Swiss-Prot is the starting point.

**TrEMBL** (Translated EMBL) is the automatically annotated, unreviewed component. It contains tens of millions of sequences, computationally translated from nucleotide records and automatically annotated using rule-based systems. TrEMBL annotations are often correct, but have not been manually verified.

Together, Swiss-Prot and TrEMBL constitute **UniProtKB** (the UniProt Knowledge Base). When searching UniProt, you can filter by review status to restrict to Swiss-Prot entries when confidence is a priority.

### 3.3 Evidence Codes: Reading the Fine Print

Almost all biological databases use some form of evidence code to indicate how an annotation was derived. Understanding these codes is essential for critically evaluating database entries.

The Gene Ontology Consortium defines the most widely used system, which is also adopted by many other databases:

| Code | Meaning | Trust level |
|------|---------|-------------|
| EXP | Inferred from Experiment | High — direct experimental evidence |
| IDA | Inferred from Direct Assay | High — specific biochemical assay |
| IPI | Inferred from Physical Interaction | High — protein interaction evidence |
| IGI | Inferred from Genetic Interaction | High — genetic evidence |
| IMP | Inferred from Mutant Phenotype | High — mutant phenotype |
| IEP | Inferred from Expression Pattern | Moderate — co-expression evidence |
| ISS | Inferred from Sequence or Structural Similarity | Moderate — computational transfer |
| ISO | Inferred from Sequence Orthology | Moderate — orthology-based transfer |
| IBA | Inferred from Biological aspect of Ancestor | Moderate — phylogenetic inference |
| IEA | Inferred from Electronic Annotation | Lower — fully automated, no manual review |
| ND | No biological Data available | — |

> **Practical rule:** Before citing a functional annotation in your own work, check its evidence code. A protein described as a "transcription factor" based on IEA alone has been automatically annotated — the evidence may be indirect, incomplete, or derived from a distant homologue. This is not necessarily wrong, but it should be stated as a computational prediction, not an established fact.

---

## 4. Functional and Interpretive Databases

### 4.1 Gene Ontology (GO)

The Gene Ontology (http://geneontology.org) is a controlled vocabulary — an ontology — for describing gene and gene product function in a consistent, species-independent way. It is structured around three orthogonal aspects:

- **Molecular Function (MF):** what the gene product does at the molecular level (e.g., "ATP binding", "serine-type endopeptidase activity")
- **Biological Process (BP):** the broader biological programme the gene product participates in (e.g., "DNA repair", "photoperiodism, flowering")
- **Cellular Component (CC):** where the gene product is active in the cell (e.g., "nucleus", "chloroplast stroma")

GO annotations are associated with evidence codes (see Section 3.3). The GO is used throughout bioinformatics — in differential expression analysis, functional enrichment testing, comparative genomics, and genome annotation pipelines. Understanding what GO terms mean and how they are derived is fundamental.

An important subtlety: most GO annotations for non-model organisms are transferred computationally from model organisms based on sequence similarity. The accuracy of these transferred annotations depends on the degree of functional conservation between the organisms, which is not always high — particularly for organism-specific biological processes.

### 4.2 InterPro: Protein Domains and Families

InterPro (https://www.ebi.ac.uk/interpro) integrates protein classification data from multiple member databases, each of which uses different methods to identify protein families and domains:

- **Pfam** — profile hidden Markov models for protein families and domains
- **PRINTS** — fingerprints (groups of motifs) for protein families
- **PROSITE** — patterns and profiles for protein families and functional sites
- **HAMAP** — hand-curated profiles for microbial protein families
- **CDD** — conserved domain database (NCBI)
- **SUPERFAMILY**, **Gene3D**, **PANTHER**, and others

InterPro provides a unified view: for any protein, you can see its domain architecture — which protein domains are present, in what order, and with what functional assignments. This is one of the most practically useful annotations for understanding what an unknown protein does.

### 4.3 KEGG and Reactome: Pathway Databases

**KEGG (Kyoto Encyclopedia of Genes and Genomes)** (https://www.kegg.jp) provides pathway maps linking genes to biochemical reactions, metabolic networks, and disease associations. KEGG pathways are widely used for functional enrichment analysis ("which metabolic pathways are overrepresented in my gene list?"). KEGG has a licensing model that restricts some programmatic access.

**Reactome** (https://reactome.org) is a fully open-source, manually curated pathway database with strong programmatic access via a REST API and an R/Bioconductor package. It is more detailed at the molecular level than KEGG and is increasingly the preferred resource for open reproducible analyses.

### 4.4 STRING: Protein Interaction Networks

**STRING** (https://string-db.org) integrates known and predicted protein–protein interactions from multiple evidence sources: co-expression, experimental evidence, text-mining, genomic context, and database-curated interactions. It assigns confidence scores to interactions and allows network visualisation and functional enrichment analysis. STRING is widely used to contextualise gene lists from omics experiments.

### 4.5 The AlphaFold Database and PDB

**The Protein Data Bank (PDB)** (https://www.rcsb.org) is the primary archive for experimentally determined three-dimensional structures of proteins, nucleic acids, and their complexes. Structures are determined primarily by X-ray crystallography, cryo-electron microscopy, or NMR spectroscopy.

**The AlphaFold Protein Structure Database** (https://alphafold.ebi.ac.uk) provides computational structure predictions for virtually all proteins in UniProt (~200 million entries), generated by the AlphaFold2 algorithm. This represents a paradigm shift: for the first time, structural information is available for almost any protein, not just those that have been experimentally characterised. Understanding the accuracy and limitations of AlphaFold predictions is important — the per-residue confidence score (pLDDT) is a critical indicator of prediction reliability.

---

## 5. Specialist and Organism-Specific Resources

### 5.1 Model Organism Databases

Model organism databases are Tier 4 resources that integrate genome sequence, gene annotation, experimental data, and community-curated knowledge for specific organisms. They are important because much of the functional annotation in general databases (GO terms, pathway assignments) originates from experimental work in model organisms.

| Database | Organism | URL |
|----------|---------|-----|
| TAIR | *Arabidopsis thaliana* | https://www.arabidopsis.org |
| FlyBase | *Drosophila melanogaster* | https://flybase.org |
| WormBase | *Caenorhabditis elegans* | https://wormbase.org |
| ZFIN | *Danio rerio* (zebrafish) | https://zfin.org |
| MGI | *Mus musculus* (mouse) | https://www.informatics.jax.org |
| SGD | *Saccharomyces cerevisiae* | https://www.yeastgenome.org |
| PomBase | *Schizosaccharomyces pombe* | https://www.pombase.org |

### 5.2 Plant and Tree Resources

**JGI Phytozome** (https://phytozome-next.jgi.doe.gov) is the primary portal for plant genome sequences and annotations, hosted by the Joint Genome Institute. It contains genome assemblies and gene annotations for a large number of plant species and provides standardised comparative genomics tools. For tree genomics, Phytozome hosts *Populus trichocarpa* and other important species.

**JGI MycoCosm** (https://mycocosm.jgi.doe.gov) is the equivalent portal for fungal genomes, also at JGI.

**PlantGenIE** (https://plantgenie.org / https://plantgenie.se) is a specialist resource for conifer and angiosperm genomics developed in part at Umeå University. It integrates genome browsers, co-expression networks, gene family tools, and BLAST search for a curated set of plant species with a particular focus on boreal forest trees including *Picea abies* (Norway spruce) and *Populus tremula* (European aspen). A new version is in active development (https://plantgenie.se).

**TAIR (The Arabidopsis Information Resource)** remains the gold standard for plant genomics and is the source of much of the functional annotation propagated to other plant species.

### 5.3 Environmental and Biodiversity Resources

**SILVA** (https://www.arb-silva.de) provides high-quality ribosomal RNA (rRNA) reference databases — 16S/18S for small subunit and 23S/28S for large subunit. It is the primary reference for amplicon-based microbial community profiling (metabarcoding) and phylogenetic placement of environmental sequences. SILVA is a key resource for anyone working in microbial ecology, soil biology, or aquatic biology.

**UNITE** (https://unite.ut.ee) is the equivalent resource for fungal ITS (Internal Transcribed Spacer) sequences, the standard barcode marker for environmental fungi. UNITE provides species hypotheses — clusters of ITS sequences that likely represent single fungal species — which are essential for fungal community analysis. It is particularly important for mycology, soil ecology, and studies of mycorrhizal networks.

**GBIF (Global Biodiversity Information Facility)** (https://www.gbif.org) is an open data infrastructure for publishing, accessing, and using biodiversity occurrence data — where and when organisms have been observed or collected. GBIF aggregates records from natural history museums, citizen science platforms, and research databases. It is essential for macroecological analyses, species distribution modelling, and eDNA study design.

**BOLD (Barcode of Life Data System)** (https://www.boldsystems.org) is a database of DNA barcode sequences linked to voucher specimens, used for species identification. BOLD is particularly important for metazoan biodiversity work (COI barcoding) and is the companion resource to GBIF for sequence-based identification.

**IMG/M** (https://img.jgi.doe.gov) at JGI hosts metagenomic datasets and provides comparative analysis tools for environmental genomic data.

> **SDG connection:** Several of these resources are directly relevant to monitoring progress towards the UN Sustainable Development Goals, particularly SDG 15 (Life on Land) and SDG 14 (Life Below Water). Biodiversity databases such as GBIF and BOLD, and eDNA-based approaches enabled by SILVA and UNITE, are increasingly central tools in global biodiversity assessment frameworks.

### 5.4 Human and Clinical Resources

**ENCODE (Encyclopedia of DNA Elements)** (https://www.encodeproject.org) is a large-scale international consortium project that has systematically characterised the functional elements in the human (and mouse) genome — transcription factor binding sites, histone modifications, chromatin accessibility, and RNA expression — across hundreds of cell types and conditions. ENCODE data is essential for understanding gene regulation in human cells.

**GTEx (Genotype-Tissue Expression)** (https://gtexportal.org) provides data on tissue-specific gene expression and its relationship to genetic variation (expression quantitative trait loci, eQTLs) across 54 human tissues. GTEx is the reference resource for understanding how genomic variants affect gene expression in different tissues.

**gnomAD (Genome Aggregation Database)** (https://gnomad.broadinstitute.org) aggregates and harmonises sequencing data from large-scale human genomic studies to provide population-level variant frequency data across diverse human populations. It is the primary reference for assessing whether a variant is rare (potentially disease-causing) or common (likely benign) in clinical genomics contexts.

**ClinVar** (https://www.ncbi.nlm.nih.gov/clinvar/) is NCBI's archive of variant–phenotype relationships — variants that have been submitted with clinical significance interpretations (pathogenic, likely pathogenic, benign, etc.). It is a central resource for clinical variant classification and interpretation.

**OMIM (Online Mendelian Inheritance in Man)** (https://www.omim.org) is a manually curated database of human genes and genetic disorders, with detailed clinical and molecular descriptions and extensive literature references.

---

## 6. How to Evaluate Any Unfamiliar Database

You will encounter databases throughout this programme and your career that are not covered in this lecture. The following checklist provides a framework for evaluating any unfamiliar resource:

**1. What is its scope and what questions can it answer?**
Read the "About" page. What organism(s), data type(s), and biological level(s) does it cover? Is it a primary archive, a reference database, or a functional/interpretive resource?

**2. Who maintains it and how is it funded?**
Databases maintained by established institutions (NCBI, EBI, JGI, model organism communities) with long-term funding are more likely to be stable and reliable than those maintained by a single research group. Check when it was last updated.

**3. What is the update cycle?**
Some databases are updated continuously; others have versioned releases. For reproducibility, knowing which version of a database you used is essential — always record this.

**4. How are annotations derived and what evidence codes are used?**
Does the database document its curation process? Are evidence codes available? Can you trace an annotation back to its primary source?

**5. Is programmatic access available?**
Does the database have a REST API, an FTP site, or a command-line client? This matters for scaling your work beyond what is feasible manually.

**6. How should it be cited?**
Most databases have a primary citation paper. Using a database without citing it is poor scientific practice and fails to support the funding and maintenance of the resource.

---

## 7. Hands-On Exercise: Your First Programmatic Database Query

**Objective:** Retrieve biological sequences from NCBI and UniProt using the command line, parse the results with Linux tools, and commit your work to Git. By the end of this exercise, you will have performed a complete data retrieval workflow using real programmatic database access — the same approach used in production bioinformatics pipelines.

**Prerequisites:** You should be logged in to Kebnekaise via OnDemand. All commands below run in a terminal session.

---

### Part A — Setting up your workspace

```bash
# Create a directory for this exercise
mkdir -p ~/course/lecture11-databases
cd ~/course/lecture11-databases

# Initialise a Git repository
git init

# Create a README file
echo "# Lecture 02: Programmatic Database Access" > README.md
echo "## Date: $(date)" >> README.md
git add README.md
git commit -m "initial commit: lecture11 exercise setup"
```

---

### Part B — Fetching a sequence from NCBI Entrez

NCBI provides a web API called **Entrez Utilities (E-utilities)** that allows programmatic access to all NCBI databases. The base URL is:

`https://eutils.ncbi.nlm.nih.gov/entrez/eutils/`

The two most useful endpoints are:
- `efetch.fcgi` — retrieve a specific record by accession
- `esearch.fcgi` — search a database and return accession numbers

**Step 1:** Fetch the RefSeq mRNA record for human *TP53* (accession `NM_000546.6`) in FASTA format:

```bash
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?\
db=nucleotide&id=NM_000546.6&rettype=fasta&retmode=text" \
> TP53_mRNA.fasta
```

**Step 2:** Inspect the file using tools you have already learned:

```bash
# Look at the header and first few lines
head -5 TP53_mRNA.fasta

# How many sequences are in the file?
grep -c ">" TP53_mRNA.fasta

# How many characters (bytes) is the file?
wc -c TP53_mRNA.fasta

# How many lines?
wc -l TP53_mRNA.fasta
```

*Questions to consider: What information is in the FASTA header line? What does the accession number format tell you about this record?*

**Step 3:** Now fetch the same record in **GenBank format** — a richer format that includes extensive metadata:

```bash
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?\
db=nucleotide&id=NM_000546.6&rettype=gb&retmode=text" \
> TP53_mRNA.gb

# Extract key metadata fields
grep "DEFINITION\|SOURCE\|ORGANISM\|KEYWORDS\|COMMENT" TP53_mRNA.gb
```

*Questions: What additional information does the GenBank format provide compared to FASTA? Can you find the gene name, organism, and a description of what this transcript encodes?*

---

### Part C — Fetching a protein from UniProt

UniProt provides a REST API at `https://rest.uniprot.org/`. UniProt accession numbers are alphanumeric (e.g., `P04637` for human TP53).

```bash
# Fetch the human TP53 protein sequence from UniProt in FASTA format
curl "https://rest.uniprot.org/uniprotkb/P04637.fasta" \
> TP53_protein.fasta

# Inspect the header
head -3 TP53_protein.fasta

# Count the amino acids (exclude the header line, remove newlines, count characters)
grep -v ">" TP53_protein.fasta | tr -d '\n' | wc -c
```

*Questions: How many amino acids does human TP53 have? How does the UniProt FASTA header format differ from the NCBI FASTA header? What information is encoded in each field?*

**Fetch the full UniProt entry in text format to see the annotation:**

```bash
curl "https://rest.uniprot.org/uniprotkb/P04637.txt" > TP53_protein.txt

# Is this a Swiss-Prot (reviewed) or TrEMBL (unreviewed) entry?
grep "^ID" TP53_protein.txt

# What GO terms are associated with TP53?
grep "^DR   GO;" TP53_protein.txt | head -10

# What evidence codes are used?
grep "^DR   GO;" TP53_protein.txt | grep -o "IDA\|IEA\|IMP\|ISS\|IPI\|EXP" | sort | uniq -c
```

---

### Part D — Documenting and committing your work

A core principle of FAIR and reproducible bioinformatics is that **the commands you used are as important as the data you produced**. Document your workflow:

```bash
# Append your findings to the README
cat >> README.md << 'EOF'

## Data retrieved
- TP53_mRNA.fasta — Human TP53 mRNA (NM_000546.6) from NCBI RefSeq in FASTA format
- TP53_mRNA.gb   — Same record in GenBank format
- TP53_protein.fasta — Human TP53 protein (P04637) from UniProt Swiss-Prot in FASTA format
- TP53_protein.txt   — Full UniProt annotation record for P04637

## Key findings
<!-- Add your answers to the questions above here -->

## Database versions / access date
- NCBI Entrez accessed: $(date)
- UniProt release used: check https://www.uniprot.org/help/release-notes
EOF

# Stage all files and commit
git add .
git commit -m "lecture11: retrieved TP53 records from NCBI and UniProt

- NM_000546.6 fetched in FASTA and GenBank format via Entrez API
- P04637 fetched from UniProt REST API
- Documented access date and findings in README"
```

*Note the commit message style: a short summary line, then a blank line, then more detail. This is good practice you should use throughout the programme.*

---

### Extension Tasks (if time allows)

**Extension A — A plant gene example:**

Fetch the rbcL gene (*ribulose-1,5-bisphosphate carboxylase/oxygenase large subunit*) from *Arabidopsis thaliana*. rbcL is one of the most widely used plant marker genes and is central to eDNA metabarcoding of plant communities.

```bash
# Search NCBI for Arabidopsis rbcL in the nucleotide database
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?\
db=nucleotide&term=Arabidopsis+thaliana[orgn]+rbcL[gene]+refseq[filter]\
&retmax=5&retmode=json" > rbcL_search.json

# Inspect the JSON output — this is a common API response format
cat rbcL_search.json
```

*Question: The output is in JSON format. How is it structured? What information would you need to extract from it to then fetch the actual sequence?*

**Extension B — Searching ENA programmatically:**

```bash
# Search ENA for RNA-seq datasets from Populus tremula
curl "https://www.ebi.ac.uk/ena/portal/api/search?\
query=tax_eq(182688)%20AND%20library_strategy=%22RNA-Seq%22\
&result=read_study&fields=study_accession,study_title,scientific_name\
&format=tsv&limit=5" > populus_rnaseq.tsv

cat populus_rnaseq.tsv
```

*Question: What does the query structure tell you about how the ENA API works? How might you modify this query to search for a different organism?*

---

## 8. In-Session Quizzes

### Mentimeter Quiz 1 — Prior knowledge (session opening)

*Displayed on screen at the start of the session:*

- Q1: "Which of these databases have you heard of?" (select all that apply): NCBI / ENA / UniProt / Ensembl / GEO / InterPro / KEGG / STRING / AlphaFold / gnomAD / GBIF / None of the above
- Q2 (open word cloud): "In one word: what is a biological database?"

### Mentimeter Quiz 2 — Classification and evidence codes (end of Block 1, before break)

**Q1:** You have just completed an RNA-seq experiment in *Populus tremula*. Where would you deposit the raw FASTQ reads?
- A) GEO (Gene Expression Omnibus)
- B) NCBI SRA (Sequence Read Archive) ✓ — *raw reads go to SRA; the processed expression data may additionally go to GEO*
- C) UniProt
- D) Ensembl

**Q2:** A GO annotation on a gene you are studying is labelled IEA. What does this mean, and should it change how you interpret the annotation?
- A) Inferred from Experimental Analysis — high confidence
- B) Inferred from Electronic Annotation — automated, no manual review ✓
- C) International Expert Assessment — curated by a specialist
- D) Integrated Evidence Archive — aggregated from multiple sources

**Q3:** Which of the following best describes the relationship between GenBank and RefSeq?
- A) They contain identical sequences with different accession numbers
- B) RefSeq is a curated, non-redundant subset; GenBank contains all submissions ✓
- C) GenBank is European; RefSeq is American
- D) They are operated by different organisations and do not overlap

---

## 9. What You Should Know After This Session

✅ **Describe the four-tier database hierarchy** and give one example from each tier.

✅ **Explain the INSDC partnership** and why the same nucleotide sequences appear in ENA, GenBank, and DDBJ.

✅ **Distinguish GenBank from RefSeq** and explain when you would use each.

✅ **Distinguish Swiss-Prot from TrEMBL** and explain what manually reviewed means in practice.

✅ **Explain what an evidence code is** and why IEA and EXP annotations are not equivalent.

✅ **Name at least two databases from each of:** primary archives; functional databases; plant/environmental resources; human/clinical resources.

✅ **Use `curl` to retrieve a sequence from NCBI Entrez and from UniProt**, and explain the structure of the URLs used.

✅ **Use `grep`, `wc`, and `tr`** to extract information from FASTA and GenBank format files.

✅ **Commit your data and documented commands to a Git repository** with a meaningful commit message.

✅ **Apply the database evaluation checklist** to assess any unfamiliar resource.

---

## 10. Further Reading and Resources

- Cochrane G. et al. (2016). The International Nucleotide Sequence Database Collaboration. *Nucleic Acids Research*, 44(D1): D48–D50. — Overview of the INSDC partnership.
- The UniProt Consortium (2023). UniProt: the Universal Protein Knowledgebase in 2023. *Nucleic Acids Research*, 51(D1): D523–D531. — Current reference for UniProt.
- Ashburner M. et al. (2000). Gene Ontology: tool for the unification of biology. *Nature Genetics*, 25: 25–29. — The foundational GO paper.
- Blum M. et al. (2021). The InterPro protein families and domains database: 20 years on. *Nucleic Acids Research*, 49(D1): D344–D354. — Current InterPro reference.
- Jumper J. et al. (2021). Highly accurate protein structure prediction with AlphaFold. *Nature*, 596: 583–589. — The AlphaFold paper; essential reading.

---

