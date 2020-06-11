#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0

requirements:
  ResourceRequirement:
      ramMin: 1000
      coresMin: 1
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
#  - class: SchemaDefRequirement
#    types:
#      - $import: ../tools/InterProScan/InterProScan-apps.yaml
#      - $import: ../tools/InterProScan/InterProScan-protein_formats.yaml

inputs:

  CGC_predicted_proteins: File
  chunk_size: int
  name_ips: string
  name_hmmscan: string

  HMMSCAN_gathering_bit_score: boolean
  HMMSCAN_omit_alignment: boolean
  HMMSCAN_name_database: string
  HMMSCAN_data: Directory

  EggNOG_db: File
  EggNOG_diamond_db: File
  EggNOG_data_dir: string

  InterProScan_databases: Directory
  InterProScan_applications: string[]  # ../tools/InterProScan/InterProScan-apps.yaml#apps[]?
  InterProScan_outputFormat: string[]  # ../tools/InterProScan/InterProScan-protein_formats.yaml#protein_formats[]?

outputs:
  hmmscan_result:
    type: File
    outputSource: run_hmmscan/hmmscan_result
  ips_result:
    type: File
    outputSource: run_IPS/ips_result
  eggnog_annotations:
    outputSource: eggnog/annotations
    type: File
  eggnog_orthologs:
    outputSource: eggnog/orthologs
    type: File

steps:

  # << Chunk faa file >>
  split_seqs:
    in:
      seqs: CGC_predicted_proteins
      chunk_size: chunk_size
    out: [ chunks ]
    run: ../../../tools/chunks/protein_chunker.cwl

  # << EggNOG >>
  eggnog:
    run: ../../../tools/Assembly/EggNOG/eggnog-subwf.cwl
    in:
      fasta_file: split_seqs/chunks
      db_diamond: EggNOG_diamond_db
      db: EggNOG_db
      data_dir: EggNOG_data_dir
      cpu: { default: 16 }
      file_acc:
        source: CGC_predicted_proteins
        valueFrom: $(self.nameroot)
    out: [ annotations, orthologs ]

  run_hmmscan:
    run: ../chunking-subwf-hmmscan.cwl
    in:
      CGC_predicted_proteins: CGC_predicted_proteins
      chunk_size: chunk_size
      name_hmmscan: name_hmmscan
      HMMSCAN_gathering_bit_score: HMMSCAN_gathering_bit_score
      HMMSCAN_omit_alignment: HMMSCAN_omit_alignment
      HMMSCAN_name_database: HMMSCAN_name_database
      HMMSCAN_data: HMMSCAN_data
    out: [ hmmscan_result ]

  run_IPS:
    run: ../chunking-subwf-IPS.cwl
    in:
      CGC_predicted_proteins: CGC_predicted_proteins
      chunk_size: chunk_size
      name_ips: name_ips
      InterProScan_databases: InterProScan_databases
      InterProScan_applications: InterProScan_applications
      InterProScan_outputFormat: InterProScan_outputFormat
    out: [ ips_result ]