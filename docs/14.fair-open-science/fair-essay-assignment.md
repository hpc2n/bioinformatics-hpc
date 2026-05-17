# Assessment: FAIR Compliance Essay
## Computing for Data-Driven Biology (5BI00A)
### Master's Programme in Bioinformatics — Umeå University

---

## Overview

This assignment asks you to critically evaluate the FAIR compliance of a published bioinformatics study and its associated dataset. You will assess the study against the four FAIR principles (Findable, Accessible, Interoperable, Reusable), evaluate the reproducibility of its computational analysis, and make specific, evidenced recommendations for how FAIR compliance could have been improved.

---

## The Paper Shortlist

Choose **one** of the following three papers to assess. Each covers a different biological domain, and the choice is yours — select the paper whose biological topic interests you most.

**Paper A — Human/Clinical**
Himes B.E. et al. (2014). RNA-Seq Transcriptome Profiling Identifies CRISPLD2 as a Glucocorticoid Responsive Gene that Modulates Cytokine Function in Airway Smooth Muscle Cells. *PLoS One* 9(6): e99625.
DOI: 10.1371/journal.pone.0099625 · GEO accession: GSE52778

**Paper B — Plant/Conifer**
Trujillo-Moya C. et al. (2020). RNA-Seq and secondary metabolite analyses reveal a putative defence-transcriptome in Norway spruce (*Picea abies*) against needle bladder rust infection. *BMC Genomics* 21: 336.
DOI: 10.1186/s12864-020-6587-z

**Paper C — Microbial/Environmental**
Azarbad H. et al. (2022). Relative and Quantitative Rhizosphere Microbiome Profiling Results in Distinct Abundance Patterns. *Frontiers in Microbiology* 12: 798023.
DOI: 10.3389/fmicb.2021.798023

All three papers are open access. You can read them and access their associated datasets freely.

---

## What You Are Being Asked to Do

Write a structured analytical essay of **1,200–1,500 words** that:

1. **Assesses each of the four FAIR principles** against concrete, specific evidence drawn from the paper and its associated dataset. You should access the paper's data repository (GEO, ENA, or SRA) directly as part of your assessment.

2. **Evaluates whether the metadata is sufficient for reuse** — specifically, whether you would have enough information to reproduce a differential expression (or equivalent) analysis from the deposited data alone, without contacting the authors.

3. **Assesses the reproducibility of the computational analysis** — are software versions specified? Are analysis parameters documented? Is code available, and if so, is it versioned and documented?

4. **Makes specific, concrete, evidenced recommendations** for what could have been done differently to improve FAIR compliance. These should be actionable and specific — not "better metadata" but "the GEO submission should have included EFO ontology terms for tissue type and treatment, specifically UBERON:0002368 for adrenal medulla and CHEBI:41879 for dexamethasone."

---

## Structure

Your essay does not need section headings, but the following logical structure is expected:

- Brief contextual introduction to the study and its biological question (2–3 sentences only — this is not a paper summary)
- Assessment of Findability
- Assessment of Accessibility
- Assessment of Interoperability
- Assessment of Reusability (including reproducibility of the computational analysis)
- Synthesis: an overall judgement of FAIR compliance, identifying the most significant gaps and their practical consequences
- Specific recommendations

---

## What Distinguishes G and VG Responses

**G (Pass)** — Correctly identifies and describes FAIR issues across all four principles. Applies the principles accurately to the specific study. Notes data deposition, metadata availability, and code availability. Observations are accurate and relevant.

**VG (Distinction)** — Does all of the above, and additionally:
- Evaluates the *consequences* of each FAIR issue — not merely that metadata is missing, but what a researcher would be unable to do as a result
- Demonstrates understanding that FAIR is a spectrum, not a binary — assessing the *quality* and *completeness* of compliance, not merely whether a box is ticked
- Makes recommendations that are specific, concrete, and actionable — naming the ontology, the standard, the tool, or the practice that should have been used
- Where the paper was published before the FAIR principles were formalised (Paper A, 2014), engages explicitly with how standards have evolved and what this means for the permanent scientific record
- Is written as a coherent analytical argument, not a checklist

---

## Practical Steps Before You Write

1. **Read the paper** — the methods section in particular. Note every piece of information about data generation, processing, analysis tools, software versions, and data availability.

2. **Access the data repository** — go to the GEO, ENA, or SRA accession linked in the paper. Inspect the sample metadata. Try to download or preview the raw data. Note what is and is not present.

3. **Use the FAIR assessment checklist** from the Lecture 14 handout as a guide — work through it systematically for your chosen paper. Your notes from this process form the evidence base for your essay.

4. **Do not attempt to re-run the analysis** — this is not required. The assessment is of the FAIRness of the study as published, not of the biological results.

---

## Submission

- **Word count:** 1,200–1,500 words (excluding references)
- **Format:** PDF
- **References:** Cite the FAIR paper (Wilkinson et al. 2016) and any other sources used. No specific referencing style is required — be consistent.
- **Deadline:** [Set in Canvas]
- **Submission method:** Upload to this Canvas assignment

---

## Academic Integrity

You may use AI writing tools to help structure your thinking or check grammar, but the assessment and analysis must be your own. If you use AI tools, declare this at the end of your submission in a brief statement (one sentence is sufficient). A submission that consists primarily of AI-generated text will not demonstrate the analytical engagement that distinguishes G and VG responses.

---

*This assignment assesses ILOs 3 and 13 of the course. Marking is carried out by the course leader against the criteria above.*
