#Principal components analysis bi-plot using TPM values
#Convert TPM to logTPM values

suppressPackageStartupMessages(library("edgeR"))
library("magrittr")
library("stringr")
library(ggfortify)
library(ggthemes)

library(stringr)


# Get input file from standard input ------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)

stopifnot(length(args) > 0, file.exists(args))

f_counts <- args

# For testing:
# f_counts <- Sys.glob("results/counts.tpm")

#open file from stdin
tpm <- read.table(args[1], header=TRUE)

rownames(tpm) <- tpm[,1]

colnames(tpm) <- str_replace(colnames(tpm), "results.", "")

colnames(tpm) <- str_replace(colnames(tpm), ".s.bam", "")

tpm <- tpm[,-1]

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

pca_res = prcomp(xt, center=T, scale.=F)

pca_res

#draw PCA plot - autoassign group colors
autoplot(pca_res, data = xt, label = TRUE, label.size = 3) + theme_few()
