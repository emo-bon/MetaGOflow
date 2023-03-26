#! /usr/bin/env python3

import sys
import argparse 
import textwrap
from rocrate.rocrate import ROCrate
from rocrate.model.person import Person
import datetime

ena_accession_raw_data= "Raw sequence data and laboratory sequence generation metadata",

descriptions = [
    {
        "@id": "sequence-categorisation/",
        "@type": "Dataset",
        "name": "Sequence categorisation",
        "description": "Identify specific loci in the sample."
    },
    {   "@id": "functional_annotation/",
        "@type": "Dataset",
        "name": "Functional annotation results",
        "description": "Functional annotation of merged reads"},
    {
        "@id": "config.yml",
        "@type": "File",                 
        "name": "MetaGOflow configuration file",
        "description": "The configuration file through which the user sets the values of the metaGOflow parameters.",
        "encodingFormat": "text/yaml"
    },
    {
        "@id": "fastp.html",
        "@type": "File",                 
        "name": "FASTP analysis of raw sequence data",
        "description": "Quality control and preprocessing of FASTQ files",
        "encodingFormat": "text/html"
    },
    {
        "@id": "final.contigs.fa",
        "@type": "File",                 
        "name": "FASTA formatted contig sequences",
        "description": "These are the assembled contig sequences from the merged reads in FASTA format",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "go.stats",
        "@type": "File",
        "name": "Geno Ontology summary statistics",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "interproscan.stats",
        "@type": "File",
        "name": "InterProScan summary statistics",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "ko.stats",
        "@type": "File",
        "name": "Kegg Ontology summary statistics",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "orf.stats",
        "@type": "File",
        "name": "ORF summary statistics",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "pfam.stats",
        "@type": "File",
        "name": "Pfam summary statistcs",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged_CDS.I5.tsv.gz",
        "@type": "File",
        "name": "Merged contigs CDS I5 summary",
        "encodingFormat": "application/zip"
    },
    {
        "@id": ".merged.hmm.tsv.gz",
        "@type": "File",
        "name": "Merged contigs HMM summary",
        "encodingFormat": "application/zip"
    },
    {
        "@id": ".merged.summary.go",
        "@type": "File",
        "name": "Merged contigs GO summary",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged.summary.go_slim",
        "@type": "File",
        "name": "Merged contigs InterProScan slim",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged.summary.ips",
        "@type": "File",
        "name": "Merged contigs InterProScan",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged.summary.ko",
        "@type": "File",
        "name": "Merged contigs KO summary",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged.summary.pfam",
        "@type": "File",
        "name": "Merged contigs PFAM summary",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "RNA-counts",
        "@type": "File",
        "name": "Numbers of RNA's counted",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "krona.html",
        "@type": "File",
        "name": "Krona summary of LSU taxonomic inventory",
        "encodingFormat": "application/html"
    },
    {
        "@id": ".merged_LSU.fasta.mseq.gz",
        "@type": "File",
        "name": "LSU sequences used for indentification",
        "encodingFormat": "application/zip"
    },
    {
        "@id": ".merged_LSU.fasta.mseq_hdf5.biom",
        "@type": "File",
        "name": "BIOM formatted hdf5 taxon counts for LSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": ".merged_LSU.fasta.mseq_json.biom",
        "@type": "File",
        "name": "BIOM formatted taxon counts for LSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": ".merged_LSU.fasta.mseq.tsv",
        "@type": "File",
        "name": "Tab-separated formatted taxon counts for LSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": ".merged_LSU.fasta.mseq.txt",
        "@type": "File",
        "name": "Text-based taxon counts for LSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": "krona.html",
        "@type": "File",
        "name": "Krona summary of SSU taxonomic inventory",
        "encodingFormat": "text/html"
    },
    {
        "@id": ".merged_SSU.fasta.mseq.gz",
        "@type": "File",
        "name": "LSU sequences used for indentification",
        "encodingFormat": "application/zip"
    },
    {
        "@id": ".merged_SSU.fasta.mseq_hdf5.biom",
        "@type": "File",
        "name": "BIOM formatted hdf5 taxon counts for SSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": ".merged_SSU.fasta.mseq_json.biom",
        "@type": "File",
        "name": "BIOM formatted taxon counts for SSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": ".merged_SSU.fasta.mseq.tsv",
        "@type": "File",
        "name": "Tab-separated formatted taxon counts for SSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": ".merged_SSU.fasta.mseq.txt",
        "@type": "File",
        "name": "Text-based formatted taxon counts for SSU sequences",
        "encodingFormat": "application/json-ld"
    },
    {
        "@id": ".all.tblout.deoverlapped",
        "@type": "File",
        "name": "Sequence hits against covariance model databases. Mandatory to run partially the functional annotation step of metaGOflow.",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged.fasta",
        "@type": "File",
        "name": "Merged filtered reads.",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".fastq.trimmed.fasta",
        "@type": "File",
        "name": "Filtered .fastq file of the single-end reads (forward/reverse).",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".fastq.trimmed.qc_summary",
        "@type": "File",
        "name": "Summary with statistics of the single-end reads (forward/reverse).",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".all.tblout.deoverlapped",
        "@type": "File",
        "name": "Sequence hits against covariance model databases",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged.unfiltered_fasta",
        "@type": "File",
        "name": "",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".motus.tsv",
        "@type": "File",
        "name": "",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged.qc_summary",
        "@type": "File",
        "name": "Summary with statistics of the merged reads.",
        "encodingFormat": "text/plain"
    },
    {
        "@id": "SSU.fasta.gz",
        "@type": "File",
        "name": "SSU sequences.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "SSU_rRNA_archaea.RF01959.fa.gz",
        "@type": "File",
        "name": "SSU sequences mapping to Archaea.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "SSU_rRNA_bacteria.RF00177.fa.gz",
        "@type": "File",
        "name": "SSU sequences mapping to Bacteria.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "SSU_rRNA_eukarya.RF01960.fa.gz",
        "@type": "File",
        "name": "SSU sequences mapping to Eukaryotes.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "tmRNA.RF00023.fasta.gz",
        "@type": "File",
        "name": "Sequences mapping to transfer-messenger RNAs",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "tRNA.RF00005.fasta.gz",
        "@type": "File",
        "name": "Sequences mapping to tranfer RNAs",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "tRNA-Sec.RF01852.fasta.gz",
        "@type": "File",
        "name": "Sequences mapping to selenocysteine tRNAs.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "LSU.fasta.gz",
        "@type": "File",
        "name": "LSU sequences.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "LSU_rRNA_archaea.RF02540.fa.gz",
        "@type": "File",
        "name": "LSU sequences mapping to Archaea.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "LSU_rRNA_bacteria.RF02541.fa.gz",
        "@type": "File",
        "name": "LSU sequences mapping to Bacteria.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "LSU_rRNA_eukarya.RF02543.fa.gz",
        "@type": "File",
        "name": "LSU sequences mapping to Eukaryotes.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "RNaseP_bact_a.RF00010.fasta.gz",
        "@type": "File",
        "name": "Sequences mapping to ribonucleus P bacterial sequences.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "5_8S.fa.gz",
        "@type": "File",
        "name": "Sequences mapping to ribonucleus 5_8S rRNA gene.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "alpha_tmRNA.RF01849.fasta.gz",
        "@type": "File",
        "name": "Sequences mapping to alpha transfer-messenger RNA.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "Bacteria_large_SRP.RF01854.fasta.gz",
        "@type": "File",
        "name": "Sequences mapping to bacterial large signal recognition particle RNAs.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": "Bacteria_small_SRP.RF00169.fasta.gz",
        "@type": "File",
        "name": "Sequences mapping to bacterial small signal recognition particle RNAs.",
        "encodingFormat": "application/zip"
    },
    {
        "@id": ".merged_CDS.faa",
        "@type": "File",
        "name": "Coding sequences with amino acids.",
        "encodingFormat": "text/plain"
    },
    {
        "@id": ".merged_CDS.ffn",
        "@type": "File",
        "name": "Coding sequences with nucleotides.",
        "encodingFormat": "text/plain"
    }
]

def main(target_directory, extended_config_yaml, ena_run_accession_id, metagoflow_version ):
    """
    Edit the output of the `rocrate init` tool. 
    Map files descriptions ; should be done through the cwl descriptions but we go that way at a later point.
    Add extra ids on the ro-crate describing the metaGOflow workflow and the ENA data (if used). 
    """

    crate = ROCrate(target_directory) # here we use a complete directory, could we use just the json..?

    for entry in crate.get_entities():
        for description in descriptions:
            try:
                pk = description["@id"] in entry.id
            except:
                pass
            finally:
                if pk :
                    for k,v in description.items():
                        if k not in entry.properties().keys():
                            entry.properties()[k] = v

    metagoflow_id = "workflow/metaGOflow"
    mg_license_id = "https://www.apache.org/licenses/LICENSE-2.0"
    embrc_id      = "https://ror.org/0038zss60"
    mail_id       = "mailto:help@embrc.org"
    metagoflow_product_license_id = "https://creativecommons.org/licenses/by/4.0/legalcode"
    

    mg_license = crate.add(Person(crate, mg_license_id, properties={
        "@type": "CreativeWork",
        "name": "Apache License 2.0",
        "identifier": "https://spdx.org/licenses/Apache-2.0.html"
    }))

    metagoflow_product_license = crate.add(Person(crate,metagoflow_product_license_id, properties={
        "@type": "CreativeWork",
        "name": "Creative Commons (CC-BY 4.0)",
        "identifier": "https://spdx.org/licenses/CC-BY-4.0.html"
    }))

    embrc_mail = crate.add(Person(crate, mail_id, properties={
        "@type": "ContactPoint",
        "contactType": "Help Desk",
        "email": "help@embrc.org",
        "identifier": "help@embrc.org",
        "url": "https://www.embrc.eu/about-us/contact-us"
    }))


    embrc = crate.add(Person(crate, embrc_id, properties={
        "@type": "Organization",
        "name": "European Marine Biological Resource Centre",
        "url": embrc_id,
        "contactPoint": {"@id": mail_id}
    }))


    metagoflow = crate.add(Person(crate, metagoflow_id, properties={
        "@type": ["File", "SoftwareSourceCode", "ComputationalWorkflow"],
        "name": "metaGOflow",
        "affiliation": "University of Flatland", 
        "author": {"@id": "EMO BON"}, 
        "url": metagoflow_version,
        "license": { "@id": mg_license_id},
        "hasPart": [
            {"@id": "config.yml"},
            {"@id": extended_config_yaml}
        ]
    }))


    if ena_run_accession_id != "None":

        ena_id = crate.add(Person(crate, ena_run_accession_id, properties={

            "@id": ena_accession_raw_data, 
            "@type": "File",
            "name": "ENA accession for run raw sequence data",
            "description": "Link to the ENA entry of the raw data used for this analysis.",
            "url": "https://www.ebi.ac.uk/ena/browser/view/" + ena_run_accession_id, 
            "encodingFormat": "text/xml"
        }))

    crate.root_dataset.properties()["name"]      = "MetaGoFlow Results"
    # crate.root_dataset.properties()["license"]   = {"@id": metagoflow_product_license_id}
    crate.root_dataset.properties()["publisher"] =  {"@id": embrc_id}

    print("export...")

    crate.write_zip("".join([target_directory,".zip"]))
    
    print("..ro-crate as .zip ready.")


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
            formatter_class=argparse.RawDescriptionHelpFormatter
            # description=textwrap.dedent(desc),
            )
    parser.add_argument("target_directory",
                        help="Name of target directory containing MetaGOflow" +\
                        "output"
                        )
    parser.add_argument("extended_config_yaml",
                        help="The extened YAML file metaGOflow built and used based on user's config" +\
                        "output"
                        )
    parser.add_argument("ena_run_accession_id",
                        help="Run accession id in ENA."
                        )
    parser.add_argument("metagoflow_version",
                        help="URL pointing to the metaGOflow version used"
                        )

    args = parser.parse_args()
    
    # Run main function
    main(args.target_directory, args.extended_config_yaml, args.ena_run_accession_id, args.metagoflow_version)
