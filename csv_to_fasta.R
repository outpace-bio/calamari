
if(!("seqinr" %in% installed.packages())){
  install.packages("seqinr")
}
library(seqinr)

plasmids <- read.csv("fastas.csv")
plasmids$Sequence <- sapply(plasmids$Sequence,
                            tolower)

write.fasta(sequences = lapply(1:nrow(plasmids), function(i) plasmids$Sequence[i]),
            names = plasmids$Registry.ID,
            file.out = "fastas.fasta")
