## Dockerfile to build Docker image for this Snakemake workflow.
FROM ubuntu:20.04

LABEL maintainer = "Jason Charamis" 
LABEL contact    = "jason.charamis@gmail.com"
LABEL build_date = "2023-11-30"
LABEL version    = "v.0.0.1-dev"

# Set environment variables for non-interactive installation of R
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe

# Step 1: Install essential dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl-dev \
        libxml2-dev \
        git \
        python3-pip \
	gzip \
	emacs \
	wget

## Load mambaforge image
FROM condaforge/mambaforge:latest

RUN mkdir -p /conda-envs/rnaseq
COPY envs/rnaseq.yaml /conda-envs/rnaseq/environment.yaml

## Install required packages through conda
RUN mamba env create --prefix /conda-envs/rnaseq --file /conda-envs/rnaseq/environment.yaml && \
    mamba clean --all -y

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl

## Install Python packages, including Snakemake, through pip
RUN /conda-envs/rnaseq/bin/pip3 install wheel && \
    /conda-envs/rnaseq/bin/pip3 install datrie && \
    /conda-envs/rnaseq/bin/pip3 install numpy && \
    /conda-envs/rnaseq/bin/pip3 install snakemake

RUN git clone https://github.com/JasonCharamis/ARuS.git

RUN curl -O -L https://raw.githubusercontent.com/trinityrnaseq/trinityrnaseq/master/Analysis/DifferentialExpression/run_DE_analysis.pl &&\
    curl -O -L https://raw.githubusercontent.com/trinityrnaseq/trinityrnaseq/master/Analysis/DifferentialExpression/analyze_diff_expr.pl
    
RUN mv *.pl ARuS/workflow/scripts

ENV PATH="~/.local:$PATH"
ENV PATH="ARuS:$PATH"
ENV PATH="ARuS/workflow/scripts:$PATH"
ENV PATH="/conda-envs/rnaseq/bin:$PATH"
ENV PATH="/usr/lib/R/bin:$PATH"
