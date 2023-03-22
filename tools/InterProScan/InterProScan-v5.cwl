#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2

label: 'InterProScan: protein sequence classifier'

requirements:
  - class: ShellCommandRequirement 
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: DockerRequirement
    dockerPull: hariszaf/pipeline-v5.interproscan:v5.57-90.0
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.databases)
        entryname: $("/opt/interproscan/data")
        writable: true
  - class: ResourceRequirement 
    ramMin: 15000
    coresMin: 4
  - class: NetworkAccess
    networkAccess: true

baseCommand: [ interproscan.sh ]

inputs:

  inputFile:
    type: File
    format: edam:format_1929
    inputBinding:
      position: 8
      prefix: '--input'
    label: Input file path
    doc: >-
      Optional, path to fasta file that should be loaded on Master startup.
      Alternatively, in CONVERT mode, the InterProScan 5 XML file to convert.

  applications:
    type: string[]?
    inputBinding:
      position: 9
      itemSeparator: ','
      prefix: '--applications'
    label: Analysis
    doc: >-
      Optional, comma separated list of analyses. If this option is not set, ALL
      analyses will be run.

  databases:
    type: [string?, Directory]

  cpu:
    type: int
    default: 8
    inputBinding:
      position: 2
      prefix: '--cpu'
    label: Number of CPUs
    doc: >-
      Optional, number of CPUs to use. If not set, the number of CPUs available
      on the machine will be used.

  disableResidueAnnotation:
    type: boolean?
    inputBinding:
      position: 11
      prefix: '--disable-residue-annot'
    label: Disables residue annotation
    doc: 'Optional, excludes sites from the XML, JSON output.'


arguments:
  - position: 0
    valueFrom: '--disable-precalc'
  - position: 1
    valueFrom: '--goterms'
  - position: 2
    valueFrom: '--pathways'
  - position: 3
    prefix: '--tempdir'
    valueFrom: $(runtime.tmpdir)
  - position: 7
    valueFrom: 'TSV'
    prefix: '-f'
  - position: 8
    valueFrom: $(runtime.outdir)/$(inputs.inputFile.nameroot).IPS.tsv
    prefix: '-o'

outputs:
  i5Annotations:
    format: edam:format_3475
    type: File
    outputBinding:
      glob: $(inputs.inputFile.nameroot).IPS.tsv

doc: >-
  InterProScan is the software package that allows sequences (protein and
  nucleic) to be scanned against InterPro's signatures. Signatures are
  predictive models, provided by several different databases, that make up the
  InterPro consortium.
  This tool description is using a Docker container tagged as version
  v5.30-69.0.
  Documentation on how to run InterProScan 5 can be found here:
  https://github.com/ebi-pf-team/interproscan/wiki/HowToRun

$namespaces:
  edam: 'http://edamontology.org/'
  iana: 'https://www.iana.org/assignments/media-types/'
  s: 'http://schema.org/'

$schemas:
  - 'https://raw.githubusercontent.com/edamontology/edamontology/main/releases/EDAM_1.20.owl'
  - 'https://schema.org/version/latest/schemaorg-current-http.rdf'

s:author: "Michael Crusoe, Aleksandra Ola Tarkowska, Maxim Scheremetjew, Haris Zafeiropoulos"
s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder:
    - name: "EMBL - European Bioinformatics Institute"
    - url: "https://www.ebi.ac.uk/"
