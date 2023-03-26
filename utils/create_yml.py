#!/usr/bin/env python3

import argparse
from ruamel.yaml import YAML
import os
import yaml as yml

db_fields = [
    "ssu_db",
    "lsu_db",
    "ssu_tax",
    "lsu_tax",
    "ssu_otus",
    "lsu_otus",
    "rfam_models",
    "rfam_model_clans",
    "HMM_database_dir",
    "ko_file",
    "InterProScan_databases",
    "EggNOG_data_dir",
    "EggNOG_db",
    "EggNOG_diamond_db",
    "diamond_databaseFile",
    "Uniref90_db_txt",
    "go_config",
    "pathways_names",
    "pathways_classes",
    "graphs"
]


def db_dir(db_path, tools_path, yaml_path):
    with open(yaml_path) as f:
        yaml = YAML(typ="safe")
        doc = yaml.load(f)
        for db_field in db_fields:
            print(">", db_field)
            if isinstance(doc[db_field], (list, tuple)):
                for el in doc[db_field]:
                    el["path"] = os.path.join(db_path, el["path"])
            else:
                if db_field == "go_config": 
                    doc[db_field]["path"] = os.path.join(tools_path, doc[db_field]["path"])
                else:
                    doc[db_field]["path"] = os.path.join(db_path, doc[db_field]["path"])
    return doc

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Create the input.yml for the pipeline"
    )
    parser.add_argument(
        "-y", "--yml", dest="yml", help="YAML file with the constants", required=True
    )
    parser.add_argument(
        "-f", "--fr", dest="fr", help="Forward reads file path", required=False
    )
    parser.add_argument(
        "-r", "--rr", dest="rr", help="Reverse reads file path", required=False
    )
    parser.add_argument(
        "-o", "--output", dest="output", help="Output yaml file path", required=True
    )
    parser.add_argument(
        "-l", "--ena_raw_data_path", 
        dest="ena_raw_data_path", 
        help="Path to output directory", 
        required=False
    )    
    parser.add_argument(
        "-d",
        "--dbdir",
        dest="db_dir",
        help="Path to database directory",
        required=False
    )
    parser.add_argument(
        "-t",
        "--toolsdir",
        dest="tools_dir",
        help="Path to tools directory",
        required=False
    )
    parser.add_argument(
        "-e", 
        "--run_accession_number", 
        dest="run_accession_number", 
        help="The accession number in ENA of the run to be analysed", 
        required=False
    )
    parser.add_argument(
        "-p", 
        "--private", 
        dest="private_data", 
        help="Use if raw data in ENA are under private status", 
        action='store_true',
        required=False
    )
    parser.add_argument(
        "-u", 
        "--ena_api_username", 
        dest="ena_api_username", 
        help="The username of the account in ENA where the run is located", 
        required=False
    )
    parser.add_argument(
        "-k", 
        "--ena_api_password", 
        dest="ena_api_password", 
        help="The password for the account in ENA where the run is located", 
        required=False
    )


    args = parser.parse_args()

    # load template yml file and append database path
    template_yml = db_dir(args.db_dir, args.tools_dir, args.yml)

    # Building the .yml file
    with open(args.output, "w") as output_yml:
        
        yaml = YAML(typ="safe")

        yaml.dump(template_yml, output_yml)

    cwd = os.getcwd()
    config_file =  os.path.join(cwd, "config.yml")
    with open(config_file, "r") as config_yml: 

        config = yml.safe_load(config_yml)

        if args.fr.endswith(".fastq.gz") and args.rr.endswith(".fastq.gz"): 

            config["forward_reads"] = {
                "class": "File",
                "format": "edam:format_1930",
                "path": args.fr,
            }

            config["reverse_reads"] = {
                "class": "File",
                "format": "edam:format_1930",
                "path": args.rr,
            }

            config["both_reads"] = [args.fr.split("/")[-1].split(".fastq.gz")[0], args.rr.split("/")[-1].split(".fastq.gz")[0]]

        else: 

            forward_reads = args.ena_raw_data_path + "/" + args.run_accession_number + "_1.fastq.gz"
            reverse_reads = args.ena_raw_data_path + "/" + args.run_accession_number + "_2.fastq.gz"

            config["forward_reads"] = {
                "class": "File",
                "format": "edam:format_1930",
                "path": forward_reads
            }

            config["reverse_reads"] = {
                "class": "File",
                "format": "edam:format_1930",
                "path": reverse_reads
            }

            config["both_reads"] = [forward_reads.split("/")[-1].split(".fastq.gz")[0], reverse_reads.split("/")[-1].split(".fastq.gz")[0]]

    with open("eosc-wf.yml", "w") as config_yml:
        yaml.dump(config, config_yml)

