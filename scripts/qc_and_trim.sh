#!/bin/bash

# Define input/output files
R1_IN="data/sample_R1.fastq.gz"
R2_IN="data/sample_R2.fastq.gz"
R1_OUT="results/sample_R1.trim.fastq.gz"
R2_OUT="results/sample_R2.trim.fastq.gz"
QC_DIR="results/qc"
FASTP_HTML="results/fastp.html"
MULTIQC_DIR="results/multiqc"

# Create output directories if they don't exist
mkdir -p "$QC_DIR"
mkdir -p "$MULTIQC_DIR"

echo "Running FastQC for initial quality check..."
fastqc -t 4 "$R1_IN" "$R2_IN" -o "$QC_DIR"

echo "Trimming reads with fastp..."
fastp -i "$R1_IN" -I "$R2_IN" \
  -o "$R1_OUT" -O "$R2_OUT" \
  -h "$FASTP_HTML" -j "results/fastp.json"

echo "Aggregating all QC reports with MultiQC..."
multiqc "$QC_DIR" "$FASTP_HTML" -o "$MULTIQC_DIR"