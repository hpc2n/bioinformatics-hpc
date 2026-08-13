#!/bin/bash
# Lecture 15: FAIR in Practice — PlantGenIE API exercises
#
# The new PlantGenIE API's base URL, endpoint paths, and gene ID format
# will be confirmed by Jamie McCann ahead of the session. Update the two
# variables below before running.
BASE_URL="PLANTGENIE_BASE_URL"
GENE_ID="EXAMPLE_GENE_ID"

curl -s "${BASE_URL}/genes/${GENE_ID}" > gene_info.json && echo "=== Gene info ===" && cat gene_info.json
curl -s "${BASE_URL}/expression/${GENE_ID}" > expression_data.json && echo "=== Expression ===" && grep -o '"tissue": "[^"]*"' expression_data.json | wc -l && echo "tissues"
