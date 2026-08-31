#!/usr/bin/env python3
# =============================================================================
# 01 - Define "diagnostic SNPs" that distinguish two candidate alleles
# -----------------------------------------------------------------------------
# Real teaching example (see ../README.md for the full case study). Goal:
# given a coding sequence of interest (here, a cloned/synthetic gene) and a
# reference genome, find the positions where the sequence differs from the
# reference. Those positions are the sites we will later genotype in
# independent sequencing (RNA-seq) to test which allele a sample really
# carries — i.e. a sample-identity check.
#
# Concepts illustrated:
#   - pairwise spliced alignment of a CDS to a genome (minimap2 via the `mappy`
#     Python binding)
#   - reading an alignment's `cs` string to extract substitutions and their
#     genomic positions and alleles
#   - 1-based vs 0-based coordinates, and window offsets
#   - (optional) cross-checking which differences are known segregating SNPs in
#     a genotype panel, so the diagnostic sites are actually informative
#
# Inputs (edit the paths):
#   CLONE_CDS   a FASTA (or plain text) of the coding sequence of interest
#   GENOME_FA   the reference genome FASTA (gzipped ok); we use one chromosome
#   (optional) a genotype panel to flag which sites are polymorphic
#
# Output: a TSV of chr, pos (1-based), reference allele, alternate/clone allele.
#
# On Kebnekaise: module load GCC/13.3.0 Python/3.12.3, then
#   python3 -m venv venv && source venv/bin/activate && pip install mappy
# (verified working on the login node 2026-08-13 — mappy 2.31 installs and
# imports cleanly with that module pair).
#
# NOTE — this script needs the genome FASTA and the clone CDS, which are not
# bundled in this repo (they are unpublished research inputs). You can still
# read through this script to understand the method: the pre-computed output,
# diagnostic_SNPs.example.tsv, is provided so you can go straight to script 03
# without running this one. See ../README.md for what to do if you want to run
# the full pipeline yourself.
# =============================================================================
import gzip, re, sys

CLONE_CDS = "cloned_cds.txt"                 # your CDS of interest
GENOME_FA = "Potra02_genome.fasta.gz"        # reference genome
CHROM     = "chr4"                           # chromosome the gene is on
WINDOW    = (6_100_000, 6_200_000)           # a window around the locus (bp, 1-based)

import mappy

def read_fasta_one(path, want):
    """Return the sequence of record `want` from a (optionally gzipped) FASTA."""
    op = gzip.open if path.endswith(".gz") else open
    name, buf = None, []
    with op(path, "rt") as fh:
        for line in fh:
            if line.startswith(">"):
                if name == want:
                    return "".join(buf)
                name, buf = line[1:].split()[0], []
            else:
                buf.append(line.strip())
    return "".join(buf) if name == want else None

clone = "".join(open(CLONE_CDS).read().split()).upper()
chrom = read_fasta_one(GENOME_FA, CHROM).upper()

# Align the CDS to the genome window. preset="splice" allows introns; a
# single-exon gene simply aligns as one block.
a = WINDOW[0]
aligner = mappy.Aligner(seq=chrom[a:WINDOW[1]], preset="splice")
hit = sorted(aligner.map(clone, cs=True), key=lambda h: -h.mlen)[0]
print(f"# aligned CDS to {CHROM}:{a+hit.r_st+1}-{a+hit.r_en} "
      f"identity={hit.mlen/hit.blen*100:.1f}% cigar={hit.cigar_str}", file=sys.stderr)

# Walk the cs string. Tokens: :N = N matches, *xy = substitution ref x -> query y,
# +seq = insertion in query, -seq = deletion from reference. We collect only
# substitutions (single-base allele differences) here.
rpos = hit.r_st                      # 0-based offset within the window
subs = []
for tok in re.findall(r':\d+|\*[a-z]{2}|\+[a-z]+|-[a-z]+', hit.cs):
    if tok[0] == ':':
        rpos += int(tok[1:])
    elif tok[0] == '*':
        genomic = a + rpos + 1       # convert to 1-based genomic coordinate
        subs.append((genomic, tok[1].upper(), tok[2].upper()))  # pos, ref, clone
        rpos += 1
    elif tok[0] == '-':              # reference has extra base(s) -> advance ref
        rpos += len(tok) - 1
    # '+' (query insertion) does not advance the reference

print("chrom\tpos\tref_allele\tclone_allele")
for pos, ref, alt in subs:
    print(f"{CHROM}\t{pos}\t{ref}\t{alt}")
print(f"# {len(subs)} substitution sites written", file=sys.stderr)
