#!/bin/bash

# Create raw_data and logs folders if they don't exist
mkdir -p ../raw_data
mkdir -p ../logs

# Move to raw_data directory
cd ../raw_data || exit

# Sample SRR IDs
SRR_IDS=(
  "SRR22018187" "SRR22018189" "SRR22018190" 
"SRR22018191" "SRR22018188"
)

for SRR in "${SRR_IDS[@]}"; do
  echo "[$(date)] Prefetching $SRR..."
  prefetch "$SRR" --output-directory "$(pwd)" > "../logs/${SRR}_prefetch.log" 2>&1

  echo "[$(date)] Converting $SRR to FASTQ..."
  fasterq-dump "$SRR" --split-files --threads 4 --outdir "$(pwd)" > "../logs/${SRR}_fastq.log" 2>&1

  gzip "${SRR}"_*.fastq  # Compress the fastq files after conversion

  echo "[$(date)] $SRR completed."
done

echo "All downloads and conversions completed on [$(date)]."
