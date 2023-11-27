
rule build_genome_index:
	output: 'genome/index_chkp'
	params: hisat2_build_threads = config['hisat2_build_threads']
	shell: "hisat2-build -p {params.hisat2_build_threads} genome/{genome_fasta} genome/{genome_idx} && 
	        mkdir results/ && touch genome/index_chkp"

rule mapping:
	input:
		r1_trimmed = 'reads/{sample}_1.trimmed.fastq.gz',
		r2_trimmed = 'reads/{sample}_2.trimmed.fastq.gz'
		
	output:
		bam_file = protected('results/{sample}.s.bam')

	threads: 8
	
	message: "Mapping reads to genome and converting SAM to BAM files using samtools"

	params:
		hisat2_map_threads=config['hisat2_map_threads']
		samtools_threads=config['samtools_threads']

	shell: "hisat2 --dta-cufflinks 
	       	       --threads {params.hisat2_map_threads} 
		       -x genome/{genome_idx} 
		       -1 {input.r1_trimmed} -2 {input.r2_trimmed} | 
		
		samtools view -b - | 
		samtools sort -m 32G --threads {params.samtools_threads} -o {output.bam_file} && 
		samtools index -@ {params.samtools_threads} {output.bam_file}"

