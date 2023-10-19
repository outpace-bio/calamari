#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

print(length(args))
print(args[1])
message("Starting working directory is ",args[1])
message("Miseq output directory is ",args[2])

starting_wd <- args[1]
miseq_dir <- args[2]

setwd(miseq_dir)

#load library
if(!("stringr" %in% installed.packages())){
  install.packages("stringr")
}
library(stringr)



fastq_loc <- "Alignment_1"
if(!(fastq_loc %in% list.files())){
  stop("There must be a file name Alignment_1 in your working directory for this script to work!")
}
#path to where fastqs *should* live
fastq_loc <- paste(fastq_loc,list.files(fastq_loc),"Fastq",sep = "/",collapse = "/")

files_in_fastq <- list.files(fastq_loc)

nfastqs <- sum(sapply(files_in_fastq,
       function(x) grepl(".fastq",x,fixed = TRUE)))

if(nfastqs ==0){
  stop(paste("No fastq files detected in subdirectory ",fastq_loc,".",sep = "",collapse = ""))
}

if(!("SampleSheet.csv" %in% list.files())){
  stop("Could not find file SampleSheet.csv directory ", getwd())
}
samplesheet <- read.csv("SampleSheet.csv",row.names = NULL)
write.table(samplesheet,"archived_untransformed_SampleSheet.csv",
            sep = ",",
            row.names = FALSE,col.names = FALSE)


n_to_skip <- which(samplesheet[,1]=="Sample_ID")

if(length(n_to_skip)>0){
samplesheet <- read.csv("SampleSheet.csv",skip = n_to_skip)
}



base_wd <- getwd()
setwd(fastq_loc)
fastq_names <- list.files()

replacement_sheet <- samplesheet
for(id in samplesheet$Sample_ID){
  id <- str_replace_all(id,"_","-")
  which_names <- which(sapply(fastq_names,function(x) grepl(id,x,fixed = TRUE)))
  for(name_ind in which_names){
    old_name <- fastq_names[name_ind]
    samplesheet_row <- which(sapply(samplesheet$Sample_ID,
                              function(x)
                                grepl(x,
                                      str_replace_all(old_name,"-","_"))))
    new_name_piece <- str_replace_all(samplesheet$Sample_Name[samplesheet_row],"_","-")
    new_name <- str_replace(old_name,
                            str_replace_all(samplesheet$Sample_ID[samplesheet_row],"_","-"),
                            new_name_piece)
    file.rename(fastq_names[name_ind],
                new_name)
    
    replacement_sheet$Sample_ID[replacement_sheet$Sample_ID == untransf_id] <- 
      paste(id,new_name_piece,sep = "-",collapse = "-")
    
  }
}

setwd(miseq_dir)

old_sample_sheet <-  read.csv("SampleSheet.csv",row.names = NULL)

old_sample_sheet[n_to_skip + 1:nrow(replacement_sheet),] <- replacement_sheet

write.table(old_sample_sheet,"SampleSheet.csv",
            sep = ",",
            row.names = FALSE,col.names = FALSE)

setwd(starting_wd)


