#!/bin/bash

METAGOFLOW_VERSION="https://github.com/emo-bon/MetaGOflow/releases/tag/v1.0.0"

# default values #
SCRIPT_PATH=$(realpath "$0")
PIPELINE_DIR=$(dirname "${SCRIPT_PATH}")
MEMORY=10G
NUM_CORES=1
LIMIT_QUEUE=100
YML="${PIPELINE_DIR}/Installation/templates/default.yml"
DB_DIR="${PIPELINE_DIR}/ref-dbs/"
TOOLS="${PIPELINE_DIR}/tools/"

_usage() {
  echo "
metaGOflow interface.
Script arguments.
  Resources:
  -m                  Memory to use to with toil --defaultMemory. (optional, default ${MEMORY})
  -c                  Number of cpus to use with toil --defaultCores. (optional, default ${NUM_CORES})
  -l                  Limit number of jobs to schedule. (optional, default ${LIMIT_QUEUE})

  Pipeline parameters:
  -y                  template yml file. (optional, default ../templates/rna_prediction_template.yml})
  -f                  Forward reads fasta file path.
  -r                  Reverse reads fasta file path.
  -n                  Name of run and prefix to output files.
  -d                  Path to run directory.
  -s                  Run workflow using Singularity (docker is the by default container technology) ('true' or 'false')
  -b                  Keep tmp folder. 
"
}

# [TODO] Consider adding a -t argument to run using toil.
while getopts :y:f:r:e:u:k:c:d:m:n:l:bsph option; do
  case "${option}" in
  y) YML=${OPTARG} ;;
  f)
    FORWARD_READS=${OPTARG}
    echo "Presented paired-end forward read: ${FORWARD_READS}" 
    ;;
  r)
    REVERSE_READS=${OPTARG}
    printf "Presented paired-end reverse path: ${REVERSE_READS}\n"
    ;;
  e) ENA_RUN_ID=${OPTARG} ;;
  u) ENA_USERNAME=${OPTARG} ;;
  k) ENA_PASSWORD=${OPTARG} ;;
  c) NUM_CORES=${OPTARG} ;;
  d) RUN_DIR=${OPTARG} ;;
  m) MEMORY=${OPTARG} ;;
  n) NAME=${OPTARG} ;;
  l) LIMIT_QUEUE=${OPTARG} ;;
  b) KEEP_TMP="--keep-tmp" ;;
  s) SINGULARITY="--singularity" ;;
  p) PRIVATE_DATA="-p" ;;
  h)
    _usage
    exit 0
    ;;
  :)
   usage
   exit 1
   ;;
  \?)
    echo ""
    echo "Invalid option -${OPTARG}" >&2
    _usage
    exit 1
    ;;
  esac
done

# ----------------------------- sanity check arguments ----------------------------- #

_check_mandatory() {
  # Check if the argument is empty or null
  # $1 variable
  # $2 name to show
  if [ -z "$1" ]; then
    echo "Error." >&2
    echo "Option ${2} is mandatory " >&2
    echo "type -h to get help"
    exit 1
  fi
}

_check_reads() {
  # check forward and reverse reads both present
  # check if single reads then no other readsgiven
  # BASH SYNTAX: 
  # to check if a variable has value: 
  # [ -z "$var" ] && echo "Empty"

  if [ -z "$1" ] && [ -n "$2" ]; then
    echo "Error"
    echo "only reverse reads given, provide forward with -f"
    exit 1
  fi

  if [ -n "$1" ] && [ -z "$2" ]; then
    echo "Error"
    echo "only forward reads given, provide reverse with -r"
    exit 1
  fi

}

_check_mandatory "$NAME" "-n"
_check_mandatory "$RUN_DIR" "-d"
_check_reads "$FORWARD_READS" "$REVERSE_READS" 

# ----------------------------- environment & variables ----------------------------- #

# load required environments and packages before running

export CWD=$(pwd)

export TOIL_SLURM_ARGS="--array=1-${LIMIT_QUEUE}%20" #schedule 100 jobs 20 running at one time
export CWL="${PIPELINE_DIR}/workflows/gos_wf.cwl"

# work dir
export WORK_DIR=${RUN_DIR}/work-dir
export JOB_TOIL_FOLDER=${WORK_DIR}/job-store-wf
export TMPDIR=${RUN_DIR}/tmp

# result dir
export OUT_DIR=${RUN_DIR}
export LOG_DIR=${OUT_DIR}/log-dir/${NAME}
export OUT_DIR_FINAL=${OUT_DIR}/results
export CACHE_DIR=${OUT_DIR}/cache
mkdir -p "${OUT_DIR_FINAL}" "${TMPDIR}"

export EXTENDED_CONFIG_YAML_TMP=${RUN_DIR}/"${NAME}"_temp.yml
export EXTENDED_CONFIG_YAML=${RUN_DIR}/"${NAME}".yml
export FUNCTIONAL_ANNOTATION=${OUT_DIR}/results/functional-annotation/


# Get study id in case of ENA fetch tool
if [[ $ENA_RUN_ID != "" ]];
then 

  echo "metaGOflow is about to fetch data from ENA" 

  # Run cwl for the ENA fetch tool
  cp tools/fetch-tool/get_raw_data_run.cwl .

  printf "
  run_accession_number: ${ENA_RUN_ID}
  private_data: true
  ena_api_username: ${ENA_USERNAME}
  ena_api_password: ${ENA_PASSWORD}
  " > get_raw_data_run-test.yml

  cwl-runner ${SINGULARITY} --outdir ${OUT_DIR} --debug get_raw_data_run.cwl get_raw_data_run-test.yml
 
  rm get_raw_data_run.cwl
  rm get_raw_data_run-test.yml

  # Get the accession id of the corresponding study
  ENA_STUDY_ID=$(curl -X POST "https://www.ebi.ac.uk/ena/browser/api/xml?accessions="$ENA_RUN_ID"&expanded=true" \
                -H "accept: application/xml" | grep -A 1 "ENA-STUDY" | tail -1 | sed 's/.*<ID>// ; s/<\/ID>//')

  export PATH_ENA_RAW_DATA=${PIPELINE_DIR}/${OUT_DIR}/raw_data_from_ENA/${ENA_STUDY_ID}/raw/

fi

# ----------------------------- prepare yml file ----------------------------- #

echo "Writing yaml file"

# DO NOT leave spaces after "\" in the end of a line
python utils/create_yml.py \
  -y "${YML}" \
  -o "${EXTENDED_CONFIG_YAML_TMP}" \
  -l "${PATH_ENA_RAW_DATA}" \
  -f "${PIPELINE_DIR}/${FORWARD_READS}" \
  -r "${PIPELINE_DIR}/${REVERSE_READS}" \
  -d "${DB_DIR}" \
  -t "${TOOLS}" \
  -e "${ENA_RUN_ID}"

mv eosc-wf.yml ${RUN_DIR}/
cat ${RUN_DIR}/eosc-wf.yml ${EXTENDED_CONFIG_YAML_TMP} > ${EXTENDED_CONFIG_YAML}
rm ${EXTENDED_CONFIG_YAML_TMP}
rm ${RUN_DIR}/eosc-wf.yml
cp config.yml ${RUN_DIR}/

# ----------------------------- running pipeline ----------------------------- #

# Run the metaGOflow workflow using cwl-runner (could use instead cwltool)  
echo "metaGOflow is ready to go!"
cwl-runner --parallel ${SINGULARITY} --outdir ${OUT_DIR_FINAL} ${CWL} ${EXTENDED_CONFIG_YAML}


# -----------------------  edit output structure   --------------------------- #

if [[ $KEEP_TMP != "" ]];
then 
  echo "Keep temporary output directory."
  mv ${TMPDIR} ${CWD}
else
  rm -rf ${TMPDIR}
fi


if [ -z "$FUNCTIONAL_ANNOTATION" ]; then

  cd ${FUNCTIONAL_ANNOTATION}
  count=`ls -1 *.chunks 2>/dev/null | wc -l`
  if [ $count != 0 ]
  then 
    rm *.chunks
  fi 

  count=`ls -1 *CDS.I5_001.tsv.gz 2>/dev/null | wc -l`
  if [ $count != 0 ]
  then 

    fullfile=*.merged.CDS.I5_001.tsv.gz
    prefix=$(echo $fullfile | sed 's/[^_]*$//')
    prefix=${prefix::-1}

    ls *.merged.CDS.I5_*.tsv.gz | xargs -I {} cat  {} > allfiles.gz
    ls *.merged.CDS.I5_*.tsv.gz | xargs -I {} rm {}
    mv allfiles.gz ${prefix}".tsv.gz"
  fi 
fi

cd ${CWD}


# -----------------------  build RO-crate   --------------------------- #

if [ -z "$ENA_RUN_ID" ]; then
  ENA_RUN_ID="None"
else
  rm -r ${OUT_DIR}/raw_data_from_ENA
fi

# Init the RO-Crate
rocrate init -c ${RUN_DIR}

# Edit the RO-Crate
if [[ $KEEP_TMP != "" ]];
then 
  export KEEP_TMP="True"
else
  export KEEP_TMP="False"
fi

python utils/edit-ro-crate.py ${OUT_DIR} ${EXTENDED_CONFIG_YAML} ${ENA_RUN_ID} ${METAGOFLOW_VERSION} ${KEEP_TMP}


# Bring back temporary folder if kept.
if [[ $KEEP_TMP == "True" ]];
then 
  echo "Keep temporary output directory."
  mv ${CWD}/tmp ${TMPDIR}
fi

echo "metaGOflow has been completed."


