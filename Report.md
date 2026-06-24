# Identification and Prioritization of High-Impact Variants from Family-Based Whole Exome Sequencing Data in Focal Epilepsy

---

## 1. Introduction

Epilepsy is a neurological disorder characterized by recurrent seizures arising from abnormal neuronal activity. Advances in next-generation sequencing (NGS) have made it possible to identify genetic variants underlying different forms of epilepsy. Whole Exome Sequencing (WES) is widely used for this purpose, as it targets protein-coding regions of the genome where a large proportion of disease-causing variants occur.

The objective of this project was to implement a complete WES variant-calling workflow and prioritize potentially functional variants from a family-based focal epilepsy dataset, demonstrating practical skills in NGS data processing, variant discovery, annotation, and biological interpretation.

---

## 2. Dataset

**Data source:** Publicly available whole-exome sequencing data obtained from the NCBI Sequence Read Archive (SRA).

**Study objective:** Identify pathogenic variants in patients with focal epilepsy using whole-exome sequencing.

**Samples included (family-based design):**

| Sample ID | Description |
|---|---|
| SRR22018191 | Proband (Female) |
| SRR22018188 | Mother |
| SRR22018189 | Father |
| SRR22018190 | Brother |
| SRR22018187 | Additional family sample |

**Reference genome:** GRCh38 Full Analysis Set + Decoy + HLA

---

## 3. Methods

### 3.1 Variant calling workflow

```
Raw SRA Data → FASTQ Conversion → Quality Control (FastQC) → Read Trimming (fastp)
   → Reference Preparation → Alignment (BWA-MEM2) → BAM Sorting
   → Alignment Quality Assessment → WES Metrics → Duplicate Marking
   → Variant Calling (GATK4 HaplotypeCaller) → GVCF Generation → Joint Genotyping
   → SNP/INDEL Filtering → Variant Annotation (SnpEff/SnpSift) → Variant Prioritization
```

The pipeline was implemented as a sequence of Linux shell scripts (`scripts/01_download.sh` through `scripts/14_annotation.sh`), with downstream prioritization and visualization performed in R.

### 3.2 Software used

- SRA Toolkit
- FastQC
- fastp
- BWA-MEM2
- Samtools
- GATK4 (HaplotypeCaller, joint genotyping, variant filtering)
- bcftools
- SnpEff / SnpSift
- R, ggplot2

---

## 4. Results

### 4.1 Variant prioritization

The annotated dataset initially contained **423,991 variants**. A stepwise filtering strategy was applied to progressively narrow this to biologically relevant candidates:

| Stage | Variant count |
|---|---:|
| All annotated variants | 423,991 |
| Functional variants | 21,740 |
| High-impact variants | 1,041 |
| NPRL3 candidate variants | 3 |

*See `Results/Figures/Var_Priortation_Workflow.png` for the visual summary of this filtering cascade.*

**Functional variant classes retained:** missense, frameshift, stop gained, stop lost, start lost, and splice-site variants.

### 4.2 Variant effect distribution

The majority of variants were located in non-coding genomic regions, such as introns, upstream, and downstream regions. Functional filtering substantially reduced the candidate set to variants more likely to affect protein structure or RNA processing.

*See `Results/Figures/Top10_Variant_Effects.png`.*

### 4.3 High-impact variant analysis

High-impact variants were extracted based on predicted functional consequence, including:

- Frameshift variants
- Stop gained variants
- Stop lost variants
- Start lost variants
- Splice donor variants
- Splice acceptor variants

A total of **1,041 high-impact variants affecting 898 genes** were identified.

*See `Results/Figures/Top_gene_with_high_impact.png` for the genes with the highest burden of high-impact variants.*

---

## 5. Candidate Gene Investigation

To identify biologically relevant candidates, high-impact variants were screened against genes previously associated with epilepsy. This screen identified **three high-impact variants in NPRL3**.

### NPRL3 candidate variants

| Chromosome | Position | Effect |
|---|---|---|
| chr16 | 86871 | splice_acceptor_variant |
| chr16 | 93296 | stop_gained |
| chr16 | 138304 | splice_acceptor_variant |

**NPRL3** is a component of the **GATOR1 complex**, which negatively regulates the mTOR signaling pathway. Pathogenic variants in NPRL3 have previously been associated with focal epilepsy and related neurodevelopmental disorders, often through loss-of-function mechanisms that de-repress mTOR signaling.

The identified stop-gained and splice-acceptor variants are both classes typically associated with loss of gene function, making NPRL3 a strong candidate for further investigation — for example, via Sanger validation, segregation analysis within the family, or functional studies.

---

## 6. Conclusion

This project implemented a complete whole-exome sequencing variant-calling workflow using publicly available family-based focal epilepsy data. Starting from raw sequencing reads, the pipeline performed quality control, alignment, variant calling, joint genotyping, filtering, annotation, and stepwise variant prioritization.

A total of 423,991 annotated variants were reduced to 1,041 high-impact variants through functional filtering, and further prioritization identified **three candidate loss-of-function variants in NPRL3** — a gene previously implicated in focal epilepsy via mTOR pathway dysregulation.

The project demonstrates practical, end-to-end skills in NGS analysis, GATK Best Practices-based variant calling, variant annotation, data visualization, and biological interpretation of genomic variants in a clinically motivated context.

---

## 7. Limitations

- Family-based design with a small number of individuals limits the statistical power for formal segregation or linkage-based inference.
- Candidate variants were prioritized computationally and have **not been experimentally or clinically validated**.
- Gene-level prioritization relied on a curated epilepsy gene list; variants in genes outside this list were not further investigated, and some may still be biologically relevant.
- No structural variant or copy-number variant analysis was performed; the workflow is limited to SNPs and small indels detectable by GATK HaplotypeCaller.

---

## 8. Skills Demonstrated

- Whole Exome Sequencing (WES) analysis
- NGS data processing and quality control
- Linux shell scripting for reproducible pipelines
- GATK4 Best Practices (HaplotypeCaller, joint genotyping, filtering)
- Variant annotation (SnpEff/SnpSift)
- Variant prioritization strategy design
- Data visualization in R (ggplot2)
- Biological interpretation of candidate genetic variants

---

## 9. Disclaimer

This project is intended for **educational and portfolio purposes**. The identified variants are candidate variants derived from a bioinformatics analysis pipeline and should not be interpreted as clinically validated findings.
