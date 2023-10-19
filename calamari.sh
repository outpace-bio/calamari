#! /bin/bash

while getopts a:d:q: flag
do
  case "${flag}" in
    a) FASTAS_DIR="${OPTARG}" ;;
    d) DOCKER_IMAGE="${OPTARG}" ;;
    q) MISEQ_OUTPUTS="${OPTARG}" ;;
  esac
done

#
echo "Fasta directory set to ${FASTAS_DIR}."
echo "Docker image specified as ${DOCKER_IMAGE}."
echo "Miseq output directory set to ${MISEQ_OUTPUTS}."

#download fasta creation script, move it, and run it
curl -o csv_to_fasta.R https://raw.githubusercontent.com/outpace-bio/calamari/main/csv_to_fasta.R
mv csv_to_fasta.R $FASTAS_DIR
Rscript "${FASTAS_DIR}/csv_to_fasta.R" $(pwd) $FASTAS_DIR

# download fastq processing script, move it, and run it
curl -o rename_fastqs.R https://raw.githubusercontent.com/outpace-bio/calamari/main/rename_fastqs.R
mv rename_fastqs.R $MISEQ_OUTPUTS
Rscript "${MISEQ_OUTPUTS}/rename_fastqs.R" $(pwd) $MISEQ_OUTPUTS

#run Octant's pipeline script
./run-octopus-analysis.sh -a $FASTAS_DIR -d $DOCKER_IMAGE -q $MISEQ_OUTPUTS