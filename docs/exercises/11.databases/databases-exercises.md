# Exercises: The Biological Database Landscape (Lecture 11)

Exercises accompany [Lecture 11](../../11.database-landscape/database-landscape.md).

## Quick start

```bash
mkdir -p ~/course/lecture11-databases && cd ~/course/lecture11-databases

# git is not installed on every Kebnekaise node image - load it explicitly
# rather than relying on it already being on PATH
module load GCCcore/14.3.0 git/2.50.1 cURL/8.14.1
git init
# Fetch TP53 protein from UniProt
curl "https://rest.uniprot.org/uniprotkb/P04637.fasta" > TP53_protein.fasta
git add . && git commit -m "lecture11: TP53 sequence retrieved from UniProt"
```

Full commands in the [lecture handout](../../11.database-landscape/database-landscape.md).
