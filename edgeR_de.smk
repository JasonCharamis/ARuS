counts_file = 'results/counts.txt'
counts_mod = 'results/counts.mod.txt'
samples_file = 'results/samples.list'
pca = 'Rplots.pdf'

#universal samples name format {sample}\_{replicate_number <=9}\_{1 || 2 - paired reads}.fastq.gz
rule make_directories:
        input: {pca},
               {counts_file},
               {samples_file}
     
        output: 'chkp'

        shell: "mkdir edgeR && cd edgeR && mkdir 01_run_DE_analysis && mkdir 02_analyze_DE && cd ../ && cp results/counts.mod.txt edgeR/01_run_DE_analysis/ && cp {samples_file} edgeR/01_run_DE_analysis/ && touch {output}"

rule run_DE_analysis:
        input:  {counts_file},
                {samples_file},
                'chkp'

        output: 'edgeR/chkp01' 

        shell: "cd edgeR/01_run_DE_analysis && Trinity/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix ../../results/counts.mod.txt --method edgeR --samples_file ../../{samples_file} && cd ../ && touch chkp01"

rule analyze_DE:
        input: 'edgeR/chkp01'

        output: 'edgeR/chkp02'

        shell: "cd edgeR/02_analyze_DE && ln -s ../01_run_DE_analysis/edgeR.*/counts.mod.txt* . && /data/iasonas/Programs/Trinity/Analysis/DifferentialExpression/analyze_diff_expr.pl --matrix ../../results/counts.mod.txt --samples ../01_run_DE_analysis/samples.list -P 1e-3 -C 1 && cd ../ && touch chkp02"
