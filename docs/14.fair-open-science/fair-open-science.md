# 14. FAIR and Open Science

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Slides:** [PDF](../PDFs/lecture-14-fair-open-science.pdf)  

---

## Principles, Reproducibility, and Open Research
### Master's Programme in Bioinformatics — Umeå University
### Computing for Data-Driven Biology (5BI00A)

---

## Session Aims

By the end of this session you should be able to:

1. State and explain the four FAIR principles and give a concrete bioinformatics example for each
2. Distinguish between findability, accessibility, interoperability, and reusability in practice
3. Describe the open science landscape — open access, open data, open source, and open peer review — and identify key resources and reading for each
4. Explain why Git is reproducibility infrastructure, not just version control
5. Explain what a reproducible report (R Markdown/knitr, Jupyter notebook) adds beyond a plain script
6. Write a reproducible Methods section — specifying exact software versions, all parameters, and database/genome release versions, with appropriate citations
7. Explain the "gold standard" of full reproducibility — deposited data plus deposited code enabling independent regeneration of every result — and why this is becoming easier to verify
8. Describe the FAIR for Research Software (FAIR4RS) principles and explain how they extend FAIR to code
9. Connect open science practices to the UN Sustainable Development Goals
10. Identify the key criteria for the FAIR compliance essay assessment and describe the difference between a passing and a distinction-level response

**Links to course ILOs:** This session directly addresses ILOs 3 and 13. It provides the conceptual foundation for the self-study practical exercises in Lecture 15. It also introduces the FAIR essay assessment, which is submitted via Canvas.

**Guest contribution:** Jamie McCann, developer of PlantGenIE (plantgenie.se) at Umeå University, joins this session to introduce the platform directly — see Section 9.

---

## Opening Activity

*A Mentimeter poll will ask what you think FAIR stands for (word cloud), and whether you have ever tried to reproduce or reanalyse a published dataset. There are no wrong answers — this surfaces assumptions that we will examine carefully during the session.*

---

## 1. Why This Matters: The Reproducibility Problem

### 1.1 A Crisis With Evidence

In 2016, *Nature* surveyed 1,576 researchers from across the sciences. More than 70% reported failing to reproduce another researcher's experiments; more than 50% had failed to reproduce their own. This is not a fringe concern — it is a structural problem in how science is conducted and communicated.

Bioinformatics is not immune. A 2018 study by Wijesooriya et al. attempted to reproduce the results of 20 high-profile RNA-seq differential expression papers published in top journals. Complete reproduction was possible in fewer than half; in several cases, neither the code nor the precise software versions were available, making independent verification impossible.

The consequences are not merely academic:

- **Wasted public funding** — replication attempts consume substantial resources that could otherwise generate new knowledge
- **Clinical consequences** — in translational research, irreproducible results can inform clinical decisions before they are identified as errors
- **Literature pollution** — citing an irreproducible result propagates the error; the published record becomes unreliable
- **Career risk** — retractions, post-publication criticism, and failed replications carry serious professional consequences for the researchers involved

### 1.2 The Causes in Bioinformatics

Irreproducibility in bioinformatics arises from a specific and largely preventable set of causes:

- **Undescribed software versions** — tools are updated continuously; the same tool may produce different results in different versions
- **Unavailable raw data** — "data available upon request" is not FAIR; requests are often ignored, researchers move institutions, or files are lost
- **Undocumented parameters** — default parameters change between software versions; not specifying them makes reproduction impossible
- **Ad hoc scripts without version control** — code that existed on a local machine but was never committed to a repository cannot be recovered
- **Statistical reporting without methodology** — reporting a p-value without the full analysis pipeline is insufficient for reproduction
- **Format and dependency issues** — code that ran on a specific operating system, with a specific library version, may not run elsewhere without containerisation

Each of these causes has a direct solution — and the solutions are exactly what FAIR data and software practices provide.

---

## 2. The FAIR Principles

The FAIR principles were published by Wilkinson et al. in *Scientific Data* in 2016 (DOI: 10.1038/sdata.2016.18). They provide a framework for making scientific data and software **Findable, Accessible, Interoperable, and Reusable** — primarily by machines, not just by humans. This distinction is important: FAIR is about enabling computational discovery and reuse at scale, not just making data available for download.

### 2.1 Findable

Data cannot be used if it cannot be found. Findability requires:

**F1 — Globally unique and persistent identifiers:** A dataset needs an identifier that will not change when a server is upgraded, a researcher moves institutions, or a project ends. A lab website URL is not persistent. A Digital Object Identifier (DOI) assigned by a repository is.

**F2 — Rich metadata:** The metadata — the description of the data — should be sufficiently detailed that a researcher who has never seen the dataset can understand what it is, who produced it, when, why, and under what conditions. Metadata should be indexed and searchable.

**F3 — Metadata includes the identifier:** The metadata record should unambiguously link to the data it describes.

**F4 — Data is registered or indexed in a searchable resource:** Depositing raw reads in the ENA or SRA, expression data in GEO or ArrayExpress, or proteomics data in PRIDE makes them findable by search engines and database query interfaces.

> **Bioinformatics example:** An RNA-seq study that deposits raw reads in the ENA with a study accession (PRJEB12345), annotates samples with EFO ontology terms, and records the NCBI taxonomy identifier for the organism is highly findable. A study that provides data only as a supplementary Excel file attached to the paper is not — the file has no independent identifier, will not be indexed by database search engines, and may become inaccessible if the publisher changes hosting.

### 2.2 Accessible

Accessible does not mean open. It means that there is a well-defined, open protocol by which authorised users can retrieve the data — even if the data itself is access-controlled.

**A1 — Data is retrievable by its identifier using a standardised communications protocol:** Retrieval via HTTP, HTTPS, or FTP with a stable URL is accessible. Retrieval by emailing the corresponding author is not — the author may not respond, may have retired, or may no longer have the file.

**A1.2 — The protocol allows for authentication and authorisation where necessary:** Human genomic data often cannot be fully open due to privacy and consent obligations. This is legitimate. The solution is controlled access with a documented process (as in dbGaP or the European Genome-phenome Archive, EGA) — not simply locking the data away without any retrieval mechanism.

**A2 — Metadata remains accessible even if the data is no longer available:** If a dataset must be withdrawn (for example, after a privacy breach is discovered), the metadata record — describing what the dataset was — should remain as a tombstone record, so that citations to the data can still be traced.

> **Bioinformatics example:** The GTEx dataset is accessible: raw data requires an application process (human subjects data), but the access protocol is clearly documented, the data is retrieved via dbGaP using standardised tools, and processed summary data is fully open. A dataset described as "available upon reasonable request" in a 2019 paper, with the corresponding author having since left academia, is not accessible.

### 2.3 Interoperable

Interoperability is about enabling data to be integrated with other data and analysed by other tools without manual intervention. It requires:

**I1 — Data uses a formal, accessible, shared, and broadly applicable language for knowledge representation:** In bioinformatics, this means using standard file formats (FASTA, FASTQ, BAM, VCF, GFF — which you have already learned) rather than proprietary formats, and using ontologies (GO, EFO, NCBI Taxonomy, OBI) to annotate metadata.

**I2 — Data uses vocabularies that follow FAIR principles:** An ontology term from the Gene Ontology or the Experimental Factor Ontology has a stable, resolvable identifier (e.g. `GO:0006355` for "regulation of DNA-templated transcription"). A free-text annotation such as "liver (adult, treated)" cannot be reliably parsed by a machine or compared across datasets.

**I3 — Data includes qualified references to other data:** A genomic dataset should specify which reference genome assembly it was aligned to, with a versioned identifier. It should cross-reference the ENA study from which raw reads came. These cross-references allow datasets to be integrated without manual disambiguation.

> **Bioinformatics example:** PlantGenIE (plantgenie.se) exposes its data through documented REST API endpoints that return data in standard formats (JSON, FASTA). This means a researcher can query PlantGenIE data programmatically, integrate results with other databases, and build reproducible analysis pipelines. In Lecture 15, you will work directly with these API endpoints. This is interoperability in practice — not a database that requires a specific browser plugin to access its data.

### 2.4 Reusable

Reusable data is data that is sufficiently well described for someone other than the original producer to understand it and use it confidently for a new purpose.

**R1 — Data is richly described with a plurality of accurate and relevant attributes:** This means detailed sample-level metadata: organism (with taxonomy ID), tissue or cell type (with EFO or CL ontology term), treatment, age, sex, time point, growth conditions, and any other experimental variables. For a differential expression analysis, a researcher receiving your data should be able to assign samples to conditions without contacting you.

**R1.1 — Data is released with a clear and accessible data usage licence:** Without a licence, the legal default in most jurisdictions is that data is fully protected by copyright and cannot be reused. A Creative Commons CC-BY licence allows reuse with attribution; CC0 waives all rights entirely. For software, MIT, Apache 2.0, and GPL are common open-source licences.

**R1.2 — Data is associated with detailed provenance:** Where did the data come from? What processing steps were applied? Which software versions were used? A fully documented provenance chain allows a new user to understand not just what the data is, but how it became what it is.

**R1.3 — Data meets domain-relevant community standards:** In genomics, this means MINSEQE (Minimum Information about a high-throughput Nucleotide SeQuencing Experiment) for RNA-seq studies; MIxS (Minimum Information about any (x) Sequence) for environmental sequencing; MIAPE for proteomics. These standards define the minimum metadata required for a dataset to be considered adequately described.

> **Bioinformatics example:** A GEO dataset with complete sample metadata — organism (NCBI taxonomy ID), tissue (UBERON ontology term), treatment, time point, genotype, and growth conditions — released under CC-BY, with raw reads deposited in SRA and a Snakemake workflow pinned to exact software versions deposited in Zenodo with a DOI, is highly reusable. A GEO dataset with samples labelled "control" and "treated" and no further metadata, with code described as "scripts used in analysis are available upon request," is not.

---

## 3. The Open Science Landscape

Open science is a broader movement of which FAIR data is a component. It encompasses several interconnected practices, each of which is relevant to your career as a bioinformatician.

### 3.1 Open Access to Publications

Open access (OA) is the practice of making scientific publications freely available online without subscription barriers. There are several models:

- **Gold OA:** The final published version is immediately open, hosted by the publisher. Often requires payment of an Article Processing Charge (APC) by the author or funder.
- **Green OA (self-archiving):** The author deposits a version of the manuscript in an institutional or subject repository (e.g. PubMed Central, bioRxiv, Europe PMC). The publisher version may remain behind a paywall; the deposited version is free.
- **Diamond OA:** Fully open to read and publish, with no APCs. Typically supported by institutions, societies, or grants.
- **Preprints:** Non-peer-reviewed manuscripts posted to a preprint server (bioRxiv, medRxiv, arXiv) before or during peer review. Increasingly common in biology; enables rapid knowledge sharing and community feedback.

The Swedish Research Council (Vetenskapsrådet) and the European Research Council both mandate open access for publications arising from their funding. As a researcher in Sweden, you should familiarise yourself with your institution's OA policy and the requirements of your funders.

**Further reading:**
- Budapest Open Access Initiative (2002) — the founding document: https://www.budapestopenaccessinitiative.org/
- Plan S principles: https://www.coalition-s.org/

### 3.2 Open Data

Open data in science means making datasets publicly available with sufficient metadata for reuse. The FAIR principles apply directly here. Key resources:

- **Zenodo** (https://zenodo.org) — general-purpose open repository operated by CERN and the European Commission; assigns DOIs and accepts any file format
- **Figshare** (https://figshare.com) — similar to Zenodo; widely used for supplementary figures, datasets, and code
- **The domain-specific archives** covered in Lecture 11 (ENA, GEO, PRIDE, etc.) are the primary destinations for bioinformatics data

**Further reading:**
- Wilkinson M.D. et al. (2016) — the FAIR paper: DOI 10.1038/sdata.2016.18
- The Open Data Handbook: https://opendatahandbook.org/

### 3.3 Open Source Software

Open source software makes source code publicly available under a licence that permits use, modification, and redistribution. For bioinformatics, this is the norm rather than the exception — the tools you have already used (BLAST+, samtools, bcftools, bedtools) are all open source.

Licences determine what others can do with your code:
- **MIT / Apache 2.0:** Permissive — anyone can use, modify, and redistribute, including in commercial software
- **GPL (General Public Licence):** Copyleft — derivative works must also be open source
- **CC-BY:** Commonly used for content and data; allows reuse with attribution

**Further reading:**
- Choose a Licence: https://choosealicense.com/
- The Turing Way Guide to Reproducible Research: https://the-turing-way.netlify.app/

### 3.4 Open Peer Review

Traditional peer review is anonymous and the reviews are not published. Open peer review makes reviewer identities and/or the content of reviews publicly available. Several journals (eLife, PeerJ, F1000Research) now publish peer review reports alongside accepted papers. This increases accountability and transparency in the evaluation process.

---

## 4. Git as Reproducibility Infrastructure

You have been using Git throughout this course for version control of your exercises. It is worth being explicit about why Git matters for reproducible science, beyond its role as a coding tool.

### 4.1 Every Commit is a Reproducibility Checkpoint

A Git repository contains the complete history of every change made to every file. When you commit your analysis scripts at each stage of a project, you create a record of exactly what the analysis looked like at that point in time. This means:

- If a reviewer asks "what exactly did you do?", you can show them the exact code at the time of submission
- If you update a tool and results change, you can identify when and why the results changed
- If a collaborator joins the project, they can see the full development history, not just the current state

### 4.2 Tags Connect Commits to Publications

Git allows you to tag specific commits. The standard practice is to create a tag (e.g. `v1.0-paper-submission`) at the exact commit used to generate the results in a submitted manuscript. This tag can then be referenced in the paper's methods section, and readers can retrieve exactly that version of the code.

### 4.3 Repositories as Persistent Archives

A Git repository hosted on GitHub or GitLab is not a persistent archive — repositories can be deleted. For a publication, you should archive the repository at a persistent service that issues a DOI:

- **Zenodo** integrates directly with GitHub: each tagged release automatically creates a DOI-bearing archive
- **Software Heritage** archives all public code repositories, including historical states

### 4.4 Containers Extend Reproducibility Beyond Code

Code alone is not sufficient for full reproducibility — the software environment matters too. The same script may produce different results with a different version of a library. Containers (Docker, Singularity/Apptainer) package the code together with its complete software environment, producing a portable, reproducible unit. This is what the HPC2N block covered when introducing containers — and it is directly a FAIR4RS practice.

### 4.5 Reproducible Reports: Notebooks and R Markdown

A script produces results; it does not, by itself, explain them. A **reproducible report** — an R Markdown document rendered with `knitr`, or a Jupyter notebook — combines the code that produced a result, the narrative explaining what it shows, and the rendered output (tables, plots) into a single document that is both human-readable and rerunnable from scratch.

- **R Markdown, rendered with `knitr`,** produces an HTML, PDF, or Word report from a single `.Rmd` file that interleaves R code chunks with narrative Markdown text. Rendering the same `.Rmd` file always regenerates the same report from the same code — the report is a reproducible artefact, not a one-off screenshot of a plot.
- **Jupyter notebooks** do the equivalent for Python: code cells, their live output, and narrative Markdown cells in one `.ipynb` file, which can be re-executed top to bottom to regenerate every output.

Both are available on Kebnekaise via OnDemand — RStudio Server (for R Markdown) and Jupyter Notebook are both listed as interactive apps there.

This is not a cosmetic difference from a plain script. A colleague, a reviewer, or your future self six months on, opening a notebook or an `.Rmd` file, sees the reasoning alongside the code and the actual result it produced — not a script they must run blind, and a set of output files whose provenance they must reconstruct from memory or a README. This is what turns the "gold standard" combination of deposited data and code (Section 6) into something a human can actually follow, not just something a machine can technically re-execute.

You will work with both R Markdown (in *Data Science for Biology with R*) and Jupyter notebooks (in *Python Programming for Bioinformatics*) in depth later in the programme. In Lecture 15 you will build a minimal example using results you already have from this session.

---

## 5. Writing Reproducible Methods

Every principle above has a direct, practical consequence for how you write the Methods section of your own papers. A Methods section is not a narrative description of what you did in general terms — it is a specification precise enough that someone else could redo the analysis without asking you a single follow-up question.

### 5.1 The Minimum a Reproducible Methods Section Must State

**Software, with exact version numbers.** "We used BLAST" is not reproducible — BLAST 2.2.31 and BLAST+ 2.17.0 can give different results for the same query. State the tool and the exact version: "blastp v2.17.0 (BLAST+)".

**A citation for every tool, not just a version number.** Citing the software is how the people who built and maintain the tool get scientific credit for that work — the same courtesy as citing a paper for a method or a dataset. Most bioinformatics tools have a canonical citation, often given in their documentation or a `--citation` flag; cite it, in addition to stating the version.

> **Example:** "Reads were aligned with minimap2 v2.28 (Li, 2018, *Bioinformatics* 34(18): 3094–3100) using the `-ax splice` preset."

**Every parameter that was set — including when you used defaults.** Default parameters change between software versions. Writing "default parameters were used" is not sufficient on its own; stating the exact version (see above) pins what those defaults actually were, and any parameter changed from the default must be stated explicitly.

**Database and reference genome versions, with citations where the resource has one.** "The human reference genome" is not reproducible — different genome assembly patches, annotation releases, and gene model versions give measurably different results. State the exact assembly and release, e.g. "GRCh38.p14 (Ensembl release 110)". If the database or release has a citable publication or DOI, cite it — again, the same courtesy as citing a tool.

### 5.2 A Worked Example

| Not reproducible | Reproducible |
|---|---|
| "Reads were aligned to the reference genome with default parameters." | "Reads were aligned to GRCh38.p14 (Ensembl release 110) with STAR v2.7.11a (Dobin et al., 2013, *Bioinformatics* 29(1): 15–21), using `--outFilterMismatchNmax 2`; all other parameters were left at their v2.7.11a defaults." |
| "Differential expression was assessed using standard statistical methods." | "Differential expression was assessed with DESeq2 v1.42.0 (Love et al., 2014, *Genome Biology* 15: 550) in R v4.3.2, using the default Wald test and an adjusted p-value threshold of 0.05 (Benjamini-Hochberg correction)." |

This is the same standard the "Things to Look For" checklist in Section 10.3 asks you to apply when assessing someone else's paper for the essay — here you are looking at the same requirements from the other side, as the author.

---

## 6. The Gold Standard: Data, Code, and Full Reproducibility

### 6.1 What "Full Reproducibility" Actually Means

The FAIR principles, Git practices, and Methods-writing guidance above are all components of a single underlying goal: **an independent researcher, with no access to you, should be able to regenerate every reported number, table, and figure from the raw data.**

This is achieved by the combination of two things, both properly deposited and both citable:

1. **The inputs** — the raw data, deposited at a persistent repository such as Zenodo, Figshare, or a domain-specific archive (ENA, GEO, PRIDE — see Lecture 11).
2. **The producers** — the analysis code, deposited at a version-controlled repository (Git), ideally with a tagged release archived to Zenodo so it has its own DOI (Section 4.3).

Neither is sufficient alone. Data without code tells a reader what went in but not how the reported values came out. Code without data is unusable — a script cannot run against nothing. Together, and only together, they make every table, figure, and stated value in a paper something a reader can regenerate, not merely something they must take on trust.

### 6.2 Why This Is Becoming Easier to Check — and Increasingly Expected

Verifying this used to mean a human reviewer manually attempting to rerun a pipeline, which is slow, expensive, and rarely done in practice. That is changing. AI-assisted and fully autonomous systems are now being used to attempt exactly this: taking a paper's deposited data and code and independently regenerating its reported results. Recent work used a multi-agent large language model system to attempt this directly on a bioinformatics single-cell RNA-seq study, with partial but real success and clearly documented failure modes — including non-determinism in generated code and difficulty procuring the correct data (Bersenev et al., 2024, *bioRxiv*, DOI: 10.1101/2024.04.08.588614). A large controlled study of AI-assisted reproduction of social-science findings found that AI-assisted teams reproduced results about as well as human-only teams, while fully autonomous AI-led reproduction attempts performed markedly worse — useful context for how far this technology has, and has not, come (Brodeur et al., 2026, *PNAS*, DOI: 10.1073/pnas.2524747123).

As these tools improve, "cleanroom" reproduction — an independent party or an automated system regenerating your results from nothing but your deposited data and code — is plausibly becoming something journals and funders can routinely check, rather than something they must take on faith. It is a reasonable expectation that computational biology will move further in this direction during your careers, and that a reviewer or an automated system attempting exactly this kind of cleanroom rerun could become a normal part of submission or review, not a hypothetical.

**The practical implication for you:** treat "could a stranger, or an AI system with no access to me, regenerate this figure from what I have deposited?" as a genuine test to apply to your own work before submission.

---

## 7. FAIR for Research Software (FAIR4RS)

The FAIR4RS principles, published in 2022, extend FAIR to software and code:

**F — Findable software:** Software has a globally unique and persistent identifier (e.g. a Zenodo DOI). Its metadata is indexed in a searchable resource (e.g. bio.tools, SciCrunch).

**A — Accessible software:** Source code is accessible via a standardised protocol (GitHub URL, Zenodo DOI). Access does not require proprietary tools. The metadata is accessible even if the software is retired.

**I — Interoperable software:** Software uses standard formats for input and output (connecting directly to Lecture 13). Software uses and produces data that follow community standards. APIs are documented and stable.

**R — Reusable software:** Software has a licence. It is documented sufficiently to be understood and adapted. It follows community best practices (version control, tests, documentation). Its provenance and version history are available.

> **Practical example:** A Python script saved on a lab PC with no version control, no licence, no documentation, and sent as an email attachment on request is not FAIR. The same script in a public GitHub repository with a version tag, a README, an MIT licence, a Zenodo DOI, and a `requirements.txt` pinning all dependencies is FAIR.

**Further reading:**
- Chue Hong N.P. et al. (2022). FAIR Principles for Research Software (FAIR4RS Principles). DOI: 10.15497/RDA00068

---

## 8. Open Science and the UN Sustainable Development Goals

The open science agenda connects directly to several UN Sustainable Development Goals:

**SDG 3 — Good Health and Well-Being:** Open access to genomic, clinical, and pharmacogenomic data accelerates medical research and democratises access to scientific knowledge for researchers in low- and middle-income countries.

**SDG 14 — Life Below Water / SDG 15 — Life on Land:** Biodiversity databases (GBIF, BOLD, SILVA, UNITE) are open data infrastructures that enable global monitoring of species distributions and ecosystem health. eDNA metabarcoding studies — which generate the raw data deposited in ENA — are directly used by conservation policy bodies including the CBD (Convention on Biological Diversity).

**SDG 17 — Partnerships for the Goals:** Open science is itself an instrument of international scientific partnership. Open data enables researchers in all countries to participate in global science regardless of the resources of their own institutions.

---

## 9. Guest Contribution: Introducing PlantGenIE

Jamie McCann, developer of PlantGenIE (plantgenie.se) at Umeå University, joins this session to introduce the platform directly — an opportunity to hear from the person who designed the infrastructure, and to see how the choices made when building a database resource either enable or hinder FAIR compliance in practice.

PlantGenIE is a bioinformatics resource for plant and tree genomics developed at Umeå University, with primary development by Jamie McCann. It integrates genome browsers, gene expression and co-expression data, functional annotations, a BLAST search interface, and REST API endpoints exposing all of the above, for boreal forest tree species including *Picea abies* (Norway spruce) and *Populus tremula* (European aspen).

PlantGenIE's REST API is a concrete example of the Interoperable principle already introduced in Section 2.3: standard protocols (HTTP/HTTPS), standard formats (JSON, FASTA), and documented endpoints that any tool or researcher can query directly, without contacting the authors or working through a specific browser interface.

You will work hands-on with these API endpoints — retrieving gene information, expression data, and BLAST results — in the self-study exercises in [Lecture 15: FAIR in Practice](../15.fair-in-practice/fair-in-practice.md).

---

## 10. Introduction to the FAIR Essay Assessment

*This section introduces the Canvas assignment. The full assignment description, marking criteria, submission instructions, and deadline are in Canvas.*

### 10.1 What the Assignment Asks

The essay asks you to **critically evaluate the FAIR compliance of a published bioinformatics study** and its associated data.

You will be given a specific published paper and an associated dataset (or you may be asked to locate the dataset yourself — the Canvas assignment specifies which). Your task is to:

1. Assess each of the four FAIR principles against concrete evidence from the paper and its associated data
2. Evaluate whether the metadata associated with the dataset is sufficient to enable reuse — for example, to reproduce a differential expression analysis
3. Assess the reproducibility of the computational analysis — are software versions specified? Is code available? Could you re-run the analysis?
4. Make specific, evidenced recommendations for what could have been done differently

### 10.2 What Makes a Good Response

**At the G (pass) level:** You correctly identify and describe FAIR issues. You apply the FAIR principles accurately to the specific study. You note whether data is deposited and whether code is available. Your observations are accurate and relevant.

**At the VG (distinction) level:** You do all of the above and additionally evaluate the *consequences* of the FAIR issues you identify. Why does it matter that a particular metadata field is missing? What would a researcher attempting reanalysis be unable to do? You make specific, concrete recommendations that would have improved FAIR compliance. Your argument is structured, evidenced, and analytical rather than descriptive. You demonstrate understanding of the difference between what FAIR *requires* and what it *recommends*, and between the spirit and the letter of each principle.

### 10.3 Things to Look For

When assessing a paper and its dataset, ask the following questions:

**Findability:**
- Is there an accession number in the paper? Is it a persistent identifier (SRA/ENA/GEO accession, DOI) or a URL?
- Can you retrieve the dataset from a search engine without knowing its accession?
- Is the dataset indexed in a public database?

**Accessibility:**
- Can you actually download the data using a standardised protocol (HTTPS, FTP)?
- Is the access process documented?
- If access is controlled, is there a documented application process?

**Interoperability:**
- Are data in standard formats (FASTQ, BAM, VCF...)?
- Are samples annotated with ontology terms, or with free text?
- Is the reference genome version specified with a versioned identifier?
- Is there cross-referencing to related datasets or resources?

**Reusability:**
- Is there sufficient sample metadata to assign samples to experimental conditions without contacting the authors?
- Is there a data licence?
- Is software version information provided for every tool?
- Is analysis code available, and if so, is it documented and versioned?
- Does the study declare adherence to a community metadata standard (MINSEQE, MIxS, etc.)?

### 10.4 What a Weak and a Strong Response Look Like

**Weak (likely G-level):**
> "The raw data was deposited in the NCBI SRA with accession SRP123456 (F). The data can be downloaded (A). The authors used standard FASTQ format (I). The methods section describes the analysis (R)."

This correctly identifies some FAIR-relevant facts but does not evaluate them critically. It does not assess the *quality* of findability, the *completeness* of accessibility, the *richness* of interoperability, or whether the reusability metadata is actually sufficient.

**Strong (likely VG-level):**
> "While raw sequencing reads were deposited in the NCBI SRA (accession SRP123456), the study's Findability is partially compromised: no structured metadata describing tissue type, treatment, or organism was deposited alongside the reads, and the GEO entry (GSE123456) lacks EFO ontology annotations for the six experimental conditions. A researcher attempting to locate this dataset via a semantic database search would need to know the accession number in advance. Regarding Reusability: the methods section specifies HISAT2 v2.1.0 for alignment and DESeq2 v1.20.0 for differential expression, which is commendable; however, the exact parameters passed to both tools are omitted, and no analysis code is available — the methods state only that 'standard parameters were used.' This makes independent computational reproduction impossible without author contact. The missing metadata would be straightforwardly remedied by depositing a sample table conforming to MINSEQE standards at time of submission, a step that requires minimal additional effort but substantially increases the study's long-term value to the community."

---

## 11. What You Should Know After This Session

✅ **State and explain all four FAIR principles** and give a concrete bioinformatics example for each.

✅ **Explain the difference between accessible and open** — controlled access data can be FAIR.

✅ **Explain why ontology terms make metadata more interoperable** than free-text annotations.

✅ **Describe three components of the open science landscape** — open access, open data, open source — and name one key resource for each.

✅ **Explain how Git functions as reproducibility infrastructure**, beyond its role as version control.

✅ **Explain what a reproducible report (R Markdown/knitr or a Jupyter notebook) adds** beyond a plain script or terminal transcript.

✅ **Write a reproducible Methods statement** for a given tool or analysis step, including version number, citation, parameters, and database/genome release.

✅ **Explain the "gold standard" of full reproducibility** — deposited data plus deposited code enabling independent regeneration of every result — and why AI-assisted reproduction is making this easier to verify.

✅ **Describe the FAIR4RS principles** and give one practical example of the difference between FAIR and non-FAIR software.

✅ **Apply the FAIR framework to assess a bioinformatics study**, identifying specific issues and their consequences.

✅ **Describe the difference between G and VG-level essay responses** and explain what critical evaluation means in this context.

---

## 12. Further Reading and Resources

- Wilkinson M.D. et al. (2016). The FAIR Guiding Principles for scientific data management and stewardship. *Scientific Data*, 3: 160018. DOI: 10.1038/sdata.2016.18
- Chue Hong N.P. et al. (2022). FAIR Principles for Research Software (FAIR4RS Principles). *Research Data Alliance*. DOI: 10.15497/RDA00068
- Baker M. (2016). 1,500 scientists lift the lid on reproducibility. *Nature*, 533: 452–454.
- Wijesooriya K. et al. (2022). Urgent need for consistent standards in functional enrichment analysis. *PLOS Computational Biology*, 18(3): e1009935.
- Bersenev D., Yachie-Kinoshita A. and Palaniappan S.K. (2024). Replicating a High-Impact Scientific Publication Using Systems of Large Language Models. *bioRxiv*. DOI: 10.1101/2024.04.08.588614
- Brodeur A., Valenta D. and Marcoci A. (2026). AI-assisted teams outperform AI-led teams but not human-only teams in assessing research reproducibility in quantitative social science. *PNAS*, 123(22). DOI: 10.1073/pnas.2524747123
- The Turing Way — a community-driven guide to reproducible, ethical, and collaborative data science: https://the-turing-way.netlify.app/
- FAIRsharing.org — a curated registry of data and metadata standards, databases, and policies: https://fairsharing.org/
- Plan S — funder mandate for open access: https://www.coalition-s.org/
- Choose a Licence — guide to software licensing: https://choosealicense.com/
- Zenodo — open repository for data and software: https://zenodo.org/
- bio.tools — registry of bioinformatics tools and services: https://bio.tools/
- R Markdown documentation: https://rmarkdown.rstudio.com/
- knitr documentation: https://yihui.org/knitr/
- Jupyter documentation: https://jupyter.org/documentation
- HPC2N OnDemand interactive apps (Jupyter Notebook, RStudio Server): https://docs.hpc2n.umu.se/tutorials/connections/

---


---

## Appendix: The FAIR Essay — Curated Paper Shortlist

The three papers below have been selected as candidates for the essay assessment, one per domain. Students should select one to assess in full. Each has been chosen to provide a substantive and instructive FAIR analysis — neither trivially compliant nor catastrophically non-compliant.

---

### Paper A — Human/Clinical

**Himes B.E. et al. (2014).** RNA-Seq Transcriptome Profiling Identifies CRISPLD2 as a Glucocorticoid Responsive Gene that Modulates Cytokine Function in Airway Smooth Muscle Cells. *PLoS One* 9(6): e99625.

- **DOI:** 10.1371/journal.pone.0099625
- **Data:** GEO accession GSE52778; raw reads in NCBI SRA (SRR1039508–SRR1039521)
- **Topic:** Transcriptomic response of human airway smooth muscle cells to dexamethasone — a glucocorticoid steroid relevant to asthma treatment. Biologically accessible to students from any life science background.
- **Why it is useful for FAIR assessment:** Published in 2014, before the FAIR principles were formalised. Data is deposited in GEO (good), raw reads are in SRA (good), but sample metadata in GEO is minimal with no EFO or cell ontology terms, no analysis code is provided in the paper, and parameter choices are incompletely reported. The essay can ask: what would this study look like if submitted today? This temporal dimension makes for a particularly rich analysis.
- **Access:** Open access, PLoS One.

---

### Paper B — Plant/Conifer

**Trujillo-Moya C. et al. (2020).** RNA-Seq and secondary metabolite analyses reveal a putative defence-transcriptome in Norway spruce (*Picea abies*) against needle bladder rust (*Chrysomyxa rhododendri*) infection. *BMC Genomics* 21: 336.

- **DOI:** 10.1186/s12864-020-6587-z
- **Data:** BMC Genomics requires a data availability statement — check the ENA/SRA accession is present and accessible in the paper before you begin your assessment.
- **Topic:** Transcriptome response of Norway spruce to fungal infection — directly relevant to forest health, conifer biology, and the kind of tree genomics work central to this programme. Connects to PlantGenIE and the Umeå boreal forest research context.
- **Why it is useful for FAIR assessment:** Published in 2020, in the period when data deposition was routine but code availability and rich metadata were still inconsistent. Likely has data deposited but limited or no analysis code; ontology use in sample metadata is likely incomplete. Software versions are specified in methods but may be incomplete.
- **Access:** Open access, BMC Genomics (CC BY).

---

### Paper C — Microbial/Environmental

**Azarbad H. et al. (2022).** Relative and Quantitative Rhizosphere Microbiome Profiling Results in Distinct Abundance Patterns. *Frontiers in Microbiology* 12: 798023.

- **DOI:** 10.3389/fmicb.2021.798023
- **Data:** Frontiers requires data availability — check the SRA/ENA accession is present and accessible in the paper before you begin your assessment.
- **Topic:** 16S rRNA and ITS amplicon profiling of the wheat rhizosphere microbiome under drought stress history. Covers microbial ecology and environmental genomics; connects to SILVA (16S reference), UNITE (ITS/fungal), and biodiversity themes (SDG 15).
- **Why it is useful for FAIR assessment:** Published in 2022; uses standard amplicon methods (QIIME2) but code and parameter availability vary widely in this domain. Rich area for assessing whether the SILVA and UNITE reference database versions used are specified, whether QIIME2 version is recorded, and whether raw reads are deposited with sufficient metadata for reanalysis.
- **Access:** Open access, Frontiers in Microbiology (CC BY).

