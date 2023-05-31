rule rename:
      input: 'edgeR/02_analyze_DE/counts.mod.txt.{de_subset}.edgeR.DE_results.P1e-3_C2.DE.subset'
      output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.subset'
      shell: " perl scripts/rename.pl {input} "

rule annotate_DE:
     input: de_file='edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.subset',
            gene_info = 'genome/Aculy_gene_info_20200924.txt'
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.tsv'

     shell: """ perl cripts/annotate_DE.pl {input.de_file} {input.gene_info} > {output[0]} """

rule add_orthology:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.tsv', "OrthoFinder/Results_May26/Orthologues/Aculy.tsv"
     output: orthology = 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.tsv',
             orthology_sorted = 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.tsv'
     shell: " perl scripts/add_orthology_to_modified_edgeR_DE_output.pl {input[0]} {input[1]} > {output} && perl scripts/schwartz_transform.pl {output.orthology} > {output.orthology_sorted} "

rule tsv2xlsx:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.tsv'
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.xlsx'

     shell: """ python3 scripts/tsv2xlsx.py {input[0]} """

