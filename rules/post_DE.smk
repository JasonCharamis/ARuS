rule rename:
      input: 'edgeR/02_analyze_DE/counts.mod.txt.{de_subset}.edgeR.DE_results.P1e-3_C2.DE.subset'
      output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.subset'
      shell: " perl rename.pl {input} "

rule reverse_sort:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.tsv', #orthology = 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.tsv'
     output: sorted = 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.tsv'            
     shell: """ perl reverse_sort.pl {input} > {output.sorted} """
     
rule tsv2xlsx:
     input: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.tsv'
     output: 'edgeR/02_analyze_DE/{de_subset}.P1e-3_C2.DE.annotated.plus_orthology.sorted.xlsx'
     shell: """ python3 tsv2xlsx.py {input} """

