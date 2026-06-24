#!/bin/bash

set -e

REF=../ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

echo "Indexing reference for BWA..."
bwa-mem2 index $REF

echo "Creating FASTA index..."
samtools faidx $REF

echo "Creating sequence dictionary for GATK..."
gatk CreateSequenceDictionary -R $REF

echo "Reference preparation complete"


#ref/
#GRCh38_full_analysis_set_plus_decoy_hla.fa
#GRCh38_full_analysis_set_plus_decoy_hla.fa.amb
#GRCh38_full_analysis_set_plus_decoy_hla.fa.ann
#GRCh38_full_analysis_set_plus_decoy_hla.fa.bwt.2bit.64
#GRCh38_full_analysis_set_plus_decoy_hla.fa.pac
#GRCh38_full_analysis_set_plus_decoy_hla.fa.sa
#GRCh38_full_analysis_set_plus_decoy_hla.fa.fai
#GRCh38_full_analysis_set_plus_decoy_hla.dict
