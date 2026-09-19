#!/usr/bin/env python3
"""Writes small dummy stand-ins for the Lecture 13 example files: same file names and formats, invented content.

The real files on Kebnekaise are large (the BAM file alone is 2.5 GB). Everything here is generated with a fixed
random seed, so the output is identical on every build. Usage: make_dummy_data.py OUTPUT_DIR
"""
import gzip
import os
import random
import subprocess
import sys

out = sys.argv[1]
os.makedirs(out, exist_ok=True)
R = random.Random(13)
SAMTOOLS = "/opt/tools/samtools/bin/samtools"
NCHR = 19
CHROMS = ["chr%d" % i for i in range(1, NCHR + 1)]
LENGTH = {c: R.randint(20_000_000, 45_000_000) for c in CHROMS}


def dna(n):
    return "".join(R.choice("ACGT") for _ in range(n))


def path(name):
    return os.path.join(out, name)


# ---- gene models: chr1 has 120 genes (the lecture queries chr1:1000000-2000000), the others fewer ----
genes = []  # dicts: chrom, id, start, end, strand, transcripts=[(id, [(exon_start, exon_end), ...])]
for c in CHROMS:
    pos = 8865 if c == "chr1" else R.randint(5000, 20000)
    for i in range(1, (120 if c == "chr1" else R.randint(15, 30)) + 1):
        length = 2395 if (c == "chr1" and i == 1) else R.randint(1500, 9000)
        gid = "Potra2n%sc%d" % (c[3:], i)
        transcripts = []
        for t in range(1, R.randint(1, 3) + 1):
            n = R.randint(1, 8)
            step = length // n
            exons = []
            for k in range(n):
                s = pos + k * step
                exons.append((s, s + max(50, int(step * R.uniform(0.3, 0.7)))))
            transcripts.append(("%s.%d" % (gid, t), exons))
        genes.append(dict(chrom=c, id=gid, start=pos, end=pos + length - 1, strand=R.choice("+-"), transcripts=transcripts))
        pos += length + R.randint(2000, 20000)


def write_gff(name, subset, source, gtf=False):
    with open(path(name), "w") as f:
        if not gtf:
            f.write("##gff-version 3\n")
            for c in CHROMS:
                f.write("##sequence-region %s 1 %d\n" % (c, LENGTH[c]))
        else:
            f.write("#!genome-build dummy\n")
        for g in subset:
            head = [g["chrom"], source]
            if gtf:
                f.write("\t".join(head + ["gene", str(g["start"]), str(g["end"]), ".", g["strand"], ".", 'gene_id "%s";' % g["id"]]) + "\n")
            else:
                f.write("\t".join(head + ["gene", str(g["start"]), str(g["end"]), ".", g["strand"], ".", "ID=%s;Name=%s" % (g["id"], g["id"])]) + "\n")
            for tid, exons in g["transcripts"]:
                ts, te = exons[0][0], exons[-1][1]
                if gtf:
                    f.write("\t".join(head + ["transcript", str(ts), str(te), ".", g["strand"], ".", 'gene_id "%s"; transcript_id "%s";' % (g["id"], tid)]) + "\n")
                else:
                    f.write("\t".join(head + ["mRNA", str(ts), str(te), ".", g["strand"], ".", "ID=%s;Parent=%s" % (tid, g["id"])]) + "\n")
                for k, (es, ee) in enumerate(exons, 1):
                    if gtf:
                        f.write("\t".join(head + ["exon", str(es), str(ee), ".", g["strand"], ".", 'gene_id "%s"; transcript_id "%s"; exon_number "%d";' % (g["id"], tid, k)]) + "\n")
                        f.write("\t".join(head + ["CDS", str(es), str(ee), ".", g["strand"], str(k % 3), 'gene_id "%s"; transcript_id "%s";' % (g["id"], tid)]) + "\n")
                    else:
                        f.write("\t".join(head + ["exon", str(es), str(ee), ".", g["strand"], ".", "ID=%s.exon.%d;Parent=%s" % (tid, k, tid)]) + "\n")
                        f.write("\t".join(head + ["CDS", str(es), str(ee), ".", g["strand"], str(k % 3), "ID=%s.cds.%d;Parent=%s" % (tid, k, tid)]) + "\n")


write_gff("annotation.gff", genes, "dummy")
write_gff("annotation2.gff", genes[::3], "dummy2")
write_gff("annotation.gtf", genes, "dummy", gtf=True)

# ---- BED: regions.bed is unsorted on purpose (the lecture sorts it) ----
regions = []
for i in range(1000):
    c = R.choice(CHROMS)
    s = R.randint(1, 5_000_000)
    regions.append((c, s, s + R.randint(100, 3000), "region%04d" % i, R.randint(0, 1000), R.choice("+-")))
with open(path("regions.bed"), "w") as f:
    for r in regions:
        f.write("%s\t%d\t%d\t%s\t%d\t%s\n" % r)
with open(path("regions_b.bed"), "w") as f:
    for i, r in enumerate(R.sample(regions, 60)):
        shift = R.randint(-500, 500)
        f.write("%s\t%d\t%d\tb%03d\t%d\t%s\n" % (r[0], max(1, r[1] + shift), r[2] + shift, i, R.randint(0, 1000), r[5]))
    for i in range(60, 100):
        c = R.choice(CHROMS); s = R.randint(1, 5_000_000)
        f.write("%s\t%d\t%d\tb%03d\t%d\t%s\n" % (c, s, s + R.randint(100, 3000), i, R.randint(0, 1000), R.choice("+-")))

# ---- FASTA: 30 sequences, wrapped at 60, a few soft-masked stretches ----
with open(path("sequences.fasta"), "w") as f:
    for i in range(1, 31):
        g = genes[i - 1]
        n = R.randint(400, 2500)
        s = dna(n)
        if i % 5 == 0:
            a = R.randint(0, n - 120)
            s = s[:a] + s[a:a + 100].lower() + s[a + 100:]
        f.write(">%s.1 gene=%s length=%d dummy sequence\n" % (g["id"], g["id"], n))
        for k in range(0, n, 60):
            f.write(s[k:k + 60] + "\n")

# ---- FASTQ: Phred+33, 100 bp reads ----
def fastq(n, tag):
    lines = []
    for i in range(1, n + 1):
        q = "".join(chr(min(74, max(35, int(R.gauss(66, 8))))) for _ in range(100))
        lines += ["@SIM:1:%s:1:1101:%d:%d 1:N:0:ATCACG" % (tag, R.randint(1000, 30000), i), dna(100), "+", q]
    return "\n".join(lines) + "\n"


with open(path("reads.fastq"), "w") as f:
    f.write(fastq(1000, "FCA"))
with gzip.open(path("reads.fastq.gz"), "wt") as f:
    f.write(fastq(400, "FCB"))

# ---- SAM and BAM: unsorted; reads sit mostly in genes; a mix of FLAG values and CIGAR strings ----
header = ["@HD\tVN:1.6\tSO:unsorted"] + ["@SQ\tSN:%s\tLN:%d" % (c, LENGTH[c]) for c in CHROMS] + ["@PG\tID:dummy\tPN:make_dummy_data.py"]
reads = []


def place():
    g = R.choice(genes[:150]) if R.random() < 0.6 else R.choice(genes)
    return g["chrom"], R.randint(g["start"], max(g["start"], g["end"] - 300))


for i in range(3000):  # 3000 proper pairs
    c, p = place(); p2 = p + R.randint(150, 300)
    f1, f2 = (99, 147) if R.random() < 0.5 else (83, 163)
    name = "pair%05d" % i; mq = R.choice([60, 60, 60, 42, 20, 0])
    reads.append((name, f1, c, p, mq, "100M", "=", p2, p2 - p + 100))
    reads.append((name, f2, c, p2, mq, R.choice(["100M", "100M", "5S95M", "60M1I39M"]), "=", p, -(p2 - p + 100)))
for i in range(2000):  # single-end reads, some spliced or with a deletion, some duplicates or secondary
    c, p = place()
    cig = R.choice(["100M"] * 6 + ["40M500N60M", "50M2D50M", "90M10S"])
    flag = R.choice([0, 16]) | (1024 if R.random() < 0.03 else 0) | (256 if R.random() < 0.02 else 0)
    reads.append(("single%05d" % i, flag, c, p, R.choice([60, 60, 60, 30, 0]), cig, "*", 0, 0))
for i in range(100):
    reads.append(("unmapped%03d" % i, 4, "*", 0, 0, "*", "*", 0, 0))
R.shuffle(reads)
sam = list(header)
for name, flag, c, p, mq, cig, rn, pn, tl in reads:
    sam.append("\t".join([name, str(flag), c, str(p), str(mq), cig, rn, str(pn), str(tl), dna(100),
                          "".join(chr(min(74, max(35, int(R.gauss(66, 8))))) for _ in range(100)), "NM:i:%d" % R.choice([0, 0, 0, 1, 2])]))
with open(path("alignment_downsampled.sam"), "w") as f:
    f.write("\n".join(header + sam[len(header):len(header) + 1500]) + "\n")
full = path("_alignment_full.sam")
with open(full, "w") as f:
    f.write("\n".join(sam) + "\n")
subprocess.run([SAMTOOLS, "view", "-b", "-o", path("alignment.bam"), full], check=True)
os.remove(full)

# ---- VCF: SNPs and indels, mostly inside genes, three samples ----
vh = ["##fileformat=VCFv4.2", "##source=make_dummy_data.py", '##FILTER=<ID=PASS,Description="All filters passed">', '##FILTER=<ID=LowQual,Description="Low quality">']
vh += ["##contig=<ID=%s,length=%d>" % (c, LENGTH[c]) for c in CHROMS]
vh += ['##INFO=<ID=DP,Number=1,Type=Integer,Description="Total depth">', '##INFO=<ID=AF,Number=A,Type=Float,Description="Allele frequency">',
       '##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">', '##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Sample depth">',
       '##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype quality">', "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tsample1\tsample2\tsample3"]
recs = []
for i in range(3000):
    c, p = place() if i >= 3 else ("chr1", R.randint(8865, 11259))
    ref = R.choice("ACGT")
    kind = R.random()
    if kind < 0.8:
        alt = R.choice([b for b in "ACGT" if b != ref]); rr = ref
    elif kind < 0.9:
        rr = ref; alt = ref + dna(R.randint(1, 3))
    else:
        rr = ref + dna(R.randint(1, 3)); alt = ref
    lowq = R.random() < 0.2
    dp = R.randint(5, 80)
    smp = "\t".join("%s:%d:%d" % (R.choice(["0/0", "0/1", "1/1"]), R.randint(3, 40), R.randint(10, 99)) for _ in range(3))
    recs.append((CHROMS.index(c), p, "%s\t%d\t.\t%s\t%s\t%.1f\t%s\tDP=%d;AF=%.2f\tGT:DP:GQ\t%s" % (c, p, rr, alt, R.uniform(3, 60) if lowq else R.uniform(30, 99), "LowQual" if lowq else "PASS", dp, R.uniform(0.05, 1), smp)))
recs.sort()
with open(path("variants.vcf"), "w") as f:
    f.write("\n".join(vh) + "\n" + "\n".join(r[2] for r in recs) + "\n")

with open(path("README-DUMMY-DATA.txt"), "w") as f:
    f.write("These files are small dummy stand-ins for the Lecture 13 example files on Kebnekaise.\n"
            "They have the same names and formats, but the content is invented and generated at build time, so numbers\n"
            "(read counts, gene counts, variant counts) differ from the real files. The real files are large (up to 2.5 GB)\n"
            "and stay on Kebnekaise: /proj/nobackup/cddb_course/Bioinformatics_File_Formats/example_formats\n")
print("wrote", len(os.listdir(out)), "files to", out)
