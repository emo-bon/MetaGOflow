#!/usr/bin/env python3

import argparse
import os
import sys

from ruamel.yaml import YAML

IPS_VERSION = "5.36-75.0"
DIAMOND_VERSION = "0.9.25"
UNIREF_VERSION = "v2019_11"
MOTUS_VERSION = "2.5.1"


def convert_to_string(value):
    """Convert File,Directory or [File,Directory] into string or a list of string"""
    if type(value) is dict and value.get("class") in ["File", "Directory"]:
        return value["path"]
    elif type(value) is list or type(value) is tuple:
        converted_list = []
        for item in value:
            if type(item) is dict and item.get("class") in ["File", "Directory"]:
                converted_list.append(item["path"])
            else:
                converted_list.append(item)
        return converted_list
    else:
        return value


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parsing first sub-wf of pipeline")
    parser.add_argument(
        "-d",
        "--dir",
        dest="dir",
        help="Directory with the databases (download with download_dbs.sh",
        required=True,
    )
    parser.add_argument(
        "-t",
        "--type",
        dest="type",
        choices=["assembly", "wgs", "amplicon"],
        help="Analysis type",
        required=True,
    )
    parser.add_argument(
        "-c",
        dest="cwltypes",
        action="store_false",
        help="Use File or Directory for databases instead of string. Please see #https://github.com/DataBiosphere/toil/issues/2534",
    )

    args = parser.parse_args()

    input_yaml = {
        "$namespaces": {"s": "https://schema.org", "e": "http://edamontology.org/"}
    }

    # ==== for all types ====
    # rna prediction
    input_yaml.update(
        {
            "ssu_label": "SSU_rRNA",
            "lsu_label": "LSU_rRNA",
            "5.8s_pattern": "5_8S_rRNA",
            "5s_pattern": "mtPerm-5S",
        }
    )

    # ssu
    input_yaml.update(
        {
            "ssu_db": {
                "class": "File",
                "path": args.dir + "/silva_ssu/SSU.fasta",
                "format": "edam:format_1929",
                "checksum": "6b0580823a8c6860a0674428745fb943",
            },
            "lsu_db": {
                "class": "File",
                "path": args.dir + "/silva_lsu/LSU.fasta",
                "format": "edam:format_1929",
                "checksum": "96dc05a4ab2933ec6f443a1a0ce0d225",
            },
            "ssu_tax": {
                "class": "File",
                "path": args.dir + "/silva_ssu/slv_ssu_filtered2.txt",
            },
            "lsu_tax": {
                "class": "File",
                "path": args.dir + "/silva_lsu/slv_lsu_filtered2.txt",
            },
            "ssu_otus": {
                "class": "File",
                "path": args.dir + "silva_ssu/ssu2.otu",
            },
            "lsu_otus": {
                "class": "File",
                "path": args.dir + "/silva_lsu/lsu2.otu",
            },
        }
    )
    # lsu
    input_yaml.update(
        {
            "ssu_db": {
                "class": "File",
                "path": args.dir + "/silva_ssu/SSU.fasta",
                "format": "edam:format_1929",
                "checksum": "6b0580823a8c6860a0674428745fb943",
            },
            "lsu_db": {
                "class": "File",
                "path": args.dir + "/silva_lsu/LSU.fasta",
                "format": "edam:format_1929",
                "checksum": "96dc05a4ab2933ec6f443a1a0ce0d225",
            },
            "ssu_tax": {
                "class": "File",
                "path": args.dir + "/silva_ssu/slv_ssu_filtered2.txt",
            },
            "lsu_tax": {
                "class": "File",
                "path": args.dir + "/silva_lsu/slv_lsu_filtered2.txt",
            },
            "ssu_otus": {
                "class": "File",
                "path": args.dir + "/silva_ssu/ssu2.otu",
            },
            "lsu_otus": {
                "class": "File",
                "path": args.dir + "/silva_lsu/lsu2.otu",
            },
        }
    )

    # ko file
    input_yaml.update(
        {"ko_file": {"class": "File", "path": args.dir + "/kofam_ko_desc.tsv"}}
    )

    # rfam_models
    rfam_models = [
        args.dir + "/ribosomal/RF00002.cm",
        args.dir + "/ribosomal/RF00177.cm",
        args.dir + "/ribosomal/RF01959.cm",
        args.dir + "/ribosomal/RF01960.cm",
        args.dir + "/ribosomal/RF02540.cm",
        args.dir + "/ribosomal/RF02541.cm",
        args.dir + "/ribosomal/RF02542.cm",
        args.dir + "/ribosomal/RF02543.cm",
        args.dir + "/ribosomal/RF02546.cm",
        args.dir + "/ribosomal/RF02547.cm",
    ]
    if args.type in ["assembly", "wgs"]:
        rfam_models.extend(
            [
                args.dir + "/other/alpha_tmRNA.cm",
                args.dir + "/other/Plant_SRP.cm",
                args.dir + "/other/Archaea_SRP.cm",
                args.dir + "/other/Protozoa_SRP.cm",
                args.dir + "/other/Bacteria_large_SRP.cm",
                args.dir + "/other/RNase_MRP.cm",
                args.dir + "/other/Bacteria_small_SRP.cm",
                args.dir + "/other/RNaseP_arch.cm",
                args.dir + "/other/beta_tmRNA.cm",
                args.dir + "/other/RNaseP_bact_a.cm",
                args.dir + "/other/cyano_tmRNA.cm",
                args.dir + "/other/RNaseP_bact_b.cm",
                args.dir + "/other/Dictyostelium_SRP.cm",
                args.dir + "/other/RNase_P.cm",
                args.dir + "/other/Fungi_SRP.cm",
                args.dir + "/other/RNaseP_nuc.cm",
                args.dir + "/other/Metazoa_SRP.cm",
                args.dir + "/other/tmRNA.cm",
                args.dir + "/other/mt-tmRNA.cm",
                args.dir + "/other/tRNA.cm",
                args.dir + "/other/tRNA-Sec.cm",
            ]
        )

    input_yaml.update(
        {"rfam_models": [{"class": "File", "path": path} for path in rfam_models]}
    )

    if args.type in ["assembly", "wgs"]:
        # ==== for wgs and assembly ====
        # rfam_model_clans
        input_yaml.update(
            {"rfam_model_clans": {"class": "File", "path": args.dir + "/rRNA.claninfo"}}
        )

        # other RNA
        input_yaml.update(
            {
                "other_ncrna_models": [
                    "alpha_tmRNA.RF01849",
                    "Bacteria_large_SRP.RF01854",
                    "beta_tmRNA.RF01850",
                    "Dictyostelium_SRP.RF01570",
                    "Metazoa_SRP.RF00017",
                    "Protozoa_SRP.RF01856",
                    "RNaseP_arch.RF00373",
                    "RNaseP_bact_b.RF00011",
                    "RNaseP_nuc.RF00009",
                    "tRNA.RF00005",
                    "Archaea_SRP.RF01857",
                    "Bacteria_small_SRP.RF00169",
                    "cyano_tmRNA.RF01851",
                    "Fungi_SRP.RF01502",
                    "mt-tmRNA.RF02544",
                    "Plant_SRP.RF01855",
                    "RNase_MRP.RF00030",
                    "RNaseP_bact_a.RF00010",
                    "RNase_P.RF01577",
                    "tmRNA.RF00023",
                    "tRNA-Sec.RF01852",
                ]
            }
        )

        # CGC
        input_yaml.update(
            {"CGC_postfixes": ["_CDS.faa", "_CDS.ffn"], "cgc_chunk_size": 100000}
        )

        # functional annotation
        input_yaml.update(
            {
                "protein_chunk_size_hmm": 50000,
                "protein_chunk_size_IPS": 10000,
                "protein_chunk_size_eggnog": 100000,
                "func_ann_names_ips": ".I5.tsv.without_header",
                "func_ann_names_hmmer": ".hmm.tsv.without_header",
            }
        )

        # hmmer
        input_yaml.update(
            {
                "HMM_gathering_bit_score": True,
                "HMM_omit_alignment": True,
                "HMM_database": "db_kofam.hmm",
                "HMM_database_dir": {
                    "class": "Directory",
                    "path": args.dir + "/db_kofam/",
                },
            }
        )

        # IPS
        input_yaml.update(
            {
                "InterProScan_applications": [
                    "PfamA",
                    "TIGRFAM",
                    "PRINTS",
                    "PrositePatterns",
                    "Gene3d",
                ],
                "InterProScan_outputFormat": ["TSV"],
                "InterProScan_databases": {
                    "class": "Directory",
                    "path": f"{args.dir}/interproscan-{IPS_VERSION}/data",
                },
            }
        )

        if args.type == "assembly":
            # ===== only assembly =====
            print("Assembly")
            input_yaml.update({"contig_min_length": 500})

            # eggnog
            input_yaml.update(
                {
                    "EggNOG_db": {
                        "class": "File",
                        "path": args.dir + "/eggnog/eggnog.db",
                    },
                    "EggNOG_diamond_db": {
                        "class": "File",
                        "path": args.dir + "/eggnog/eggnog_proteins.dmnd",
                    },
                    "EggNOG_data_dir": {
                        "class": "Directory",
                        "path": args.dir + "/eggnog/",
                    },
                }
            )

            # diamond
            input_yaml.update(
                {
                    "Uniref90_db_txt": {
                        "class": "File",
                        "path": f"{args.dir}/diamond/db_uniref90_{UNIREF_VERSION}.txt",
                    },
                    "diamond_databaseFile": {
                        "class": "File",
                        "path": f"{args.dir}/diamond/uniref90_{UNIREF_VERSION}_diamond-v{DIAMOND_VERSION}.dmnd",
                    },
                    "diamond_maxTargetSeqs": 1,
                }
            )

            # pathways
            input_yaml.update(
                {
                    "graphs": {
                        "class": "File",
                        "path": args.dir + "/kegg_pathways/graphs.pkl",
                    },
                    "pathways_names": {
                        "class": "File",
                        "path": args.dir + "/kegg_pathways/all_pathways_names.txt",
                    },
                    "pathways_classes": {
                        "class": "File",
                        "path": args.dir + "/kegg_pathways/all_pathways_class.txt",
                    },
                }
            )
            # antismash
            input_yaml.update(
                {
                    "clusters_glossary": {
                        "class": "File",
                        "path": args.dir + "/antismash_glossary.tsv",
                    }
                }
            )
        else:
            # ==== only wgs ====
            print("WGS")
            input_yaml.update({"qc_min_length": 100})
    else:
        # ====== only amplicon =======
        print("AMPLICON")
        input_yaml.update(
            {
                "qc_min_length": 100,
                "stats_file_name": "qc_summary",
                "unite_label": "UNITE",
                "itsonedb_label": "ITSonedb",
            }
        )

        # rfam_model_clans
        input_yaml.update(
            {
                "rfam_model_clans": {
                    "class": "File",
                    "path": args.dir + "/ribosomal/ribo.claninfo",
                }
            }
        )

        # UNITE
        input_yaml.update(
            {
                "unite_db": {
                    "class": "File",
                    "path": args.dir + "/UNITE/unite.fasta",
                    "checksum": "ddb2105cb1f1ffa8941b44c19022b5a3",
                    "format": "edam:format_1929",
                },
                "unite_tax": {
                    "class": "File",
                    "path": args.dir + "/UNITE/UNITE-tax.txt",
                },
                "unite_otu_file": {
                    "class": "File",
                    "path": args.dir + "/UNITE/UNITE.otu",
                },
            }
        )

        # ITSoneDB
        input_yaml.update(
            {
                "itsonedb": {
                    "class": "File",
                    "path": args.dir + "/ITSonedb/itsonedb.fasta",
                    "checksum": "ec369f9fe6818482ce0ab184461ac116",
                    "format": "edam:format_1929",
                },
                "itsonedb_tax": {
                    "class": "File",
                    "path": args.dir + "/ITSonedb/ITSonedb-tax.txt",
                },
                "itsonedb_otu_file": {
                    "class": "File",
                    "path": args.dir + "/ITSonedb/ITSonedb.otu",
                },
            }
        )

    # files that can't be strings
    NON_CONVERTABLES = [
        "ssu_db",
        "lsu_db",
        "unite_db",
        "itsonedb",
    ]

    if args.cwltypes:
        # convert File and Directory entries to string
        for key, value in input_yaml.items():
            if key not in NON_CONVERTABLES:
                input_yaml[key] = convert_to_string(value)

    with open(args.type + ".yml", "w") as file_yml:
        yaml = YAML()
        yaml.indent(mapping=2, sequence=4, offset=2)
        yaml.dump(input_yaml, file_yml)
        # add headers manually
        # the yml lib doesn't handle \t
        file_yml.write(
            "\n"
            + 'diamond_header: "'
            + "\t".join(
                [
                    "uniref90_ID",
                    "contig_name",
                    "percentage_of_identical_matches",
                    "lenght",
                    "mismatch",
                    "gapopen",
                    "start",
                    "qend",
                    "sstart",
                    "send",
                    "evalue",
                    "bitscore",
                    "protein_name",
                    "num_in_cluster",
                    "taxonomy",
                    "tax_id",
                    "rep_id",
                ]
            )
            + '"'
        )
        file_yml.write("\n")
        file_yml.write(
            'hmmsearch_header: "'
            + "\t".join(
                [
                    "query_name",
                    "query_accession",
                    "tlen",
                    "target_name",
                    "target_accession",
                    "qlen",
                    "full_sequence_e-value",
                    "full_sequence_score",
                    "full_sequence_bias",
                    "# of",
                    "c-evalue",
                    "i-evalue",
                    "domain_score",
                    "domain_bias",
                    "hmm_coord_from",
                    "hmm_coord_to",
                    "ali_coord_from",
                    "ali_coord_to",
                    "env_coord_from",
                    "env_coord_to",
                    "acc",
                    "description_of_ta",
                    "rget",
                ]
            )
            + '"'
        )
        file_yml.write("\n")
        file_yml.write(
            'ips_header: "'
            + "\t".join(
                [
                    "protein_accession",
                    "sequence_md5_digest",
                    "sequence_length",
                    "analysis",
                    "signature_accession",
                    "signature_description",
                    "start_location",
                    "stop_location",
                    "score",
                    "status",
                    "date",
                    "accession",
                    "description",
                    "go",
                    "pathways_annotations",
                ]
            )
            + '"'
        )

    print("---------> yml done")