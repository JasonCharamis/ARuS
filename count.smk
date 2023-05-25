
rule count:
        input: expand('results/{sample}.Aligned.sortedByCoord.out.bam', sample = samples)
        output: 'results/counts.txt'
        shell: "/data/iasonas/Programs/Subread/featureCounts -M -s 0 -T 12 -p -t exon -g gene_id -a genome/{gtf} -o {output} {input}"

rule modify:
        input: "results/counts.txt"
        output: "results/counts.mod.txt"
        shell: "perl ~/bin/snakemake/rnaseq_analysis/counts_mod.pl {input} > {output}"

rule samples_list:
        input: rules.modify.output
        output: samples_list = "results/samples.list"
        shell: " perl /data/iasonas/bin/counts_to_samples_list.pl {input} | sort -Vk2 > {output.samples_list}"

rule counts_to_tpm:
        input: counts="results/counts.txt",
               file = "results/samples.list"

        output: counts_tpm = "results/counts.tpm"
        shell: """ perl ~/bin/counts_to_tpm.pl {input.counts} > {output.counts_tpm} """

rule pca:
     input: "results/counts.tpm"
     output: "Rplots.pdf"
     shell: "Rscript ~/bin/snakemake/rnaseq_analysis/pca.R {input}"






