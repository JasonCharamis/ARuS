
#this rule does not need any input to run
rule build_genome_index:
	output: 'genome/index_chkp'
	shell: "hisat2-build -p 8 genome/{genome_fasta} genome/{genome_idx} && mkdir results/ && touch genome/index_chkp"

rule mapping:
	input:
		r1_trimmed = 'reads/{sample}_1.trimmed.fastq.gz',
		r2_trimmed = 'reads/{sample}_2.trimmed.fastq.gz'
		
	output:
		bam_file = protected('results/{sample}.s.bam')

	threads: 8
	
	message: "Mapping reads to genome and converting SAM to BAM files using samtools"

	shell: "hisat2 --dta-cufflinks --threads 8 -x genome/{genome_idx} -1 {input.r1_trimmed} -2 {input.r2_trimmed} | samtools view -b --threads 5 | samtools sort -m 32G --threads 5 -o {output.bam_file} && samtools index -@ 5 {output.bam_file}"

