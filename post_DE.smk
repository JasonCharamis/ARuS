rule rename:
      input: 'edgeR/02_analyze_DE/counts.mod.txt.{de_subset}.edgeR.DE_results.P1e-3_C2.DE.subset'
      output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.subset'
      shell: " perl scripts/rename.pl {input} "

rule annotate_DE:
     input: de_file='edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.subset',
            gene_info = config['gene_info']
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.tsv'

     shell: """ perl annotate_DE.pl {input.de_file} {input.gene_info} > {output} """

rule add_orthology:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.tsv', "/OrthoFinder/Results_May26/Orthologues/Aculy.tsv"
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.tsv'
     shell: "perl scripts/add_orthology_to_modified_edgeR_DE_output.pl {input[0]} {input[1]} > {output}"

rule tsv2xlsx:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.tsv'
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.xlsx'

     shell: """ python3 scripts/tsv2xlsx.py {input[0]} """



