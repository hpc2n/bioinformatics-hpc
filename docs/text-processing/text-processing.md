# Reading and querying bioinformatics text files

*Guided self-study. About 3 hours in total; you can do it in several sittings.*

Most of what you do at the command line in this course, and in the exam, is asking questions of text files: a UniProt entry, a FASTA file, a GenBank record, a table of BLAST hits. The commands for this (`grep`, `cut`, `sort`, `uniq`, `awk` and the pipe `|`) were introduced in the Linux introduction ([Pipes and filters](../06.linux-intro/pipesfilters.md), [Finding patterns](../06.linux-intro/patterns.md) and [Awk](../06.linux-intro/awk.md)). This page is about using them on biological files with understanding, so that you can change a command to answer a new question rather than copy it.

**How to use this page.** Each part takes one command apart, piece by piece, and then asks: *how would you change this to…?* Before you open an answer, write down the command you would try, and what you expect it to print. Then run it. If the result surprises you, work out why before moving on: that is where most of the learning happens. The answers are hidden in boxes that open when you click them.

The example outputs were produced on Kebnekaise on 29 September 2026. UniProt and NCBI update their entries regularly, so some of your counts may differ slightly. The structure of the files, and the commands, stay the same.

| Part | Topic | Time |
|---|---|---|
| 1 | Look at a file before you query it | 25 min |
| 2 | Taking a `grep` command apart | 40 min |
| 3 | Fields and separators: `cut` and `awk` | 40 min |
| 4 | Sorting and counting: `sort` and `uniq` | 30 min |
| 5 | Building a pipeline one step at a time | 30 min |
| 6 | When a command does not do what you expect | 20 min |

---

## Setting up

Log in to Kebnekaise, make a folder for this page and fetch the files. They are the human TP53 files that you also meet in Lectures 11 and 15.

```bash
mkdir -p ~/course/text-processing
cd ~/course/text-processing

# The UniProt entry for human TP53, in full text and FASTA format (Lecture 11, Part B)
curl -s "https://rest.uniprot.org/uniprotkb/P04637.txt" > TP53_protein.txt
curl -s "https://rest.uniprot.org/uniprotkb/P04637.fasta" > TP53_protein.fasta

# The RefSeq mRNA record in GenBank format (Lecture 11, Part C)
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NM_000546.6&rettype=gb&retmode=text" > TP53_mRNA.gb

# A local BLAST result for TP53 against the course Swiss-Prot database
curl -sL "https://raw.githubusercontent.com/hpc2n/bioinformatics-hpc/main/docs/exercises/text-processing/TP53_blastp_local.tsv" > TP53_blastp_local.tsv
```

The BLAST file was made with the job script from Lecture 15, Exercise 1D, with `-max_target_seqs 1000`. You can also make it yourself with that script; you will then have the same 40 hits.

---

## Part 1 — Look at a file before you query it

Every command you write depends on how the file is laid out. So the first step is always to look.

### The UniProt text entry

```bash
head -5 TP53_protein.txt
```

```text
ID   P53_HUMAN               Reviewed;         393 AA.
AC   P04637; Q15086; Q15087; Q15088; Q16535; Q16807; Q16808; Q16809; Q16810;
AC   Q16811; Q16848; Q2XN98; Q3LRW1; Q3LRW2; Q3LRW3; Q3LRW4; Q3LRW5; Q86UG1;
AC   Q8J016; Q99659; Q9BTM4; Q9HAQ8; Q9NP68; Q9NPJ2; Q9NZD0; Q9UBI2; Q9UQ61;
DT   13-AUG-1987, integrated into UniProtKB/Swiss-Prot.
```

Every line starts with a two-letter code, then three spaces, then the content. `ID` is the identifier line, `AC` the accession numbers, `DT` the dates. The codes are what make this file easy to search: to find a kind of information, you search for its code at the start of the line.

Which codes are there, and how many lines of each? This command answers that:

```bash
cut -c1-2 TP53_protein.txt | sort | uniq -c | sort -k1,1nr
```

Taking it apart:

- `cut -c1-2 TP53_protein.txt` keeps characters 1 to 2 of every line, which is the line code.
- `|` sends that output on to the next command, instead of to the screen.
- `sort` puts identical codes next to each other.
- `uniq -c` collapses each run of identical lines into one, with a count in front.
- `sort -k1,1nr` sorts by the first field (`-k1,1`, the count), as a number (`n`), largest first (`r`).

```text
   5408 FT
   1120 DR
    737 CC
    448 RA
    ...
      1 OS
      1 OX
      1 PE
      1 SQ
```

`FT` lines describe features along the sequence, `DR` lines are cross-references to other databases, `CC` lines are comments, and the `R` lines are the literature references. `SQ` starts the sequence.

??? question "How would you find the line that gives the sequence length and molecular weight, and its line number in the file?"
    Search for the `SQ` code at the start of the line; `-n` adds the line number.

    ```bash
    grep -n "^SQ" TP53_protein.txt
    ```

    ```text
    9152:SQ   SEQUENCE   393 AA;  43653 MW;  AD5C149FD8106131 CRC64;
    ```

??? question "The `DR` lines each point to another database. How would you count how many lines point to each database?"
    A `DR` line looks like `DR   GO; GO:0005813; C:centrosome; IDA:UniProtKB.`: the database name comes after `DR` and three spaces, and ends at the first `;`. So keep the part before the first `;`, remove the first five characters (`DR` and the three spaces), and count.

    ```bash
    grep "^DR   " TP53_protein.txt | cut -d";" -f1 | cut -c6- | sort | uniq -c | sort -k1,1nr | head -8
    ```

    ```text
        311 PDB
        311 PDBsum
        119 GO
         85 EMBL
         46 Reactome
         25 RefSeq
         22 Ensembl
         22 Orphanet
    ```

    `cut -d";" -f1` splits each line at `;` and keeps field 1; `cut -c6-` keeps characters 6 to the end. There are 311 structures in the Protein Data Bank for TP53, and 25 RefSeq lines: that is where you find the RefSeq mRNA accessions (Part 2).

### The BLAST table

```bash
head -3 TP53_blastp_local.tsv
```

```text
sp|P04637|P53_HUMAN	P04637	100.000	393	0	0	1	393	1	393	0.0	813
sp|P04637|P53_HUMAN	P56424	95.674	393	17	0	1	393	1	393	0.0	782
sp|P04637|P53_HUMAN	P61260	95.674	393	17	0	1	393	1	393	0.0	782
```

This is BLAST's tabular format (`-outfmt 6`): one line per hit, 12 columns, no header. The columns are separated by tab characters, which look like spaces on screen. `cat -A` shows them as `^I`:

```bash
head -1 TP53_blastp_local.tsv | cat -A
```

```text
sp|P04637|P53_HUMAN^IP04637^I100.000^I393^I0^I0^I1^I393^I1^I393^I0.0^I813$
```

(`$` marks the end of the line.) To see which value is in which column, turn the tabs of one line into line breaks and number the lines:

```bash
head -1 TP53_blastp_local.tsv | tr '\t' '\n' | cat -n
```

```text
     1	sp|P04637|P53_HUMAN
     2	P04637
     3	100.000
     4	393
     5	0
     6	0
     7	1
     8	393
     9	1
    10	393
    11	0.0
    12	813
```

- `tr '\t' '\n'` translates every tab (`\t`) into a line break (`\n`).
- `cat -n` prints its input with line numbers.

Compare with the column table in [Lecture 15, Exercise 1D](../15.fair-in-practice/fair-in-practice.md): column 2 is the hit, 3 the percent identity, 11 the E-value and 12 the bit score. The first line is your own protein, found in the database: the *self hit*.

??? question "How would you look at the columns of the second hit instead of the first?"
    Take line 2 instead of line 1. `sed -n 2p` prints only line 2:

    ```bash
    sed -n 2p TP53_blastp_local.tsv | tr '\t' '\n' | cat -n
    ```

    Column 2 is now `P56424` (TP53 of the rhesus macaque), with 95.674 % identity (column 3) and 17 mismatches (column 5).

### The GenBank record

```bash
grep -n "^FEATURES\|^ORIGIN\|^//" TP53_mRNA.gb
```

```text
229:FEATURES             Location/Qualifiers
657:ORIGIN
700://
```

A GenBank record has a header (from `LOCUS` to the references), a `FEATURES` table, and the sequence after `ORIGIN`, ending with `//`. `\|` inside the pattern means *or*.

??? question "How would you print the record's description and its accession with version number?"
    These are the `DEFINITION` and `VERSION` lines:

    ```bash
    grep "^DEFINITION\|^VERSION" TP53_mRNA.gb
    ```

    ```text
    DEFINITION  Homo sapiens tumor protein p53 (TP53), transcript variant 1, mRNA.
    VERSION     NM_000546.6
    ```

---

## Part 2 — Taking a `grep` command apart

Lecture 11 uses this command to show the GO annotations of TP53:

```bash
grep "^DR   GO;" TP53_protein.txt | head -3
```

```text
DR   GO; GO:0005813; C:centrosome; IDA:UniProtKB.
DR   GO; GO:0000785; C:chromatin; IDA:BHF-UCL.
DR   GO; GO:0005737; C:cytoplasm; IDA:UniProtKB.
```

Every character in it has a job:

| Piece | What it does |
|---|---|
| `grep` | prints the lines of a file that match a pattern |
| `"..."` | the quotes keep the pattern together as one argument, spaces and `;` included |
| `^` | the match must start at the beginning of the line |
| `DR` | the line code for cross-references |
| three spaces | exactly as in the file: the code is always followed by three spaces |
| `GO;` | the database name, with the `;` that ends it |
| `TP53_protein.txt` | the file to search |
| `\| head -3` | show only the first 3 matching lines |

**Why the quotes matter.** Without them, the shell splits the command at every space and at the `;`:

```bash
grep ^DR   GO; TP53_protein.txt
```

```text
grep: GO: No such file or directory
bash: line 1: TP53_protein.txt: command not found
```

`grep` searched for `^DR` in a file called `GO`, and the `;` ended the command, so the shell then tried to run `TP53_protein.txt` as a command.

**Why the `^` matters.** Count the lines with and without it:

```bash
grep -c "^DR   GO;" TP53_protein.txt     # 119
grep -c "GO;" TP53_protein.txt           # 122
```

The three extra lines are not GO annotations at all:

```text
DR   PDB; 4AGO; X-ray; 1.45 A; A/B=94-312.
DR   PAN-GO; P04637; 8 GO annotations based on evolutionary models.
DR   PDBsum; 4AGO; -.
```

A protein structure with the identifier `4AGO` contains `GO;`, and so does `PAN-GO;`. The anchor `^DR   GO;` avoids them. For PDB the difference is larger: `grep -c "PDB"` finds 668 lines, but only 311 are `DR   PDB;` lines; the rest are `PDBsum` cross-references and literature lines that mention a structure.

**Why the exact spacing matters.** With one space instead of three there are no matches at all:

```bash
grep -c "^DR GO;" TP53_protein.txt       # 0
```

`grep` is also case-sensitive: `"^DR   go;"` finds 0 lines, while `grep -i "^DR   go;"` (ignore case) finds 119.

A few options you will use often: `-c` counts the matching lines instead of printing them, `-v` prints the lines that do *not* match, `-n` adds line numbers, `-i` ignores case, and `-o` prints only the part of the line that matched.

??? question "How would you change the command to show the RefSeq cross-references instead of the GO annotations?"
    Change the database name, and keep everything else:

    ```bash
    grep "^DR   RefSeq;" TP53_protein.txt | head -3
    ```

    ```text
    DR   RefSeq; NP_000537.3; NM_000546.6. [P04637-1]
    DR   RefSeq; NP_001119584.1; NM_001126112.3. [P04637-1]
    DR   RefSeq; NP_001119585.1; NM_001126113.3. [P04637-3]
    ```

    Each line gives a RefSeq protein (`NP_`) and the mRNA that encodes it (`NM_`); the part in square brackets is the UniProt isoform. `NM_000546.6` is the record you fetched from NCBI in the set-up: this is how you get from a UniProt accession to an NCBI mRNA accession. It is the first step of Part 1 of the exam.

??? question "How would you count the protein structures of TP53 in the Protein Data Bank?"
    ```bash
    grep -c "^DR   PDB;" TP53_protein.txt
    ```

    This gives 311. Without the `^DR   ` and the `;` you would count the `PDBsum` lines too.

??? question "How would you print only the NM_ accessions, without the rest of the line?"
    `-o` prints only the part that matched. A first try:

    ```bash
    grep "^DR   RefSeq;" TP53_protein.txt | grep -o "NM_[0-9.]*" | head -3
    ```

    ```text
    NM_000546.6.
    NM_001126112.3.
    NM_001126113.3.
    ```

    `[0-9.]*` means "any number of digits or full stops", so it also took the full stop that ends the UniProt field. That full stop is not part of the accession, and NCBI rejects the ID with it. A more precise pattern: digits, one full stop (`\.`, where `\` makes the full stop literal), then digits.

    ```bash
    grep "^DR   RefSeq;" TP53_protein.txt | grep -o "NM_[0-9]*\.[0-9]*" | head -3
    ```

    ```text
    NM_000546.6
    NM_001126112.3
    NM_001126113.3
    ```

??? question "And the RefSeq protein accessions (NP_)?"
    Change only the prefix:

    ```bash
    grep "^DR   RefSeq;" TP53_protein.txt | grep -o "NP_[0-9]*\.[0-9]*" | head -3
    ```

    ```text
    NP_000537.3
    NP_001119584.1
    NP_001119585.1
    ```

??? question "How would you show the InterPro domains, or the Pfam families, of TP53?"
    ```bash
    grep "^DR   InterPro;" TP53_protein.txt
    grep "^DR   Pfam;" TP53_protein.txt
    ```

    TP53 has 9 InterPro lines and 4 Pfam lines, for example `DR   Pfam; PF00870; P53; 1.`

---

## Part 3 — Fields and separators: `cut` and `awk`

Many biological files are tables, even when they do not look like one. What separates the columns is what decides which command, and which option, you need.

| File | Columns separated by |
|---|---|
| BLAST `-outfmt 6` | a tab |
| UniProt `DR` lines | `; ` (a semicolon and a space) |
| FASTA | not a table: a header line starting with `>`, then sequence lines |

### `cut`: pick columns by number

```bash
cut -f2,3,11,12 TP53_blastp_local.tsv | head -5
```

```text
P04637	100.000	0.0	813
P56424	95.674	0.0	782
P61260	95.674	0.0	782
P56423	95.674	0.0	782
P13481	95.674	0.0	780
```

`-f2,3,11,12` keeps fields 2, 3, 11 and 12. By default `cut` splits at tabs, which is exactly what the BLAST table uses. For another separator, give it with `-d`:

```bash
grep "^DR   PDB;" TP53_protein.txt | head -3
```

```text
DR   PDB; 1A1U; NMR; -; A/C=324-358.
DR   PDB; 1AIE; X-ray; 1.50 A; A=326-356.
DR   PDB; 1C26; X-ray; 1.70 A; A=325-356.
```

```bash
grep "^DR   PDB;" TP53_protein.txt | cut -d";" -f3 | sort | uniq -c
```

```text
     15  EM
     30  NMR
    266  X-ray
```

`cut -d";" -f3` splits each line at `;` and keeps field 3, the method used to solve the structure. Field 1 is `DR   PDB`, field 2 the PDB identifier. The space in front of each method is the space that followed the `;` in the file; it is still there because `cut` splits only at the `;`.

??? question "Each GO line ends with an evidence code, such as IDA or IEA. How would you count how many GO annotations there are for each evidence code?"
    In `DR   GO; GO:0005813; C:centrosome; IDA:UniProtKB.` the evidence code is at the start of field 4, before the `:`. So take field 4, then the part before the `:`, then count:

    ```bash
    grep "^DR   GO;" TP53_protein.txt | cut -d";" -f4 | cut -d: -f1 | sort | uniq -c | sort -k1,1nr
    ```

    ```text
         57  IDA
         21  IMP
         17  IPI
          8  IEA
          4  IEP
          4  ISS
          3  EXP
          3  TAS
          2  IGI
    ```

    This is the "number of GO annotations for each evidence code" asked for in Part 1 of the exam. Lecture 11 counts with `grep -o "IDA\|IEA\|IMP\|ISS\|IPI\|EXP"`, which only looks for those six codes: for TP53 it misses IEP, TAS and IGI. This version counts every code that is there.

??? question "The third field of a GO line starts with C, F or P: the GO aspect (cellular component, molecular function or biological process). How would you count the annotations in each aspect?"
    Field 3 is ` C:centrosome` (with a leading space), so the aspect letter is character 2 of the field:

    ```bash
    grep "^DR   GO;" TP53_protein.txt | cut -d";" -f3 | cut -c2 | sort | uniq -c
    ```

    ```text
         17 C
         35 F
         67 P
    ```

### `awk`: choose lines by the value in a column

`cut` picks columns; `awk` can also test the values in them. Here is a command that lists the hits with at least 90 % identity:

```bash
awk -F'\t' '$3 >= 90 {print $2, $3}' TP53_blastp_local.tsv
```

```text
P04637 100.000
P56424 95.674
P61260 95.674
P56423 95.674
P13481 95.674
...
```

| Piece | What it does |
|---|---|
| `-F'\t'` | fields are separated by tabs (without it, `awk` splits at any run of spaces or tabs) |
| `'...'` | single quotes around the `awk` program, so the shell does not touch `$3` |
| `$3` | the value in column 3, the percent identity |
| `$3 >= 90` | the condition: only lines where it is true are used |
| `{print $2, $3}` | the action: print columns 2 and 3 |

Without an action, `awk` prints the whole line; without a condition, it uses every line. So `awk -F'\t' '$3 >= 90' TP53_blastp_local.tsv | wc -l` counts the hits with at least 90 % identity: 6.

??? question "How would you count the hits with an E-value below 1e-10? And below 1e-100?"
    The E-value is column 11. `awk` understands numbers written like `1e-10`:

    ```bash
    awk -F'\t' '$11 < 1e-10' TP53_blastp_local.tsv | wc -l     # 40
    awk -F'\t' '$11 < 1e-100' TP53_blastp_local.tsv | wc -l    # 29
    ```

    All 40 hits are below 1e-10; 29 are below 1e-100. The first command is Part 3 of the exam.

??? question "How would you find the best hit that is not your own protein (the best non-self hit), with its percent identity?"
    The self hit has your own accession, `P04637`, in column 2. Leave that line out, and take the first line that remains; BLAST lists hits best first:

    ```bash
    awk -F'\t' '$2 != "P04637"' TP53_blastp_local.tsv | head -1 | cut -f2,3
    ```

    ```text
    P56424	95.674
    ```

    `!=` means "is not equal to", and the accession is in double quotes because it is text. A tempting shortcut, `$1 != $2`, does not work: column 1 is `sp|P04637|P53_HUMAN` and column 2 is `P04637`, which are never equal, so the self hit stays in.

??? question "How would you list the hits with less than 50 % identity, with their E-values?"
    ```bash
    awk -F'\t' '$3 < 50 {print $2, $3, $11}' TP53_blastp_local.tsv
    ```

    There are 12, from `P25035 49.876 5.64e-124` to `O12946 48.561 1.31e-79`: more distant relatives of p53, still with very low E-values.

---

## Part 4 — Sorting and counting: `sort` and `uniq`

### Taking `sort` apart

Here is a command that sorts the BLAST hits by E-value, smallest first:

```bash
sort -t$'\t' -k11,11g TP53_blastp_local.tsv | cut -f2,11 | head -3
```

| Piece | What it does |
|---|---|
| `-t$'\t'` | fields are separated by tabs; `$'\t'` is how you type a tab in the shell |
| `-k11,11` | sort on field 11, and only field 11 (`-k11` alone would mean "from field 11 to the end of the line") |
| `g` | compare as *general* numbers, which understands notation such as `2.1e-150` |
| `r` (when you add it) | reverse: largest first |

**Why `g` and not `n`.** `-n` reads a number only up to the `e`, so `1.18e-118` counts as 1.18 and `3.57e-125` as 3.57. Compare hits 20 to 25 of the two sorts:

```bash
sort -k11 -n TP53_blastp_local.tsv | cut -f2,11 | sed -n 20,25p
sort -t$'\t' -k11,11g TP53_blastp_local.tsv | cut -f2,11 | sed -n 20,25p
```

```text
with -n                  with -g
Q9TUB2  0.0              Q9TUB2  0.0
Q9WUR6  0.0              Q9WUR6  0.0
P79892  1.02e-153        P79892  1.02e-153
P07193  1.18e-118        Q29480  3.57e-125
O12946  1.31e-79         P25035  5.64e-124
Q9JJP2  1.38e-84         P07193  1.18e-118
```

With `-n`, `1.31e-79` comes before `1.38e-84`, which is smaller: the order is wrong.

**Smallest first, unless you add `r`.** For E-values, smallest is best. For percent identity or bit score, largest is best, so you need `r`:

```bash
sort -t$'\t' -k3,3g  TP53_blastp_local.tsv | cut -f2,3 | head -3   # lowest identity first: Q9JJP2 42.975
sort -t$'\t' -k3,3gr TP53_blastp_local.tsv | cut -f2,3 | head -3   # highest identity first: P04637 100.000
```

And without any number option, `sort` compares text character by character, so `100.000` comes before `42.975` (because `1` comes before `4`):

```bash
sort -k3 TP53_blastp_local.tsv | cut -f2,3 | head -3
```

```text
P04637	100.000
Q9JJP2	42.975
Q9W679	43.944
```

**Ties.** 21 of the 40 hits have an E-value of exactly `0.0`. Sorting by E-value cannot rank them, and `sort` then orders tied lines by the rest of the line, which puts them in alphabetical order. BLAST's own order breaks ties by bit score, so for "the top hits" the simplest and safest command is no sort at all:

```bash
head -3 TP53_blastp_local.tsv | cut -f2,3,11
```

??? question "How would you sort the hits by bit score, highest first?"
    Bit score is column 12, and larger is better:

    ```bash
    sort -t$'\t' -k12,12gr TP53_blastp_local.tsv | cut -f2,12 | head -3
    ```

    ```text
    P04637	813
    P56423	782
    P56424	782
    ```

    Notice the tie at 782: `sort` put P56423 before P56424 alphabetically, while BLAST's own file lists P56424, P61260 and then P56423.

### `uniq` needs sorted input

`uniq -c` only merges identical lines that are *next to each other*. On unsorted input it gives a misleading count:

```bash
grep "^DR   GO;" TP53_protein.txt | cut -d";" -f4 | cut -d: -f1 | uniq -c | head -4
```

```text
      4  IDA
      2  EXP
      7  IDA
      2  IEA
```

IDA appears in several separate runs. With `sort` first, each code appears once, with its total (57 IDA; see Part 3).

??? question "How would you count how many different percent-identity values there are among the hits?"
    `sort -u` sorts and keeps one copy of each value:

    ```bash
    cut -f3 TP53_blastp_local.tsv | sort -u | wc -l
    ```

    This gives 34: some hits share the same identity, such as the four at 95.674 %.

---

## Part 5 — Building a pipeline one step at a time

Long pipelines are built, and checked, one step at a time. After each `|`, look at a few lines of output with `head -3` before adding the next step. Here is how the evidence-code count from Part 3 is built.

**Question: which evidence codes support TP53's GO annotations, most common first?**

Step 1. Find the GO lines:

```bash
grep "^DR   GO;" TP53_protein.txt | head -3
```

```text
DR   GO; GO:0005813; C:centrosome; IDA:UniProtKB.
DR   GO; GO:0000785; C:chromatin; IDA:BHF-UCL.
DR   GO; GO:0005737; C:cytoplasm; IDA:UniProtKB.
```

Step 2. Keep field 4, split at `;`:

```bash
grep "^DR   GO;" TP53_protein.txt | cut -d";" -f4 | head -3
```

```text
 IDA:UniProtKB.
 IDA:BHF-UCL.
 IDA:UniProtKB.
```

Step 3. Keep the part before the `:`:

```bash
grep "^DR   GO;" TP53_protein.txt | cut -d";" -f4 | cut -d: -f1 | head -3
```

```text
 IDA
 IDA
 IDA
```

Step 4. Sort, count, and put the most common first (and now remove the `head`):

```bash
grep "^DR   GO;" TP53_protein.txt | cut -d";" -f4 | cut -d: -f1 | sort | uniq -c | sort -k1,1nr
```

A good check at the end: does the total add up? `grep -c "^DR   GO;"` gives 119, and 57 + 21 + 17 + 8 + 4 + 4 + 3 + 3 + 2 is also 119.

### Try it on a different protein

Your exam protein will not be TP53. Here is a plant protein for practice: the large subunit of Rubisco (rbcL) from *Arabidopsis thaliana*, UniProt accession O03042.

```bash
curl -s "https://rest.uniprot.org/uniprotkb/O03042.txt" > RBL_ARATH.txt
```

??? question "How long is the protein, and is the entry Swiss-Prot or TrEMBL?"
    ```bash
    grep "^ID\|^SQ" RBL_ARATH.txt
    ```

    The `ID` line says `Reviewed; 479 AA.`, so it is a Swiss-Prot entry with 479 amino acids; the `SQ` line agrees.

??? question "How many GO annotations are there for each evidence code?"
    The same pipeline, with the new file name:

    ```bash
    grep "^DR   GO;" RBL_ARATH.txt | cut -d";" -f4 | cut -d: -f1 | sort | uniq -c | sort -k1,1nr
    ```

    ```text
          9  HDA
          3  IEA
          2  IEP
          1  IDA
    ```

    Most are HDA (inferred from a high-throughput direct assay), a code that Lecture 11's six-code count would not see at all.

??? question "Find the RefSeq cross-references. Is there an NM_ accession, and if not, why might that be?"
    ```bash
    grep "^DR   RefSeq;" RBL_ARATH.txt
    ```

    ```text
    DR   RefSeq; NP_051067.1; NC_000932.1.
    ```

    There is a RefSeq protein (`NP_`), but the nucleotide record is `NC_000932.1`, a complete genome rather than an mRNA. The `OG` line explains why:

    ```bash
    grep "^OG" RBL_ARATH.txt
    ```

    ```text
    OG   Plastid; Chloroplast.
    ```

    rbcL is encoded in the chloroplast genome, not in the nucleus, so RefSeq links it to the chloroplast genome. Not every protein has an `NM_` record: always look at what the cross-references actually say.

??? question "How many structures of rbcL are in the Protein Data Bank, and by which methods?"
    ```bash
    grep "^DR   PDB;" RBL_ARATH.txt | cut -d";" -f3 | sort | uniq -c
    ```

    ```text
          2  EM
          1  X-ray
    ```

---

## Part 6 — When a command does not do what you expect

These are common mistakes, and several of them happened in this year's exam. For each, work out what happened, and how you would fix it, before opening the answer.

??? question "`grep ^DR   GO; TP53_protein.txt` prints `grep: GO: No such file or directory` and `TP53_protein.txt: command not found`."
    The pattern is not in quotes, so the shell split it at the spaces and ended the command at the `;`. Put the pattern in double quotes: `grep "^DR   GO;" TP53_protein.txt`.

??? question "`grep -c '^DR GO;' TP53_protein.txt` gives 0, although there are GO lines."
    The file has three spaces after `DR`; the pattern has one. Copy the spacing exactly from the file, or look at a line with `head` first.

??? question "`head -3 TP53_blastp_locl.tsv` prints `No such file or directory`."
    The file name is misspelt (`locl`). `ls` shows the files in the current folder. Use the Tab key to complete file names, and you will not mistype them.

??? question "You stored a sequence with `SEQ=$(cat TP53_protein.fasta)` and checked it with `cat $SEQ`. It prints `No such file or directory` for every word."
    `cat` opens files. It treated each word of the sequence as a file name. To look at a variable, use `echo`: `echo "$SEQ" | head -3`. To check its length: `printf '%s' "$SEQ" | wc -c` (0 means the variable is empty).

??? question "Sorting BLAST hits with `sort -k11 -n` puts `1.31e-79` above `1.38e-84`."
    `-n` does not understand the `e` notation. Use `sort -t$'\t' -k11,11g`. And for the top hits, you usually do not need to sort at all: see Part 4.

??? question "`awk '$11 < 1e-10' hits.tsv | wc -l` gives 44, but the file only has 40 hits."
    The file was made with `-outfmt 7`, which adds comment lines starting with `#`. `awk` compared those lines too, and four of them passed the test. Remove the comment lines first:

    ```bash
    grep -v "^#" hits.tsv | awk -F'\t' '$11 < 1e-10' | wc -l
    ```

??? question "`grep -o 'NM_[0-9.]*'` gives `NM_000546.6.`, and NCBI says it cannot understand the ID."
    The pattern also took the full stop that ends the UniProt field. Use `grep -o "NM_[0-9]*\.[0-9]*"` (Part 2).

??? question "`awk -F'\t' '$1 != $2'` was meant to remove the self hit, but P04637 is still the first line."
    Column 1 is `sp|P04637|P53_HUMAN` and column 2 is `P04637`: they are never equal, so every line passes. Compare column 2 with your accession: `awk -F'\t' '$2 != "P04637"'` (Part 3).

### Habits that help

- **Look before you query.** `head` the file, and find out what separates its columns.
- **Build step by step.** Add one command at a time, with `| head -3` to see what it does.
- **Check with a second method.** Does the total add up? Does `wc -l` give the number you expect?
- **Read the help.** `man sort` and `sort --help` list every option; search inside `man` with `/` followed by a word, for example `/general`.

---

## How this connects to the rest of the course

| Where | What you need from this page |
|---|---|
| Lecture 11 and exam Part 1 | Find the `NM_` accession in the `DR   RefSeq` lines (Part 2); count GO annotations per evidence code (Part 3) |
| Lecture 15 and exam Part 2 | Read the BLAST table by column number (Part 1); take the top hits with `head` (Part 4) |
| Exam Part 3 | Count hits below an E-value (Part 3); find the best non-self hit (Part 3) |
| Lecture 13, file formats | The same approach works for any tabular format: look first, then pick the separator |
