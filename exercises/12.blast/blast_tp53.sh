#!/bin/bash
#SBATCH --job-name=blast_tp53
#SBATCH --account=YOUR_PROJECT_ACCOUNT
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --output=blast_tp53_%j.out
#SBATCH --error=blast_tp53_%j.err
# Lecture 12: BLAST — local blastp on Kebnekaise
# Update YOUR_PROJECT_ACCOUNT and module version before submitting
module load blast+/VERSION
blastp \
  -query TP53_protein.fasta \
  -db /proj/nobackup/bioinformatics_course/databases/swissprot/swissprot \
  -out TP53_blastp_local.txt \
  -outfmt 6 -evalue 1e-5 -num_threads 4 -max_target_seqs 50
echo "BLAST complete: $(date)"
sort -k11 -n TP53_blastp_local.txt | head -10
