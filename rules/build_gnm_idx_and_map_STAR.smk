rule build_genome_index:
        output: 'genome/index_chkp'
        shell: "STAR --runThreadN 12 --runMode genomeGenerate --genomeDir genome/ --genomeFastaFiles genome/{genome_fasta} --sjdbGTFfile genome/{gtf} --sjdbOverhang 149 && touch genome/index_chkp"

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

     threads: 8
     message: "Mapping reads to genome and converting to sorted BAM"

     shell: " STAR --runThreadN {threads} --readFilesIn {input.r1_trimmed} {input.r2_trimmed} --genomeDir genome --outSAMtype BAM SortedByCoordinate --outFileNamePrefix results/{wildcards.sample}. "
