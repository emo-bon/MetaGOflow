#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "Parse EggNOG hits retrieved from emapper."
requirements:
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}
  StepInputExpressionRequirement: {}
  ResourceRequirement:
    coresMax: 1
    ramMin: 200

hints:
  - class: DockerRequirement
    dockerPull: debian:stable-slim

inputs:
  eggnog_annotations:
    type: File
    label: eggnog annotations TSV format

outputs:
  summary_eggnog:
    type: File
    outputSource: format_output_step/formatted

steps:

  # STEP A
  awk_step:

    in:
      eggnog_annotations: eggnog_annotations

    out: [out]

    run:
      class: CommandLineTool

      baseCommand: []

      stdout: output.txt

      inputs:
        eggnog_annotations:
          type: File
          inputBinding: {}

      outputs:

        out:
          type: File
          outputBinding:
            glob: output.txt

      arguments:
        - awk
        - -F
        - \t
        - '{print $5"\t"$8}'


  # STEP B
  sed_step:
    in:
      two_cols:
        source: awk_step/out

    out: [trimmed]

    run:
      class: CommandLineTool
      inputs:
        two_cols: 
          type: File
          inputBinding: {}

      stdout: trimmed.tsv

      outputs:
        trimmed:
          type: File
          outputBinding:
            glob: trimmed.tsv

      baseCommand: []

      arguments:
        - sed
        - 's/|.*\t/\t/g ; s/@1//g' 

  # STEP C
  sort_step:

    in:
      trimmed_two_cols:
        source: sed_step/trimmed

    out: [sorted]

    run:
      class: CommandLineTool
      inputs:
        trimmed_two_cols: 
          type: File
          inputBinding: {}

      stdout: sorted.tsv

      outputs:
        sorted:
          type: File
          outputBinding:
            glob: sorted.tsv

      baseCommand: [sort]

  # STEP D
  uniq_step:
    in:
      sorted_two_cols:
        source: sort_step/sorted

    out: [uniq]

    run:
      class: CommandLineTool

      inputs:
        sorted_two_cols: 
          type: File
          inputBinding: {}

      stdout: uniq.tsv

      outputs:
        uniq:
          type: File
          outputBinding:
            glob: uniq.tsv

      baseCommand: [ uniq ]

      arguments:
        - -c

  # STEP E
  sort_uniq_step:
    in:
      uniq_two_cols:
        source: uniq_step/uniq

    out: [uniq_sorted]

    run:
      class: CommandLineTool

      inputs:
        uniq_two_cols: 
          type: File
          inputBinding: {}

      stdout: uniq_sorted.tsv

      outputs:
        uniq_sorted:
          type: File
          outputBinding:
            glob: uniq_sorted.tsv

      baseCommand: [ sort ]

      arguments:
        - -nr
        - -k1

  # STEP F
  format_output_step:
    requirements: 
      StepInputExpressionRequirement: {}

    in:
      uniq_sorted:
        source: sort_uniq_step/uniq_sorted

      outputname:
        source: eggnog_annotations
        valueFrom: $(self.nameroot).summary.eggnog

    out: [formatted]

    run:
      class: CommandLineTool

      inputs:
        uniq_sorted: 
          type: File
          inputBinding: {}
        outputname:
          type: string

      stdout: $(inputs.outputname)

      outputs:
        formatted:
          type: stdout

      baseCommand: [ awk ]

      arguments:
        - -F
        - " "
        - '{print "\"" $1 "\",\"" $2 "\",\""  substr($0,index($0,$3)) "\""}'
