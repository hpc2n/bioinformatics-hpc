# Practice environment for the 5BI00A exam while Kebnekaise is unavailable.
# Ubuntu 22.04 matches the Kebnekaise login nodes (git 2.34.1, GNU awk 5.1.0).
# Slurm and the module system are imitated; everything else is the real tool.
FROM ubuntu:22.04

ARG TARGETARCH
ARG BLAST_VERSION=2.17.0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl wget git openssh-client zip unzip nano vim less jq gawk \
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
RUN set -eux; mkdir -p "$DBDIR"; cd "$DBDIR"; \
    curl -fsSL https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz | gunzip > uniprot_sprot.fasta; \
    curl -fsSL https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/reldate.txt > RELEASE.txt; \
    /opt/blast/bin/makeblastdb -in uniprot_sprot.fasta -dbtype prot -parse_seqids -blastdb_version 5 \
        -title "UniProt Swiss-Prot (practice copy)" -out swissprot

# Module and Slurm imitations
COPY shims/hpc2n-shim.sh /etc/profile.d/hpc2n-shim.sh
COPY shims/slurm-shim /usr/local/bin/slurm-shim
COPY exam-practice-check /usr/local/bin/exam-practice-check
RUN chmod +x /usr/local/bin/slurm-shim /usr/local/bin/exam-practice-check; \
    for c in sbatch squeue sacct scancel; do ln -s slurm-shim /usr/local/bin/$c; done; \
    printf '\n[ -f /etc/profile.d/hpc2n-shim.sh ] && . /etc/profile.d/hpc2n-shim.sh\n' >> /etc/bash.bashrc; \
    printf '%s\n' \
        'if [ -z "$PRACTICE_MOTD_SHOWN" ]; then export PRACTICE_MOTD_SHOWN=1;' \
        '  echo "Exam practice image. This is NOT Kebnekaise: module and Slurm are imitated."' \
        '  echo "Run exam-practice-check to test your setup. Work in ~/work."; fi' >> /etc/bash.bashrc

# A user with the same layout as on the cluster: the working folder is below the course students/ folder
RUN useradd -m -s /bin/bash student; \
    mkdir -p /proj/nobackup/cddb_course/students /home/student/work; \
    ln -s /home/student/work /proj/nobackup/cddb_course/students/student; \
    chown -R student:student /home/student
USER student
ENV USER=student
WORKDIR /home/student/work
CMD ["bash"]
