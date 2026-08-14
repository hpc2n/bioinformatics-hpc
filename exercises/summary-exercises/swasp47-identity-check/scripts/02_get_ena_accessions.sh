#!/bin/bash
# =============================================================================
# 02 - Find public RNA-seq run accessions + FASTQ URLs from ENA
# -----------------------------------------------------------------------------
# Real teaching example (see ../README.md). Public sequence archives (ENA /
# NCBI SRA) let you retrieve the raw reads for a published study by its
# project accession. The ENA "portal" API returns a simple TSV linking each
# run (ERRxxxxxxx) to its FASTQ download URLs and to descriptive fields, so
# you can pick the exact samples you need. This is the same ENA portal API
# pattern used in Lecture 11 (Biological Database Landscape).
#
# Concepts: BioProject/study vs run accessions; the ENA filereport API;
#           `fastq_ftp` (ENA-hosted, renamed) vs `submitted_ftp` (original
#           filenames, which often preserve the lab's sample labels).
#
# This script needs no private inputs — it only talks to the public ENA API,
# so you can run it as-is, on Kebnekaise or your own machine. Verified
# reachable from both the Kebnekaise login node and a compute node
# (2026-08-13).
#
# Usage:  bash 02_get_ena_accessions.sh PRJEB73507 > runs.tsv
#         then grep for the samples you want, e.g.  grep 'Buds_.*_47_' runs.tsv
# =============================================================================
set -euo pipefail
STUDY="${1:?give an ENA study/project accession, e.g. PRJEB73507}"

curl -s "https://www.ebi.ac.uk/ena/portal/api/filereport\
?accession=${STUDY}\
&result=read_run\
&fields=run_accession,sample_alias,library_name,fastq_ftp,submitted_ftp,fastq_bytes\
&format=tsv&limit=0"

# Example: for study PRJEB73507 (the SwAsp identity-check study, see
# ../README.md) the sample_alias is self-documenting (e.g. "Buds_GH_47_T1"),
# so the four SwAsp47 bud samples used in the case study are:
#   X61  = ERR13726589  (Buds_GH_47    = tissue culture)
#   X130 = ERR13726389  (Buds_GH_47    = tissue culture)
#   X268 = ERR13726525  (Buds_Savar_47 = field)
#   X282 = ERR13726538  (Buds_Savar_47 = field)
# and the R1 FASTQ URL is column `fastq_ftp` (first of the ';'-separated pair),
# prefixed with https://
