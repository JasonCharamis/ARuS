
samples = { f[:-19] for f in os.listdir("reads/trimmed") if f.endswith(".fastq.gz") }
genome_fasta = { f for f in os.listdir("genome") if f.endswith ((".fa")) }
genome_idx = { f[:-3] for f in os.listdir("genome") if f.endswith ((".fa")) }
gtf = { f for f in os.listdir ("genome" ) if f.endswith(".gtf") }

samples = sorted(samples)

include: '/data/iasonas/bin/snakemake/rnaseq_analysis/create_directories.smk'
include: '/data/iasonas/bin/snakemake/rnaseq_analysis/trim_reads.smk'
include: '/data/iasonas/bin/snakemake/rnaseq_analysis/build_gnm_idx_and_map_STAR.smk'
#include: '/data/iasonas/bin/snakemake/rnaseq_analysis/build_gnm_idx_and_map_hisat2.smk'
include: '/data/iasonas/bin/snakemake/rnaseq_analysis/count.smk'
include: '/data/iasonas/bin/snakemake/rnaseq_analysis/edgeR_de.smk'

wildcard_constraints: samples="trim"

rule all:
     input:
         expand('reads/trimmed/{sample}_1.trimmed.fastq.gz', sample=samples),
         expand('reads/trimmed/{sample}_2.trimmed.fastq.gz', sample=samples),
         'genome/index_chkp',
         expand('results/{sample}.Aligned.sortedByCoord.out.bam', sample=samples),
         'results/counts.txt',
         'results/counts.mod.txt',
         'results/counts.tpm',
         'Rplots.pdf',
         'results/samples.list',
         'chkp',
         'edgeR/chkp01',
         'edgeR/chkp02'
