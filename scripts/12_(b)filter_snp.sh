#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa
VCF=../variants/cohort_raw_variants.vcf.gz

mkdir -p ../variants

echo "Selecting SNPs..."

gatk SelectVariants \
    -R $REF \
    -V $VCF \
    --select-type-to-include SNP \
    -O ../variants/cohort_snps.vcf.gz


echo "Applying SNP filters..."

gatk VariantFiltration \
    -R $REF \
    -V ../variants/cohort_snps.vcf.gz \
    -O ../variants/cohort_snps_filtered.vcf.gz \
    --filter-name "QD_filter" --filter-expression "QD < 2.0" \
    --filter-name "FS_filter" --filter-expression "FS > 60.0" \
    --filter-name "MQ_filter" --filter-expression "MQ < 40.0" \
    --filter-name "MQRankSum_filter" --filter-expression "MQRankSum < -12.5" \
    --filter-name "ReadPosRankSum_filter" --filter-expression "ReadPosRankSum < -8.0"
