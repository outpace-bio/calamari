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


curl -o rename_fastqs.R https://raw.githubusercontent.com/outpace-bio/calamari/main/rename_fastqs.R
mv rename_fastqs.R $MISEQ_OUTPUTS

Rscript "${MISEQ_OUTPUTS}/rename_fastqs.R"

./run-octopus-analysis.sh -a $FASTAS_DIR -d $DOCKER_IMAGE -q $MISEQ_OUTPUTS