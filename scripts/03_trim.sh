#!/bin/bash

mkdir -p ../trimmed 
mkdir -p ../qc 

for r1 in ../raw_data/*_1.fastq.gz
do
    r2=${r1/_1.fastq.gz/_2.fastq.gz}

    base=$(basename $r1 _1.fastq.gz)

    fastp \
    -i $r1 \
    -I $r2 \
    -o ../trimmed/${base}_1_trimmed.fastq.gz \
    -O ../trimmed/${base}_2_trimmed.fastq.gz \
    -h ../qc/${base}_fastp.html \
    -j ../qc/${base}_fastp.json \
    -w 6 \
    --detect_adapter_for_pe
done
