#!/bin/bash
# QC & Trimming Script for Plant Virus Pipeline
# Usage: bash qc_and_trim.sh sample_R1.fastq.gz sample_R2.fastq.gz output_dir

R1=$1
R2=$2
OUTDIR=$3

mkdir -p $OUTDIR/qc $OUTDIR/trimmed

echo "Running FastQC on raw reads..."
fastqc -t 4 $R1 $R2 -o $OUTDIR/qc

echo "Trimming with fastp..."
fastp \
  -i $R1 -I $R2 \
  -o $OUTDIR/trimmed/trimmed_R1.fastq.gz \
  -O $OUTDIR/trimmed/trimmed_R2.fastq.gz \
  -j $OUTDIR/trimmed/fastp.json \
  -h $OUTDIR/trimmed/fastp.html

echo "Running MultiQC..."
multiqc $OUTDIR -o $OUTDIR

echo "QC and trimming complete!"
