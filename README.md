# 🧬 Family-Based WES Variant Calling & Prioritization in Focal Epilepsy

![Bash](https://img.shields.io/badge/Bash-Pipeline-lightgrey)
![GATK4](https://img.shields.io/badge/GATK4-Best%20Practices-blue)
![R](https://img.shields.io/badge/R-Visualization-blue)
![Status](https://img.shields.io/badge/status-complete-brightgreen)
![License](https://img.shields.io/badge/license-MIT-yellow)

An end-to-end Whole Exome Sequencing (WES) variant calling and prioritization pipeline, applied to publicly available **family-based focal epilepsy** data — from raw SRA reads to a short list of biologically interpretable candidate variants.

📄 **[Full analysis report →](Report.md)**

---

## 📌 Project Overview

This project implements a complete WES variant-calling workflow following **GATK Best Practices**, applied to a focal epilepsy family trio/quad dataset. It demonstrates a realistic clinical-genomics-style analysis: raw reads → alignment → joint genotyping → annotation → stepwise variant prioritization → candidate gene investigation.

## ❓ Biological Question

> Can high-impact candidate variants associated with focal epilepsy be identified from family-based whole exome sequencing data using a standard variant-calling workflow?

## 🧪 Dataset

| Field | Detail |
|---|---|
| Source | NCBI Sequence Read Archive (SRA) |
| Study objective | Identify pathogenic variants in focal epilepsy patients via WES |
| Reference genome | GRCh38 Full Analysis Set + Decoy + HLA |

**Samples (family-based design):**

| Sample ID | Description |
|---|---|
| SRR22018191 | Proband (Female) |
| SRR22018188 | Mother |
| SRR22018189 | Father |
| SRR22018190 | Brother |
| SRR22018187 | Additional family sample |

## ⚙️ Workflow

```
Raw SRA Data
   │  SRA Toolkit
   ▼
FASTQ Conversion
   │
   ▼
Quality Control ───────────────► FastQC
   │
   ▼
Read Trimming ─────────────────► fastp
   │
   ▼
Reference Preparation (GRCh38 + decoy + HLA)
   │
   ▼
Alignment ─────────────────────► BWA-MEM2
   │
   ▼
BAM Sorting & Alignment QC ────► Samtools
   │
   ▼
WES Metrics
   │
   ▼
Duplicate Marking
   │
   ▼
Variant Calling ───────────────► GATK4 HaplotypeCaller (per-sample GVCF)
   │
   ▼
Combine GVCFs → Joint Genotyping (GATK4)
   │
   ▼
SNP / INDEL Filtering ─────────► GATK4 / bcftools
   │
   ▼
Variant Annotation ────────────► SnpEff, SnpSift
   │
   ▼
Variant Prioritization ────────► R / ggplot2
```

| Step | Tool(s) |
|---|---|
| Download / FASTQ conversion | SRA Toolkit |
| Quality control | FastQC |
| Trimming | fastp |
| Alignment | BWA-MEM2 |
| BAM processing & QC | Samtools |
| Variant calling | GATK4 (HaplotypeCaller, joint genotyping) |
| Filtering | GATK4, bcftools |
| Annotation | SnpEff, SnpSift |
| Prioritization & visualization | R, ggplot2 |

## 📊 Key Results

Stepwise filtering of the annotated variant set:

| Filtering stage | Variant count |
|---|---:|
| All annotated variants | 423,991 |
| Functional variants | 21,740 |
| High-impact variants | 1,041 (898 genes) |
| **NPRL3 candidate variants** | **3** |

**Functional variant classes retained:** missense, frameshift, stop gained, stop lost, start lost, splice-site variants.

**High-impact variant classes:** frameshift, stop gained, stop lost, start lost, splice acceptor, splice donor.

### 🎯 Top candidate gene: NPRL3

| Chromosome | Position | Effect |
|---|---|---|
| chr16 | 86871 | splice_acceptor_variant |
| chr16 | 93296 | stop_gained |
| chr16 | 138304 | splice_acceptor_variant |

**NPRL3** is a component of the **GATOR1 complex**, a negative regulator of mTOR signaling, and has been previously associated with focal epilepsy. The presence of stop-gained and splice-site variants makes it a strong candidate for further investigation.

See **[Report.md](Report.md)** for the full write-up and `Results/Figures/` for the variant prioritization workflow, top variant effects, and top high-impact genes.

## 📁 Repository Structure

```
.
├── Analysis/
│   └── Var_Prior_script.R              # variant prioritization & figures (R)
├── Env/
│   └── var_call_environment.yml        # conda environment specification
├── Results/
│   ├── Figures/
│   │   ├── Var_Priortation_Workflow.png
│   │   ├── Top10_Variant_Effects.png
│   │   └── Top_gene_with_high_impact.png
│   ├── variant_table.csv               # full prioritized variant table
│   └── NPRL3_candidate_variants.csv    # final candidate variants
├── scripts/                             # 01–14: SRA download → annotation
│   ├── 01_download.sh
│   ├── 02_fastqc.sh
│   ├── 03_trim.sh
│   ├── 04_prepare_reference.sh
│   ├── 05_alignment.sh
│   ├── 06_alignment_stats.sh
│   ├── 07_wes_metrics.sh
│   ├── 08_mark_duplicates.sh
│   ├── 09_variant_calling.sh
│   ├── 10_combine_gvcfs.sh
│   ├── 11_genotype_gvcfs.sh
│   ├── 12_(a)_filter_indels.sh
│   ├── 12_(b)_filter_snp.sh
│   ├── 13_merge_variants.sh
│   └── 14_annotation.sh
├── Workflow/
│   └── Wes_Var_call_pipeline.txt        # full pipeline notes/commands
├── Report.md
└── README.md
```

> **Note:** Raw FASTQ/SRA files, the reference genome/index, and intermediate BAM/GVCF files are not included in this repository due to size. Only scripts, the environment spec, results tables, and figures are tracked. See `Env/var_call_environment.yml` to recreate the analysis environment.

## 🚀 Reproducing the Analysis

```bash
# 0. Set up environment
conda env create -f Env/var_call_environment.yml
conda activate var_call_environment

# 1. Download & convert raw reads
bash scripts/01_download.sh

# 2. QC and trimming
bash scripts/02_fastqc.sh
bash scripts/03_trim.sh

# 3. Reference preparation & alignment
bash scripts/04_prepare_reference.sh
bash scripts/05_alignment.sh
bash scripts/06_alignment_stats.sh
bash scripts/07_wes_metrics.sh

# 4. Duplicate marking & variant calling
bash scripts/08_mark_duplicates.sh
bash scripts/09_variant_calling.sh
bash scripts/10_combine_gvcfs.sh
bash scripts/11_genotype_gvcfs.sh

# 5. Filtering & annotation
bash "scripts/12_(a)_filter_indels.sh"
bash "scripts/12_(b)_filter_snp.sh"
bash scripts/13_merge_variants.sh
bash scripts/14_annotation.sh

# 6. Variant prioritization (R)
Rscript Analysis/Var_Prior_script.R
```

Full step-by-step commands are also documented in `Workflow/Wes_Var_call_pipeline.txt`.

## 🛠 Tools & Technologies

- **Download / format conversion:** SRA Toolkit
- **QC:** FastQC
- **Trimming:** fastp
- **Alignment:** BWA-MEM2
- **BAM processing:** Samtools
- **Variant calling:** GATK4 (HaplotypeCaller, joint genotyping)
- **Filtering:** GATK4, bcftools
- **Annotation:** SnpEff, SnpSift
- **Visualization:** R, ggplot2

## 🧾 Conclusion

A complete WES variant-calling workflow reduced 423,991 annotated variants to 1,041 high-impact candidates across 898 genes, narrowing further to **3 high-impact variants in NPRL3** — a GATOR1 complex member and known focal epilepsy candidate gene. Full discussion in [Report.md](Report.md).

## ⚠️ Disclaimer

This project is intended for **educational and portfolio purposes**. The variants identified are bioinformatically derived candidates and have **not been clinically validated**. They should not be interpreted as diagnostic or clinically actionable findings.

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---
*Author: Pratyush — feel free to open an issue or reach out with questions/suggestions.*
