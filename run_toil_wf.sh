#!/bin/bash

source util_functions.sh


# ----------------------------- running pipeline ----------------------------- #

# IMPORTANT! 
# To work with slurm, add "--batchSystem slurm", "--disableChaining" and "--disableCaching" in the TOIL_PARMS object
TOIL_PARAMS+=(
  --singularity
  --preserve-entire-environment
  --batchSystem slurm
  --disableChaining
  # --provenance "${PROV_DIR}"
  --disableCaching
  --logFile "${LOG_DIR}/${NAME}.log"
  --jobStore "${JOB_TOIL_FOLDER}/${NAME}"
  --outdir "${OUT_DIR_FINAL}"
  --maxCores 20
  --defaultMemory "${MEMORY}"
  --defaultCores "${NUM_CORES}"
  --retryCount 2
  --logDebug
  "$CWL"
  "$RENAMED_YML"
)


# Toil parameters documentation 
# --disableChaining                Disables  chaining  of jobs (chaining uses one job's resource allocation for its successor job if possible).
# --preserve-entire-environment    Need to propagate the env vars for Singularity, etc., into the HPC jobs
# --disableProgress                Disables the progress bar shown when standard error is a terminal.
# --retryCount                     Number of times to retry a failing job before giving up and labeling job failed. default=1
# --disableCaching                 Disables caching in the file store. This flag must be set to use a batch  system that does not support caching such as Grid Engine, Parasol, LSF, or Slurm.


# Create util directories
mkdir -p ${LOG_DIR}
mkdir -p ${JOB_TOIL_FOLDER}
mkdir ${RUN_DIR}/tmp_dir/
mkdir ${RUN_DIR}/tmp_out_dir/


toil-cwl-runner "${TOIL_PARAMS[@]}"



