#!/bin/bash

set -e

mkdir -p ../variants

echo "Merging SNP and INDEL VCFs..."

gatk MergeVcfs \
    -I ../variants/cohort_snps_filtered.vcf.gz \
    -I ../variants/cohort_indels_filtered.vcf.gz \
    -O ../variants/cohort_merged_variants.vcf.gz
    
#bcftools view -f PASS \
#../variants/cohort_merged_variants.vcf.gz \
#-Oz -o ../variants/cohort_final_variants.vcf.gz

#Sanity check

#Count number of variants
#bcftools stats ../variants/cohort_final_variants.vcf.gz > ../qc/vcf_stats.txt

#Check transition / transversion ratio
#bcftools stats ../variants/cohort_final_variants.vcf.gz | grep TSTV

#Variants inside target regions
#bedtools intersect \
#-a ../variants/cohort_final_variants.vcf.gz \
#-b ../ref/idt_exome_targets.hg38.bed \
#-u | wc -l
