
rule count:
        input: expand('results/{sample}.Aligned.sortedByCoord.out.bam', sample = samples)
        threads: config['featureCounts_threads']
        output: 'results/counts.txt'
	params: gtf=config['gtf']
        shell: " featureCounts -M 
	       	 	       -s 0 
			       -T {threads} 
			       -p 
			       -t exon 
			       -g gene_id 
			       -a genome/{gtf} 
			       -o {output} {input} "

rule modify:
        input: "results/counts.txt"
        output: "results/counts.mod.txt"
        shell: " perl counts_mod.pl {input} > {output} "

rule samples_list:
        input: rules.modify.output
        output: samples_list = "results/samples.list"
        shell: " perl counts_to_samples_list.pl {input} | 
	       	 sort -Vk2 > {output.samples_list} "

rule counts_to_tpm:
        input: counts="results/counts.txt",
               file = "results/samples.list"

        output: counts_mod_tpm="results/counts.mod.tpm"
        shell: """ perl counts_to_tpm.pl {input.counts} | 
	       	   sed 's/\.Aligned\.sortedByCoord\.out\.bam//g' | 
		   sed 's/gene\://g' | 
		   sed 's/results\///g' > {output.counts_mod_tpm}"""

rule pca:
     input: "results/counts.mod.tpm"
     output: "results/PCA.svg"
     shell: " Rscript pca.R {input} && 
     	      mv PCA.svg results/ "