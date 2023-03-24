#!/bin/bash

source util_functions.sh


# ----------------------------- running pipeline ----------------------------- #

cwltool ${SINGULARITY} --provenance ${PROV_DIR} --outdir ${OUT_DIR_FINAL} ${CWL} ${RENAMED_YML}

#cwltool --debug ${SINGULARITY} --provenance ${PROV_DIR} --outdir ${OUT_DIR_FINAL} ${CWL} ${RENAMED_YML}

# --cachedir ${CACHE_DIR} 
# --leave-tmpdir --leave-outputs


