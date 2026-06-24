#!/bin/bash

set -e

mkdir -p ../logs

for bam in ../alignment/*_sorted.bam
do
    base=$(basename $bam _sorted.bam)

    echo "Generating stats for $base"

    samtools flagstat $bam > ../logs/${base}_flagstat.txt

    samtools stats $bam > ../logs/${base}_stats.txt

done
