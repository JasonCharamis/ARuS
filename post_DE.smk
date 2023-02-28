
rule annotate_DE:
     input: 'edgeR/02_analyze_DE/{de_subsets}.DE.subset',
     	    'edgeR/chkp02',
	    gene_info = 'genome/Aculy_gene_info_20200924.txt'

     output: 'edgeR/02_analyze_DE/{de_subsets}.DE.annot.tsv'

     shell: """ perl ~/bin/annotate_DE.pl {input[0]} {input.gene_info} | sort -t$"\t" -rk3 > {output[0]} """





