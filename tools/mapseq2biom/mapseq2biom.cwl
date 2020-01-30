#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: mapseq2biom:latest

requirements:
  ResourceRequirement:
    ramMin: 200
    tmpdirMin: 200
    coresMin: 2

inputs:
  otu_table:
    type: File
    doc: |
      the OTU table produced for the taxonomies found in the reference
      databases that was used with MAPseq
    inputBinding:
      prefix: --otuTable 

  query:
    type: File
    label: the output from the MAPseq that assigns a taxonomy to a sequence
    inputBinding:
      prefix: --query

  label:
    type: string
    label: label to add to the top of the outfile OTU table
    inputBinding:
      prefix: --label

  taxid_flag:
    type: boolean?
    label: output NCBI taxids for all databases bar UNITE
    inputBinding:
        prefix: --taxid

baseCommand: ['mapseq2biom.pl'] # or perl /hps/nobackup/production/metagenomics/production-scripts/current/mgportal/analysis-pipeline/python/tools/taxonomy_summary/scripts/mapseq2biom.pl

arguments:
  - valueFrom: $(inputs.query.basename).tsv
    prefix: --outfile
  - valueFrom: $(inputs.query.basename).txt
    prefix: --krona
  - valueFrom: $(inputs.query.basename).notaxid.tsv
    prefix: --notaxidfile

outputs:
  otu_tsv:
    type: File
    outputBinding:
      glob: $(inputs.query.basename).tsv

  otu_txt:
    type: File
    outputBinding:
      glob: $(inputs.query.basename).txt

  otu_tsv_notaxid:
    type: File?
    outputBinding:
        glob: $(inputs.query.basename).notaxid.tsv

$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
