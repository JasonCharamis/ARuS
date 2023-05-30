
samples = { f[:-11] for f in os.listdir("reads") if f.endswith(".fastq.gz") }
genome_fasta = { f for f in os.listdir("genome") if f.endswith ((".fa")) }
genome_idx = { f[:-3] for f in os.listdir("genome") if f.endswith ((".fa")) }
gtf = { f for f in os.listdir ("genome" ) if f.endswith(".gtf") }
de_subsets = { f[:-36] for f in os.listdir("edgeR/02_analyze_DE/") if f.endswith("DE.subset") }

samples = sorted(samples)
de_subsets = sorted(de_subsets)

include: 'rules/create_directories.smk'
include: 'rules/trim_reads.smk'
include: 'rules/build_gnm_idx_and_map_STAR.smk'
#include: 'rules/build_gnm_idx_and_map_hisat2.smk'
include: 'rules/count.smk'
include: 'rules/edgeR_de.smk'
include: 'rules/post_DE.smk'

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
         'results/PCA.svg',
         'results/samples.list',
         'chkp',
         'edgeR/chkp01',
         'edgeR/chkp02',
         expand ( 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.tsv', de_subset=de_subsets ),   
         expand ( 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.xlsx', de_subset=de_subsets )

