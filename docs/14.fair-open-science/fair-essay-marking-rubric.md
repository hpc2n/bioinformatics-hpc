# Marking Rubric: FAIR Compliance Essay
## Computing for Data-Driven Biology (5BI00A)
### Master's Programme in Bioinformatics — Umeå University
### Assessment deadline: 29 September 2026

---

## Overview

The essay is marked on the Swedish two-grade scale: **G (Godkänd / Pass)** or **VG (Väl Godkänd / Pass with Distinction)**. A response that does not meet the G criteria receives **U (Underkänd / Fail)** and may be resubmitted.

The essay is assessed across five domains. The overall grade is holistic — a VG requires consistent distinction-level work across most domains, not perfection in one and weakness in others. A response that is strong on description but consistently fails to evaluate consequences or make specific recommendations cannot receive VG regardless of its length or detail.

---

## Domain 1 — Findability (F)

### U (Fail)
- Does not locate the dataset's repository entry (GEO/ENA/SRA)
- Incorrectly describes the accession number or its significance
- Conflates having a DOI (for the paper) with having a persistent identifier for the data
- Makes no reference to indexing or discoverability

### G (Pass)
- Correctly identifies the data accession number cited in the paper
- Notes whether the accession is a persistent identifier (ENA/SRA/GEO accession) or merely a URL
- Notes whether the dataset can be found via a database search engine without prior knowledge of the accession
- Notes whether sample metadata is indexed in the database alongside the raw data
- Observations are accurate and relevant to the specific study

### VG (Distinction) — all G criteria plus:
- Assesses the *quality and completeness* of findability, not merely its presence: is the accession present in the methods, abstract, or only buried in supplementary material?
- Notes whether the dataset appears in secondary databases or cross-registry searches (e.g. OmicsDI, FAIRsharing) — and if not, explains why this matters
- Evaluates the persistence risk: a GEO accession is more stable than a lab website, but still dependent on NCBI infrastructure; assesses whether a secondary archive (Zenodo, Figshare) was also used
- Connects findability gaps to specific practical consequences: e.g., "A researcher querying GEO for all RNA-seq studies of X tissue in Y organism using semantic metadata search would not retrieve this dataset because..."

---

## Domain 2 — Accessibility (A)

### U (Fail)
- Does not attempt to access the data
- Equates "open access publication" with "accessible data"
- States data is accessible without verifying this

### G (Pass)
- Confirms whether raw data (FASTQ files or equivalent) can be downloaded via a standardised protocol (HTTPS, FTP)
- Distinguishes between raw and processed data accessibility
- Notes whether any data is behind controlled access and, if so, whether the access process is documented
- Acknowledges FAIR principle A2: notes whether metadata would persist if data were withdrawn

### VG (Distinction) — all G criteria plus:
- Evaluates the *mechanism* of accessibility, not just the outcome: what protocol is used, is it stable, is it documented, does it require proprietary tools?
- Where access is restricted (e.g. human subjects data), evaluates the quality of the documented access process — is the application route clear, is there a stated timeline, is there a contact?
- Notes whether processed summary files (count matrices, normalised data) are also available, and evaluates whether this is sufficient for independent reanalysis or whether raw data is essential
- Explicitly assesses A2: if the paper were retracted tomorrow, what would a reader citing this dataset find at the accession URL?

---

## Domain 3 — Interoperability (I)

### U (Fail)
- Does not address metadata vocabulary or format
- Conflates file format with interoperability
- States data is "interoperable" because it is in FASTQ format without engaging with metadata

### G (Pass)
- Notes whether data are in standard formats (FASTQ, BAM, VCF, etc.)
- Notes whether sample metadata uses ontology terms (EFO, UBERON, CHEBI, NCBI Taxonomy) or free text
- Notes whether the reference genome version is specified with a stable identifier
- Notes whether cross-references to related databases or resources are provided

### VG (Distinction) — all G criteria plus:
- Distinguishes between *format* interoperability (FASTQ is readable by any tool) and *metadata* interoperability (sample annotations are machine-readable and comparable across studies)
- Evaluates specific ontology gaps: not "no ontology terms were used" but "the tissue type was described as 'leaf tissue' rather than using UBERON:0000004 (leaf) or PO:0025034 (plant leaf), preventing automated integration with other plant transcriptomic datasets using standard metadata search"
- Evaluates cross-referencing: does the ENA/GEO entry link to the paper DOI? Does it link to related datasets from the same project? Are external tool/workflow references provided?
- Notes where the temporal context matters: for a 2014 study, many ontology annotation practices were not yet standard, and the response acknowledges this appropriately rather than applying 2025 standards anachronistically

---

## Domain 4 — Reusability (R)

This is typically the richest domain for assessment and should receive the most analytical attention.

### U (Fail)
- Does not attempt to assess whether the analysis could be reproduced
- States code is "not available" without exploring consequences
- Does not assess metadata sufficiency for reanalysis
- Fails to engage with software versioning

### G (Pass)
- Assesses whether sample metadata is sufficient to assign all samples to experimental conditions without contacting the authors
- Notes whether a data licence is provided (or absent)
- Notes which software tools are named in the methods section
- Notes whether software versions are specified for all key tools
- Notes whether analysis code is available and if so, in what form
- Notes whether any community metadata standard is declared (MINSEQE, MIxS, etc.)

### VG (Distinction) — all G criteria plus:
- Evaluates metadata *sufficiency* with specificity: for the specific analysis described, identifies the minimum metadata fields required for reproduction and assesses whether each is present. E.g., "To reproduce the differential expression analysis, one requires: sample-condition assignments, library type (stranded/unstranded), reference genome version, and DESeq2 normalisation parameters. Of these, [X] is absent, making independent reproduction impossible without author contact."
- Distinguishes between software version specification (good) and default parameter reporting (often absent and consequential): "HISAT2 v2.1.0 is specified, but the authors state 'default parameters were used' — defaults change between versions and this statement is insufficient for exact reproduction"
- Where code is available, evaluates its quality as a reproducibility tool: is it version-controlled? Does it specify dependencies? Is there a README? Could an independent researcher run it?
- Evaluates the FAIR4RS dimension: is the analysis software itself FAIR — does it have a persistent identifier, a licence, documentation?
- Makes specific, actionable recommendations: not "better metadata" but naming the specific standard, tool, or practice that would have addressed each gap

---

## Domain 5 — Synthesis, Argument Quality, and Recommendations

### U (Fail)
- No synthesis or overall evaluation
- Merely lists findings from each principle without connecting them
- No recommendations
- Essay is a checklist, not an argument

### G (Pass)
- Provides a coherent overall evaluation of FAIR compliance
- Identifies the most significant gaps across the four principles
- Makes recommendations that address the identified gaps
- Essay is written in clear academic prose, not as a bullet-point list

### VG (Distinction) — all G criteria plus:
- Synthesis prioritises and ranks: identifies which FAIR failures are most consequential for this specific study, rather than treating all gaps as equal
- Recommendations are specific, concrete, and actionable — naming ontologies, standards, tools, or archiving services, not generic exhortations to "improve metadata"
- Where the study was published before FAIR was formalised (Paper A, 2014), the synthesis explicitly engages with the evolution of standards: what was state-of-the-art at publication time, what has since changed, and what would this study look like if submitted today?
- The essay demonstrates understanding that FAIR is a spectrum and a journey, not a binary — the conclusion evaluates *where on the FAIR spectrum* this study sits and what the barriers to improvement were (awareness, tooling, journal policy, funder mandate, time constraints)
- The essay is analytical in register throughout: consequences are evaluated, mechanisms are explained, and recommendations are evidenced

---

## Length, Format, and Presentation

### U criteria
- Substantially below 1,000 words or substantially above 2,000 words
- No references
- Factual errors about the FAIR principles themselves

### G criteria
- 1,200–1,500 words (excluding references)
- References include at minimum Wilkinson et al. (2016) and cite the assessed paper
- Written in coherent academic prose — not bullet points, not a checklist
- Submitted as PDF

### VG criteria — all G criteria plus:
- Appropriate use of specific identifiers (accession numbers, ontology IDs, version numbers) as evidence throughout
- Referencing is accurate, complete, and consistently formatted
- Prose is precise and economical — says what needs to be said without padding

---

## AI Use Declaration

The assignment requires an AI use declaration. A missing declaration does not automatically fail the essay, but the marker should note it. A submission that consists primarily of AI-generated text without evidence of independent analysis will not demonstrate the evaluative judgement required for G or VG. Markers should look for evidence of specific engagement with the actual dataset (accession visited, sample metadata inspected) as a marker of genuine student work.

---

## Resubmission

A U grade may be resubmitted once. The resubmission deadline is [set in Canvas — two weeks after original deadline]. Resubmission feedback should be specific about which domains failed and what the student needs to demonstrate in the resubmission.

---

## Quick Reference Summary

| Domain | G requires | VG additionally requires |
|--------|-----------|--------------------------|
| Findability | Accession identified; persistence noted; indexing noted | Consequence of F gaps; secondary archive; temporal context |
| Accessibility | Data confirmed downloadable; protocol noted; A2 noted | Mechanism evaluated; access process quality assessed; A2 implications |
| Interoperability | Format and vocabulary noted; cross-references noted | Ontology specifics; metadata vs format distinction; temporal context |
| Reusability | Metadata sufficiency, versions, code, licence, standard all noted | Sufficiency evaluated for the specific analysis; code quality; FAIR4RS; specific recommendations |
| Synthesis | Overall verdict; significant gaps; recommendations | Prioritised; actionable; temporal framing; FAIR as spectrum |

*Prepared for the Master's Programme in Bioinformatics, Department of Plant Physiology, Umeå University. Course code: 5BI00A.*
