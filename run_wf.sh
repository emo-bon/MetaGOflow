#!/bin/bash

source util_functions.sh


# ----------------------------- running pipeline ----------------------------- #

cwltool --parallel ${SINGULARITY} --outdir ${OUT_DIR_FINAL} ${CWL} ${EXTENDED_CONFIG_YAML}


# Edit output structure 
rm -rf ${TMPDIR}

cd ${OUT_DIR}/results/functional-annotation/

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

cd ${CWD}


# --------------------------------------------

# Build RO-crate
rocrate init -c ${RUN_DIR}

if [ -z "$ENA_RUN_ID" ]; then
  ENA_RUN_ID="None"
fi
python utils/edit-ro-crate.py ${OUT_DIR} ${EXTENDED_CONFIG_YAML} ${ENA_RUN_ID} ${METAGOFLOW_VERSION}

# --------------------------------------------

rm -r ${OUT_DIR}
