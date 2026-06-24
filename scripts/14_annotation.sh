#!/bin/bash

set -e

INPUT=../variants/cohort_final_variants.vcf.gz
ANNOTATED=../variants/cohort_annotated.vcf
OUTPUT=../variants/variant_table.csv

echo "Running snpEff annotation..."

java -Xmx16g -jar /home/lab210/miniconda3/envs/wes_pipeline/share/snpeff-5.4.0c-0/snpEff.jar GRCh38.99 $INPUT > $ANNOTATED

echo "Extracting variant table..."

SnpSift extractFields -s "," $ANNOTATED \
CHROM POS REF ALT "ANN[0].GENE" "ANN[0].EFFECT" \
> $OUTPUT

echo "Finished."
