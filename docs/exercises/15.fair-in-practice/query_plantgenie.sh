#!/bin/bash
# Lecture 15: FAIR in Practice — PlantGenIE API exercises
#
# Base URL, endpoints, and example values below were verified working
# against the live PlantGenIE API. Jamie McCann (plantgenie.se developer)
# is confirming these are final ahead of the session — if he requests
# changes, update the variables below.
BASE_URL="https://www.plantgenie.se/api"
SPECIES="populus-tremula"
GENE_ID="Potra2n4c9093"
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
