#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

mkdir -p ../variants
mkdir -p ../logs

gvcfs=""

for gvcf in ../variants/*.g.vcf.gz
do
    gvcfs="$gvcfs -V $gvcf"
done

echo "Combining gVCFs..."

gatk CombineGVCFs \
    -R $REF \
    $gvcfs \
    -O ../variants/combined_cohort.g.vcf.gz
