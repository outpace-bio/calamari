
if(!("stringr" %in% installed.packages())){
  install.packages("stringr")
}
if(!("rstudioapi" %in% installed.packages())){
  install.packages("rstudioapi")
}

library(stringr)
library("rstudioapi")

#make sure we are in directory 
wd <- getSourceEditorContext()$path
wd <- gsub("/rename_fastqs.R","",wd)
setwd(wd)

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


n_to_skip <- which(samplesheet[,1]=="Sample_ID")

if(length(n_to_skip)>0){
samplesheet <- read.csv("SampleSheet.csv",skip = n_to_skip)
}



base_wd <- getwd()
setwd(fastq_loc)
fastq_names <- list.files()

if(!("Sample_Name" %in% colnames(samplesheet))){
  samplesheet$Sample_Name <- apply(samplesheet,1,
                                   function(x) paste(x["Sample_Plate"],x["Sample_Well"],collapse = "_",
                                                     sep = "_"))
  
  for_ss_replacement <- read.csv(paste(base_wd,"/SampleSheet.csv",sep = ""),header= FALSE)
  which_start <- which(for_ss_replacement[,1] == "Sample_ID") 
  for_ss_replacement <- cbind(for_ss_replacement,"")
  for_ss_replacement[which_start:nrow(for_ss_replacement),ncol(for_ss_replacement)] <- 
    c("Sample_Name",samplesheet$Sample_Name)
  
  write.table(for_ss_replacement,paste(base_wd,"/SampleSheet.csv",sep = ""),
              sep = ",",
                                     row.names = FALSE,col.names = FALSE)
    
}

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
  }
}

setwd(base_wd)
