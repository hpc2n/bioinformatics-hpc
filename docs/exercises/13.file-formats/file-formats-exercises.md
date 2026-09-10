# Exercises: Bioinformatics File Formats (Lecture 13)

Exercises accompany [Lecture 13](../../13.file-formats/file-formats.md).

Exercise data at: `/proj/nobackup/bioinformatics_course/data/formats/`

## Quick start
```bash
mkdir -p ~/course/lecture13-formats && cd ~/course/lecture13-formats

# git is not installed on every Kebnekaise node image - load it explicitly
# rather than relying on it already being on PATH
module load GCCcore/14.3.0 git/2.50.1 cURL/8.14.1
git init
cp /proj/nobackup/bioinformatics_course/data/formats/* .
module load SAMtools/1.22
samtools flagstat sample.bam
grep -v "^#" sample.vcf | wc -l
awk '!/^#/{print $3}' sample.gtf | sort | uniq -c | sort -rn
```
Full commands in the [lecture handout](../../13.file-formats/file-formats.md).
