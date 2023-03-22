#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Modified from https://github.com/common-workflow-library/bio-cwl-tools/blob/release/fastp/fastp.cwl
requirements:
    InlineJavascriptRequirement: {}

hints:
    DockerRequirement:
        dockerPull: microbiomeinformatics/pipeline-v5.fastp:0.20.0

baseCommand: [ fastp ]

arguments: [
        $(inputs.detect_adapter_for_pe),
        $(inputs.overrepresentation_analysis),
        $(inputs.merge),
        $(inputs.merged_out),
        $(inputs.cut_right), 
        $(inputs.base_correction),
        $(inputs.overlap_len_require),
        $(inputs.force_polyg_tail_trimming),
        $(inputs.min_length_required),

        --thread=$(inputs.threads),
        --html, "fastp.html", 
        --json, "fastp.json",
        -i, $(inputs.forward_reads),
        -I, $(inputs.reverse_reads),
        -o, $(inputs.forward_reads.nameroot).trimmed.fastq,
        -O, $(inputs.reverse_reads.nameroot).trimmed.fastq
]

inputs:

  detect_adapter_for_pe:
    type: boolean
    default: false
    inputBinding: 
      valueFrom:
        ${
          if (inputs.detect_adapter_for_pe == true){
            return '--detect_adapter_for_pe';
          } else {
            return '';
          }
        }

  overrepresentation_analysis:
    type: boolean
    default: false
    inputBinding: 
      valueFrom:
        ${
          if (inputs.overrepresentation_analysis == true){
            return '--overrepresentation_analysis';
          } else {
            return '';
          }
        }

  merge: 
    type: boolean
    default: true
    inputBinding: 
      valueFrom: 
        ${
          if (inputs.merge != false){
            return '--merge';
          } else {
            return '';
          }
        }

  merged_out: 
    type: boolean?
    default: true
    inputBinding: 
      prefix: --merged_out
      valueFrom: 
        ${
          if (inputs.merge != false){
            return inputs.forward_reads.nameroot.split(/_(.*)/s)[0] + '.merged.fastq';
          } else {
            return '';
          }
        }

  forward_reads:
    type: File
    format:
      - edam:format_1930 # FASTA
      - edam:format_1929 # FASTQ

  reverse_reads:
    format:
      - edam:format_1930 # FASTA
      - edam:format_1929 # FASTQ
    type: File?

  threads:
    type: int?
    default: 1

  qualified_phred_quality:
    type: int?
    default: 0
    inputBinding: 
      valueFrom: 
        ${
          if (inputs.qualified_phred_quality > 0) {
            return '--qualified_quality_phred=' + inputs.qualified_phred_quality
          } else {
            return ''
          }
        }

  unqualified_percent_limit:
    type: int?
    default: 0
    inputBinding: 
      valueFrom: 
        ${
          if (inputs.unqualified_percent_limit > 0) {
            return '--unqualified_percent_limit=' + inputs.unqualified_percent_limit
          } else {
            return ''
          }
        }

  min_length_required:
    type: int?
    default: 0
    inputBinding: 
      valueFrom: 
        ${
          if (inputs.min_length_required > 0) {
            return '--length_required=' + inputs.min_length_required
          } else {
            return ''
          }
        }

  force_polyg_tail_trimming:
    type: boolean?
    default: false
    inputBinding:
      valueFrom: 
        ${
          if (inputs.force_polyg_tail_trimming != false){
            return '--trim_poly_g';
          } else {
            return '';
          }
        }

  disable_trim_poly_g:
    type: boolean?
    default: false
    inputBinding:
      valueFrom: 
        ${
          if (inputs.disable_trim_poly_g == true){
            return '--disable_trim_poly_g';
          } else {
            return '';
          }
        }

  base_correction:
    type: boolean?
    default: false
    inputBinding:
      valueFrom: 
        ${
          if (inputs.merge == true && inputs.base_correction == true){
            return '--correction';
          } else {
            return '';
          }
        }

  overlap_len_require: 
    type: int
    default: 0
    inputBinding:
      valueFrom:
        ${
          if (inputs.merge == true){
            return '--overlap_len_require='+inputs.overlap_len_require;
          } else {
            return '';
          }
        }

  cut_right: 
    type: boolean
    default: true
    inputBinding:
      valueFrom: 
        ${
          if (inputs.cut_right == true){
            return '--cut_right'
          } else {
            return ''
          }
        }


#  overlap_diff_limit (default 5) and overlap_diff_limit_percent (default 20%). 
#  Please note that the reads should meet these three conditions simultaneously.

outputs:
  out_fastq1:
      type: File
      format: $(inputs.forward_reads.format)
      outputBinding:
        glob: $(inputs.forward_reads.nameroot).trimmed.fastq
  out_fastq2:
      type: File
      format: $(inputs.reverse_reads.format)
      outputBinding:
        glob: $(inputs.reverse_reads.nameroot).trimmed.fastq
  merged_fastq: 
    type: File
    format: $(inputs.forward_reads.format)
    outputBinding:
        glob: '*.merged.fastq'
  html_report:
    type: File
    outputBinding:
        glob: fastp.html
  json_report:
    type: File
    outputBinding:
        glob: fastp.json
  both_paired: 
    type: File[]
    format: edam:format_1930
    outputBinding: 
      glob: [$(inputs.forward_reads.nameroot).trimmed.fastq, $(inputs.reverse_reads.nameroot).trimmed.fastq]

# namespaces
$namespaces:
  edam: http://edamontology.org/
  s: http://schema.org/
$schemas:
  - http://edamontology.org/EDAM_1.18.owl
  - https://schema.org/version/latest/schemaorg-current-http.rdf
s:author: "Haris Zafeiropoulos"
