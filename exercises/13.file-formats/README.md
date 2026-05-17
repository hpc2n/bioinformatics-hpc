# Exercises: Bioinformatics File Formats (Lecture 13)

Exercises accompany [Lecture 13](../../docs/13.file-formats/index.md).

Exercise data at: `/proj/nobackup/bioinformatics_course/data/formats/`

## Quick start
```bash
cd ~/course && mkdir -p lecture13-formats && cd lecture13-formats
git init
cp /proj/nobackup/bioinformatics_course/data/formats/* .
module load SAMtools/1.22
samtools flagstat sample.bam
grep -v "^#" sample.vcf | wc -l
awk '!/^#/{print $3}' sample.gtf | sort | uniq -c | sort -rn
```
Full commands in the [lecture handout](../../docs/13.file-formats/index.md).
