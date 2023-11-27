FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

## Dockerfile to build Docker image for this Snakemake workflow.
FROM ubuntu:20.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe

# Step 1: Install essential dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        git \
        python3-pip \
	gunzip \
	wget

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Set conda on the PATH
ENV PATH /opt/conda/bin:$PATH
RUN conda init --all

# Step 2: Install R without prompts
RUN apt-get install -y --no-install-recommends \
        r-base \
        r-base-dev \
        && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV PATH /usr/lib/R/bin:$PATH

# Step 2: Retrieve conda environments

RUN conda install -c bioconda fastqc &&\
    conda install -c bioconda trimmomatic &&\
    conda install -c bioconda star &&\
    conda install -c bioconda subread &&\
    conda install -c conda-forge r-essentials

# Install BiocManager
RUN R -e 'install.packages("BiocManager", repos="https://cran.rstudio.com")'

# Install required R packages using BiocManager
RUN R -e 'BiocManager::install(c("limma", "voom", "edgeR"))'

# Install other required R packages from CRAN
RUN R -e 'install.packages(c("dplyr", "magrittr", "stringr", "ggplot2", "ggfortify", "ggthemes", "ggrepel", "stringi", "tidyverse"), repos="https://cran.rstudio.com")'

# Step 3: Install and test Snakemake

RUN conda install wheel &&\
    conda install snakemake

RUN git clone Automated-RNAseq-analysis-using-Snakemake.git &&\
    git clone https://github.com/JasonCharamis/Snakemake_utils.git

ENV PYTHONPATH="$PYTHONPATH:Snakemake_utils"

RUN curl -O -L https://raw.githubusercontent.com/trinityrnaseq/trinityrnaseq/master/Analysis/DifferentialExpression/run_DE_analysis.pl &&\
    curl -O -L https://raw.githubusercontent.com/trinityrnaseq/trinityrnaseq/master/Analysis/DifferentialExpression/analyze_diff_expr.pl

RUN mv *.pl Automated-RNAseq-analysis-using-Snakemake/workflow/scripts

ENV PATH="~/.local:$PATH"
ENV PATH="Automated-RNAseq-analysis-using-Snakemake:$PATH"
ENV PATH="Automated-RNAseq-analysis-using-Snakemake/workflow/scripts:$PATH"

CMD ["Everything installed!"]