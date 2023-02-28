This is a Snakemake pipeline for running automated genome mapping-based RNAseq analysis. 

This

The pipeline is designed for paired-end Illumina reads and it includes:

1. Read quality control (QC) and adapter-trimming
2. Mapping of reads against provided genome sequence
3. Assign mapped reads to genes - this step also computes TPM values and uses them to produce a PCA plot
4. Differential expression (DE) analysis using edgeR

Dependencies:

FASTQC

https://github.com/s-andrews/FastQC


Trimommatic

https://github.com/usadellab/Trimmomatic


hisat2

https://github.com/DaehwanKimLab/hisat2


featureCounts

https://github.com/torkian/subread-1.6.1


edgeR

https://bioconductor.org/packages/release/bioc/html/edgeR.html


Trinity-bundled Perl scripts for DE analysis using edgeR

https://github.com/trinityrnaseq/trinityrnaseq

