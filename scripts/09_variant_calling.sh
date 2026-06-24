#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

mkdir -p ../variants
mkdir -p ../logs

for bam in ../alignment/*_sorted_dedup.bam
do
    base=$(basename $bam _sorted_dedup.bam)

    echo "Running variant calling for $base"

    gatk HaplotypeCaller \
        -R $REF \
        -I $bam \
        -O ../variants/${base}.g.vcf.gz \
        -ERC GVCF
done
