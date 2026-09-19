#!/bin/bash
# Offline smoke test of the practice image. Run inside the container in an interactive bash, for example:
#   docker run --rm -v "$PWD/tests:/tests:ro" exam-practice bash -ic '/tests/smoke.sh'
# Exit status 0 means every check passed.
pass=0; fail=0
check() { # check "description" command...
    local d="$1"; shift
    if "$@" >/dev/null 2>&1; then echo "  ok    $d"; pass=$((pass+1)); else echo "  FAIL  $d"; fail=$((fail+1)); fi
}
eq() { [ "$1" = "$2" ]; }
DB=/proj/nobackup/cddb_course/databases/swissprot/swissprot
FF=/proj/nobackup/cddb_course/Bioinformatics_File_Formats/example_formats

echo "Modules"
check "BLAST+ alone is refused"                 bash -c '! module load BLAST+/2.17.0'
check "SAMtools alone is refused"               bash -c '! module load SAMtools/1.22'
check "BEDTools accepts GCC/13.3.0"             bash -c 'module load GCC/13.3.0 BEDTools/2.31.1'
check "samtools not on PATH before its module"  bash -c '! command -v samtools'
module load GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0 SAMtools/1.22
module load GCC/13.2.0 BCFtools/1.19
module load GCC/14.3.0 BEDTools/2.31.1
check "blastp is 2.17.0"                        bash -c 'blastp -version | grep -q "2.17.0"'
check "samtools is exactly 1.22"                bash -c 'samtools --version | head -1 | grep -qx "samtools 1.22"'
check "bcftools is exactly 1.19"                bash -c 'bcftools --version | head -1 | grep -qx "bcftools 1.19"'
check "bedtools is v2.31.1"                     bash -c 'bedtools --version | grep -q "v2.31.1"'
check "module spider shows the prerequisites"   bash -c 'module spider SAMtools/1.22 | grep -q "GCC/14.2.0"'
check "module -r spider matches a regex"       bash -c 'module -r spider "^GCC/14" | grep -q "GCC/14.3.0"'
check "ml purge unloads everything"             bash -c 'ml GCC/14.2.0; ml purge; ml | grep -q "No modules loaded"'

echo "Other tools"
check "python3 runs"                            python3 -c "import json; json.dumps({'ok': 1})"
check "man git-commit works"                    bash -c 'man git-commit | head -3 | grep -q "GIT-COMMIT"'
check "srun starts one process per task"        bash -c '[ "$(srun -n 3 hostname | wc -l)" = 3 ]'
check "gawk is the awk"                         bash -c 'awk --version | grep -q "GNU Awk"'
check "exam-practice-setup is installed"        bash -c 'command -v exam-practice-setup'
check "exam-practice-check is installed"        bash -c 'command -v exam-practice-check'
check "the prompt starts with [practice container]" bash -c 'PROMPT_COMMAND=$(grep -h "^PROMPT_COMMAND" /etc/bash.bashrc | tail -1 | cut -d= -f2- | tr -d "\047"); eval "$PROMPT_COMMAND"; case "$PS1" in "[practice container]"*) true;; *) false;; esac'
check "the banner names the two commands"       bash -c 'grep -q "exam-practice-setup" /etc/bash.bashrc'
check "exercises are seeded"                    test -f "$HOME/exercises/06.linux-intro/patterns/myfile1.txt"

echo "File-format example data (dummy files)"
for f in alignment.bam alignment_downsampled.sam annotation.gff annotation.gtf annotation2.gff reads.fastq reads.fastq.gz regions.bed regions_b.bed sequences.fasta variants.vcf; do
    check "$f exists and is not empty" test -s "$FF/$f"
done
check "FASTQ file has 4 lines per read"         bash -c '[ $(( $(wc -l < '"$FF"'/reads.fastq) % 4 )) = 0 ]'
check "BAM has 19 reference sequences"          bash -c '[ "$(samtools view -H '"$FF"'/alignment.bam | grep -c "^@SQ")" = 19 ]'
check "BAM has mapped reads"                    bash -c '[ "$(samtools view -c -F 4 '"$FF"'/alignment.bam)" -gt 0 ]'
check "bcftools reads the VCF"                  bash -c 'bcftools stats '"$FF"'/variants.vcf | grep -q "^SN"'
check "bedtools intersects the BED files"       bash -c '[ "$(bedtools intersect -a '"$FF"'/regions.bed -b '"$FF"'/regions_b.bed | wc -l)" -gt 0 ]'
check "GFF has genes"                           bash -c '[ "$(awk "!/^#/ && \$3==\"gene\"" '"$FF"'/annotation.gff | wc -l)" -gt 0 ]'

echo "Slurm job (offline, the Lecture 15 job script pattern)"
W=$(mktemp -d); cd "$W"
blastdbcmd -db "$DB" -entry P04637 -out query.fasta
cat > job.sh <<'JOB'
#!/bin/bash
#SBATCH --job-name=smoke
#SBATCH --account=hpc2ncourses2026-013
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
module load GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0
blastp -query query.fasta -db /proj/nobackup/cddb_course/databases/swissprot/swissprot -out hits.txt -outfmt 6 -evalue 1e-5 -num_threads 2 -max_target_seqs 20
JOB
out=$(sbatch job.sh); echo "  $out"
id=${out##* }
for i in $(seq 1 120); do sacct -j "$id" | grep -qE "COMPLETED|FAILED|TIMEOUT|CANCELLED" && break; sleep 1; done
check "job finished COMPLETED"                  bash -c "sacct -j $id | grep -q COMPLETED"
check "results file has hits"                   bash -c '[ "$(wc -l < hits.txt)" -gt 0 ]'
check "top hit is the query itself at 100%"     bash -c 'head -1 hits.txt | awk "\$3==100 && \$2==\"P04637\"" | grep -q .'
printf '#!/bin/bash\n#SBATCH --account=nonsense\necho hi\n' > badacct.sh
check "a wrong account is rejected"             bash -c '! sbatch badacct.sh'
printf 'echo hi\n' > noshebang.sh
check "a script without #! is rejected"         bash -c '! sbatch noshebang.sh'

echo
echo "$pass ok, $fail FAIL"
[ $fail -eq 0 ]
