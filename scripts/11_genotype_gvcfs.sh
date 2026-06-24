 #!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

mkdir -p ../variants
mkdir -p ../logs

echo "Running joint genotyping..."

gatk GenotypeGVCFs \
    -R $REF \
    -V ../variants/combined_cohort.g.vcf.gz \
    -O ../variants/cohort_raw_variants.vcf.gz
