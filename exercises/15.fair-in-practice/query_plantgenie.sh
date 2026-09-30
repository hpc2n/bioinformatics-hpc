#!/bin/bash
# Lecture 15: FAIR in Practice — PlantGenIE API exercises
#
# Base URL, endpoints, and example values below were confirmed working
# against the live PlantGenIE API (annotations, expression, and BLAST).
# If an endpoint has changed since, check the current API documentation
# or post on the Canvas discussion board.
BASE_URL="https://www.plantgenie.se/api"
SPECIES="populus-tremula"
GENE_ID="Potra2n18c32336"
EXPERIMENT_ID=15   # "Potra Wood Development" — likely the AspWood dataset (ERP016242) used in Part 2

echo "=== Gene annotation ==="
curl -s -X POST "${BASE_URL}/v1/annotations" \
  -H "Content-Type: application/json" \
  -d "{\"species\": \"${SPECIES}\", \"geneIds\": [\"${GENE_ID}\"]}" \
  > gene_info.json
cat gene_info.json

echo "=== Expression data ==="
curl -s -X POST "${BASE_URL}/v1/expression" \
  -H "Content-Type: application/json" \
  -d "{\"experimentId\": ${EXPERIMENT_ID}, \"geneIds\": [\"${GENE_ID}\"]}" \
  > expression_data.json
cat expression_data.json

echo "=== Number of samples with expression values ==="
python3 -c "import json; print(len(json.load(open('expression_data.json'))['samples']))"

# --- BLAST via the PlantGenIE API ---
# PlantGenIE does not expose a sequence-retrieval endpoint of its own, so
# a query sequence for this gene is provided alongside this script:
# potra-Potra2n18c32336-1.fasta
#
# Always use www.plantgenie.se (not dev.plantgenie.se) for BLAST —
# BLAST is not set up correctly on the development server.
echo "=== BLAST submit ==="
JOB_ID=$(curl -s -X POST "${BASE_URL}/v1/blast/blastn/submit?database_type=cds" \
  -F "species_id=3" \
  -F "genome_id=3" \
  -F "file=@potra-Potra2n18c32336-1.fasta" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['jobId'])")
echo "Job ID: $JOB_ID"

echo "=== BLAST poll ==="
while true; do
  sleep 5
  STATUS=$(curl -s "${BASE_URL}/v1/blast/poll/${JOB_ID}" \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['status'])")
  echo "$STATUS"
  [ "$STATUS" = "SUCCESS" ] && break
done

echo "=== BLAST retrieve ==="
curl -s "${BASE_URL}/v1/blast/retrieve/${JOB_ID}/tsv" > blast_result.tsv
cat blast_result.tsv
