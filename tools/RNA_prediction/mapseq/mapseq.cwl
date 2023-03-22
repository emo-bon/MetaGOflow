#!/usr/bin/env cwl-runner

# edited from ebi-metagenomics-cwl/tools/mapseq.cwl

cwlVersion: v1.0
class: CommandLineTool
label: MAPseq v 1.2.3

doc: |
  sequence read classification tools designed to assign taxonomy and OTU
  classifications to ribosomal RNA sequences.
  https://github.com/jfmrod/MAPseq

requirements:
  ResourceRequirement:
    ramMin: 25000
    coresMin: 8

hints:
  - class: DockerRequirement
    dockerPull: microbiomeinformatics/pipeline-v5.mapseq:v1.2.3

baseCommand: mapseq

inputs:

  prefix: File

  sequences:
    type: File
    inputBinding:
      position: 1
    format: edam:format_1929  # FASTA

  database:
    type: File
    inputBinding:
      position: 2
    secondaryFiles: .mscluster
    format: edam:format_1929  

  taxonomy:
    type: [string, File]
    inputBinding:
      position: 4

  threads: 
    type: int?
    default: 8
    inputBinding:
      prefix: "-nthreads"
      position: 5


arguments: ['-tophits', '80', '-topotus', '40', '-outfmt', 'simple']

stdout: $(inputs.prefix.nameroot)_$(inputs.database.basename).mseq  # helps with cwltool's --cache

outputs:
  classifications:
    type: stdout
    format: iana:text/tab-separated-values

$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/

$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/version/latest/schemaorg-current-http.rdf

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder:
  - name: "EMBL - European Bioinformatics Institute"
  - url: "https://www.ebi.ac.uk/"
