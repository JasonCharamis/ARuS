#Principal components analysis bi-plot using TPM values
#Convert TPM to logTPM values

suppressPackageStartupMessages(library("edgeR"))
library("magrittr")
library("stringr")
library(ggfortify)
library(ggthemes)
library("stringi")
library(dplyr)
library(tidyverse)

# Get input file from standard input ------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)

stopifnot(length(args) > 0, file.exists(args))

f_counts <- args

#open file from stdin
tpm <- read.table(args[1], header=TRUE)

## make first column as rownames ## 
rownames(tpm) <- tpm[,1]
tpm <- tpm[,-1]

## transform colnames to same syntax ##
colnames(tpm) <- str_replace(colnames(tpm), "PSKW_|results.|.s.bam|_", "")

tpm <- as.matrix(tpm)

#function to convert tpm to logtpm
logTPM <- function(tpm, dividebyten=TRUE) {
  if(dividebyten) {
    logtpm <- log(tpm/10+1, 2)}
  else if(!dividebyten) {
    logtpm <- log(tpm+1, 2)}
  return(logtpm)
}

#convert to logtpms
logtpms<-logTPM(tpm, dividebyten = FALSE)

#run PCA analysis
xt = t(logtpms)

xt <- as.data.frame(xt)

groups <- str_replace(rownames(xt), "\\d$", "")

xtl <- xt %>% add_column(Sample = groups)

pca_res = prcomp(xt, center=T, scale.=F)

svg("PCA.svg")

#draw PCA plot - make a dataframe like iris with Species as the replicate variable - see iris and xt file structure
print ( autoplot(pca_res, data=xtl, colour='Sample', label = TRUE, label.size = 3) + theme_few() )

dev.off()
