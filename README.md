# calamari
Some help with our cephalopod friends

## To run pipeline

### (1) Clone https://github.com/octantbio/octopus3 into a folder on your local machine

### (2) Download https://raw.githubusercontent.com/outpace-bio/calamari/main/calamari.sh into the folder containing octopus3 (see previous step)

### (3) If desired, inside octopus3 folder, edit src/variant-calling.sh so that line 61 reads  --min-base-quality 30 \ (default is 20)

### (4) Inside octopus3 folder, create data folder to contain miseq output and reference fastas

### (5) Inside above data folder, create a uniquely named folder for miseq output. This folder should contain a sample sheet named SampleSheet.csv and a folder named Alignment_1 a subdirectory of which contains fastq files produced by miseq.

### (6) Also inside above data folder, create a uniquely named folder for reference fastas. This folder should contain a csv file containing reference sequences in a column named "Sequence" and unique sequence identifiers in a column named "Registry ID".

### (7) Make sure Docker Desktop is started and an image for Octopus3 named octopus3:release is built. If this image is not available, follow directions on Octopus3 github to build it.

### (8) In terminal, navigate to octopus3 folder containing calamari.sh and run this script with ./calamari.sh -a $(pwd)/[FASTAS DIR] -q $(pwd)/[MISEQ DIR] -d octopus3:release. The pipeline should run from this point.

Note: you must have a functioning internet connection to run calamari.sh.


