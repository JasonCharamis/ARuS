
samples = { f[:-11] for f in os.listdir("reads") if f.endswith("\d+.fastq.gz")  }
genome_fasta = { f for f in os.listdir("genome") if f.endswith ((".fa")) }
genome_idx = { f[:-3] for f in os.listdir("genome") if f.endswith ((".fa")) }
gtf = { f for f in os.listdir ("genome" ) if f.endswith(".gtf") }
#de_subsets = { f[:-10] for f in os.listdir("edgeR/02_analyze_DE/") if f.endswith("DE.subset") }
samples = sorted(samples)

include: 'create_directories.smk'

include: 'trim_reads.smk'

include: 'build_gnm_idx_and_map.smk'

include: 'count.smk'

include: 'edgeR_de.smk'

inlude: 'post_DE.smk'

rule all:
     input:
          "reads/",
          "genome/",
          "results/",
          "edgeR/",
          "edgeR/01_run_DE_analysis",
          "edgeR/02_analyze_DE",
          expand('reads/{sample}_1.trimmed.fastq.gz', sample=samples),
          expand('reads/{sample}_2.trimmed.fastq.gz', sample=samples),
          'genome/index_chkp',
          expand('results/{sample}.s.bam', sample=samples),
          'results/counts.txt',
          'results/counts.mod.txt',
          'results/counts.tpm',
          'Rplots.pdf',
          'results/samples.list',
          'chkp',
          'edgeR/chkp01',
          'edgeR/chkp02',
          #expand('edgeR/02_analyze_DE/{comparison}.DE.annot.tsv', comparison=de_subsets)


