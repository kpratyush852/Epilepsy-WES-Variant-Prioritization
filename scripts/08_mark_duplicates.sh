#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

mkdir -p ../alignment
mkdir -p ../logs

for bam in ../alignment/*_sorted.bam
do
    base=$(basename $bam _sorted.bam)

    echo "Marking duplicates for $base"

    gatk --java-options "-Xmx8G" MarkDuplicates \
        -I $bam \
        -O ../alignment/${base}_sorted_dedup.bam \
        -M ../logs/${base}_dup_metrics.txt \
        --CREATE_INDEX true
done
