#!/bin/bash

mkdir -p ../logs
mkdir -p ../qc

Data=../raw_data

for file in "${Data}"/*.fastq.gz; do
  base=$(basename "$file")   # get filename only
  echo "[ $(date) ] Running fastqc on $base"
  fastqc "$file" -o ../qc > "../logs/${base}_fastqc.log" 2>&1
done

echo "[ $(date) ] fastqc complete for all samples"
