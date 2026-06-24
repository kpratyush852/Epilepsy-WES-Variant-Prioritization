#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa
BAITS=../ref/idt_exome_baits.interval_list
TARGETS=../ref/idt_exome_targets.interval_list

mkdir -p logs

for bam in ../alignment/*_sorted.bam
do
    base=$(basename $bam _sorted.bam)

    echo "Calculating WES metrics for $base"

    gatk CollectHsMetrics \
        -I $bam \
        -O logs/${base}_hs_metrics.txt \
        -R $REF \
        -BAIT_INTERVALS $BAITS \
        -TARGET_INTERVALS $TARGETS
done
