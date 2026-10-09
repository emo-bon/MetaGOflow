#!/bin/bash

#SBATCH --partition=fat
#SBATCH --nodes=1
#SBATCH --nodelist=
#SBATCH --ntasks-per-node=40
#SBATCH --mem=
#SBATCH --mail-user=haris.zafr@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --requeue
#SBATCH --job-name="tara4IPS"
#SBATCH --output=tara4cpusIPS.output

# Deactivate conda if already there
conda deactivate

# Load module
module load python/3.7.8
module load singularity/3.7.1 


# Run the wf with mini dataset
# ./run_wf.sh -f test_input/wgs-paired-SRR1620013_1.fastq.gz -r test_input/wgs-paired-SRR1620013_2.fastq.gz -n mini_dataset -d MINI_DATASET -s 

# Run the wf with short dataset
# ./run_wf.sh -f test_input/test_1_fwd_HWLTKDRXY_600000.fastq.gz -r test_input/test_2_rev_HWLTKDRXY_600000.fastq.gz -n dev_dataset -d DEV_DATASET -s

# To run the manuscript use cases:
# marine sediment
# ./run_wf.sh -f test_input/DBH_AAAIOSDA_1_1_HMNJKDSX3.UDI224_clean.fastq.gz -r test_input/DBH_AAAIOSDA_1_2_HMNJKDSX3.UDI224_clean.fastq.gz -n DBH_dataset -d marine_sediment_dbh -s

# column water
# ./run_wf.sh -f test_input/DBB_AABVOSDA_1_1_HMNJKDSX3.UDI256_clean.fastq.gz -r test_input/DBB_AABVOSDA_1_2_HMNJKDSX3.UDI256_clean.fastq.gz -n DBB_dataset -d water_column_dbb -s

# To run an ENA run
./run_wf.sh -e ERR599171 -d TARA_OCEANS_SAMPLE -n ERR599171 -s -b
#./run_wf.sh -f test_input/ERR599171_1.fastq.gz -r test_input/ERR599171_2.fastq.gz -n ERR599171  -d TARA_OCEANS_SAMPLE_3steps -s


# Disable the module
module purge
