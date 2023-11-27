rule build_genome_index:
        output: 'genome/index_chkp'
	
	params: genome_fasta=config['genome_fasta'],
		gtf=config['gtf']

	threads: star_threads=config['star_build_threads']

	message: "Building genome index"

        shell: "STAR --runThreadN {threads.star_threads} 
	       	     --runMode genomeGenerate 
		     --genomeDir genome/ 
		     --genomeFastaFiles genome/{params.genome_fasta} 
		     --sjdbGTFfile genome/{params.gtf} 
		     --sjdbOverhang 149 && 
		
		mkdir results/ && touch genome/index_chkp"

rule gunzip:
     input:
        'reads/trimmed/{sample}_1.trimmed.fastq.gz',
        'reads/trimmed/{sample}_2.trimmed.fastq.gz'

     output:
        'reads/trimmed/{sample}_1.trimmed.fastq',
        'reads/trimmed/{sample}_2.trimmed.fastq'

     shell: "gunzip {input}"


rule mapping:
     input:
        r1_trimmed = 'reads/trimmed/{sample}_1.trimmed.fastq',
        r2_trimmed = 'reads/trimmed/{sample}_2.trimmed.fastq'

     output: protected('results/{sample}.Aligned.sortedByCoord.out.bam')

     threads: star_threads=config['star_map_threads']
     message: "Mapping reads to genome and converting to sorted BAM"

     shell: " STAR --runThreadN {threads} 
     	      	   --readFilesIn {input.r1_trimmed} {input.r2_trimmed} 
		   --genomeDir genome 
		   --outSAMtype BAM SortedByCoordinate 
		   --outFileNamePrefix results/{wildcards.sample}. "
