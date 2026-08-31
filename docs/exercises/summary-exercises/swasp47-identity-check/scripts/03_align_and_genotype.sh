#!/bin/bash
#SBATCH --job-name=swasp47_idcheck
#SBATCH --account=hpc2ncourses2026-013
#SBATCH --time=00:20:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --output=swasp47_idcheck_%j.out
#SBATCH --error=swasp47_idcheck_%j.err
# =============================================================================
# 03 - Genotype diagnostic sites from RNA-seq, disk-safely, via containers
# -----------------------------------------------------------------------------
# Real teaching example (see ../README.md for the full case study and what it
# demonstrates). For each sample we stream R1 straight from ENA into the
# aligner, keep only the reads on our gene, and count reference vs alternate
# reads at the diagnostic positions. If a sample shows the reference allele at
# the diagnostic sites it is the genuine genotype; if it shows the clone/alt
# allele it is a different source (a sample swap).
#
# Concepts illustrated:
#   - reproducible tools via containers (apptainer) instead of a fragile
#     module/conda environment — apptainer is a system binary on Kebnekaise
#     (/usr/bin/apptainer, v1.3.5), no module load needed (verified 2026-08-13)
#   - STREAMING: `curl | zcat | minimap2 ...` so the multi-GB FASTQ is never
#     written to disk. On shared HPC storage this is the difference between a
#     harmless job and one that fills a filesystem for everyone.
#   - work on node-local scratch ($SNIC_TMP, see Lecture "Batch system/Slurm"),
#     not the shared /proj/nobackup filesystem — this job requested no local
#     disk constraint explicitly; on Kebnekaise $SNIC_TMP is provisioned per
#     job automatically (verified 2026-08-13: job resolved $SNIC_TMP=/scratch,
#     13 GB, wiped when the job ends)
#   - MAPQ filtering to drop multi-mapping/paralogous reads
#   - restricting to the gene of interest, then `samtools mpileup`
#   - reading a pileup: '.'/',' mean "matches the reference base"
#   - single-end R1 is plenty of depth to genotype an expressed gene
#
# Inputs you edit:
#   REF        a FASTA the reads align to (here the gene's transcript(s)) —
#              NOT bundled in this repo (unpublished research input); ask
#              Nathaniel for the staged path on /proj/nobackup/cddb_course
#              before running this for real. Until it is staged, read through
#              the script to understand the method.
#   RUNS       "label:ERRaccession:enaSubdir" per sample
#   POS        diagnostic positions IN TRANSCRIPT COORDINATES (genomic - start + 1)
#   REFNAME    the reference sequence name to keep (the transcript id)
#
# Output is copied back to $SLURM_SUBMIT_DIR before the node-local scratch is
# wiped at job end — everything under $SNIC_TMP disappears once the job exits.
# =============================================================================
set -u
W=$SNIC_TMP
mkdir -p "$W/cache" "$W/tmp" "$W/work" "$W/results"
export APPTAINER_CACHEDIR=$W/cache APPTAINER_TMPDIR=$W/tmp
cd "$W/work"

# --- tools: pull once into self-contained .sif images -----------------------
[ -f samtools.sif ] || apptainer pull -F samtools.sif docker://staphb/samtools:latest >/dev/null 2>&1
[ -f minimap2.sif ] || apptainer pull -F minimap2.sif docker://staphb/minimap2:latest >/dev/null 2>&1
rm -rf "$W/cache"/* 2>/dev/null           # the .sif files are standalone; drop the pull cache
BIND="--bind $W"
SAM="apptainer exec $BIND $W/work/samtools.sif samtools"
MM2="apptainer exec $BIND $W/work/minimap2.sif minimap2"

# --- reference the reads align to (put your gene transcript FASTA here) ------
REF=$W/work/reference.fa
# cp /proj/nobackup/cddb_course/databases/swasp47_reference/Potra2n4c9093_transcript.fa $REF
$SAM faidx "$REF"
REFNAME="Potra2n4c9093.1"                 # the transcript to genotype

# diagnostic positions in TRANSCRIPT coordinates (= genomic pos - transcript_start + 1)
POS="275 295 736 760 769 780 784 1130 1134 1151"

# label:ERR:enaSubdir  (enaSubdir is the 3-digit dir in the ENA path — see
# script 02 for how these accessions were found from PRJEB73507)
RUNS="X61_TC:ERR13726589:089 X130_TC:ERR13726389:089 X268_field:ERR13726525:025 X282_field:ERR13726538:038"

for entry in $RUNS; do
  name=${entry%%:*}; err=$(echo "$entry" | cut -d: -f2); sd=$(echo "$entry" | cut -d: -f3)
  url="https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR137/$sd/$err/${err}_1.fastq.gz"

  # simple disk guard on node-local scratch (we only use ~200 MB, but be safe)
  avail=$(df -BG "$W" | awk 'NR==2{gsub("G","",$4); print $4}')
  echo "== $name ($err)  local_free=${avail}G =="
  [ "$avail" -lt 5 ] && { echo "ABORT: low local disk"; break; }

  # STREAM: download R1 -> decompress -> align -> keep only our gene -> sort.
  # Nothing but the tiny final BAM ever touches disk.
  curl -sL "$url" | zcat 2>/dev/null \
    | $MM2 -ax sr -t 4 "$REF" - 2>"$name.mm2.log" \
    | $SAM view -h -q 20 - 2>/dev/null \
    | awk -v r="$REFNAME" 'substr($0,1,1)=="@" || $3==r' \
    | $SAM sort -T "$W/tmp/s_$name" -o "$name.bam" - 2>"$name.sort.log"
  $SAM index "$name.bam"

  # pileup and count reference-matching reads ('.'/',') at each diagnostic site
  $SAM mpileup -f "$REF" -r "$REFNAME" "$name.bam" 2>/dev/null > "$W/results/$name.pileup"
  echo "   reads on $REFNAME: $($SAM view -c "$name.bam")"
  awk -v want="$POS" 'BEGIN{n=split(want,a," "); for(i=1;i<=n;i++)W[a[i]]=1}
    $2 in W { bases=$5; depth=$4; ref=gsub(/[.,]/,"",bases);
      printf "   site %-5s depth=%-4s ref=%-4s (%.0f%% reference allele)\n",
             $2, depth, ref, (depth>0?100*ref/depth:0) }' "$W/results/$name.pileup"

  rm -f "$name.bam" "$name.bam.bai"       # keep only the small pileup
done

# copy results back before $SNIC_TMP is wiped at job end
cp -rp "$W/results" "$SLURM_SUBMIT_DIR/swasp47_results_${SLURM_JOB_ID}"
echo "Results copied to $SLURM_SUBMIT_DIR/swasp47_results_${SLURM_JOB_ID}"
