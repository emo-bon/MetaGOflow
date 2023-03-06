#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}
inputs:

    forward_reads: File?
    reverse_reads: File?
    both_reads: string[]?
    threads: {type: int }

    # fastp
    min_length_required: { type: int? }
    force_polyg_tail_trimming: { type: boolean? }
    base_correction: { type: boolean? }
    qualified_phred_quality: { type: int? }
    unqualified_percent_limit: { type: int? }
    disable_trim_poly_g: { type: boolean? }
    overlap_len_require: { type: int? }
    cut_right: { type: boolean? }
    detect_adapter_for_pe: { type: boolean, default: false }
    overrepresentation_analysis: { type: boolean, default: false }
    qc_stats_folder_for_merged: { type: string, default: "merged_qc" }

outputs:

  # hashsum files
  input_files_hashsum_paired:
    type: File[]?
    outputSource: hashsum_paired/hashsum
    pickValue: all_non_null

  # outputs for merged seq file
  m_qc_stats:
    type: Directory?
    outputSource: m_qc-stats/output_dir

  # this is the filtered merged seq file
  m_filtered_fasta:
    type: File
    outputSource:
      - m_length_filter/filtered_file
      - m_convert_trimmed_reads_to_fasta/fasta
    pickValue: first_non_null

  # outputs for each of the 2 trimmed seq file
  fastp_filtering_json:
    type: File?
    outputSource: fastp_trim_and_overlap/html_report

  trimmed_fr: 
    type: File?
    outputSource: fastp_trim_and_overlap/out_fastq1

  trimmed_rr: 
    type: File?
    outputSource: fastp_trim_and_overlap/out_fastq2

  qc-status:
    type: File[]?
    outputSource: QC-FLAG/qc-flag

  trimmed_seqs: 
    type: File[]?
    outputSource: fastp_trim_and_overlap/both_paired

  trimmed_fasta_seqs: 
    type: File[]?
    outputSource: convert_trimmed_reads_to_fasta/fasta

  qc-statistics:
    type: Directory[]?
    outputSource: qc_stats/output_dir

  qc_summary:
    type: File[]?
    outputSource: pe_length_filter/stats_summary_file

  filtered_fasta:
    type: File[]?
    outputSource: pe_length_filter/filtered_file

  motus_input:
    type: File?
    outputSource: clean_merged_fasta_headers/sequences_with_cleaned_headers

steps:
  # << calculate hashsum >>
  hashsum_paired:
    run: ../../utils/generate_checksum/generate_checksum.cwl
    scatter: input_file
    in:
      input_file:
        - forward_reads
        - reverse_reads
    out: [ hashsum ]

  # << unzipping paired reads >>
  count_submitted_reads:
    run: ../../utils/count_lines/count_lines.cwl
    in:
      sequences: forward_reads
      number: { default: 4 }
    out: [ count ]

  fastp_trim_and_overlap:

    doc: |
      Quality control using the fastp tool and merging of the reads

    run: ../../tools/fastp/fastp.cwl

    in:
      forward_reads: forward_reads
      reverse_reads: reverse_reads
      threads: threads
      min_length_required: min_length_required
      force_polyg_tail_trimming: force_polyg_tail_trimming
      qualified_phred_quality: qualified_phred_quality 
      unqualified_percent_limit: unqualified_percent_limit
      disable_trim_poly_g: disable_trim_poly_g 
      overlap_len_require: overlap_len_require
      cut_right: cut_right
      base_correction: base_correction
      detect_adapter_for_pe: detect_adapter_for_pe
      overrepresentation_analysis: overrepresentation_analysis

    out: [ out_fastq1, out_fastq2, both_paired, merged_fastq, html_report, json_report ]

  # WITH RESPECT TO MERGED SEQS
  # ---------------------------
  #fastq
  m_clean_fasta_headers:
    run: ../../utils/clean_fasta_headers.cwl
    in:
      sequences: fastp_trim_and_overlap/merged_fastq
    out: [ sequences_with_cleaned_headers ]

  #fasta
  m_convert_trimmed_reads_to_fasta:
    run: ../../utils/fastq_to_fasta/fastq_to_fasta.cwl
    in:
      fastq: m_clean_fasta_headers/sequences_with_cleaned_headers
    out: [ fasta ]

  # << QC filtering >>
  m_length_filter:
    run: ../../tools/qc-filtering/qc-filtering.cwl
    in:
      seq_file: m_convert_trimmed_reads_to_fasta/fasta
      submitted_seq_count: count_submitted_reads/count
      stats_file_name: {default: 'qc_summary'}
      min_length: min_length_required
      input_file_format: { default: 'fasta' }
    out: [ filtered_file, stats_summary_file ]

  m_count_processed_reads:
    run: ../../utils/count_fasta.cwl
    in:
      sequences: m_length_filter/filtered_file
      number: { default: 1 }
    out: [ count ]

  # << QC FLAG >>
  m_QC-FLAG:
    run: ../../utils/qc-flag.cwl
    in:
      qc_count: m_count_processed_reads/count
    out: [ qc-flag ]

  # << QC >>
  m_qc-stats:
    run: ../../tools/qc-stats/qc-stats.cwl
    in:
      QCed_reads: m_length_filter/filtered_file
      sequence_count: m_count_processed_reads/count
      out_dir_name: qc_stats_folder_for_merged
    out: [ output_dir ]


  clean_merged_fasta_headers:
    run: ../../utils/clean_fasta_headers.cwl
    in:
      sequences: fastp_trim_and_overlap/merged_fastq
    out: [ sequences_with_cleaned_headers ]



  # WITH REPSECT TO EACH OF THE 2 TRIMMED SEQ FILES
  # -------------------------------------------------

  #fastq
  clean_fasta_headers:
    run: ../../utils/clean_fasta_headers.cwl
    scatter: sequences
    in:
      sequences: fastp_trim_and_overlap/both_paired
    out: [ sequences_with_cleaned_headers ]

  #fasta - output called *.unclean
  convert_trimmed_reads_to_fasta:
    run: ../../utils/fastq_to_fasta/fastq_to_fasta.cwl
    scatter: fastq
    in:
      fastq: clean_fasta_headers/sequences_with_cleaned_headers
    out: [ fasta ]

  # << QC filtering >>
  pe_length_filter:
    run: ../../tools/qc-filtering/qc-filtering.cwl
    scatter: seq_file
    in:
      seq_file: convert_trimmed_reads_to_fasta/fasta
      submitted_seq_count: count_submitted_reads/count
      stats_file_name: {default: 'qc_summary' }
      min_length: min_length_required 
      input_file_format: { default: 'fasta' }
    out: [ filtered_file, stats_summary_file ]


  count_processed_reads:
    run: ../../utils/count_fasta.cwl
    scatter: sequences
    in:
      sequences: pe_length_filter/filtered_file
      number: { default: 1 }
    out: [ count ]

  # << QC FLAG >>
  QC-FLAG:
    run: ../../utils/qc-flag.cwl
    scatter: qc_count
    in:
        qc_count: count_processed_reads/count
    out: [ qc-flag ]

  # << QC >>
  qc_stats:

    scatter: [ QCed_reads, sequence_count, out_dir_name ]
    scatterMethod: dotproduct
    run: ../../tools/qc-stats/qc-stats.cwl
    in:
        QCed_reads: pe_length_filter/filtered_file
        sequence_count: count_processed_reads/count
        out_dir_name: both_reads
    out: [ output_dir, summary_out ]


$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/
$schemas:
 - https://raw.githubusercontent.com/edamontology/edamontology/main/releases/EDAM_1.16.owl
 - https://schema.org/version/latest/schemaorg-current-http.rdf

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
