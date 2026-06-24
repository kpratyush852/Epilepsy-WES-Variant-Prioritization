#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa
VCF=../variants/cohort_raw_variants.vcf.gz

mkdir -p ../variants

echo "Selecting INDELs..."

gatk SelectVariants \
    -R $REF \
    -V $VCF \
    --select-type-to-include INDEL \
    -O ../variants/cohort_indels.vcf.gz


echo "Applying INDEL filters..."

gatk VariantFiltration \
    -R $REF \
    -V ../variants/cohort_indels.vcf.gz \
    -O ../variants/cohort_indels_filtered.vcf.gz \
    --filter-name "QD_filter" --filter-expression "QD < 2.0" \
    --filter-name "FS_filter" --filter-expression "FS > 200.0" \
    --filter-name "ReadPosRankSum_filter" --filter-expression "ReadPosRankSum < -20.0"
