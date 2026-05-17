#!/bin/bash
# Lecture 15: FAIR in Practice — PlantGenIE API exercises
# Update BASE_URL when confirmed with Jamie McCann
BASE_URL="https://api.plantgenie.se"
curl -s "${BASE_URL}/genes/MA_10000g0010" > gene_info.json && echo "=== Gene info ===" && cat gene_info.json
curl -s "${BASE_URL}/expression/MA_10000g0010" > expression_data.json && echo "=== Expression ===" && grep -o '"tissue": "[^"]*"' expression_data.json | wc -l && echo "tissues"
