counts_file = 'results/counts.txt'
counts_mod = 'results/counts.mod.txt'
counts_mod_tpm = 'results/counts.mod.tpm'
samples_file = 'results/samples.list'
pca='results/PCA.svg'

rule make_directories:
        input:
               {counts_file},
               {samples_file}
     
        output: 'chkp'

        shell: "mkdir edgeR && 
	       	cd edgeR && 
		mkdir 01_run_DE_analysis && 
		mkdir 02_analyze_DE && 
		cd ../ && 
		cp results/counts.mod.txt edgeR/01_run_DE_analysis/ && 
		cp {samples_file} edgeR/01_run_DE_analysis/ && touch chkp "

rule run_DE_analysis:
        input:  {counts_file},
                {samples_file},
                'chkp'

        output: 'edgeR/chkp01' 

        shell: """ cd edgeR/01_run_DE_analysis && 
	       	   perl run_DE_analysis.pl --matrix ../../results/counts.mod.txt 
		   			   --method edgeR 
					   --samples_file ../../results/samples.list && 
		   cd ../ && touch chkp01 """

rule analyze_DE:
        input: 'edgeR/chkp01'
        output: 'edgeR/chkp02'
	params: log2FC_cutoff=config['log2FC_cutoff']
	
        shell: """ cd edgeR/02_analyze_DE && 
	       	   ln -s ../01_run_DE_analysis/edgeR.*/counts.mod.txt* . && 
		   perl analyze_diff_expr.pl --matrix ../../results/counts.mod.txt 
		   			     --samples ../01_run_DE_analysis/samples.list 
					     -P 1e-3 
					     -C {params.log2FC_cutoff} && 
		   cd ../ && touch chkp02 && 
		   rm ../chkp ../{input} ../{output} """
