#!/bin/bash

set -e

usage() {
    echo ""
    echo "Download the EOSC Life GOs workflow related reference databases"
    echo "* requires 'wget"
    echo ""
    echo "-f Output folder [mandatory]"
    echo " "
}

OUTPUT=""

while getopts "f:h" opt; do
    case $opt in
    f)
        OUTPUT="$OPTARG"
        if [ -z "$OUTPUT" ]; then
            echo ""
            echo "ERROR -f cannot be empty." >&2
            usage
            exit 1
        fi
        ;;
    h)
        usage
        exit 0
        ;;
    :)
        usage
        exit 1
        ;;
    \?)
        echo ""
        echo "Invalid option -${OPTARG}" >&2
        usage
        exit 1
        ;;
    esac
done

if ((OPTIND == 1)); then
    echo ""
    echo "ERROR: No options specified"
    usage
    exit 1
fi

CWD=$(pwd)
mkdir -p "${OUTPUT}" && cd "${OUTPUT}" || exit 1

# MGnify base FTP server with related dbs
export FTP_DBS=ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/

# Versions
IPR=5

# We are now in InterPro 89.0. (Checked on June 2022)
IPRSCAN=5.57-90.0

# The integrated version is from Jul 23, 2019
# We are now in version 2..0.15 (Checked on June 2022)
DIAMOND_VERSION=0.9.25

# Checked on June 2022: Last modified November 29, 2021
UNIREF90_VERSION=v2019_08

# --------------------------
# RNA PREDICTION RELATED
# --------------------------

# download silva dbs #
echo "Downloading silva_ssu and silva_lsu"
mkdir silva_ssu silva_lsu

wget \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/silva_ssu-20200130.tar.gz \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/silva_lsu-20200130.tar.gz
tar xfv silva_ssu-20200130.tar.gz --directory=silva_ssu --strip-components 1
tar xfv silva_lsu-20200130.tar.gz --directory=silva_lsu --strip-components 1

# download the RFam models #
echo "Downloading the rfam_models"
mkdir Rfam
cd Rfam

mkdir ribosomal

wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/rfam_models/ribosomal_models/RF*.cm \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/rfam_models/ribosomal_models/ribo.claninfo \
    -P ribosomal

# rRNA.claninfo
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/rRNA.claninfo

# other Rfam models
mkdir other
cd other
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/rfam_models/other_models/*.cm \
    -P other

cd "${CWD}"/"${OUTPUT}"

# download IPS #
echo 'download IPS'
wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/interproscan-data-$IPRSCAN.tar.gz && \
        tar -pxvzf interproscan-data-$IPRSCAN.tar.gz && \
        rm -f interproscan-data-$IPRSCAN.tar.gz

# kofam db
echo 'Download db KOfam'
mkdir db_kofam
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/db_kofam.hmm.h3f.gz -P db_kofam
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/db_kofam.hmm.h3i.gz -P db_kofam
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/db_kofam.hmm.h3m.gz -P db_kofam
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/db_kofam.hmm.h3p.gz -P db_kofam
gunzip db_kofam/db_kofam.hmm.h3f.gz db_kofam/db_kofam.hmm.h3i.gz db_kofam/db_kofam.hmm.h3m.gz db_kofam/db_kofam.hmm.h3p.gz

# ko file
wget $FTP_DBS/kofam_ko_desc.tsv

# eggnog and diamond 5.0.2 
echo 'Download eggnog dbs'
wget http://eggnog5.embl.de/download/emapperdb-5.0.2/eggnog_proteins.dmnd.gz
wget http://eggnog5.embl.de/download/emapperdb-5.0.2/eggnog.db.gz
gunzip eggnog.db.gz eggnog_proteins.dmnd.gz
mkdir eggnog && mv eggnog_proteins.dmnd eggnog.db eggnog

# Diamond
echo 'Download diamond dbs'
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/db_uniref90_result.txt.gz \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/uniref90_${UNIREF90_VERSION}_diamond-v${DIAMOND_VERSION}.dmnd.gz
gunzip db_uniref90_result.txt.gz uniref90_${UNIREF90_VERSION}_diamond-v${DIAMOND_VERSION}.dmnd.gz
mkdir diamond && mv db_uniref90_result.txt uniref90_${UNIREF90_VERSION}_diamond-v${DIAMOND_VERSION}.dmnd diamond

# KEGG pathways
echo 'Download pathways data'
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/graphs-20200805.pkl.gz \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/all_pathways_class.txt.gz \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/pipeline-5.0/ref-dbs/all_pathways_names.txt.gz
gunzip graphs-20200805.pkl.gz all_pathways_class.txt.gz all_pathways_names.txt.gz
mkdir kegg_pathways && mv graphs-20200805.pkl all_pathways_class.txt all_pathways_names.txt kegg_pathways
