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


