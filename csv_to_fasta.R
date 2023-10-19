
if(!("seqinr" %in% installed.packages())){
  install.packages("seqinr")
}
library(seqinr)
args = commandArgs(trailingOnly=TRUE)

message("Starting working directory is ",args[1])
message("Fastas output directory is ",args[2])

setwd(args[2])

message(paste("Converting csv file in ",getwd()," to fasta file.",sep = ""))
filenames <- list.files()
if(length(filenames)==0){
  stop("You must include a csv file containing reference sequences in your fastas directory.")
}
which_csv <- sapply(filenames,function(x) grepl(".csv",x,fixed = TRUE))
if(sum(which_csv) ==0){
  stop("No csv file detected in fastas directory.")
}

if(sum(which_csv)>1){
  stop("More than one csv file detected in fastas directory.")
}

fasta_csv_file <- filenames[which_csv]

plasmids <- read.csv(fasta_csv_file)
plasmids$Sequence <- sapply(plasmids$Sequence,
                            tolower)

write.fasta(sequences = lapply(1:nrow(plasmids), function(i) plasmids$Sequence[i]),
            names = plasmids$Registry.ID,
            file.out = "fastas.fasta")

setwd(args[1])
