#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Demo workflow that copies an input file to an output file with a different name.
baseCommand: sh

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.script_name)
      - $(inputs.filename)

inputs:
  script_name:
    type: File
    inputBinding:
      position: 0
  filename:
    type: File
    inputBinding:
      position: 1

outputs:
  the_files:
    type: File[]
    outputBinding:
      glob: "*.dat"
