# Exercises: BLAST and Sequence Similarity (Lecture 12)

Exercises accompany [Lecture 12](../../docs/12.blast/blast.md).

| File | Description |
|------|-------------|
| [blast_tp53.sh](blast_tp53.sh) | Slurm job script for local blastp |

## Quick start

```bash
cd ~/course && mkdir -p lecture12-blast && cd lecture12-blast
cp ../lecture11-databases/TP53_protein.fasta .
git init && git add . && git commit -m "initial: lecture12 blast, TP53 from lecture11"
sbatch blast_tp53.sh   # update account name first
```

Full commands in the [lecture handout](../../docs/12.blast/blast.md).
