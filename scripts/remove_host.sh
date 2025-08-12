#!/bin/bash
# Host Genome Removal Script for Plant Virus Pipeline
# Usage: bash remove_host.sh host_genome.fa trimmed_R1.fastq.gz trimmed_R2.fastq.gz output_dir

HOST_REF=$1       # Host genome FASTA file
TRIM_R1=$2        # Trimmed R1 from QC step
TRIM_R2=$3        # Trimmed R2 from QC step
OUTDIR=$4         # Output directory

mkdir -p $OUTDIR

echo "Step 1: Building Bowtie2 index for host genome..."
bowtie2-build $HOST_REF $OUTDIR/host_index

echo "Step 2: Mapping trimmed reads to host genome..."
bowtie2 -x $OUTDIR/host_index -1 $TRIM_R1 -2 $TRIM_R2 \
  -S $OUTDIR/host_align.sam --very-sensitive -p 4

echo "Step 3: Converting SAM to BAM..."
samtools view -bS $OUTDIR/host_align.sam > $OUTDIR/host_align.bam

echo "Step 4: Extracting unmapped reads..."
samtools view -b -f 12 -F 256 $OUTDIR/host_align.bam > $OUTDIR/unmapped.bam
samtools fastq \
  -1 $OUTDIR/unmapped_R1.fastq.gz \
  -2 $OUTDIR/unmapped_R2.fastq.gz \
  $OUTDIR/unmapped.bam

echo "Host genome removal complete!"
echo "Unmapped reads saved to:"
echo " - $OUTDIR/unmapped_R1.fastq.gz"
echo " - $OUTDIR/unmapped_R2.fastq.gz"
