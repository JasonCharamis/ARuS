import re
import numpy as np
import itertools

## wildcards ##

samples = { f[:-11] for f in os.listdir("reads/") if f.endswith(".fastq.gz") }

## create comparisons based on sample names ##
groups = [re.sub("\d+$|_\d+$","",i) for i in samples]
groups = np.unique(groups)

##---------------------------------------------------------------------------
def all_pairs (x):
    samp = (s for s in x)
    comparisons = {}
    
    for sample1, sample2 in itertools.combinations(samp, 2):
        comparisons[str(sample1+"_"+sample2)]=str(sample1+"_vs_"+sample2)   
    return list(comparisons.values())                   
##---------------------------------------------------------------------------

genome_fasta = { f for f in os.listdir("genome") if f.endswith ((".fa")) }
genome_idx = { f[:-3] for f in os.listdir("genome") if f.endswith ((".fa")) }
gtf = { f for f in os.listdir ("genome" ) if f.endswith(".gtf") }
de_subset = all_pairs(groups)

wildcard_constraints: samples="trim"

samples = sorted(samples)
de_subset = sorted(de_subset)

## rules ##
include: '/home/iasonas/snakemake/rnaseq_analysis/rules/trim_reads.smk'
include: '/home/iasonas/snakemake/rnaseq_analysis/rules/build_gnm_idx_and_map_STAR.smk'
include: '/home/iasonas/snakemake/rnaseq_analysis/rules/build_gnm_idx_and_map_hisat2.smk'
include: '/home/iasonas/snakemake/rnaseq_analysis/rules/count.smk'
include: '/home/iasonas/snakemake/rnaseq_analysis/rules/edgeR_de.smk'
include: '/home/iasonas/snakemake/rnaseq_analysis/rules/post_DE.smk'

rule all:
        input:
           expand ('edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.xlsx', de_subset=de_subset)
