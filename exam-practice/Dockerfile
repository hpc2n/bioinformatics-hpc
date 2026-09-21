# Practice environment for the 5BI00A exam while Kebnekaise is unavailable.
# Ubuntu 22.04 matches the Kebnekaise login nodes (git 2.34.1, GNU awk 5.1.0).
# Slurm and the module system are imitated; everything else is the real tool.
FROM ubuntu:22.04

ARG TARGETARCH
ARG BLAST_VERSION=2.17.0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl wget git openssh-client zip unzip nano vim less jq gawk python3 \
        libgomp1 libbz2-1.0 zlib1g procps file bash-completion locales \
    && rm -rf /var/lib/apt/lists/*

# BLAST+ from NCBI, checked against NCBI's published MD5 (x86-64 and ARM64 builds exist)
RUN set -eux; \
    case "$TARGETARCH" in \
        amd64) A=x64-linux;; \
        arm64) A=aarch64-linux;; \
        *) echo "unsupported architecture: $TARGETARCH" >&2; exit 1;; \
    esac; \
    T="ncbi-blast-${BLAST_VERSION}+-${A}.tar.gz"; \
    U="https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}"; \
    cd /tmp; curl -fsSLO "$U/$T"; curl -fsSLO "$U/$T.md5"; \
    md5sum -c "$T.md5"; \
    tar xzf "$T" -C /opt; mv "/opt/ncbi-blast-${BLAST_VERSION}+" /opt/blast; \
    rm -f "$T" "$T.md5"

# Swiss-Prot BLAST database at the same path as on Kebnekaise, so job scripts work unchanged.
# This is the current UniProt release, not the 13 Aug 2026 course copy, so hits and E-values can differ slightly.
ENV DBDIR=/proj/nobackup/cddb_course/databases/swissprot
# The EBI copy of the UniProt FTP site is tried first and the UniProt site second: the UniProt site can be unreachable
# from some networks (a student's build failed with "SSL connection timeout"). Each download is retried, and the file is
# checked with gzip -t before it is unpacked, so that a partial download stops the build with a clear error.
RUN set -eux; mkdir -p "$DBDIR"; cd "$DBDIR"; \
    for base in https://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete \
                https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete; do \
        if curl -fsSL --connect-timeout 30 --max-time 900 --retry 3 --retry-delay 5 -o uniprot_sprot.fasta.gz "$base/uniprot_sprot.fasta.gz" \
           && gzip -t uniprot_sprot.fasta.gz \
           && curl -fsSL --connect-timeout 30 --max-time 60 --retry 3 --retry-delay 5 -o RELEASE.txt "$base/reldate.txt"; then break; fi; \
        echo "download from $base failed, trying the next site" >&2; rm -f uniprot_sprot.fasta.gz RELEASE.txt; \
    done; \
    test -s uniprot_sprot.fasta.gz && test -s RELEASE.txt; \
    gunzip uniprot_sprot.fasta.gz; \
    /opt/blast/bin/makeblastdb -in uniprot_sprot.fasta -dbtype prot -parse_seqids -blastdb_version 5 \
        -title "UniProt Swiss-Prot (practice copy)" -out swissprot

# Manual pages: the base image strips them, so restore those the course pages point to (man git-<command>)
RUN set -eux; \
    sed -i '/path-exclude=\/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/excludes || true; \
    apt-get update; \
    apt-get install -y --no-install-recommends man-db bzip2; \
    apt-get install -y --reinstall git-man coreutils grep gawk sed findutils; \
    rm -f /usr/bin/man; dpkg-divert --local --remove --rename /usr/bin/man; \
    rm -rf /var/lib/apt/lists/*

# File-format tools at the versions the Lecture 13 module lines name. SAMtools 1.22 and BCFtools 1.19 need
# different htslib versions, so each tool gets its own environment and its module adds its own bin directory.
RUN set -eux; \
    case "$TARGETARCH" in amd64) M=linux-64;; arm64) M=linux-aarch64;; *) echo "unsupported architecture: $TARGETARCH" >&2; exit 1;; esac; \
    curl -fsSL "https://micro.mamba.pm/api/micromamba/$M/latest" | tar -xj -C /usr/local/bin --strip-components=1 bin/micromamba; \
    for spec in samtools==1.22 bcftools==1.19 bedtools==2.31.1 seqkit; do \
        micromamba create -y -q -p "/opt/tools/${spec%%=*}" -c conda-forge -c bioconda "$spec"; \
    done; \
    micromamba clean -a -y -q; rm -f /usr/local/bin/micromamba; \
    ln -s /opt/tools/seqkit/bin/seqkit /usr/local/bin/seqkit

# Exercise files from the course repository. They are copied to ~/exercises the first time a shell starts,
# which is where the course pages expect them.
RUN set -eux; \
    git clone -q --depth 1 https://github.com/hpc2n/bioinformatics-hpc.git /tmp/course; \
    mkdir -p /opt/exercises-seed; \
    cp -r /tmp/course/exercises/. /opt/exercises-seed/; \
    cp -r /tmp/course/docs/exercises/12.blast /tmp/course/docs/exercises/15.fair-in-practice /opt/exercises-seed/; \
    rm -rf /tmp/course

# Small dummy stand-ins for the Lecture 13 example files. The real files are large (up to 2.5 GB) and stay on
# Kebnekaise; these have the same names and formats but invented content, generated with a fixed random seed.
COPY dummy_data/make_dummy_data.py /tmp/make_dummy_data.py
RUN set -eux; \
    sed -i 's/\r$//' /tmp/make_dummy_data.py; \
    python3 /tmp/make_dummy_data.py /proj/nobackup/cddb_course/Bioinformatics_File_Formats/example_formats; \
    chmod -R a+rX /proj/nobackup/cddb_course/Bioinformatics_File_Formats; \
    rm /tmp/make_dummy_data.py

# Module and Slurm imitations
COPY shims/hpc2n-shim.sh /etc/profile.d/hpc2n-shim.sh
COPY shims/slurm-shim /usr/local/bin/slurm-shim
COPY exam-practice-check /usr/local/bin/exam-practice-check
COPY exam-practice-setup /usr/local/bin/exam-practice-setup
# Strip Windows line endings in case the repository was cloned with CRLF conversion
RUN sed -i 's/\r$//' /etc/profile.d/hpc2n-shim.sh /usr/local/bin/slurm-shim /usr/local/bin/exam-practice-check /usr/local/bin/exam-practice-setup; \
    chmod +x /usr/local/bin/slurm-shim /usr/local/bin/exam-practice-check /usr/local/bin/exam-practice-setup; \
    for c in sbatch squeue sacct scancel srun; do ln -s slurm-shim /usr/local/bin/$c; done; \
    printf '\n[ -f /etc/profile.d/hpc2n-shim.sh ] && . /etc/profile.d/hpc2n-shim.sh\n' >> /etc/bash.bashrc; \
    printf '%s\n' \
        '[ -d "$HOME/exercises" ] || cp -r /opt/exercises-seed "$HOME/exercises"' \
        'if [ -z "$PRACTICE_MOTD_SHOWN" ]; then export PRACTICE_MOTD_SHOWN=1;' \
        '  echo "You are INSIDE the practice container: the prompt starts with [practice container]."' \
        '  echo "This is not Kebnekaise: module and Slurm are imitated. Work in ~/work. When you have finished working, type exit to leave."' \
        '  echo "Next: 1) exam-practice-check   2) exam-practice-setup (Git and GitHub)   3) exam-practice-check again"; fi' >> /etc/bash.bashrc; \
    printf '%s\n' "PROMPT_COMMAND='PS1=\"[practice container] \\u@\\h:\\w\\\$ \"'" >> /etc/bash.bashrc

# A user with the same layout as on the cluster: the working folder is below the course students/ folder
RUN useradd -m -s /bin/bash student; \
    mkdir -p /proj/nobackup/cddb_course/students /home/student/work; \
    ln -s /home/student/work /proj/nobackup/cddb_course/students/student; \
    chown -R student:student /home/student
USER student
ENV USER=student
WORKDIR /home/student/work
CMD ["bash"]
