

rule create_directories:
     output: "reads/",
     	     "genome/",
	     "results/",
	     "edgeR/",
	     "edgeR/01_run_DE_analysis",
	     "edgeR/02_analyze_DE"

     shell:
             "mkdir {output[0]} && mkdir {output[1]} && mkdir {output[2]} && mkdir {output[3]} && mkdir {output[4]} && mkdir {output[5]} && mkdir {output[6]}"