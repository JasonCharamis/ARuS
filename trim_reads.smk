rule fastqc:
        input:  'reads/{sample}_1.fastq.gz',
                'reads/{sample}_2.fastq.gz'

        output: "reads/fastqc/{sample}_fastqc/fastqc_report.html"

        shell: "mkdir fastqc && fastqc {input} -t 12"

rule trim_reads:
        input: 
                r1 = 'reads/{sample}_1.fastq.gz',
                r2 = 'reads/{sample}_2.fastq.gz'

        output:
                r1_trimmed = 'reads/trimmed/{sample}_1.trimmed.fastq.gz',
                r2_trimmed = 'reads/trimmed/{sample}_2.trimmed.fastq.gz',
                r1_garbage = temp('reads/{sample}_1.garbage.fastq.gz'),
                r2_garbage = temp('reads/{sample}_2.garbage.fastq.gz')
                
        threads: 8

        message: "Adapter-trimming reads"

        shell: "java -jar /home/iasonas/Programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads {threads} {input.r1} {input.r2} {output.r1_trimmed} {output.r1_garbage} {output.r2_trimmed} {output.r2_garbage} ILLUMINACLIP:/home/pioannidis/Programs/trimmomatic_0.39/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 && mkdir trimmed && mv *trimmed* trimmed/"
