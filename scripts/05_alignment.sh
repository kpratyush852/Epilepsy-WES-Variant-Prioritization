#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

mkdir -p ../alignment 
mkdir -p ../logs

for r1 in ../trimmed/*_1_trimmed.fastq.gz
do
    r2=${r1/_1_trimmed.fastq.gz/_2_trimmed.fastq.gz}

    base=$(basename $r1 _1_trimmed.fastq.gz)

    echo "Processing sample: $base"

    bwa-mem2 mem -t 12 \
    -R "@RG\tID:${base}\tSM:${base}\tPL:ILLUMINA" \
    $REF \
    $r1 \
    $r2 \
    | samtools view -@ 12 -b \
    | samtools sort -@ 12 -o ../alignment/${base}_sorted.bam

done

#After alignment finishes:

#samtools view -H alignment/SRR22018187_sorted.bam | grep SO
