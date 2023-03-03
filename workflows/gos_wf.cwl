#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.2

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

doc: |
  This workflow is based on the MGnify tools and subworkflows to address the needs 
  for the analysis of the metagenomics data derived from the marine 
  Genomic Observatories (https://www.embrc.eu/newsroom/news/emo-bon-first-coordinated-long-term-genomic-biodiversity-observatory-europe).
  It returns the taxonomic profile of a sample based on RNA prediction of its raw-data as well as its functional annotation based on them. 
  It may also build the assembly of the metagenomic data using the MEGAHIT algorithm. The assembly can then be further analysed through 
  the "assembly" pipeline of MGnify.

inputs:

  # Global
  forward_reads: File?
  reverse_reads: File?
  both_reads: string[]?
  threads: {type: int, default: 5}

  #Interproscan
  interproscan_threads: {type: int, default: 8}

  # Steps
  qc_and_merge_step: { type: boolean, default: true }
  taxonomic_inventory: { type: boolean, default: true }
  cgc_step: { type: boolean, default: false }
  reads_functional_annotation: { type: boolean, default: false }
  assemble: { type: boolean, default: false }

  # Files to run partially the wf
  ncrna_tab_file: {type: File?}

  # Pre-process
  overrepresentation_analysis: { type: boolean, default: false }
  detect_adapter_for_pe: { type: boolean, default: false }
  force_polyg_tail_trimming: { type: boolean, default: false }
  overlap_len_require: { type: int, default: 3 }
  qualified_phred_quality: { type: int? }
  unqualified_percent_limit: { type: int? }
  disable_trim_poly_g: { type: boolean, default: true }
  min_length_required: { type: int, default: 100 }
  cut_right: { type: boolean, default: true }
  base_correction: { type: boolean, default: false }

  # RNA prediction input vars
  ssu_db: 
    type: File?
    secondaryFiles: [.mscluster] 
  lsu_db: 
    type: File? 
    secondaryFiles: [.mscluster]
  ssu_tax: [string, File]
  lsu_tax: [string, File]
  ssu_otus: [string, File]
  lsu_otus: [string, File]
  rfam_models:
    type:
      - type: array
        items: [string, File]
  rfam_model_clans: [string, File?]
  other_ncRNA_models: string[]?
  ssu_label: string?
  lsu_label: string?
  5s_pattern: string?
  5.8s_pattern: string?

  # Assembly step 
  min-contig-len: int?
  memory: float?

  # CGC
  CGC_postfixes: string[]?
  cgc_chunk_size: {type: int, default: 50}

  ## Functional annotation input vars
  protein_chunk_size_hmm: int?
  func_ann_names_hmmer: string?
  HMM_gathering_bit_score: {type: boolean, default: true}
  HMM_omit_alignment: {type: boolean, default: true}
  HMM_database: [string, File?]
  HMM_database_dir: [string, Directory?]
  hmmsearch_header: string?

  protein_chunk_size_IPS: int?
  func_ann_names_ips: string?
  InterProScan_databases: [string, Directory?]
  InterProScan_applications: string[]?
  InterProScan_outputFormat: string[]?
  ips_header: string?

  protein_chunk_size_eggnog: int?

  EggNOG_db: [string?, File?]
  EggNOG_diamond_db: [string?, File?]
  EggNOG_data_dir: [string?, Directory?]
  
  go_config: [string, File?]
  ko_file: [string, File?]

  # ----------------------------------------------
  # Variables to be used for partial run of the wf
  processed_reads:
    type: File?
    default: pseudo_files/pseudo.merged.fasta

  input_for_motus: 
    type: File?
    default: pseudo_files/pseudo.merged.unfiltered.fasta

  maskfile: 
    type: File?
    default: pseudo_files/pseudo.merged.cmsearch.all.tblout.deoverlapped

  processed_read_files:
    type:
      - File?
      - type: array
        items: File
    default: 
      - class: File
        path: pseudo_files/pseudo_1_clean.fastq.trimmed.fasta
      - class: File
        path: pseudo_files/pseudo_2_clean.fastq.trimmed.fasta

  predicted_faa_from_previous_run: 
    type: File?
    format: edam:format_1929
    default: pseudo_files/pseudo.merged_CDS.faa

  count_faa_from_previous_run: {type: int?, default: 1}


steps:
  # QC FOR RNA PREDICTION
  qc_and_merge:
    doc: 
      The rna prediction step is based on pre-processed and merged reads. 
      This step aims at the pre-processing and merging the raw reads so its output can be used 
      for the rna prediction step. 

    when: $(inputs.qc_and_merge_step)
    run: conditionals/qc.cwl
    in:
      # conditional
      qc_and_merge_step: qc_and_merge_step

      # Parameters' values
      forward_reads: forward_reads
      reverse_reads: reverse_reads
      both_reads: both_reads
      min_length_required: min_length_required
      force_polyg_tail_trimming: force_polyg_tail_trimming
      threads: threads
      overlap_len_require: overlap_len_require
      qualified_phred_quality: qualified_phred_quality
      unqualified_percent_limit: unqualified_percent_limit
      disable_trim_poly_g: disable_trim_poly_g
      cut_right: cut_right
      base_correction: base_correction
      overrepresentation_analysis: overrepresentation_analysis
      detect_adapter_for_pe: detect_adapter_for_pe

    out:
      # Merged sequence file
      - m_qc_stats
      - m_filtered_fasta

      # Trimmed PE files
      - qc-statistics
      - qc_summary
      - qc-status
      - input_files_hashsum_paired
      - fastp_filtering_json
      - filtered_fasta
      - motus_input

  # mOTUs2
  motus_taxonomy:
    doc: 
    when: $(inputs.taxonomic_inventory)
    run: subworkflows/raw_reads/mOTUs-workflow.cwl
    in:
      # conditional
      taxonomic_inventory: taxonomic_inventory

      # from previous step
      reads:
        source:
          - qc_and_merge/motus_input
          - input_for_motus
        pickValue: first_non_null

      # Global
      threads: threads
    out: 
      - motus

  # RNA PREDICTION STEP 
  rna_prediction:
    doc: 
      Returns taxonomic profile of the sample based on the prediction of rna reads
      and their assignment
    when: $(inputs.taxonomic_inventory)
    run: conditionals/rna-prediction.cwl
    in:
      # conditional
      taxonomic_inventory: taxonomic_inventory

      # from previous step
      filtered_fasta:
        source:
          - qc_and_merge/m_filtered_fasta
          - processed_reads
        pickValue: first_non_null

      # from initial arguments reg. RNA prediction
      ssu_db: ssu_db
      lsu_db: lsu_db
      ssu_tax: ssu_tax
      lsu_tax: lsu_tax
      ssu_otus: ssu_otus
      lsu_otus: lsu_otus
      rfam_models: rfam_models
      rfam_model_clans: rfam_model_clans
      other_ncRNA_models: other_ncRNA_models
      ssu_label: ssu_label
      lsu_label: lsu_label
      5s_pattern: 5s_pattern
      5.8s_pattern: 5.8s_pattern
      threads: threads

    out:
      - sequence_categorisation_folder
      - taxonomy-summary_folder
      - rna-count
      - compressed_files
      - optional_tax_file_flag
      - ncRNA

  # COMBINED GENE CALLER BASED ON THE READS
  cgc_on_reads:
    doc: 
      Combined gene caller is a step where thanks to the FragGeneScan software, genes are predicted. 

    when: $(inputs.cgc_step)
    run: subworkflows/raw_reads/cgc/CGC-subwf.cwl
    in:
      # Conditional 
      cgc_step: cgc_step

      # Coming from the QC step: 
      input_fasta: 
        source:
          - qc_and_merge/m_filtered_fasta
          - processed_reads
        pickValue: first_non_null

      # Coming from the taxonomic intentory step: 
      maskfile: 
        source: 
          - rna_prediction/ncRNA
          - maskfile
        pickValue: first_non_null

      # Values from the default.yml
      postfixes: CGC_postfixes
      chunk_size: cgc_chunk_size


    out: [ predicted_faa, predicted_ffn, count_faa ]
  # FUNCTIONAL ANNOTATION ON THE RAW READS
  functional_annotation_on_reads:
    doc: 
      The functional annotation subworkflow of the MGnify raw-reads workflow is performed
      to annotate the filtered reads. This is the most computationally- and time-expensive step. 

    when: $(inputs.reads_functional_annotation)
    run: conditionals/Func_ann_and_post_proccessing-subwf.cwl
    in:
       # Conditional
       reads_functional_annotation: reads_functional_annotation

       # From the QC step 
       filtered_fasta: 
        source: 
          - qc_and_merge/m_filtered_fasta
          - processed_reads
        pickValue: first_non_null

       # From the taxonomic inventory step 
       rna_prediction_ncRNA:
        source: 
          - rna_prediction/ncRNA
          - maskfile
        pickValue: first_non_null

       #  From the CGC step
       check_value: 
        source: 
          - cgc_on_reads/count_faa
          - count_faa_from_previous_run
        pickValue: first_non_null

       cgc_results_faa: 
        source: 
          - cgc_on_reads/predicted_faa
          - predicted_faa_from_previous_run
        pickValue: first_non_null

       # Parameters' values 
       protein_chunk_size_hmm: protein_chunk_size_hmm
       protein_chunk_size_IPS: protein_chunk_size_IPS
       protein_chunk_size_eggnog: protein_chunk_size_eggnog

       func_ann_names_ips: func_ann_names_ips
       InterProScan_databases: InterProScan_databases
       InterProScan_applications: InterProScan_applications
       InterProScan_outputFormat: InterProScan_outputFormat
       ips_header: ips_header

       func_ann_names_hmmer: func_ann_names_hmmer
       HMM_gathering_bit_score: HMM_gathering_bit_score
       HMM_omit_alignment: HMM_omit_alignment
       HMM_database: HMM_database
       HMM_database_dir: HMM_database_dir
       hmmsearch_header: hmmsearch_header

       EggNOG_db: EggNOG_db
       EggNOG_diamond_db: EggNOG_diamond_db
       EggNOG_data_dir: EggNOG_data_dir

       go_config: go_config
       ko_file: ko_file
       threads: threads

    out:
      - functional_annotation_folder
      - stats

  # ASSEMBLY USING MEGAHIT
  assembly:
    doc: 
      Assembly of the raw reads using the MEGAHIT algorithm.
    when: $(inputs.assemble)
    run: conditionals/megahit.cwl
    in:

      # Conditional
      assemble: assemble

      # From the QC step
      forward_reads: 
        source: 
          - qc_and_merge/filtered_fasta
          - processed_read_files
        pickValue: first_non_null
        valueFrom: $(self[0])

      reverse_reads:
        source: 
         - qc_and_merge/filtered_fasta
         - processed_read_files
        pickValue: first_non_null
        valueFrom: $(self[1])

      # Parameters' values
      min-contig-len: min-contig-len
      memory: memory
      threads: threads

    out: 
      - contigs
      - options

outputs:
  # QC FOR RNA PREDICTION
  # ---------------------
  qc-statistics:
    type: Directory[]?
    outputSource: qc_and_merge/qc-statistics
    pickValue: all_non_null

  qc_summary:
    type: File[]?
    outputSource: qc_and_merge/qc_summary
    pickValue: all_non_null

  hashsum_paired:
    type: File[]?
    outputSource: qc_and_merge/input_files_hashsum_paired
    pickValue: all_non_null

  fastp_filtering_json_report:
    type: File?
    outputSource: qc_and_merge/fastp_filtering_json
    pickValue: all_non_null

  m_filtered_fasta:  # this is the filtered merged seq file
    type: File?
    outputSource: qc_and_merge/m_filtered_fasta

  filtered_fasta: 
    type: File[]?
    outputSource: qc_and_merge/filtered_fasta
    pickValue: all_non_null

  m_qc_stats:
    type: Directory? 
    outputSource: qc_and_merge/m_qc_stats

  motus_input:
    type: File?
    outputSource: qc_and_merge/motus_input

  # mOTUs STEP
  # ----------------------
  motus:
    type: File
    outputSource: motus_taxonomy/motus

  # RNA PREDICTION STEP 
  # ----------------------
  sequence-categorisation_folder:
    type: Directory?
    outputSource: rna_prediction/sequence_categorisation_folder

  taxonomy-summary_folder:
    type: Directory?
    outputSource: rna_prediction/taxonomy-summary_folder

  rna-count:
    type: File?
    outputSource: rna_prediction/rna-count

  no_tax_flag_file:
    type: File?
    outputSource: rna_prediction/optional_tax_file_flag

  ncRNA: 
    type: File? 
    outputSource: rna_prediction/ncRNA

  # CGC ON READS
  # ---
  predicted_faa:
    type: File?
    format: edam:format_1929
    outputSource: cgc_on_reads/predicted_faa

  predicted_ffn:
    type: File?
    format: edam:format_1929
    outputSource: cgc_on_reads/predicted_ffn

  count_faa:
    type: int
    outputSource: cgc_on_reads/count_faa

  # READS FUNCTIONAL ANNOTATION
  # ---------------------------
  reads_functional_annotation_folder:
    type: Directory?
    outputSource: functional_annotation_on_reads/functional_annotation_folder

  reads_stats:
    type: Directory?
    outputSource: functional_annotation_on_reads/stats

  # ASSEMBLY
  # ---------
  contigs: 
    type: File?
    outputSource: assembly/contigs

# Namespaces & schemas
$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/

$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/version/latest/schemaorg-current-https.jsonld

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "European Marine Biological Resource Centre"
s:author: "Haris Zafeiropoulos"
