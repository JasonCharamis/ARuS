rule rename:
      input: 'edgeR/02_analyze_DE/counts.mod.txt.{de_subset}.edgeR.DE_results.P1e-3_C2.DE.subset'
      output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.subset'
      shell: " perl scripts/rename.pl {input} "

rule annotate_DE:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.subset', gene_info='genome/Aculy_gene_info_20200924.txt'
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.tsv'
     shell: """ perl ~/snakemake/rnaseq_analysis/scripts/annotate_DE.pl {input[0]} {input.gene_info} > {output} """

rule add_orthology:
     input: annotated = 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.tsv',
            ortho_info = "/home/iasonas/transcriptomes/aculops/new_analysis/orthology_analysis/OrthoFinder/Results_Jun02/Orthogroups/Orthogroups.txt"
            
     output: orthology = 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.tsv',
             orthology_sorted = 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.tsv'
             
     shell: """ perl ~/snakemake/rnaseq_analysis/scripts/add_orthology_to_modified_edgeR_DE_output2.pl  {input.annotated} {input.ortho_info} > {output.orthology} && perl ~/snakemake/rnaseq_analysis/scripts/schwartz_transform.pl {output.orthology} > {output.orthology_sorted} """

rule tsv2xlsx:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.tsv'
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.xlsx'
     shell: """ python3 ~/snakemake/rnaseq_analysis/scripts/tsv2xlsx.py {input} """

