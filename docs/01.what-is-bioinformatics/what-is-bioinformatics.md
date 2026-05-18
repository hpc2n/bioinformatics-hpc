# 01. What is Bioinformatics?

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University  
**Slides:** [PDF](../../PDFs/lecture-01-what-is-bioinformatics.pdf)  

---


## Session Aims

By the end of this session you should be able to:

1. Describe the origins, scope, and interdisciplinary nature of bioinformatics
2. Explain the kinds of biological questions that bioinformatics can and cannot answer
3. Articulate why epistemic awareness — understanding *what* an analysis actually tells you — is as important as technical proficiency
4. Describe the potential and risks of AI-assisted coding in the context of bioinformatics research
5. Identify the Expected Learning Outcomes (ILOs) of this course and the programme, and explain how they relate to different career trajectories in bioinformatics

**Links to course ILOs:** This session provides foundational conceptual grounding for ILOs 1, 3, 5, and 13. It does not directly assess technical skills, but establishes the intellectual framework within which all technical work in this programme is situated.

---

## 1. Origins: How Did Bioinformatics Come to Exist?

The term *bioinformatics* was coined by **Paulien Hogeweg and Ben Hesper** in 1970, originally describing the study of information processes in biotic systems. However, the field as it is practised today emerged from a convergence of pressures that became acute in the 1980s and 1990s.

### 1.1 The Data Problem That Created the Field

For most of the history of molecular biology, data were scarce and hard-won. Sequencing a single gene could represent years of laboratory work. The paradigm was: develop a hypothesis, design an experiment, collect modest amounts of data, interpret.

Three technological transitions fundamentally disrupted this paradigm:

**1. The Human Genome Project (HGP, 1990–2003)** demonstrated that genome-scale sequencing was possible and scientifically transformative — but also that the resulting datasets were far beyond the capacity of traditional biological analysis. The HGP produced approximately 3.2 billion base pairs; interpreting them required entirely new computational approaches. Crucially, it also established the principle that large-scale biological data should be publicly accessible, laying the groundwork for the database landscape you will use throughout this programme.

**2. The Next-Generation Sequencing (NGS) revolution (~2005–present)** reduced the cost of sequencing by several orders of magnitude — a reduction steeper than Moore's Law for computing. A human genome that cost approximately US$100 million to sequence in 2001 can now be sequenced for less than US$200. The consequence is that data generation has massively outpaced our ability to analyse and interpret it. The bottleneck in modern biology is not generating data — it is making sense of it.

**3. The multi-omics era** introduced the simultaneous measurement of many biological layers — genome, transcriptome, proteome, metabolome, epigenome — generating data of extraordinary complexity that cannot be understood by any single disciplinary tradition. Integration of these data types is one of the defining challenges of contemporary bioinformatics.

### 1.2 What is Bioinformatics, Formally?

Bioinformatics is an interdisciplinary field at the intersection of:

- **Biology** — the domain of application and the source of the questions
- **Computer science** — the tools and infrastructure for storing, processing, and analysing data
- **Statistics and data science** — the mathematical framework for drawing valid inferences from complex data
- **Mathematics** — foundational to algorithm design and modelling
- **Biochemistry and molecular biology** — necessary for interpreting molecular-level data

No practising bioinformatician is an expert in all of these areas. What distinguishes a skilled bioinformatician is the ability to work at the interfaces — to communicate across disciplines, to critically evaluate methods from adjacent fields, and to understand when to seek expertise that they themselves do not possess.

### 1.3 The Scope of Application

Bioinformatics is now integral to virtually every area of the life sciences:

| Domain | Representative application |
|--------|---------------------------|
| Human genomics and medicine | Variant calling for disease diagnosis; cancer genomics |
| Clinical genetics | Interpretation of diagnostic sequencing; pharmacogenomics |
| Plant science and agriculture | Crop improvement; understanding adaptation to climate |
| Microbiology | Pathogen surveillance; microbiome characterisation |
| Ecology and conservation | Biodiversity monitoring via eDNA metabarcoding |
| Evolutionary biology | Phylogenomics; population genetics |
| Drug discovery | Target identification; protein structure prediction |

This breadth is reflected directly in the design of this programme, which is deliberately pluralistic: you will encounter applications in human health, plant biology, microbiology, and environmental genomics. The underlying computational and statistical skills are transferable across all of them.

---

## 2. What Can — and Cannot — Bioinformatics Tell Us?

This is the most important conceptual section of the session. A remarkable amount of erroneous science in the bioinformatics literature results not from deliberate fraud, but from a failure to understand the limitations of computational analysis. Understanding these limitations is not a sign of scepticism about the field — it is the mark of a rigorous scientist.

### 2.1 Bioinformatics Produces Hypotheses, Not Truths

Computational analysis, however sophisticated, operates on representations of biological reality — not on biological reality itself. A sequence in a database is a record of bases detected by a machine under particular experimental conditions. A gene model is a prediction made by an algorithm trained on prior knowledge. An annotation is a transfer of information from one organism to another, often via automated pipelines.

This does not mean computational results are unreliable. It means they must be interpreted with appropriate epistemic humility, and wherever possible, validated experimentally.

> **Key principle:** Bioinformatics analysis generates hypotheses that should be treated as such until supported by independent evidence.

### 2.2 Reference Bias

Almost all genomic analyses compare data to a reference genome — a single representative sequence used as a standard. This introduces reference bias: variants, genes, or features that differ substantially from the reference may be missed, misassembled, or incorrectly annotated. 

This has particular implications for:
- **Population genomics** — reference genomes are typically derived from single individuals, often from historically well-resourced research communities, and may not represent population diversity
- **Non-model organisms** — reference genomes may be incomplete, fragmented, or simply absent
- **Structural variants** — large-scale genomic rearrangements are systematically under-detected by short-read approaches aligned to a linear reference

### 2.3 The Circularity Problem in Annotation

Much of the functional annotation in biological databases was derived by computational inference — transferring annotations from well-studied organisms to less-studied ones based on sequence similarity. This is both powerful and dangerous.

The danger arises because: if an incorrect annotation is propagated to a database, and subsequent analyses use that database to annotate further genomes, the error compounds. Studies have estimated that a substantial fraction of functional annotations in major databases may be propagated errors. This is not a reason to distrust databases — they are indispensable — but it is a reason to understand how an annotation was derived before treating it as ground truth.

> **Practical rule:** Always check the evidence code for a database annotation. Is it based on experimental evidence, computational prediction, or transferred annotation? These are not equivalent.

### 2.4 Pipeline Complexity and Opaque Decisions

Modern bioinformatics workflows chain together many tools, each of which makes decisions — which reads to keep, how to define gene models, which statistical threshold to apply, how to handle multimapping reads. The cumulative effect of these decisions can substantially affect the final result, and these decisions are often invisible to someone running an established pipeline without understanding its components.

A frequently cited principle in reproducible science is that if you cannot explain every step of your analysis and why those parameters were chosen, you do not fully understand your own results. This is not an aspirational standard — it is the minimum required for the work to be scientifically defensible.

### 2.5 The Absence of Signal is Not the Absence of Biology

A gene that is not detected as differentially expressed is not necessarily unchanged biologically. A protein that is absent from a database may simply not have been studied. A variant that does not pass a quality filter may nonetheless be real. Statistical null results are information-poor by nature; the absence of a finding in a computational analysis must always be interpreted in the context of what the analysis was actually capable of detecting.

---

## 3. Artificial Intelligence in Bioinformatics: Power, Risk, and Responsibility

### 3.1 The Current Landscape

Large language models (LLMs) and AI coding assistants — including tools such as Claude Code, GitHub Copilot, and ChatGPT — have dramatically changed the experience of writing code. These tools can generate syntactically correct code for routine tasks, explain error messages, suggest debugging strategies, and accelerate the implementation of standard analyses. Used appropriately, they are genuinely transformative productivity tools.

They are already being used in bioinformatics for:
- Generating boilerplate scripts and pipeline components
- Interpreting unfamiliar code
- Drafting documentation and README files
- Exploring unfamiliar APIs and libraries
- Accelerating literature synthesis

This programme actively encourages you to become fluent with AI-assisted coding. Productivity tools that exist should be used. Refusing to engage with AI coding assistants would be professionally unwise.

**However.**

### 3.2 The Risk Hierarchy

```
Level 1 — Inconvenience:    AI generates incorrect code that fails immediately.
                            You notice. You fix it. Minor time lost.

Level 2 — Hidden error:     AI generates code that runs but implements the
                            wrong logic. You do not notice. Your results are
                            wrong. You may not discover this until peer review,
                            or a collaborator tries to reproduce your work,
                            or you publish.

Level 3 — Compounding:      Wrong results inform downstream analyses, grant
                            applications, clinical decisions, or further
                            publications. The error propagates.

Level 4 — Systemic:         AI-generated scientific content, including
                            hallucinated citations and fabricated results,
                            enters the published literature. Other researchers
                            cite it, train future AI models on it, and build
                            on it. The scientific record is degraded.
```

Levels 1 and 2 are the most common risk for individual researchers. Levels 3 and 4 are the most consequential for science as a whole — and they are already occurring.

### 3.3 Why AI Errors in Bioinformatics are Particularly Dangerous

Bioinformatics analyses produce outputs that look authoritative — tables of numbers, figures, statistical values — regardless of whether the underlying analysis is correct. Unlike a wet laboratory experiment where a failed reaction is often visible, a computational error that produces plausible-looking output may pass undetected through code review, peer review, and publication.

AI tools make this worse in a specific way: they produce code that looks correct to someone who does not know what correct looks like. This is precisely the situation of a beginner. An experienced bioinformatician reviewing AI-generated code immediately notices when a normalisation step is wrong, when a statistical test is being misapplied, or when a genome coordinate system is being confused. A student without that foundational knowledge cannot perform that evaluation.

> **The core problem is not that AI makes mistakes — it is that you need to be able to detect the mistakes. And you cannot detect what you cannot recognise.**

### 3.4 The Analogy: Learning to Walk Before Running

Consider the following progression:

🚶 **Crawl** — understanding the conceptual foundations. What does this analysis actually do? What are its assumptions? What could go wrong?

🏃 **Walk** — implementing analyses yourself, from components you understand, and being able to explain every decision.

🚀 **Run** — using AI tools to accelerate work that you already understand deeply enough to verify.

Using AI tools before reaching the "walk" stage is, to use an imperfect but memorable analogy, **like being handed the controls of a Formula 1 car when you have never driven**. You may go very fast. Almost certainly in the wrong direction. Possibly through a wall. The AI will not tell you that you are heading towards a wall — it will generate confident, well-formatted code for doing so.

*[Lecture slide suggestion: a cartoon F1 car driven by someone in a lab coat, accelerating towards a wall labelled "Publication", with "AI COPILOT: No issues detected!" on the dashboard.]*

The aim of this programme is explicitly to build the foundations — the crawl and walk stages — so that when you use AI tools (which we actively encourage), you are doing so as an expert user who can evaluate, verify, and take responsibility for the outputs.

### 3.5 Practical Guidelines for AI Use in This Programme

The following principles apply throughout:

- **You are responsible for every line of code you submit**, regardless of how it was generated. "The AI wrote it" is not an acceptable explanation for an error in assessed work.
- **Always explain what code does before submitting it.** If you cannot explain it, you do not sufficiently understand it.
- **Verify outputs against expected results.** Run analyses on test data with known answers before applying them to real data.
- **Document your use of AI tools.** Transparency about AI assistance is an emerging norm in science; practise it from the beginning.
- **AI tools hallucinate.** They generate citations that do not exist, describe tools that have never been implemented, and produce plausible-sounding but incorrect biological statements. Verify everything independently.

---

## 4. The Programme Structure and Your Career Trajectory

### 4.1 Programme Overview

The Master's Programme in Bioinformatics at Umeå University consists of 120 ECTS across two years. The design is intentional: Year 1 builds foundational skills that are applied and deepened in Year 2.

**Year 1** — Foundational skills:

| Course | Key skills | ILOs addressed |
|--------|-----------|----------------|
| Computing for Data-Driven Biology | Command line, Linux, HPC, Git, databases, FAIR | 1–13 |
| Statistics and Data Science for Biology | Statistical foundations for biological data | — |
| Programming in Python for Bioinformatics | Scripting, automation, data manipulation | — |
| Statistics and Machine Learning in Bioinformatics | ML approaches in biological contexts | — |
| Quantitative Biology and Integrative Omics | Multi-omics data integration | — |
| Comparative Genomics | Genome-scale evolutionary analysis | — |
| Functional Genomics Theory | Gene regulation, transcriptomics theory | — |
| Applied Functional Genomics | RNA-seq and functional genomics in practice | — |

**Year 2** — Applied and specialist:

Clinical Omics and Bioinformatics; Epigenetics and the Non-Coding Genome; Microbial Bioinformatics; Advanced Bioinformatics; Thesis (30 ECTS)

### 4.2 Career Trajectories and What the Programme Trains You For

| Career path | Key competencies required | Programme relevance |
|-------------|--------------------------|---------------------|
| Service facility bioinformatician (e.g. Clinical Genomics) | Reproducible pipelines, data standards, variant interpretation, documentation | Strong — especially HPC, FAIR, clinical omics |
| Research bioinformatician (core facility or research group) | Statistical rigour, domain knowledge, communication | Strong — all core courses |
| Bioinformatics scientist (private sector / biotech) | Scalable pipelines, software engineering, data science | Strong — HPC, Python, ML |
| PhD student and future academic | Critical analysis, originality, methods development | Strong — epistemic training, thesis |
| Ecological/environmental bioinformatician | Metagenomics, biodiversity informatics, eDNA | Covered — comparative genomics, microbial bioinformatics |

### 4.3 This Course (5BI00A) in Context

*Computing for Data-Driven Biology* is the foundation on which the entire programme is built. Its primary function is to ensure that all students arrive at subsequent courses with a shared operational baseline:

- You can work on the command line and navigate a Linux environment
- You know how to find, access, and critically evaluate biological data
- You understand what FAIR and reproducible science mean in practice
- You can use version control (Git) as a working practice, not an afterthought
- You have begun to build habits of documenting your work

These are not glamorous skills. They are also not optional. A student who struggles with the command line in month three will struggle with RNA-seq analysis in month six. This course exists precisely to prevent that.

---

## 5. In-Session Quiz

*These questions will be discussed in the room. There are no wrong answers at this stage — the purpose is to surface assumptions and provoke discussion.*

**Question 1.** A paper reports that Gene X is "conserved across vertebrates" based on BLAST homology searches. What are three things you would want to know before accepting this conclusion?

**Question 2.** A collaborator sends you a Python script generated by an AI assistant that processes RNA-seq count data. The script runs without errors and produces a results table. What would you do before using those results in a manuscript?

**Question 3.** Consider the following two statements. Which is better supported by a bioinformatics analysis, and why?
- (a) "Gene X is expressed in liver tissue"
- (b) "Transcripts mapping to Gene X are detected in a liver RNA-seq dataset with a mean coverage depth of 47×"

**Question 4.** *Think-pair-share (2 minutes each):* What did you most recently read or hear about AI in science? Was the framing mostly positive, mostly negative, or balanced? What was missing from the discussion?

**Question 5.** The FAIR principles state that data should be Findable, Accessible, Interoperable, and Reusable. Without looking anything up — what do you think each of those words means in practice for a bioinformatics dataset? We will return to FAIR in depth later in the course.

---

## 6. What You Should Know After This Session

By the end of this lecture, you should be able to do the following. If any of these feel unclear, note them down and bring them to the next session or contact the course leader.

✅ **Describe the historical context** that gave rise to bioinformatics as a field, including the role of the Human Genome Project and next-generation sequencing.

✅ **Define bioinformatics** as an interdisciplinary field and name the contributing disciplines.

✅ **Give at least two examples** of domains where bioinformatics is applied, spanning human health and environmental/ecological contexts.

✅ **Explain at least two specific ways** in which bioinformatics analyses can mislead, with reference to concepts such as reference bias, annotation circularity, or pipeline opacity.

✅ **Articulate the epistemic principle** that bioinformatics generates hypotheses requiring independent validation, not definitive biological facts.

✅ **Describe the risk hierarchy** associated with AI-assisted coding in bioinformatics, and explain why errors are particularly dangerous when the user lacks foundational knowledge.

✅ **Identify the ILOs** of this course and explain how they contribute to at least one plausible career trajectory.

---

## 7. Further Reading and Resources

The following are provided for interest and supplementary context. None are required reading before the next session.

- Hogeweg P. (2011). The roots of bioinformatics in theoretical biology. *PLOS Computational Biology*, 7(3): e1002021. — A reflection by one of the field's founders on its origins.
- Leinonen R. et al. (2011). The European Nucleotide Archive. *Nucleic Acids Research*, 39(suppl_1): D28–D31. — Introduction to one of the primary data archives you will use throughout this programme.
- Wilkinson M.D. et al. (2016). The FAIR Guiding Principles for scientific data management and stewardship. *Scientific Data*, 3: 160018. — The foundational paper on FAIR principles, to which we will return in Lecture 13.
- Baker M. (2016). 1,500 scientists lift the lid on reproducibility. *Nature*, 533: 452–454. — Readable overview of the reproducibility crisis across sciences, with data from a large survey of researchers.
- Lowe R. et al. (2017). Transcriptomics technologies. *PLOS Computational Biology*, 13(5): e1005457. — Accessible introduction to the technologies that generate much of the data you will analyse.

---

## Appendix: Course ILO Summary

For reference throughout the course, the full Expected Learning Outcomes are reproduced below.

**Knowledge and understanding** — After completing the course, the student should be able to:
1. Understand fundamental concepts for working on the command line and be familiar with common command-line tools
2. Understand file system structures and management
3. Describe principles of reproducible and FAIR bioinformatics
4. Explain common bioinformatics file formats and their applications
5. Identify key biological databases and how to query them
6. Describe core components of workflows and HPC environments

**Skills and abilities** — The student should be able to:
7. Select and apply appropriate command-line tools to extract information and perform routine operations on common bioinformatics file formats
8. Execute file system administration tasks
9. Conduct routine file parsing and QC in Linux
10. Run and monitor jobs on HPC systems with schedulers
11. Build a reproducible workflow using environment managers or containers
12. Use Git for version control

**Judgement and approach** — The student should be able to:
13. Evaluate reproducibility and data governance in large-scale analyses

---

