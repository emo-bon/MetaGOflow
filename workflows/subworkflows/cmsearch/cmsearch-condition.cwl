cwlVersion: v1.2
class: Workflow
doc: |
  Identifies non-coding RNAs using Rfams covariance models

requirements:
  MultipleInputFeatureRequirement: {}

inputs:

  query_sequences: File
  clan_info: [string, File]
  threads: {type: int?, default: 2}
  covariance_models:
    type:
      - type: array
        items: [string, File]

outputs:

  concatenate_matches:
    outputSource: cmsearch_raw_data/concatenate_matches
    type: File

  deoverlapped_matches:
    outputSource: cmsearch_raw_data/deoverlapped_matches
    type: File

steps:
  cmsearch_raw_data:

    label: Search sequence(s) against a covariance model database for assemblies
    run: cmsearch-multimodel-raw-data.cwl
    in:
      clan_info: clan_info
      covariance_models: covariance_models
      query_sequences: query_sequences
      threads: threads
    out: [ concatenate_matches, deoverlapped_matches ]


$namespaces:
  edam: 'http://edamontology.org/'
  s: 'http://schema.org/'

$schemas:
  - 'http://edamontology.org/EDAM_1.16.owl'
  - 'https://schema.org/version/latest/schemaorg-current-http.rdf'

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute, 2018"
s:author: "Ekaterina Sakharova"