#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

# For Megahit version 1.2.9
label: "megahit: metagenomics assembler"

hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/megahit:1.2.9--h2e03b76_1"
    
requirements:
  InlineJavascriptRequirement: {}

baseCommand: [ megahit ]

inputs:

  memory:
    type: float?
    label: Memory to run assembly. When 0 < -m < 1, fraction of all available memory of the machine is used, otherwise it specifies the memory in BYTE.
    default: 0.9
    inputBinding:
      position: 4
      prefix: "--memory"

  min-contig-len:
    type: int?
    default: 500
    inputBinding:
      position: 3
      prefix: "--min-contig-len"

  forward_reads:
    type:
      - File?
      - type: array
        items: File
    inputBinding:
      position: 1
      prefix: "-1"

  reverse_reads:
    type:
      - File?
      - type: array
        items: File
    inputBinding:
      position: 2
      prefix: "-2"

  threads: 
    type: int
    default: 1
    inputBinding: 
      position: 5
      prefix: "--num-cpu-threads"


outputs:

  contigs:
    type: File
    format: edam:format_1929  # FASTA
    outputBinding:
      glob: megahit_out/final.contigs.fa

  log:
    type: File
    format: iana:text/plain
    outputBinding:
      glob: megahit_out/log

  options:
    type: File
    outputBinding:
      glob: megahit_out/options.json


$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

doc : |
  https://github.com/voutcn/megahit/wiki
